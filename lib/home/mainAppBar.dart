import 'package:flutter/material.dart';
import 'package:untitled/home/transparentRoute.dart';

import 'categoryPage.dart';

class MainAppBar extends StatelessWidget implements PreferredSizeWidget {
  @override
  Size get preferredSize => const Size.fromHeight(50);
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
        leading: Padding(
          padding: const EdgeInsets.fromLTRB(10, 0, 0, 0),
          child: IconButton(
              icon: Image.asset("assets/category.png", width: 65, height: 65, scale: 2.5),
              onPressed: () {
                Navigator.of(context).push(
                    TransparentRoute(builder: (BuildContext context) => CategoryPage())
                );
                // Navigator.push(
                //   context,
                //   MaterialPageRoute(builder: (context) => CategoryPage()),
                // );
              }),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.fromLTRB(0, 0, 10, 0),
            child: IconButton(
                icon: Image.asset("assets/notice.png", width: 73, height: 76, scale: 3),
                onPressed: () {
                  // Bell Button Action
                }),
          ),
        ],
        backgroundColor: Color(0xff6990FF)
    );
  }
}