import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:untitled/start/Signin.dart';
import 'package:firebase_auth/firebase_auth.dart';

class SignupPage extends StatelessWidget {
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
            GoToSignIn(),
          ],
        )
    );
  }
}

class InputForm extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return InputFormTemplate();
  }
}

class InputFormTemplate extends State<InputForm> {
  final TextEditingController _sidController = TextEditingController(); // 학번 입력 form에 대한 controller
  final TextEditingController _pwController = TextEditingController();  // password 입력 form에 대한 controller
  final TextEditingController _pwConfController = TextEditingController(); // 비밀번호 확인을 위한 controller
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
          Container(height: 10),
          TextFormField(
              obscureText: true,
              controller: _pwConfController,
              decoration: InputDecoration(
                contentPadding: new EdgeInsets.symmetric(vertical: 1.0, horizontal: 10.0),
                prefixIcon: Image.asset("assets/password.png", scale: 3),
                focusedBorder: OutlineInputBorder(borderSide: BorderSide(width: 2, color: const Color(0xff6990FF))),
                enabledBorder: OutlineInputBorder(borderSide: BorderSide(width: 2, color: const Color(0xff6990FF))),
                errorBorder: OutlineInputBorder(borderSide: BorderSide(width: 2, color: const Color(0xffff0000))),
                border: OutlineInputBorder(borderSide: BorderSide(width: 2, color: Colors.red)),
                hintText: "Password Confirm",
              ),
              validator: (value){
                if(value!.length < 1 || value!=_pwController.text)
                  return "비밀번호를 확인해주세요.";
              }
          ),
          Container(height: 20),
          SizedBox(
              width: 500,
              height: 50,
              child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    primary: const Color(0xff6990FF), // background
                    onPrimary: Colors.white, // foreground
                  ),
                  child: Text('Sign in', style: TextStyle(color: Colors.white)),
                  onPressed: () async {
                    if (_formKey.currentState!.validate()) {
                      try {
                        UserCredential userCredential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
                            email: _sidController.text + "@handong.edu",
                            password: _pwController.text
                        );
                        User? user = FirebaseAuth.instance.currentUser;
                        if(user != null && !user.emailVerified) {
                          await user.sendEmailVerification();
                          ScaffoldMessenger.of(context)
                              .showSnackBar(SnackBar(content: Text('회원가입을 위한 인증메일이 발송되었습니다. 메일주소를 인증하세요.')));
                        }
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => SigninPage()),
                        );

                      } on FirebaseAuthException catch (e) {
                        if (e.code == 'weak-password') {
                          ScaffoldMessenger.of(context)
                              .showSnackBar(SnackBar(content: Text('너무 약한 비밀번호 입니다.')));
                        } else if (e.code == 'email-already-in-use') {
                          ScaffoldMessenger.of(context)
                              .showSnackBar(SnackBar(content: Text('이미 등록된 계정 입니다.')));
                        }
                      } catch (e) {
                        print(e);
                      }
                    }
                    else {
                      ScaffoldMessenger.of(context)
                          .showSnackBar(SnackBar(content: Text('오류발생! 입력값을 확인하세요!')));
                    }
                  }
              )
          ),
          Container(height: 50),
        ],
      ),
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

// 로그인 페이지로 이동하는 부분에 대한 코드
class GoToSignIn extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Text("Have an Account?",
                style: TextStyle(
                    fontFamily: 'avenir',
                    color: const Color(0xff6990FF)
                ),
              ),
              TextButton(onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => SigninPage()),
                );
              }, child: Text("Signin", style: TextStyle(
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