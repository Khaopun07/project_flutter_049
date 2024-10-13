import 'package:flutter/material.dart';
import 'package:natthawut_flutter_049/Page/AddSchoolPage.dart';
import 'package:natthawut_flutter_049/Page/EditSchoolPage.dart';
import 'package:natthawut_flutter_049/Page/home_admin.dart';

import 'package:natthawut_flutter_049/Page/home_screen.dart';
import 'package:natthawut_flutter_049/Page/login_screen.dart';
import 'package:natthawut_flutter_049/Page/register.dart';
import 'package:natthawut_flutter_049/providers/user_provider.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => UserProvider(),
      child: MaterialApp(
          title: 'Login Example',
          theme: ThemeData(
            primarySwatch: Colors.blue,
          ),
          debugShowCheckedModeBanner: false,
          initialRoute: '/login',
          routes: {
            '/home': (context) => HomeScreen(),
            '/login': (context) => LoginScreen(),
            '/register': (context) => RegisterPage(),
            '/admin': (context) => HomeAdmin(),
            '/add_school': (context) => AddSchoolPage(),
          }),
    );
  }
}