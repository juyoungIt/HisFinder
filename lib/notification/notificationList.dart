import 'package:flutter/material.dart';

class NotificationListPage extends StatefulWidget {
  @override
  _NotificationListPageState createState() => _NotificationListPageState();
}

class _NotificationListPageState extends State<NotificationListPage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: NotificationListAppBar(),
      body: Container(
        child: Text("알림들의 리스트가 여기 위치하게 됩니다.")
      )
    );
  }
}


class NotificationListAppBar extends StatelessWidget implements PreferredSizeWidget {
  @override
  Size get preferredSize => const Size.fromHeight(65);
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return AppBar(
        elevation: 0.0,
        title: Text(
          'Notification',
          style: TextStyle(
            fontFamily: 'avenir',
            fontStyle: FontStyle.italic,
            fontWeight: FontWeight.w400,
          ),
          textScaleFactor: 1.4,
        ),
        centerTitle: true,
        backgroundColor: Color(0xff6990FF)
    );
  }
}