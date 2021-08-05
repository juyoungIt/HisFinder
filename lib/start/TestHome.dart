import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import 'Signin.dart';

class TestHomePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return TestHomePageTemplate();
  }
}

class TestHomePageTemplate extends State<TestHomePage> {

  User? user = FirebaseAuth.instance.currentUser;

  void loadUserInfo() {
    if (user != null) {
      // The user object has basic properties such as display name, email, etc.
      var displayName = user!.displayName;
      var email = user!.email;
      var photoURL = user!.photoURL;
      var emailVerified = user!.emailVerified;
      var uid = user!.uid;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Text("uid = " + user!.uid.toString()),
          Text("emailVerified = " + user!.emailVerified.toString()),
          Text("displayName = " + user!.displayName.toString()),
          Text("email = " + user!.email.toString()),
          Text("phoneNumber = " + user!.phoneNumber.toString()),
          Text("photoURL = " + user!.photoURL.toString()),
          SizedBox(
              width: 500,
              height: 50,
              child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    primary: const Color(0xff6990FF), // background
                    onPrimary: Colors.white, // foreground
                  ),
                  child: Text('Logout', style: TextStyle(color: Colors.white)),
                  onPressed: () async {
                    await FirebaseAuth.instance.signOut();
                    ScaffoldMessenger.of(context)
                        .showSnackBar(SnackBar(content: Text('로그아웃 되었습니다.')));
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => SigninPage()),
                    );
                  }
              )
          ),
        ],
      ),
    );
  }
}