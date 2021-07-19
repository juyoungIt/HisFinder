import 'package:flutter/material.dart';
import 'package:untitled/start/Signup.dart';

class SigninPage extends StatelessWidget {
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
                GuestLogin(), // 게스트 로그인과 관련된 컴포넌트를 삽입하는 부분
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

class InputFormTemplate extends State<InputForm> {
  final TextEditingController _sidController = TextEditingController(); // 학번 입력 form에 대한 controller
  final TextEditingController _pwController = TextEditingController();  // password 입력 form에 대한 controller
  final _formKey = GlobalKey<FormState>();

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
                  hintText: "Student ID"
              ),
              validator: (value) {
                if(value!.length < 1)
                  return "학번을 입력해주세요.";
                }
          ),
          Container(height: 10),
          TextFormField(
              obscureText: true,
              controller: _pwController,
              decoration: InputDecoration(
                contentPadding: new EdgeInsets.symmetric(vertical: 1.0, horizontal: 10.0),
                prefixIcon: Image.asset("assets/password.png", scale: 3),
                focusedBorder: OutlineInputBorder(borderSide: BorderSide(width: 2, color: const Color(0xff6990FF))),
                enabledBorder: OutlineInputBorder(borderSide: BorderSide(width: 2, color: const Color(0xff6990FF))),
                errorBorder: OutlineInputBorder(borderSide: BorderSide(width: 2, color: const Color(0xffff0000))),
                border: OutlineInputBorder(borderSide: BorderSide(width: 2, color: Colors.red)),
                hintText: "Password",
              ),
              validator: (value){
                if(value!.length < 1)
                  return "비밀번호를 입력해주세요.";
              }
          ),
          Container(
            alignment: Alignment.topRight,
            child: TextButton(
                child: Text('Forgot your password?',
                  style: TextStyle(
                    fontFamily: 'avenir',
                    color: const Color(0xff6990FF),
                  ),
                ),
                onPressed: () { }
            ),
          ),
          SizedBox(
              width: 500,
              height: 50,
              child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    primary: const Color(0xff6990FF), // background
                    onPrimary: Colors.white, // foreground
                  ),
                  child: Text('Sign in', style: TextStyle(color: Colors.white)),
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      // If the form is valid, display a snackbar. In the real world,
                      // you'd often call a server or save the information in a database.
                      ScaffoldMessenger.of(context)
                          .showSnackBar(SnackBar(content: Text('로그인 되었습니다')));
                      print("user id = " + _sidController.text);
                      print("password = " + _pwController.text);
                    }
                    else {
                      ScaffoldMessenger.of(context)
                          .showSnackBar(SnackBar(content: Text('오류발생! 입력값을 확인하세요!')));
                    }
                  }
              )
          )
        ],
      ),
    );
  }
}

// 게스트 로그인을 안내하는 파트
class GuestLogin extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        // - Guest Login 기능에 대한 부분 -
        Text(
          '-OR-',
          style: TextStyle(
            fontFamily: 'avenir',
            color: const Color(0xff6990FF),
          ),
        ),
        Container(height: 15), // 공백 삽입을 목적으로 추가된 부분
        // Gueset Login을 안내하는 text를 출력하는 부분
        Text(
          'Guest Login',
          style: TextStyle(
            fontFamily: 'avenir',
            fontWeight: FontWeight.bold,
            color: const Color(0xff6990FF),
          ),
        ),
        // 게스트 로그인 기능으로 연결되는 버튼 부분
        IconButton(
          onPressed: () { },
          icon: Image.asset('assets/guest.png', scale: 4),
        )
      ],
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