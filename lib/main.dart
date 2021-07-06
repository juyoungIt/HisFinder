import 'package:flutter/material.dart';
import 'package:untitled/start/Signin.dart';
import 'package:untitled/start/Signup.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: SigninPage(),
    );
  }
}
