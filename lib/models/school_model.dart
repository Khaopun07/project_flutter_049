import 'dart:convert';

SchoolModel welcomeFromJson(String str) => SchoolModel.fromJson(json.decode(str));

String welcomeToJson(SchoolModel data) => json.encode(data.toJson());

class SchoolModel {
  String schoolName;
  DateTime date;
  String startTime;
  String endTime;
  String location;
  int studentCount;
  String teacherName;
  String phoneTeacher;
  String faculty;
  int countParticipants;
  String id;
  int v;

  SchoolModel({
    required this.schoolName,
    required this.date,
    required this.startTime,
    required this.endTime,
    required this.location,
    required this.studentCount,
    required this.teacherName,
    required this.phoneTeacher,
    required this.faculty,
    required this.countParticipants,
    required this.id,
    required this.v,
  });

  factory SchoolModel.fromJson(Map<String, dynamic> json) => SchoolModel(
    schoolName: json["school_name"],
    date: DateTime.parse(json["date"]),
    startTime: json["startTime"],
    endTime: json["endTime"],
    location: json["location"],
    studentCount: json["student_count"],
    teacherName: json["teacher_name"],
    phoneTeacher: json["phone_teacher"],
    faculty: json["faculty"],
    countParticipants: json["count_participants"],
    id: json["_id"],
    v: json["__v"],
  );

  Map<String, dynamic> toJson() => {
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
    "_id": id,
    "__v": v,
  };
}
