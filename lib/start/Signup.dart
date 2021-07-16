import 'package:flutter/material.dart';
import 'package:untitled/start/Signin.dart';

class SignupPage extends StatelessWidget {
  // this is key
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _sidController = TextEditingController();
  final TextEditingController _pwController = TextEditingController();
  final TextEditingController _pwConfController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;


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
                                    contentPadding: new EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
                                    // icon: Icon(Icons.lock),
                                    prefixIcon: Image.asset("assets/password.png", scale: 3),
                                    focusedBorder: OutlineInputBorder(
                                        borderSide: BorderSide(width: 2, color: const Color(0xff6990FF),)
                                    ),
                                    enabledBorder: OutlineInputBorder(
                                        borderSide: BorderSide(width: 2, color: const Color(0xff6990FF),)
                                    ),
                                    hintText: "Password"
                                ),
                                validator: (String? value){
                                  if(value == null || value.isEmpty) {
                                    return "Please input correct student id";
                                  }
                                  return null;
                                },
                              ),
                              Container(height: 10),
                              TextFormField(
                                obscureText: true,
                                controller: _pwConfController,
                                decoration: InputDecoration(
                                    contentPadding: new EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
                                    // icon: Icon(Icons.lock),
                                    prefixIcon: Image.asset("assets/password.png", scale: 3),
                                    focusedBorder: OutlineInputBorder(
                                        borderSide: BorderSide(width: 2, color: const Color(0xff6990FF),)
                                    ),
                                    enabledBorder: OutlineInputBorder(
                                        borderSide: BorderSide(width: 2, color: const Color(0xff6990FF),)
                                    ),
                                    hintText: "Password Confirm"
                                ),
                                validator: (String? value){
                                  if(value == null || value.isEmpty) {
                                    return "Please input correct student id";
                                  }
                                  return null;
                                },
                              ),
                              Container(height:size.height*0.01),
                              // Text('Forgot your password?')
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
                            child: Text('Signup', style: TextStyle(color: Colors.white)),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
                            onPressed: () {
                              print("student = " + _sidController.text.toString());
                              print("student = " + _pwController.text.toString());
                              print("student = " + _pwConfController.text.toString());
                            }
                        ),
                      ),
                    )
                    // Container(width:50, height:50, color:Colors.black)
                  ],
                ),
                Container(height: size.height*0.1),
                // Text("Have an Account? Signin"),
                Container(height: size.height*0.05)
              ],
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Text('Have an Account?',
                      style: TextStyle(
                      fontFamily: 'avenir',
                      color: const Color(0xff6990FF),
                      ),
                    ),
                    TextButton(onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => SigninPage()),
                      );
                    }, child: Text("Signin",
                      style: TextStyle(
                        fontFamily: 'avenir',
                        color: const Color(0xff6990FF),
                        fontWeight: FontWeight.bold
                      ),
                    )
                    )
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
