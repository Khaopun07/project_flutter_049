import 'package:flutter/material.dart';
import 'dart:math';
import 'package:natthawut_flutter_049/Widget/customCliper.dart';
import 'package:natthawut_flutter_049/controllers/school_controller.dart';
import 'package:natthawut_flutter_049/models/school_model.dart'; // Ensure you import the SchoolModel

class AddSchoolPage extends StatefulWidget {
  @override
  _AddSchoolPageState createState() => _AddSchoolPageState();
}

class _AddSchoolPageState extends State<AddSchoolPage> {
  final _formKey = GlobalKey<FormState>();
  final SchoolController _schoolController = SchoolController();
  String schoolName = '';
  DateTime date = DateTime.now(); // This can be updated from a DatePicker
  String startTime = '';
  String endTime = '';
  String location = '';
  int studentCount = 0; // This might be set based on user input
  String teacherName = '';
  String phoneTeacher = '';
  String faculty = '';
  int countParticipants = 0; // Initialize as needed

  // Function to add a new school
  void _addNewSchool() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      // Create a new instance of SchoolModel
      SchoolModel newSchool = SchoolModel(
        schoolName: schoolName,  
        date: DateTime.now(),  
        startTime: startTime,  
        endTime: endTime,  
        location: location,  
        studentCount: studentCount,  
        teacherName: teacherName,  
        phoneTeacher: phoneTeacher,  
        faculty: faculty,  
        countParticipants: countParticipants,  
        id: '',  
        v: 0,  
      );

      // Save the school using the controller
      _schoolController.insertSchool(
        context,
        newSchool.schoolName,
        newSchool.date,
        newSchool.startTime,
        newSchool.endTime,
        newSchool.location,
        newSchool.studentCount,
        newSchool.teacherName,
        newSchool.phoneTeacher,
        newSchool.faculty,
        newSchool.countParticipants,
      ).then((_) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('เพิ่มโรงเรียนเรียบร้อยแล้ว')),
        );
        Navigator.pushReplacementNamed(context, '/admin');
      }).catchError((error) {
        if (error.toString().contains('401')) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('token หมดอายุแล้ว กรุณา login ใหม่')),
          );
          Navigator.pushNamedAndRemoveUntil(context, '/login', (route) => false);
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('เกิดข้อผิดพลาด: $error')),
          );
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;

    return Scaffold(
      body: Container(
        height: height,
        child: Stack(
          children: [
            // Background
            Positioned(
              top: -height * .15,
              right: -width * .4,
              child: Transform.rotate(
                angle: -pi / 3.5,
                child: ClipPath(
                  clipper: ClipPainter(),
                  child: Container(
                    height: height * .5,
                    width: width,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Color(0xffE1F5E4), // Light green color
                          Color(0xffA5D6A7), // Darker green color
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
            // Form content
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    SizedBox(height: height * .1),
                    RichText(
                      textAlign: TextAlign.center,
                      text: TextSpan(
                        text: 'เพิ่ม',
                        style: TextStyle(
                          fontSize: 35,
                          fontWeight: FontWeight.w900,
                          color: Color(0xff2E7D32), // Green color
                        ),
                        children: [
                          TextSpan(
                            text: 'โรงเรียนใหม่',
                            style: TextStyle(
                                color: Color(0xff388E3C),
                                fontSize: 35), // Darker green
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 30),
                    Card(
                      elevation: 8,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: Form(
                          key: _formKey,
                          child: Column(
                            children: <Widget>[
                              _buildTextField(
                                label: 'ชื่อโรงเรียน',
                                icon: Icons.school,
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'กรุณากรอกชื่อโรงเรียน';
                                  }
                                  return null;
                                },
                                onSaved: (value) {
                                  schoolName = value!;
                                },
                              ),
                              SizedBox(height: 16),
                              _buildTextField(
                                label: 'วันที่',
                                icon: Icons.calendar_today,
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'กรุณากรอกวันที่';
                                  }
                                  return null;
                                },
                                onSaved: (value) {
                                  date = DateTime.parse(value!); // Assuming date input is in string format
                                },
                              ),
                              SizedBox(height: 16),
                              _buildTextField(
                                label: 'เวลาเริ่ม',
                                icon: Icons.access_time,
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'กรุณากรอกเวลาเริ่ม';
                                  }
                                  return null;
                                },
                                onSaved: (value) {
                                  startTime = value!;
                                },
                              ),
                              SizedBox(height: 16),
                              _buildTextField(
                                label: 'เวลาสิ้นสุด',
                                icon: Icons.access_time,
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'กรุณากรอกเวลาสิ้นสุด';
                                  }
                                  return null;
                                },
                                onSaved: (value) {
                                  endTime = value!;
                                },
                              ),
                              SizedBox(height: 16),
                              _buildTextField(
                                label: 'สถานที่',
                                icon: Icons.location_on,
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'กรุณากรอกสถานที่';
                                  }
                                  return null;
                                },
                                onSaved: (value) {
                                  location = value!;
                                },
                              ),
                              SizedBox(height: 16),
                              _buildTextField(
                                label: 'จำนวนผู้เรียน',
                                icon: Icons.group,
                                keyboardType: TextInputType.number,
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'กรุณากรอกจำนวนผู้เรียน';
                                  }
                                  if (int.tryParse(value) == null) {
                                    return 'กรุณากรอกจำนวนที่ถูกต้อง';
                                  }
                                  return null;
                                },
                                onSaved: (value) {
                                  studentCount = int.parse(value!);
                                },
                              ),
                              SizedBox(height: 16),
                              _buildTextField(
                                label: 'ชื่อครู',
                                icon: Icons.person,
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'กรุณากรอกชื่อครู';
                                  }
                                  return null;
                                },
                                onSaved: (value) {
                                  teacherName = value!;
                                },
                              ),
                              SizedBox(height: 16),
                              _buildTextField(
                                label: 'เบอร์โทรครู',
                                icon: Icons.phone,
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'กรุณากรอกเบอร์โทรครู';
                                  }
                                  return null;
                                },
                                onSaved: (value) {
                                  phoneTeacher = value!;
                                },
                              ),
                              SizedBox(height: 16),
                              _buildTextField(
                                label: 'คณะ',
                                icon: Icons.business,
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'กรุณากรอกคณะ';
                                  }
                                  return null;
                                },
                                onSaved: (value) {
                                  faculty = value!;
                                },
                              ),
                              SizedBox(height: 16),
                              _buildTextField(
                                label: 'จำนวนผู้เข้าร่วม',
                                icon: Icons.people,
                                keyboardType: TextInputType.number,
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'กรุณากรอกจำนวนผู้เข้าร่วม';
                                  }
                                  if (int.tryParse(value) == null) {
                                    return 'กรุณากรอกจำนวนที่ถูกต้อง';
                                  }
                                  return null;
                                },
                                onSaved: (value) {
                                  countParticipants = int.parse(value!);
                                },
                              ),
                              SizedBox(height: 30),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  ElevatedButton(
                                    onPressed: _addNewSchool,
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Color(0xff2E7D32), // Green color
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      padding: EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
                                    ),
                                    child: Text(
                                      'บันทึก',
                                      style: TextStyle(
                                        fontSize: 18,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                  ElevatedButton(
                                    onPressed: () {
                                      Navigator.pushReplacementNamed(context, '/admin');
                                    },
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Color.fromRGBO(103, 58, 183, 1), // Example color
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      padding: EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
                                    ),
                                    child: Text(
                                      'ยกเลิก',
                                      style: TextStyle(
                                        fontSize: 18,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField({
    required String label,
    required IconData icon,
    required String? Function(String?) validator,
    required void Function(String?) onSaved,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return TextFormField(
      keyboardType: keyboardType,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon, color: Color(0xff388E3C)), // Green icon
        border: OutlineInputBorder(),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Color(0xff2E7D32), width: 2),
        ),
      ),
      validator: validator,
      onSaved: onSaved,
    );
  }
}
