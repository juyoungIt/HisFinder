import 'package:flutter/material.dart';

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
        backgroundColor: Color(0xff6990FF));
  }
}