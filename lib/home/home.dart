import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
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
  int _selectedIndex = 0;
  bool isMoreRequesting = false;
  int nextPage = 0;
  double searchHeight = 0; // the height of the search bar

  List<Data> serverItems = []; // 더미 데이터
  List<Data> items = []; // 출력용 리스트
  double _dragDistance = 0; // 드레그 거리를 체크하기 위함 (기준: 50%)

  // appBar List
  List<PreferredSizeWidget> _appBarList = <PreferredSizeWidget>[
    MainAppBar(),
    MainAppBar(),
    MainAppBar(),
    ChatListAppBar(),
    UserInfoAppBar()
  ];

  // contentList
  List<Widget> _widgetOptions = <Widget>[
    LostListPage(),
    FoundListPage(),
    Container(), // 글쓰기
    Container(), // 채팅
    UserInfoPage()
  ];

  // 선택되는 index에 따라서 현재 인덱스 값을 업데이트
  void onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
      // navigation 을 적용해야하는 경우 해당 로직을 사용할 것
      switch (_selectedIndex) {
        case 0: //  찾았어요
          break;
        case 1: // 찾아요
          break;
        case 2: // 글쓰기
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
  initState() {
    //서버의 가상데이터(더미 데이터) 추가 => backend system 에서는 지워도 됨.
    // for (var i = 0; i < mydata.length; i++)
    //   serverItems.add(mydata[i]);
    super.initState();
    requestNew(); // 데이터 베이스 서버로부터 추가된 데이터를 요청하는 부분
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _appBarList.elementAt(_selectedIndex),
      body: _widgetOptions.elementAt(_selectedIndex),
      // for navigation bar
      bottomNavigationBar: BottomNavigationBar(
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Image.asset("assets/found.png", width: 30, height: 30, scale: 2.5),
            label: '주웠어요',
          ),
          BottomNavigationBarItem(
            icon: Image.asset("assets/lost.png", width: 30, height: 30, scale: 2.5),
            label: '찾아요',
          ),
          BottomNavigationBarItem(
            icon: Image.asset("assets/write.png", width: 30, height: 30, scale: 2.5),
            label: '글쓰기',
          ),
          BottomNavigationBarItem(
            icon: Image.asset("assets/chat.png", width: 30, height: 30, scale: 2.5),
            label: '채팅방',
          ),
          BottomNavigationBarItem(
            icon: Image.asset("assets/user.png", width: 30, height: 30, scale: 2.5),
            label: '내계정',
          ),
        ],
        currentIndex: _selectedIndex,
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

  // load the new data
  Future<void> requestNew() async {
    // 초기 데이터 세팅 - 초기 데이터를 여기에 세팅하는 과정이 필요함
    nextPage = 0; // 현재 페이지
    items.clear(); // 리스트 초기화
    setState(() {
      items += serverItems.sublist(nextPage * 10, (nextPage * 10) + 10); // 10개의 record item을 로딩함
      nextPage += 1; // 다음을 위해 페이지 증가
    });

    // 데이터 가져오는 동안 효과를 보여주기 위해 약 1초간 대기하는 것
    // 실제 서버에서 가져올땐 필요없음
    return await Future.delayed(Duration(milliseconds: 1000));
  }

  //스크롤 이벤트 처리 - 내가 따로 수정할 필요 없는 부분
  scrollNotification(notification) {
    // 스크롤 최대 범위
    var containerExtent = notification.metrics.viewportDimension;

    if (notification is ScrollStartNotification) {
      // 스크롤을 시작하면 발생(손가락으로 리스트를 누르고 움직이려고 할때)
      // 스크롤 거리값을 0으로 초기화함
      _dragDistance = 0;
    } else if (notification is OverscrollNotification) {
      //Android
      // 안드로이드에서 동작
      // 스크롤을 시작후 움직일때 발생(손가락으로 리스트를 누르고 움직이고 있을때 계속 발생)
      // 스크롤 움직인 만큼 빼준다.(notification.overscroll)
      _dragDistance -= notification.overscroll; //스크롤 하여 이동한 거리 계산
    } else if (notification is ScrollUpdateNotification) {
      // Ios
      // ios에서 동작
      // 스크롤을 시작후 움직일때 발생(손가락으로 리스트를 누르고 움직이고 있을때 계속 발생)
      // 스크롤 움직인 만큼 빼준다.(notification.scrollDelta)
      _dragDistance -= notification.scrollDelta!; //스크롤 하여 이동한 거리 계산
      setState(() {
        searchHeight = _scrollController.offset;
      });
    } else if (notification is ScrollEndNotification) {
      // 스크롤이 끝났을때 발생(손가락을 리스트에서 움직이다가 뗐을때 발생)

      // 지금까지 움직인 거리를 최대 거리로 나눈다.
      var percent = _dragDistance / (containerExtent);

      // 해당 값이 -0.4(40프로 이상) 아래서 위로 움직였다면
      if (percent <= -0.0) {
        //Ios -> 0 android -> percent
        // maxScrollExtent는 리스트 가장 아래 위치 값
        // pixels는 현재 위치 값
        // 두 같이 같다면(스크롤이 가장 아래에 있다)
        if (notification.metrics.maxScrollExtent <=
            notification.metrics.pixels) {
          setState(() {
            isMoreRequesting = true; // 프로그래스 서클 활성화
          });

          requestMore().then((value) {
            // 서버에서 데이터 가져온다.
            setState(() {
              isMoreRequesting = false; //서클 비활성화
            });
          });
        }
      }
    }
  }

  // 서버로부터 추가 데이터를 요구하는 로직 - 내가 수정해야하는 부분
  Future<void> requestMore() async {
    //추가 데이터 셋팅
    // 해당부분  // 서버에서 추가 데이터 가져올 때은 서버에서 가져오는 내용을 가상으로 만든 것이기 때문에 큰 의미는 없다.
    // 읽을 데이터 위치 얻기
    int nextDataPosition = (nextPage * 10);
    // 읽을 데이터 크기
    int dataLength = 10; //가져올 데이터 크기

    if (nextDataPosition > serverItems.length) {
      // 더 이상 데이터가 없음.
      return;
    }
    if ((nextDataPosition + 10) > serverItems.length) {
      // 가져올 수 있는 데이터가 10개 미만
      dataLength = serverItems.length - nextDataPosition; // 가능한 최대 개수 얻기
    }
    await Future.delayed(Duration(milliseconds: 1000)); // 가상으로 잠시 지연 줌
    setState(() {
      items += serverItems.sublist(
          nextDataPosition, nextDataPosition + dataLength); // 데이터 읽기
      nextPage += 1; // 다음을 위해 페이지 증가
    });
    // return await Future.delayed(Duration(milliseconds: 1000)); // 가상으로 잠시 지연 줌
  }
}

// 하나의 글을 나타내는 class
class Data {
  late List<String> pictures; // 사용자가 추가한 사진의 링크
  late String title;         // 글 제목
  late String content;       // 글 내용
  late String item;          // 물품
  late String place;         // 장소
  late String date;          // 분실/습득 일
  late String createAt;      // 해당 데이터가 생성된 시각을 기록
  late bool status;          // 글의 상태를 나타내는 부분

  // constructor
  Data(List<String> pictures, String title, String content,
      String item, String place, String date, String createAt, bool status) {
    this.pictures = pictures;
    this.title = title;
    this.content = content;
    this.item = item;
    this.place = place;
    this.date = date;
    this.createAt = createAt;
    this.status = status;
  }
}

// 화면 상단 검색창을 포함하는 부분
class HeaderTile extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: SizedBox(
              height: 40,
              child: TextFormField(
                // controller: , - 여기에 controller 추가하는 작업 필요함
                decoration: InputDecoration(
                  prefixIcon: Icon(Icons.search, color: Color(0xff6990FF)),
                  fillColor: Colors.white,
                  filled: true,
                  focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.transparent)),
                  enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.transparent)),
                  errorBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.transparent)),
                  contentPadding: new EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
                  hintText: "잃어버린 물건을 검색해보세요!",
                ),
                style: TextStyle(
                    color: Colors.black,
                    decorationColor: Colors.black
                ),
                cursorColor: Colors.black,
              ),
            ),
          ),
        )
    );
  }
}

// the each record of list
class DataTile extends StatelessWidget {
  final Data data;     // 데이터에 대한 코드 부분
  DataTile(this.data); // 주어진 데이터를 바탕으로 하는 data tile 생성

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: ListTile(
          leading: Padding(
            padding: const EdgeInsets.fromLTRB(10, 0, 0, 0),
            child: Icon(
              Icons.image,
              size: 50,
            ),
          ),
          title: Text(data.title),
          // 향후 이 부분이 글의 종류에 따라서 습득, 분실로 내용이 달라질 수 있도록 구성 해야 함
          subtitle: Text("물품 : " +
              data.item +
              '\n\n장소 : ' +
              data.place +
              '\n습득일 : ' +
              data.date),
          trailing: Column(mainAxisAlignment: MainAxisAlignment.end, children: [
            Text(
              data.createAt,
              textScaleFactor: 0.7,
              style: TextStyle(color: Colors.black54),
            ),
          ]),
          onTap: () {
            // click action
          }),
    );
  }
}

class AlarmAppBar extends StatelessWidget implements PreferredSizeWidget {
  @override
  Size get preferredSize => const Size.fromHeight(50);
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return AppBar(
      title: Text(
        'Alarm',
        style: TextStyle(
          fontFamily: 'avenir',
          fontStyle: FontStyle.italic,
          fontWeight: FontWeight.w400,
        ),
      ),
      leading: Image.asset(
        'src/back.png',
        width: 37,
        height: 69,
        scale: 3,
      ),
    );
  }
}