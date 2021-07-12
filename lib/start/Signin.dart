import 'package:flutter/material.dart';
import 'package:untitled/start/Signup.dart';
import 'package:untitled/write/write.dart';

class SigninPage extends StatelessWidget {
  // this is key
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    final TextEditingController _sidController = TextEditingController();
    final TextEditingController _pwController = TextEditingController();

    return Scaffold(
        body: Stack(
          alignment: Alignment.center,
          children: <Widget>[
            Container(color: Colors.white),
            Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(
                  'HisFinder',
                  style: TextStyle(
                    fontFamily: 'avenir',
                    fontStyle: FontStyle.italic,
                    fontWeight: FontWeight.w400,
                    color: const Color(0xff6990FF),
                  ),
                  textScaleFactor: 2.5,
                ),
                // Image.asset("assets/logo.png", width:150, height: 150),
                // Container(width:100, height:100, color: Colors.blueAccent),
                Stack(
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.only(left: 12, right: 12, top: 12, bottom: 50),
                      child: Card(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20)
                        ),
                        elevation: 0,
                        child: Padding(
                          padding: EdgeInsets.all(size.width*0.05),
                          child: Form(child: Column(
                            key: _formKey,
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: <Widget>[
                              TextFormField(
                                  controller: _sidController,
                                  decoration: InputDecoration (
                                    // hintText:
                                      contentPadding: new EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
                                      // icon: Icon(Icons.account_circle),
                                      // prefixIcon: Icon(Icons.account_circle),
                                      prefixIcon: Image.asset("assets/sid.png", scale: 3),
                                      // fillColor: Colors.blueAccent,
                                      focusedBorder: OutlineInputBorder(
                                          borderSide: BorderSide(width: 2, color: const Color(0xff6990FF),)
                                      ),
                                      enabledBorder: OutlineInputBorder(
                                        borderSide: BorderSide(width: 2, color: const Color(0xff6990FF),),
                                      ),
                                      border: OutlineInputBorder(
                                          borderSide: BorderSide(width: 2, color: Colors.red)
                                      ),
                                      suffix: Text('@handong.edu'),
                                      hintText: "Student ID"
                                  ),
                                  validator: (String? value) {
                                    if (value == null || value.isEmpty) {
                                      return '아이디를 입력해주세요!';
                                    } else {
                                      var inputID = value;
                                      return null;
                                    }
                                  }
                              ),
                              Container(height: 10),
                              TextFormField(
                                obscureText: true,
                                controller: _pwController,
                                decoration: InputDecoration(
                                    contentPadding: new EdgeInsets.symmetric(vertical: 1.0, horizontal: 10.0),
                                    // icon: Icon(Icons.lock),
                                    prefixIcon: Image.asset("assets/password.png", scale: 3),
                                    focusedBorder: OutlineInputBorder(
                                        borderSide: BorderSide(width: 2, color: const Color(0xff6990FF),)
                                    ),
                                    enabledBorder: OutlineInputBorder(
                                        borderSide: BorderSide(width: 2, color: const Color(0xff6990FF),)
                                    ),
                                    hintText: "Password",
                                ),
                                validator: (String? value){
                                  if(value == null || value.isEmpty) {
                                    return "Please input correct student id";
                                  }
                                  return null;
                                },
                              ),
                              TextButton(onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(builder: (context) => WritePage()),
                                );
                              }, child: Text('Forgot your password?',
                                style: TextStyle(
                                  fontFamily: 'avenir',
                                  // fontStyle: FontStyle.italic,
                                  // fontWeight: FontWeight.w400,
                                  color: const Color(0xff6990FF),
                                ),
                              )
                              )
                            ],
                          ),
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      left: size.width*0.09,
                      right: size.width*0.09,
                      bottom: 0,
                      child: SizedBox(
                        height: 50,
                        child: RaisedButton(
                            color: const Color(0xff6990FF),
                            child: Text('Sign in', style: TextStyle(color: Colors.white)),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
                            onPressed: () {
                              // if(_formKey.currentState.validator()) {
                              //   print('Button Pressed!');
                              // }
                            }
                        ),
                      ),
                    )
                    // Container(width:50, height:50, color:Colors.black)
                  ],
                ),
                Container(height: size.height*0.02),
                // Container(height: size.height*0.05),
                Text('-OR-', style: TextStyle(
                  fontFamily: 'avenir',
                  color: const Color(0xff6990FF),
                ),
                ),
                Container(height: 20),
                Text('Guest Login  ',
                  style: TextStyle(
                  fontFamily: 'avenir',
                  fontWeight: FontWeight.bold,
                  color: const Color(0xff6990FF),
                ),
                ),
                TextButton.icon(
                    onPressed: () {},
                    icon: Image.asset('assets/guest.png', scale: 4),
                    label: Text(''),
                )
              ],
            ),
            Column(
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
                  Container(height: 50)
                ]
            )
          ],
        )
    );
  }
}