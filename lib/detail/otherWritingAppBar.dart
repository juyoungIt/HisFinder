import 'package:flutter/material.dart';

class OtherWritingAppBar extends StatefulWidget implements PreferredSizeWidget {
  @override
  Size get preferredSize => const Size.fromHeight(65);
  @override
  _OtherWritingAppBarState createState() => _OtherWritingAppBarState();
}

class _OtherWritingAppBarState extends State<OtherWritingAppBar> {
  @override
  Widget build(BuildContext context) {
    return AppBar(
      elevation: 0.0,
      title: Text(
        'HisFinder',
        style: TextStyle(
          fontFamily: 'avenir',
          fontStyle: FontStyle.italic,
          fontWeight: FontWeight.w400,
        ),
        textScaleFactor: 1.4,
      ),
      centerTitle: true,
      backgroundColor: Color(0xff6990FF),
    );
  }
}