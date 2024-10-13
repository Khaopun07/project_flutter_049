import 'package:flutter/material.dart';
import 'dart:math';
import 'package:natthawut_flutter_049/Widget/customCliper.dart'; // Assuming you already have customClipper
import 'package:natthawut_flutter_049/controllers/school_controller.dart';
import 'package:natthawut_flutter_049/models/school_model.dart';

class EditSchoolPage extends StatefulWidget {
  final SchoolModel school; // Receive SchoolModel to edit

  const EditSchoolPage({Key? key, required this.school}) : super(key: key);

  @override
  _EditSchoolPageState createState() => _EditSchoolPageState();
}

class _EditSchoolPageState extends State<EditSchoolPage> {
  final _formKey = GlobalKey<FormState>();
  late String schoolName;
  late DateTime date; // Adjusted to DateTime
  late String startTime;
  late String endTime;
  late String location;
  late int studentCount; // Assuming studentCount is an integer
  late String teacherName;
  late String phoneTeacher;
  late String faculty;
  late int countParticipants; // Assuming countParticipants is an integer

  @override
  void initState() {
    super.initState();
    // Get data from SchoolModel to display in the form
    schoolName = widget.school.schoolName;
    date = widget.school.date; // Assuming date is a DateTime
    startTime = widget.school.startTime;
    endTime = widget.school.endTime;
    location = widget.school.location;
    studentCount = widget.school.studentCount;
    teacherName = widget.school.teacherName;
    phoneTeacher = widget.school.phoneTeacher;
    faculty = widget.school.faculty;
    countParticipants = widget.school.countParticipants;
  }

  // Function to update the school
  Future<void> _updateSchool(BuildContext context, String schoolId) async {
    final schoolController = SchoolController();
    try {
      await schoolController.updateSchool(
        context,
        schoolId,
        schoolName,
        date,
        startTime,
        endTime,
        location,
        studentCount,
        teacherName,
        phoneTeacher,
        faculty,
        countParticipants,
      );
      // If the update is successful, navigate back to the previous screen
      Navigator.pushReplacementNamed(context, '/admin');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('School updated successfully')),
      );
    } catch (error) {
      // Handle error
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error updating school: $error')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;

    return Scaffold(
      body: Container(
        height: height,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xffE0F2E9), Color(0xffA5D6A7)], // Green gradient background
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
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
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [Color(0xffA5D6A7), Color(0xffE0F2E9)],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
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
                        text: 'แก้ไข',
                        style: TextStyle(
                          fontSize: 35,
                          fontWeight: FontWeight.w900,
                          color: Color(0xff4A7C0E), // Dark green color
                        ),
                        children: [
                          TextSpan(
                            text: ' ข้อมูลโรงเรียน',
                            style: TextStyle(
                              color: Color(0xff1B5E20),
                              fontSize: 35,
                            ), // Darker green color
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 30),
                    Card(
                      elevation: 5,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(20),
                        child: Form(
                          key: _formKey,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              _buildTextField(
                                label: 'ชื่อโรงเรียน',
                                initialValue: schoolName,
                                onSaved: (value) => schoolName = value!,
                              ),
                              SizedBox(height: 16),
                              _buildTextField(
                                label: 'วันที่',
                                initialValue: date.toIso8601String(),
                                onSaved: (value) => date = DateTime.parse(value!),
                              ),
                              SizedBox(height: 16),
                              _buildTextField(
                                label: 'เวลาเริ่ม',
                                initialValue: startTime,
                                onSaved: (value) => startTime = value!,
                              ),
                              SizedBox(height: 16),
                              _buildTextField(
                                label: 'เวลาสิ้นสุด',
                                initialValue: endTime,
                                onSaved: (value) => endTime = value!,
                              ),
                              SizedBox(height: 16),
                              _buildTextField(
                                label: 'สถานที่',
                                initialValue: location,
                                onSaved: (value) => location = value!,
                              ),
                              SizedBox(height: 16),
                              _buildTextField(
                                label: 'จำนวนเด็กนักเรียน',
                                initialValue: studentCount.toString(),
                                keyboardType: TextInputType.number,
                                onSaved: (value) => studentCount = int.parse(value!),
                              ),
                              SizedBox(height: 16),
                              _buildTextField(
                                label: 'ชื่อครู',
                                initialValue: teacherName,
                                onSaved: (value) => teacherName = value!,
                              ),
                              SizedBox(height: 16),
                              _buildTextField(
                                label: 'เบอร์โทรครู',
                                initialValue: phoneTeacher,
                                onSaved: (value) => phoneTeacher = value!,
                              ),
                              SizedBox(height: 16),
                              _buildTextField(
                                label: 'คณะ',
                                initialValue: faculty,
                                onSaved: (value) => faculty = value!,
                              ),
                              SizedBox(height: 16),
                              _buildTextField(
                                label: 'จำนวนผู้เข้าร่วม',
                                initialValue: countParticipants.toString(),
                                keyboardType: TextInputType.number,
                                onSaved: (value) => countParticipants = int.parse(value!),
                              ),
                              SizedBox(height: 30),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  ElevatedButton(
                                    onPressed: () {
                                      if (_formKey.currentState!.validate()) {
                                        _formKey.currentState!.save();
                                        // Call the update function
                                        _updateSchool(context, widget.school.id);
                                      }
                                    },
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Color(0xff4CAF50), // Green color
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
                                      child: Text(
                                        'แก้ไข',
                                        style: TextStyle(
                                          fontSize: 18,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                                  ),
                                  ElevatedButton(
                                    onPressed: () {
                                      Navigator.pushReplacementNamed(context, '/admin'); // Navigate to the school display page
                                    },
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Color.fromRGBO(103, 103, 103, 1),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
                                      child: Text(
                                        'ยกเลิก',
                                        style: TextStyle(
                                          fontSize: 18,
                                          color: Colors.white,
                                        ),
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

  // Function to create TextField for the school edit form
  Widget _buildTextField({
    required String label,
    required String initialValue,
    TextInputType? keyboardType,
    required FormFieldSetter<String> onSaved,
  }) {
    return TextFormField(
      decoration: InputDecoration(
        labelText: label,
        labelStyle: TextStyle(color: Colors.black54), // Label color
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: Colors.green), // Border color
        ),
        contentPadding: EdgeInsets.symmetric(vertical: 15, horizontal: 10), // Add padding inside the text field
      ),
      initialValue: initialValue,
      keyboardType: keyboardType,
      onSaved: onSaved,
    );
  }
}
