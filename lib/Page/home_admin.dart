import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:natthawut_flutter_049/Page/EditSchoolPage.dart'; // Updated to EditSchoolPage
import 'dart:math';
import 'package:natthawut_flutter_049/Widget/customCliper.dart';
import 'package:natthawut_flutter_049/controllers/auth_controller.dart';
import 'package:natthawut_flutter_049/models/user_model.dart';
import 'package:natthawut_flutter_049/providers/user_provider.dart';
import 'package:natthawut_flutter_049/models/school_model.dart';
import 'package:natthawut_flutter_049/controllers/school_controller.dart';
import 'package:provider/provider.dart';

class HomeAdmin extends StatefulWidget {
  const HomeAdmin({super.key});

  @override
  _HomeAdminState createState() => _HomeAdminState();
}

class _HomeAdminState extends State<HomeAdmin> {
  List<SchoolModel> schools = []; // Changed to SchoolModel
  bool isLoading = true;
  String? errorMessage;

  @override
  void initState() {
    super.initState();
    _fetchSchools(); // Updated to fetch schools
  }

  Future<void> _showLogoutConfirmationDialog(BuildContext context) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button to dismiss
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10.0)), // Rounded Dialog
          title: const Text(
            'ยืนยันการออกจากระบบ',
            style: TextStyle(color: Color(0xffC7253E), fontWeight: FontWeight.bold),
          ),
          content: const Text('คุณแน่ใจหรือไม่ว่าต้องการออกจากระบบ?'),
          actions: <Widget>[
            TextButton(
              style: TextButton.styleFrom(
                foregroundColor: Color(0xffC7253E),
              ),
              child: const Text('ยกเลิก'),
              onPressed: () {
                Navigator.of(context).pop(); // close the dialog
              },
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xff821131),
              ),
              child: const Text('ออกจากระบบ'),
              onPressed: () {
                Provider.of<UserProvider>(context, listen: false).onLogout();

                Navigator.pushReplacementNamed(context, '/login');
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> _fetchSchools() async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    try {
      final schoolList = await SchoolController().getSchool(context);
      setState(() {
        schools = schoolList;
        isLoading = false;
      });
    } catch (error) {
      setState(() {
        errorMessage = 'Error fetching schools: $error';
        isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error fetching schools: $error')));
    }
  }

  void updateSchool(SchoolModel school) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => EditSchoolPage(school: school),
      ),
    );
  }

  Future<void> deleteSchool(SchoolModel school) async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    final confirmDelete = await showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10.0)),
          title: const Text('ยืนยันการลบโรงเรียน'),
          content: const Text('คุณแน่ใจหรือไม่ว่าต้องการลบโรงเรียนนี้?'),
          actions: <Widget>[
            TextButton(
              style: TextButton.styleFrom(
                foregroundColor: Color(0xffC7253E),
              ),
              child: const Text('ยกเลิก'),
              onPressed: () {
                Navigator.of(context).pop(false);
              },
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xff821131),
              ),
              child: const Text('ลบ'),
              onPressed: () {
                Navigator.of(context).pop(true);
              },
            ),
          ],
        );
      },
    );

    if (confirmDelete == true) {
      try {
        await SchoolController().deleteSchool(context, school.id);
        await _fetchSchools();
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('ลบโรงเรียนสำเร็จ')));
      } catch (error) {
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Error deleting school: $error')));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: Color.fromARGB(255, 214, 255, 236),
      body: Container(
        height: height,
        child: Stack(
          children: [
            // Background
            Positioned(
              top: -height * .1,
              right: -width * .4,
              child: Transform.rotate(
                angle: -pi / 3.5,
                child: ClipPath(
                  clipper: ClipPainter(),
                  child: Container(
                    height: height * .5,
                    width: width,
                    color: Color(0xffA8E6CF),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(height: height * .1),
                    RichText(
                      textAlign: TextAlign.center,
                      text: TextSpan(
                        text: 'จัดการ',
                        style: TextStyle(
                            fontSize: 35,
                            fontWeight: FontWeight.w900,
                            color: Color(0xff2E7D32)),
                        children: [
                          TextSpan(
                            text: 'โรงเรียน',
                            style: TextStyle(
                                color: Color(0xff388E3C), fontSize: 35),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.pushNamed(context, '/add_school');
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xff388E3C),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8)),
                      ),
                      child: Text('เพิ่มโรงเรียนใหม่',
                          style: TextStyle(color: Colors.white)),
                    ),
                    SizedBox(height: 20),
                    if (isLoading)
                      CircularProgressIndicator()
                    else if (errorMessage != null)
                      Text(errorMessage!, style: TextStyle(color: Colors.red))
                    else
                      _buildSchoolList(),
                  ],
                ),
              ),
            ),
            // LogOut Button
            Positioned(
              top: 50.0,
              right: 16.0,
              child: GestureDetector(
                behavior: HitTestBehavior.translucent,
                onTap: () {
                  _showLogoutConfirmationDialog(context);
                },
                child: Icon(Icons.logout, color: Color(0xffC7253E), size: 30),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSchoolList() {
    return ListView.builder(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      itemCount: schools.length,
      itemBuilder: (context, index) {
        final school = schools[index];
        return Container(
          margin: EdgeInsets.symmetric(vertical: 5),
          padding: EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.2),
                blurRadius: 5,
                spreadRadius: 1,
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                school.schoolName,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Color(0xffC7253E),
                ),
              ),
              SizedBox(height: 5),
              Text('วันที่: ${school.date.toLocal().toString().split(' ')[0]}'),
              Text('เวลาเริ่ม: ${school.startTime}'),
              Text('เวลาสิ้นสุด: ${school.endTime}'),
              Text('ที่อยู่: ${school.location}'),
              Text('จำนวนผู้เรียน: ${school.studentCount}'),
              Text('ชื่อครู: ${school.teacherName}'),
              Text('เบอร์ติดต่อครู: ${school.phoneTeacher}'),
              Text('คณะ: ${school.faculty}'),
              Text('จำนวนผู้เข้าร่วม: ${school.countParticipants}'),
              SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  IconButton(
                    icon: Icon(Icons.edit, color: Color(0xffFABC3F)),
                    onPressed: () {
                      updateSchool(school);
                    },
                  ),
                  IconButton(
                    icon: Icon(Icons.delete, color: Color(0xff821131)),
                    onPressed: () {
                      deleteSchool(school);
                    },
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}
