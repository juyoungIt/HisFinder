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
        body: Center(
          child: _noKeywords(),

          //   Column(
          //     mainAxisAlignment: MainAxisAlignment.center,
          //     children: [
          //       Image.asset("assets/CrangBig.png",
          //           /*width: 650, height: 626,*/ scale: 3),
          //       Padding(padding: EdgeInsets.only(top: 100)),
          //       Text(
          //         "기능을 준비중입니다.",
          //         style: TextStyle(fontSize: 20),
          //       ),
          //     ],
          //   ),
          // )

          // Container(
          //   child: Text("알림들의 리스트가 여기 위치하게 됩니다.")
          // )
        ));
  }

  Widget _noKeywords() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(
            'assets/CrangBig.png',
            scale: 3.5,
          ),
          Container(
            margin: EdgeInsets.only(top: 40),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.all(
                Radius.circular(10),
              ),
              border: Border.all(
                color: Colors.black,
                width: 1,
              ),
            ),
            child: Container(
                margin: EdgeInsets.all(5),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.all(
                    Radius.circular(10),
                  ),
                  // border 꾸미기
                  border: Border.all(
                    color: Colors.black,
                    width: 1,
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(30.0, 8.0, 30.0, 8.0),
                  child: Text(
                    // '새로운 알림이 없어요\n 알람을 받고 싶은 키워드를 설정해보세요',
                    "기능을 제작하고 있어요\n조금만 기다려주세요",
                    textAlign: TextAlign.center,
                  ),
                )),
          )
        ],
      ),
    );
  }
}

class NotificationListAppBar extends StatelessWidget
    implements PreferredSizeWidget {
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
        backgroundColor: Color(0xff6990FF));
  }
}
