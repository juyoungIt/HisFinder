import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:untitled/write/write.dart';

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _selectedIndex = 0; // 현재 선택된 창 (bottom Bar)
  bool isMoreRequesting = false; //하단 인디케이터
  int nextPage = 0; //데이터 가져올 때 페이지 구분

  List<Data> serverItems = []; // 더미 데이터
  List<Data> items = []; // 출력용 리스트
  double _dragDistance = 0; // 드레그 거리를 체크하기 위함 (기준: 50%)

  // 선택되는 index에 따라서 현재 인덱스 값을 업데이트
  void onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
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
      appBar: MainAppBar(),
      body: Stack(
        children: [
          Column(
            children: <Widget>[
              Container(
                color: Color(0xff6990FF),
                height: MediaQuery.of(context).size.height / 2.7,
              ),
              Container(
                color: Colors.white,
                height: MediaQuery.of(context).size.height / 2.7,
              )
            ],
          ),
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Expanded(
                  child: Container(
                    height: 150.0,
                    child: NotificationListener<ScrollNotification>(onNotification: (ScrollNotification notification) {
                        /*
                         스크롤 할때 발생되는 이벤트
                         해당 함수에서 어느 방향으로 스크롤을 했는지를 판단해
                         리스트 가장 밑에서 아래서 위로 40프로 이상 스크롤 했을때
                         서버에서 데이터를 추가로 가져오는 루틴이 포함됨.
                        */
                        scrollNotification(notification);
                        return false;
                      },
                      child: RefreshIndicator(
                        /*
                         리스트에 위에서 아래로 스크롤 하게되면 onRefresh 이벤트 발생
                         서버에서 새로운(최신) 데이터를 가져오는 함수 구현
                        */
                        onRefresh: requestNew,
                        child: ListView.separated(
                          separatorBuilder: (BuildContext context, int index) {
                            return Container(
                                color: Colors.white, child: const Divider());
                          },
                          padding: const EdgeInsets.all(0),
                          itemBuilder: (context, int i) {
                            if (i == 0) // 0 번쨰 리스트
                              return HeaderTile(); // 검색창
                            else {
                              // 아니라면
                              switch (_selectedIndex) {
                                case 0: //  찾았어요
                                  return DataTile(items[i - 1]);
                                case 1: // 찾아요
                                  return DataTile(items[i - 1]);
                                case 2: // 글쓰기
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(builder: (context) => WritePage()),
                                  );
                                  break;
                                case 3: // 채팅
                                case 4: // user info
                              }
                            }
                            return Container(height: 0);
                          },
                          /*
                           리스트의 데이터가 적어 스크롤이 생성되지 않아 스크롤 이벤트를 받을 수 없을수 있기 때문에 아래의 옵션을 추가함.
                           physics: AlwaysScrollableScrollPhysics()
                          */
                          physics: AlwaysScrollableScrollPhysics(),
                          itemCount: items.length,
                        ),
                      ),
                    ),
                  ),
                ),
                /*
                 추가 데이터 가져올때 하단 효과 표시 용
                */
                Container(
                  height: isMoreRequesting ? 50.0 : 0,
                  color: Colors.white,
                  child: Center(
                    child: CircularProgressIndicator(),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),

      // 화면 하단에 위치하는 navigation var에 대한 부분
      bottomNavigationBar: BottomNavigationBar(
        //selectedIconTheme: I,
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
        type: BottomNavigationBarType.fixed, // 선택 시 아이콘이 확대되는 효과를 제거함. (아이콘은 고정된 형태로 유지)
      ),
    );
  }

  // 새로운 데이터를 로딩하는 부분
  Future<void> requestNew() async {
    // 초기 데이터 세팅.
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

// 화면 상단 검색창
class HeaderTile extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
        width: 450,
        height: 50,
        color: Color(0xff6990FF),
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              width: 450,
              height: 30,
              color: Colors.white,
              child: TextFormField(
                style: TextStyle(
                    color: Colors.black, decorationColor: Colors.black),
                cursorColor: Colors.black,
              ),
            ),
          ),
        ));
  }
}

// 리스트에서 각각의 record를 나타내는 부분
class DataTile extends StatelessWidget {
  final Data data; // 데이터에 대한 코드 부분
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
              icon: Image.asset("assets/category.png",
                  width: 65, height: 65, scale: 2.5),
              onPressed: () {
                // Category button Action
              }),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.fromLTRB(0, 0, 10, 0),
            child: IconButton(
                icon: Image.asset("assets/notice.png",
                    width: 73, height: 76, scale: 3),
                onPressed: () {
                  // Bell Button Actoun
                }),
          ),
        ],
        backgroundColor: Color(0xff6990FF));
  }
}

// 별도로 분리한 Appbar에 대한 코드 부분
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
