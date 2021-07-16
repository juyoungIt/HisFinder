import 'package:flutter/material.dart';
import 'package:untitled/start/Signin.dart';

// main 함수, flutter 앱의 시작점을 의미함.
void main() => runApp(MyApp());

// 기본적으로 Applicaiton이 시작하는 로직을 기술하는 부분
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // material 디자인을 사용하는 애플리케이션을 생성하겠음을 의미
    return MaterialApp(
      debugShowCheckedModeBanner: false, // 화면 상단에 나타나는 debug symbol 을 삭제한다.
      home: SigninPage(), // 앱의 기본경로를 위한 widget
    );
  }
}