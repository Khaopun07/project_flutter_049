import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:natthawut_flutter_049/controllers/auth_controller.dart';
import 'package:natthawut_flutter_049/providers/user_provider.dart';
import 'package:natthawut_flutter_049/varibles.dart';
import 'package:natthawut_flutter_049/models/school_model.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

class SchoolController {
  final _authController = AuthController();
  static int retryCount = 0;

  Future<List<SchoolModel>> getSchool(BuildContext context) async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    var accessToken = userProvider.accessToken;

    try {
      final response = await http.get(
        Uri.parse('$apiURL/api/schools'),
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $accessToken",
        },
      );
      if (response.statusCode == 200) {
        List<dynamic> jsonResponse = json.decode(response.body);
        return jsonResponse
            .map((school) => SchoolModel.fromJson(school))
            .toList();
      } else if (response.statusCode == 401) {
        Navigator.pushNamedAndRemoveUntil(context, '/login', (route) => false);
        throw Exception('Wrong Token. Please login again.');
      } else if (response.statusCode == 403 && retryCount <= 1) {
        await _authController.refreshToken(context);
        accessToken = userProvider.accessToken;
        retryCount++;

        return await getSchool(context);
      } else if (response.statusCode == 403 && retryCount > 1) {
        Navigator.pushNamedAndRemoveUntil(context, '/login', (route) => false);
        throw Exception('Token expired. Please login again.');
      } else {
        throw Exception('Failed to load School with status code: ${response.statusCode}');
      }
    } catch (err) {
      throw Exception('Failed to load School');
    }
  }

  Future<void> insertSchool(BuildContext context, String schoolName,
      DateTime date, String startTime, String endTime, String location,
      int studentCount, String teacherName, String phoneTeacher,
      String faculty, int countParticipants) async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    var accessToken = userProvider.accessToken;
    final Map<String, dynamic> insertData = {
      "school_name": schoolName,
      "date": date.toIso8601String(),
      "startTime": startTime,
      "endTime": endTime,
      "location": location,
      "student_count": studentCount,
      "teacher_name": teacherName,
      "phone_teacher": phoneTeacher,
      "faculty": faculty,
      "count_participants": countParticipants,
    };
    try {
      final response = await http.post(
        Uri.parse("$apiURL/api/schools"),
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $accessToken"
        },
        body: jsonEncode(insertData),
      );
      if (response.statusCode == 201) {
        print("Product inserted successfully!");
      } else if (response.statusCode == 401) {
        Navigator.pushNamedAndRemoveUntil(context, '/login', (route) => false);
        throw Exception('Wrong Token. Please login again.');
      } else if (response.statusCode == 403 && retryCount <= 1) {
        await _authController.refreshToken(context);
        accessToken = userProvider.accessToken;
        retryCount++;

        return await insertSchool(context, schoolName, date, startTime,
            endTime, location, studentCount, teacherName,
            phoneTeacher, faculty, countParticipants);
      } else if (response.statusCode == 403 && retryCount > 1) {
        Navigator.pushNamedAndRemoveUntil(context, '/login', (route) => false);
        throw Exception('Token expired. Please login again.');
      } else {
        throw Exception('Failed to insert School. Server response: ${response.body}');
      }
    } catch (error) {
      print('Error inserting School: $error');
      throw Exception('Failed to insert School due to error: $error');
    }
  }

  Future<void> updateSchool(BuildContext context, String schoolsId,
      String schoolName, DateTime date, String startTime, String endTime,
      String location, int studentCount, String teacherName,
      String phoneTeacher, String faculty, int countParticipants) async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    var accessToken = userProvider.accessToken;

    final Map<String, dynamic> updateData = {
      "school_name": schoolName,
      "date": date.toIso8601String(),
      "startTime": startTime,
      "endTime": endTime,
      "location": location,
      "student_count": studentCount,
      "teacher_name": teacherName,
      "phone_teacher": phoneTeacher,
      "faculty": faculty,
      "count_participants": countParticipants,
    };

    try {
      final response = await http.put(
        Uri.parse("$apiURL/api/schools/$schoolsId"),
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $accessToken"
        },
        body: jsonEncode(updateData),
      );
      if (response.statusCode == 200) {
        print("School updated successfully!");
      } else if (response.statusCode == 401) {
        Navigator.pushNamedAndRemoveUntil(context, '/login', (route) => false);
        throw Exception('Wrong Token. Please login again.');
      } else if (response.statusCode == 403 && retryCount <= 1) {
        await _authController.refreshToken(context);
        accessToken = userProvider.accessToken;
        retryCount++;

        return await updateSchool(context, schoolsId, schoolName, date,
            startTime, endTime, location, studentCount, teacherName,
            phoneTeacher, faculty, countParticipants);
      } else if (response.statusCode == 403 && retryCount > 1) {
        Navigator.pushNamedAndRemoveUntil(context, '/login', (route) => false);
        throw Exception('Token expired. Please login again.');
      } else {
        throw Exception('Failed to update School. Server response: ${response.body}');
      }
    } catch (error) {
      print('Error updating School: $error');
      throw Exception('Failed to update School due to error: $error');
    }
  }

  Future<void> deleteSchool(BuildContext context, String schoolsId) async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    var accessToken = userProvider.accessToken;

    try {
      final response = await http.delete(
        Uri.parse("$apiURL/api/schools/$schoolsId"),
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $accessToken"
        },
      );

      if (response.statusCode == 200) {
        print("School deleted successfully!");
      } else if (response.statusCode == 401) {
        Navigator.pushNamedAndRemoveUntil(context, '/login', (route) => false);
        throw Exception('Wrong Token. Please login again.');
      } else if (response.statusCode == 403 && retryCount <= 1) {
        await _authController.refreshToken(context);
        accessToken = userProvider.accessToken;
        retryCount++;

        return await deleteSchool(context, schoolsId);
      } else if (response.statusCode == 403 && retryCount > 1) {
        Navigator.pushNamedAndRemoveUntil(context, '/login', (route) => false);
        throw Exception('Token expired. Please login again.');
      } else {
        throw Exception('Failed to delete School. Server response: ${response.body}');
      }
    } catch (error) {
      print('Error deleting School: $error');
      throw Exception('Failed to delete School due to error: $error');
    }
  }
}
