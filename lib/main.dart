import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:untitled/start/Signin.dart';

// main 함수, flutter 앱의 시작점을 의미함.
void main() {
  runApp(MyApp());
}

// 기본적으로 Applicaiton이 시작하는 로직을 기술하는 부분
class MyApp extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return MyAppTemplate();
  }
}

class MyAppTemplate extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    // material 디자인을 사용하는 애플리케이션을 생성하겠음을 의미
    return MaterialApp(
      debugShowCheckedModeBanner: false, // 상단 베너 삭제
      home: SigninPage(), // 앱의 기본경로를 위한 widget
    );
  }
}