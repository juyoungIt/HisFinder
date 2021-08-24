import 'package:flutter/material.dart';
import 'package:untitled/home/transparentRoute.dart';
import 'package:untitled/notification/notificationList.dart';

import 'categoryPage.dart';

class MainAppBar extends StatelessWidget implements PreferredSizeWidget {
  late final int selectedIndex;

  MainAppBar(this.selectedIndex);

  @override
  Size get preferredSize => const Size.fromHeight(65);
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
                String type = (selectedIndex == 0) ? "습득물" : "분실물";
                Navigator.of(context).push(
                    TransparentRoute(builder: (BuildContext context) => CategoryPage(type))
                );
              }),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.fromLTRB(0, 0, 10, 0),
            child: IconButton(
                icon: Image.asset("assets/notice.png", width: 73, height: 76, scale: 3),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => NotificationListPage()),
                  );
                }),
          ),
        ],
        backgroundColor: Color(0xff6990FF)
    );
  }
}