import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:untitled/start/signIn.dart';

class UserInfoAppBar extends StatelessWidget implements PreferredSizeWidget {
  @override
  Size get preferredSize => const Size.fromHeight(50);
  @override
  Widget build(BuildContext context) {
    return AppBar(
        elevation: 0.0,
        title: Text(
          'MyPage',
          style: TextStyle(
            fontFamily: 'avenir',
            fontStyle: FontStyle.italic,
            fontWeight: FontWeight.w400,
          ),
          textScaleFactor: 1.4,
        ),
        centerTitle: true,
        backgroundColor: Color(0xff6990FF),
      actions: [
        Padding(
          padding: const EdgeInsets.fromLTRB(0, 0, 10, 0),
          child: IconButton(
              icon: Icon(Icons.logout),
              onPressed: () {
                FirebaseAuth.instance.signOut();
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(
                    builder: (BuildContext context) => SignInPage(),
                  ),
                      (route) => false,
                );
                ScaffoldMessenger.of(context)
                    .showSnackBar(SnackBar(content: Text('로그아웃 되었습니다')));
              }),
        ),
      ],
    );
  }
}