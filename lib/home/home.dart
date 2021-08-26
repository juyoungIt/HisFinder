import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:untitled/chatting/chatroomList.dart';
import 'package:untitled/home/chatListAppBar.dart';
import 'package:untitled/home/userInfo.dart';
import 'package:untitled/home/userInfoAppBar.dart';
import 'package:untitled/write/write.dart';

import 'foundListPage.dart';
import 'lostListPage.dart';
import 'mainAppBar.dart';

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final ScrollController _scrollController = ScrollController();
  int _prevSelectedIndex = 0; // 이전에 선택되었던 index
  int _curSelectedIndex = 0;  // 현재 선택되어 있는 index
  bool isMoreRequesting = false;
  int nextPage = 0;
  double searchHeight = 0; // the height of the search bar

  @override
  void initState() {
    super.initState();
  }

  // appBar List
  List<PreferredSizeWidget> _appBarList = <PreferredSizeWidget>[
    MainAppBar(0),
    MainAppBar(1),
    MainAppBar(1), // 이 녀석이 사용될 일은 없음 - 최적화를 통해 제거되어야 하는 부분
    ChatListAppBar(),
    UserInfoAppBar()
  ];

  // contentList
  List<Widget> _widgetOptions = <Widget>[
    FoundListPage(),
    LostListPage(),
    Container(), // 글쓰기
    ChatRoomList(), // 채팅
    UserInfoPage()
  ];

  // 선택되는 index 에 따라서 현재 인덱스 값을 업데이트
  void onItemTapped(int index) {
    setState(() {
      _prevSelectedIndex = _curSelectedIndex; // backup the index
      _curSelectedIndex = index;
      // navigation 을 적용해야하는 경우 해당 로직을 사용할 것
      switch (_curSelectedIndex) {
        case 0: //  찾았어요
          break;
        case 1: // 찾아요
          break;
        case 2: // 글쓰기
          _curSelectedIndex = _prevSelectedIndex; // restore the index
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => WritePage()),
          );
          break;
        case 3:
          break;
        case 4:
          break;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _appBarList.elementAt(_curSelectedIndex),
      body: _widgetOptions.elementAt(_curSelectedIndex),
      bottomNavigationBar: BottomNavigationBar(
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Image.asset("assets/found.png", scale: 3.0),
            label: '습득물',
          ),
          BottomNavigationBarItem(
            icon: Image.asset("assets/lost.png", scale: 3.0),
            label: '분실물',
          ),
          BottomNavigationBarItem(
            icon: Image.asset("assets/write.png", scale: 3.0),
            label: '글쓰기',
          ),
          BottomNavigationBarItem(
            icon: Image.asset("assets/chat.png", scale: 3.0),
            label: '채팅방',
          ),
          BottomNavigationBarItem(
            icon: Image.asset("assets/user.png", scale: 3.0),
            label: '내계정',
          ),
        ],
        currentIndex: _curSelectedIndex,
        selectedItemColor: Color(0xff6990FF),
        unselectedItemColor: Colors.black,
        selectedIconTheme: IconThemeData(color: Color(0xff6990FF)),
        onTap: onItemTapped,
        showUnselectedLabels: true,
        elevation: 10,
        backgroundColor: Colors.white,
        type: BottomNavigationBarType.fixed, // for selected animation
      ),
    );
  }
}