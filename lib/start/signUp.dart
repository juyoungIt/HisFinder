import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:untitled/start/signIn.dart';
import 'package:firebase_auth/firebase_auth.dart';

class SignupPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;

    return Scaffold(
        body: Stack(
          alignment: Alignment.center,
          children: <Widget>[
            Container(color: Colors.white), // for background color changing
            Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                LogoText(), // service logo (HisFinder)
                Padding(
                  padding: EdgeInsets.all(size.width*0.06),
                  child: InputForm(size), // input form for sign in
                ),
              ],
            ),
            GoToSignIn(), // link button for guest login
          ],
        )
    );
  }
}

class InputForm extends StatefulWidget {
  final Size size;

  InputForm(this.size);

  @override
  State<StatefulWidget> createState() {
    return InputFormTemplate();
  }
}

class InputFormTemplate extends State<InputForm> {
  // controller for input form field
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nicknameController = TextEditingController();
  final TextEditingController _sidController = TextEditingController();
  final TextEditingController _pwController = TextEditingController();
  final TextEditingController _pwConfController = TextEditingController();
  bool check = false; // 닉네임이 중복확인이 되었는 지를 확인하는 부분
  late QuerySnapshot checkQuery;
  List<DocumentSnapshot> checkItems = [];

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: <Widget>[
          Row(
            children: <Widget>[
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.65,
                child: TextFormField(
                    controller: _nicknameController,
                    decoration: InputDecoration (
                        contentPadding: new EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
                        prefixIcon: Image.asset("assets/sid.png", scale: 3),
                        focusedBorder: OutlineInputBorder(borderSide: BorderSide(width: 2, color: const Color(0xff6990FF))),
                        enabledBorder: OutlineInputBorder(borderSide: BorderSide(width: 2, color: const Color(0xff6990FF))),
                        errorBorder: OutlineInputBorder(borderSide: BorderSide(width: 2, color: const Color(0xffff0000))),
                        border: OutlineInputBorder(borderSide: BorderSide(width: 2, color: Colors.red)),
                        hintText: "닉네임"
                    ),
                    validator: (value) {
                      if(value!.length < 1)
                        return "닉네임을 입력해주세요.";
                      else if(!check)
                        return "중복확인을 진행해주세요.";
                    }
                ),
              ),
              Padding(padding: EdgeInsets.only(right: 10)),
              SizedBox(
                  width: MediaQuery.of(context).size.width * 0.2,
                  height: 53,
                  child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        primary: const Color(0xff6990FF), // background
                        onPrimary: Colors.white, // foreground
                      ),
                      child: Text('중복확인', style: TextStyle(color: Colors.white)),
                      onPressed: ()  async {
                        var checkResult = FirebaseFirestore.instance.collection('Users')
                            .where('nickname', isEqualTo: _nicknameController.text.toString());
                        await checkResult.get().then((value) {
                          checkQuery = value;
                        });
                        checkItems.clear();
                        checkItems.addAll(checkQuery.docs);
                        if(checkItems.length != 0) {
                          ScaffoldMessenger.of(context)
                              .showSnackBar(SnackBar(content: Text('이미 사용 중인 닉네임 입니다. 다른 닉네임을 사용해주세요.')));
                        }
                        else {
                          check = true;
                          ScaffoldMessenger.of(context)
                              .showSnackBar(SnackBar(content: Text('사용 가능한 닉네임 입니다.')));
                        }
                      }
                  )
              ),
            ],
          ),
          // nickname input form field
          Container(height: 10),
          // student id input form field
          TextFormField(
              controller: _sidController,
              decoration: InputDecoration (
                  contentPadding: new EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
                  prefixIcon: Image.asset("assets/sid.png", scale: 3),
                  focusedBorder: OutlineInputBorder(borderSide: BorderSide(width: 2, color: const Color(0xff6990FF))),
                  enabledBorder: OutlineInputBorder(borderSide: BorderSide(width: 2, color: const Color(0xff6990FF))),
                  errorBorder: OutlineInputBorder(borderSide: BorderSide(width: 2, color: const Color(0xffff0000))),
                  border: OutlineInputBorder(borderSide: BorderSide(width: 2, color: Colors.red)),
                  hintText: "학번"
              ),
              validator: (value) {
                if(value!.length < 1)
                  return "학번을 입력해주세요.";
              }
          ),
          Container(height: 10),

          // password input form field
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
                hintText: "비밀번호",
              ),
              validator: (value){
                if(value!.length < 1)
                  return "비밀번호를 입력해주세요.";
              }
          ),
          Container(height: 10),
          // password confirm form field
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
                hintText: "비밀번호 확인",
              ),
              validator: (value){
                if(value!.length < 1 || value!=_pwController.text)
                  return "비밀번호를 확인해주세요.";
              }
          ),
          Container(height: 20),
          // the sign in button
          SizedBox(
              width: 500,
              height: 50,
              child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    primary: const Color(0xff6990FF), // background
                    onPrimary: Colors.white, // foreground
                  ),
                  child: Text("회원가입", style: TextStyle(color: Colors.white)),
                  onPressed: () async {
                    if (_formKey.currentState!.validate() && check) {
                      try {
                        UserCredential userCredential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
                            email: _sidController.text + "@handong.edu",
                            password: _pwController.text
                        );
                        User? user = FirebaseAuth.instance.currentUser;
                        if(user != null && !user.emailVerified) {
                          await user.sendEmailVerification();
                          // _showAlert(title: "인증메일 발송", message: "회원가입을 위한 인증메일이 발송되었습니다.\n메일주소를 인증하세요.");
                          ScaffoldMessenger.of(context)
                              .showSnackBar(SnackBar(content: Text('회원가입을 위한 인증메일이 발송되었습니다. 메일주소를 인증하세요.')));
                        }
                        // firestore에 별도로 사용자와 관련된 데이터를 저장
                        String uid = FirebaseAuth.instance.currentUser!.uid;
                        FirebaseFirestore.instance.collection('Users').doc(uid).set({
                          'nickname': _nicknameController.text.toString()
                        });
                        Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(builder: (context) => SignInPage()),
                              (route) => false,
                        );
                      } on FirebaseAuthException catch (e) {
                        if (e.code == 'weak-password') {
                          _showAlert(title: "회원가입 실패", message: "너무 약한 비밀번호 입니다. 보안을 위해 더 강한 비밀번호를 사용해야 합니다.");
                          // ScaffoldMessenger.of(context)
                          //     .showSnackBar(SnackBar(content: Text('너무 약한 비밀번호 입니다.')));
                        } else if (e.code == 'email-already-in-use') {
                          _showAlert(title: "회원가입 실패", message: "이미 등록된 계정 입니다. 로그인을 진행해 주세요.");
                          // ScaffoldMessenger.of(context)
                          //     .showSnackBar(SnackBar(content: Text('이미 등록된 계정 입니다.')));
                        }
                      } catch (e) {
                        print(e);
                      }
                    }
                    else {
                      _showAlert(title: "회원가입 실패", message: "오류발생! 입력값을 확인하세요!");
                      // ScaffoldMessenger.of(context)
                      //     .showSnackBar(SnackBar(content: Text('오류발생! 입력값을 확인하세요!')));
                    }
                  }
              )
          ),
          Container(height: 50),
        ],
      ),
    );
  }

  // cupertino alert
  void _showAlert({required String title, required String message}) {
    showCupertinoDialog(context: context, builder: (context) {
      return CupertinoAlertDialog(
        title: Text(title),
        content: Text(message),
        actions: [
          CupertinoDialogAction(
              isDefaultAction: true, child: Text("확인"), onPressed: () {
            Navigator.pop(context);
          })
        ],
      );
    });
  }
}

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
              Text("계정을 가지고 있나요?",
                style: TextStyle(
                    fontFamily: 'avenir',
                    color: const Color(0xff6990FF)
                ),
              ),
              TextButton(onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => SignInPage()),
                );
              }, child: Text("로그인", style: TextStyle(
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