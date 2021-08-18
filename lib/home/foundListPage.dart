import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:untitled/detail/detailWriting.dart';
import 'package:skeleton_text/skeleton_text.dart';

// 습득물 관련 페이지를 완성하는 부분
class FoundListPage extends StatefulWidget {
  @override
  _FoundListPageState createState() => _FoundListPageState();
}

class _FoundListPageState extends State<FoundListPage> {
  final ScrollController _scrollController = ScrollController(); // 스크롤 관련 이벤트를 핸들링 하기 위한 컨트롤러
  bool isMoreRequesting = false; // 사용자로부터 추가적인 데이터 요청이 존재하는 지를 의미하는 변수
  int nextPage = 0; // 현재까지 로딩한 페이지의 인덱스
  double searchHeight = 0; // 검색창의 뒷배경이 가지는 높이값
  double _dragDistance = 0; // 화면이 스크롤된 거리값을 저장하기 위한 변수

  // 이미지 타일에 사용되는 이미지의 사이즈를 상수로 명시한 부분
  final double _defaultImageSize = 70.0; // 이미지가 없을 시 사용되는 기본 이미지
  final double _customImageSize = 100.0; // 사용자가 직접 촬영하여 넣은 이미지

  // 데이터베이스로부터 로딩한 정보를 담는 부분
  late QuerySnapshot postQuery;            // 데이터를 가져오기 위한 Query snapshot
  late QuerySnapshot userQuery;            // 데이터를 가져오기 위한 Query snapshot
  List<DocumentSnapshot> serverItems = []; // 서버로부터 가져오는 데이터를 담음
  List<DocumentSnapshot> items = [];       // 화면에 출력되는 record 를 저장하는 부분
  late DocumentSnapshot users;             // 로그인한 사용자의 정보를 담는 document snapshot

  List<WriteData> writeDatas = []; // 실질적으로 사용할 수 있는 data의 리스트

  @override
  initState() {
    super.initState();
    requestNew();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(color: Colors.white),
        Container(
          height: ((80 + searchHeight * (-1)) < 0) ? 0 : (80 + searchHeight * (-1)),
          decoration: BoxDecoration(
              color: Color(0xff6990FF),
              borderRadius: BorderRadius.only(
                bottomRight: Radius.circular(10.0),
                bottomLeft: Radius.circular(10.0),
              )
          ),
        ),
        Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Expanded(
                child: Container(
                  // height: 150.0,
                  child: NotificationListener<ScrollNotification> (
                    onNotification: (ScrollNotification notification) {
                      scrollNotification(notification);
                      return false;
                    },
                    child: RefreshIndicator(
                      color: Color(0xff6990FF),
                      onRefresh: requestNew,
                      child: ListView.separated(
                        controller: _scrollController,
                        separatorBuilder: (BuildContext context, int index) {
                          return Container(color: Colors.white, child: const Divider());
                        },
                        itemBuilder: (context, int index) {
                          if (index == 0)
                            return HeaderTile();
                          else {
                            double imageSize =
                              (items[index-1].get('pictureCount') == 0) ? _defaultImageSize : _customImageSize;
                            return writeRecordTile(context, items[index-1], index, imageSize);
                          }
                        },
                        physics: ClampingScrollPhysics(),
                        itemCount: writeDatas.length+1
                      ),
                    ),
                  ),
                ),
              ),
              Container(
                height: isMoreRequesting ? 50.0 : 0,
                color: Colors.white,
                child: Center(
                  child: CircularProgressIndicator(color: Color(0xff6990FF)),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  // load the new data
  Future<void> requestNew() async {
    nextPage = 0;        // 현재 페이지
    FirebaseFirestore firebase = FirebaseFirestore.instance;
    FirebaseAuth auth = FirebaseAuth.instance;
    var ref = firebase.collection('Founds').orderBy('createAt', descending: true);
    await ref.get().then((value) {
      postQuery = value;
    });

    serverItems.clear();
    items.clear();
    writeDatas.clear();
    serverItems.addAll(postQuery.docs);

    setState(() {
      int count;
      if(serverItems.length < 10)
        count = serverItems.length;
      else
        count = 10;
      items += serverItems.sublist(nextPage * 10, (nextPage * 10) + count);
      nextPage += 1; // 다음을 위해 페이지 증가
    });

    for(int i=0 ; i<items.length ; i++) {
      String title = items[i].get('title').toString();
      String item = items[i].get('item').toString();
      String place = items[i].get('place').toString();
      String date = items[i].get('date').toString();
      WriteData writeData = WriteData(title, item, place, date);
      writeDatas.add(writeData);
    }
  }

  Future<void> requestMore() async {
    int nextDataPosition = (nextPage * 10); // 10개 단위로 데이터를 읽어오기 때문
    int dataLength = 10; //가져올 데이터 크기

    if (nextDataPosition > serverItems.length)
      return;
    if ((nextDataPosition + 10) > serverItems.length)
      dataLength = serverItems.length - nextDataPosition;

    setState(() {
      items += serverItems.sublist(nextDataPosition, nextDataPosition + dataLength);
      nextPage += 1;
    });

    for(int i=0 ; i<dataLength ; i++) {
      String title = items[nextDataPosition + i].get('title').toString();
      String item = items[nextDataPosition + i].get('item').toString();
      String place = items[nextDataPosition + i].get('place').toString();
      String date = items[nextDataPosition + i].get('date').toString();
      WriteData writeData = WriteData(title, item, place, date);
      writeDatas.add(writeData);
    }
  }

  // 스크롤 이벤트
  scrollNotification(notification) {
    var containerExtent = notification.metrics.viewportDimension;

    if (notification is ScrollStartNotification) {
      _dragDistance = 0;
    }
    else if (notification is OverscrollNotification) {
      _dragDistance -= notification.overscroll; //스크롤 하여 이동한 거리 계산
    }
    else if (notification is ScrollUpdateNotification) {
      _dragDistance -= notification.scrollDelta!;
      // 검색바를 위한 부분
      // setState(() {
      //   searchHeight = _scrollController.offset;
      // });
    }
    else if (notification is ScrollEndNotification) {
      var percent = _dragDistance / (containerExtent);
      if(items.length < serverItems.length) {
        if (percent <= -0.0) {
          if (notification.metrics.maxScrollExtent <= notification.metrics.pixels) {
            setState(() {
              isMoreRequesting = true;
            });
            requestMore().then((value) {
              setState(() {
                isMoreRequesting = false; //서클 비활성화
              });
            });
          }
        }
      }
    }
  }

  // 이미지를 다운로드하는 링크를 얻음
  Future<String> getImagePath(DocumentSnapshot snapshot) async {
    // 정상적으로 이미지가 존재하는 경우
    if(snapshot.get('pictureCount') != 0) {
      Reference reference = FirebaseStorage.instance.ref(snapshot.get('picture0').toString());
      String resultPath = await reference.getDownloadURL();
      return resultPath;
    }
    // 이미지가 존재하지 않는 경우
    else {
      String item = snapshot.get('item').toString();
      String path;
      if(item == '학생증') path = 'default_images/default1.png';
      else if(item == '일반카드(개인/세탁카드)') path = 'default_images/default2.png';
      else if(item == '에어팟, 버즈') path = 'default_images/default3.png';
      else if(item == '전자기기') path = 'default_images/default4.png';
      else if(item == '돈, 지갑') path = 'default_images/default5.png';
      else if(item == '화장품') path = 'default_images/default6.png';
      else if(item == '악세서리') path = 'default_images/default7.png';
      else if(item == '필기구') path = 'default_images/default8.png';
      else path = 'default_images/default9.png';
      Reference reference = FirebaseStorage.instance.ref(path);
      String resultPath = await reference.getDownloadURL();
      return resultPath;
    }
  }

  Widget writeRecordTile(BuildContext context, DocumentSnapshot snapshot, int index, double imageSize) {
    return FutureBuilder(
      // future: getImagePath(snapshot.get('picture0').toString(), snapshot),
      future: getImagePath(snapshot),
      builder: (BuildContext context, AsyncSnapshot<String> snap) {
        if(snap.connectionState == ConnectionState.done) {
          if(snap.hasData) {
            // 해당 글이 종료된 경우
            if(snapshot.get('status')) {
              return GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => MyDetail(snapshot, "Founds")),
                  );
                },
                child: Stack(
                    children: <Widget>[
                      Container(
                          color: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.all(Radius.circular(5.0)),
                                child: SizedBox(
                                  width: 100,
                                  height: 100,
                                  child: Center(
                                    child: Image.network(
                                      snap.data.toString(),
                                      width: imageSize,
                                      height: imageSize,
                                    ),
                                  ),
                                ),
                              ),
                              Expanded(
                                child: Container(
                                  height: 100,
                                  padding: const EdgeInsets.only(left: 20, top: 2),
                                  alignment: Alignment.centerLeft,
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        writeDatas[index-1].title,
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyle(fontSize: 15),
                                      ),
                                      SizedBox(height: 5),
                                      Text(
                                        "물품 " + writeDatas[index-1].item,
                                        style: TextStyle(
                                            fontSize: 12, color: Color(0xff999999)),
                                      ),
                                      Text(
                                        "장소 " + writeDatas[index-1].place,
                                        style: TextStyle(
                                            fontSize: 12, color: Color(0xff999999)),
                                      ),
                                      Text(
                                        "습득일 " + writeDatas[index-1].date,
                                        style: TextStyle(
                                            fontSize: 12, color: Color(0xff999999)),
                                      ),
                                      SizedBox(
                                        width: 80,
                                        height: 20,
                                        child: Container(
                                          decoration: BoxDecoration(
                                            color: Colors.black,
                                            borderRadius: BorderRadius.all(Radius.circular(10))
                                          ),
                                          alignment: Alignment.center,
                                          child: Text("완료", style: TextStyle(color: Colors.white))
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              )
                            ],
                          )
                      ),
                      Container(height: 120, color: Colors.white54) // 완료 글 임을 보여주기 위한 효과
                    ]
                ),
              );
            }
            // 해당 글이 종료되지 않은 경우
            else {
              return GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => MyDetail(snapshot, "Founds")),
                  );
                },
                child: Stack(
                    children: <Widget>[
                      Container(
                          color: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.all(Radius.circular(5.0)),
                                child: SizedBox(
                                  width: 100,
                                  height: 100,
                                  child: Center(
                                    child: Image.network(
                                      snap.data.toString(),
                                      width: imageSize,
                                      height: imageSize,
                                    ),
                                  ),
                                ),
                              ),
                              Expanded(
                                child: Container(
                                  height: 100,
                                  padding: const EdgeInsets.only(left: 20, top: 2),
                                  alignment: Alignment.centerLeft,
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        writeDatas[index-1].title,
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyle(fontSize: 15),
                                      ),
                                      SizedBox(height: 5),
                                      Text(
                                        "물품 " + writeDatas[index-1].item,
                                        style: TextStyle(
                                            fontSize: 12, color: Color(0xff999999)),
                                      ),
                                      Text(
                                        "장소 " + writeDatas[index-1].place,
                                        style: TextStyle(
                                            fontSize: 12, color: Color(0xff999999)),
                                      ),
                                      Text(
                                        "습득일 " + writeDatas[index-1].date,
                                        style: TextStyle(
                                            fontSize: 12, color: Color(0xff999999)),
                                      ),
                                    ],
                                  ),
                                ),
                              )
                            ],
                          )
                      ),
                    ]
                ),
              );
            }
          }
          else if(snap.hasError) {
            print(snap.error.toString());
            return Text("Unexpected Error Occured...");
          }
          else {
            return CircularProgressIndicator();
          }
        }
        else if(snap.connectionState == ConnectionState.waiting) {
          return Container(
              color: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.all(Radius.circular(5.0)),
                    child: SkeletonAnimation(
                      child: Container(
                        width: 100,
                        height: 100,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10.0),
                            color: Colors.grey[300]),
                      ),
                    ),
                  ),
                  Expanded(
                    child: SkeletonAnimation(
                      child: Container(
                        height: 100,
                        padding: const EdgeInsets.only(left: 20, top: 2),
                        alignment: Alignment.centerLeft,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              width: 300,
                              height: 20,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10.0),
                                  color: Colors.grey[300]),
                            ),
                            Padding(
                              padding: EdgeInsets.only(top: 10, bottom: 10),
                              child: Container(
                                width: 70,
                                height: 15,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10.0),
                                    color: Colors.grey[300]),
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.only(bottom: 10),
                              child: Container(
                                width: 70,
                                height: 15,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10.0),
                                    color: Colors.grey[300]),
                              ),
                            )
                          ],
                        ),
                      ),
                    )
                  )
                ],
              )
          );
        }
        else if(snap.connectionState == ConnectionState.active) {
          return Text("ConnectionState = active");
        }
        else {
          return Text("Error! - Network Failure...");
        }
      }
    );
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

class WriteData {
  late String title;
  late String item;
  late String place;
  late String date;

  WriteData(this.title, this.item, this.place, this.date);
}