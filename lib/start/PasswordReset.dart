import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:untitled/start/Signup.dart';
import 'package:untitled/write/write.dart';

import 'Signin.dart';

class PasswordResetPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return Scaffold(
        body: Stack(
          alignment: Alignment.center,
          children: <Widget>[
            Container(color: Colors.white), // 배경색상 변경을 용이하게 하기 위한 목적으로 추가
            // 로그인 정보를 입력하는 form을 column으로 구성
            Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                LogoText(), // 서비스 로고
                // 로그인 정보 입력 form
                Padding(
                  padding: EdgeInsets.all(size.width*0.06),
                  child: InputForm(),
                ),
              ],
            ),
            GoToSignUp(),
          ],
        )
    );
  }
}

// 로그인창 상단에 표시되는 "HisFinder" 로고에 대해 정의한 부분
class LogoText extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Text(
      'HisFinder',
      style: TextStyle(
        fontFamily: 'avenir',
        fontStyle: FontStyle.italic,
        fontWeight: FontWeight.w400,
        color: const Color(0xff6990FF),
      ),
      textScaleFactor: 2.5,
    );
  }
}

// 로그인 정보를 입력받는 form과 로그인 버튼에 대한 부분
class InputForm extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return InputFormTemplate();
  }
}

// 회원가입한 이메일 정보를 입력하는 부분
class InputFormTemplate extends State<InputForm> {
  final TextEditingController _sidController = TextEditingController(); // 학번 입력 form에 대한 controller
  final _formKey = GlobalKey<FormState>();

  // Set default `_initialized` and `_error` state to false
  bool _initialized = false;
  bool _error = false;

  // Define an async function to initialize FlutterFire
  void initializeFlutterFire() async {
    try {
      // Wait for Firebase to initialize and set `_initialized` state to true
      await Firebase.initializeApp();
      setState(() {
        _initialized = true;
      });
    } catch(e) {
      // Set `_error` state to true if Firebase initialization fails
      setState(() {
        _error = true;
      });
    }
  }

  @override
  void initState() {
    initializeFlutterFire();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: <Widget>[
          // 학번을 입력하는 코드 부분
          TextFormField(
              controller: _sidController,
              decoration: InputDecoration (
                  contentPadding: new EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
                  prefixIcon: Image.asset("assets/sid.png", scale: 3),
                  focusedBorder: OutlineInputBorder(borderSide: BorderSide(width: 2, color: const Color(0xff6990FF))),
                  enabledBorder: OutlineInputBorder(borderSide: BorderSide(width: 2, color: const Color(0xff6990FF))),
                  errorBorder: OutlineInputBorder(borderSide: BorderSide(width: 2, color: const Color(0xffff0000))),
                  border: OutlineInputBorder(borderSide: BorderSide(width: 2, color: Colors.red)),
                  hintText: "학번을 입력하세요."
              ),
              validator: (value) {
                if(value!.length < 1)
                  return "학번을 입력해주세요.";
              }
          ),
          Container(height: 10),
          SizedBox(
              width: 500,
              height: 50,
              child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    primary: const Color(0xff6990FF), // background
                    onPrimary: Colors.white, // foreground
                  ),
                  child: Text('초기화 메일 보내기', style: TextStyle(color: Colors.white)),
                  onPressed: () async {
                    if (_formKey.currentState!.validate()) {
                      FirebaseAuth.instance.sendPasswordResetEmail(
                          email: _sidController.text + "@handong.edu"
                      );
                      ScaffoldMessenger.of(context)
                          .showSnackBar(SnackBar(content: Text('초기화 메일을 발송하였습니다. 이메일을 확인해주세요')));
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => SigninPage()),
                      );
                    }
                  }
              )
          )
        ],
      ),
    );
  }
}

// 애플리케이션 하단, 회원가입 페이지로 연결되는 메시지 및 버튼
class GoToSignUp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Text("Don't have an Account?",
                style: TextStyle(
                    fontFamily: 'avenir',
                    color: const Color(0xff6990FF)
                ),
              ),
              TextButton(onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => SignupPage()),
                );
              }, child: Text("Signup", style: TextStyle(
                fontFamily: 'avenir',
                fontWeight: FontWeight.bold,
                color: const Color(0xff6990FF),
              ),
              ),
              ),
            ],
          ),
          Container(height: 20)
        ]
    );
  }
}