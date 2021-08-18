import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:skeleton_text/skeleton_text.dart';
import 'package:untitled/detail/myWritingAppBar.dart';
import 'package:untitled/detail/otherWritingAppBar.dart';

enum menu { update, del, complete }

class MyDetail extends StatefulWidget {
  final DocumentSnapshot data;
  final String _type;

  MyDetail(this.data, this._type);

  @override
  _MyDetailState createState() => _MyDetailState(data, _type);
}

class _MyDetailState extends State<MyDetail> {
  final DocumentSnapshot data;
  late DocumentSnapshot user;
  final String _type;
  _MyDetailState(this.data, this._type);

  late String title = data.get('title').toString();
  late String item = data.get('item').toString();
  late String place = data.get('place').toString();
  late String detail = data.get('detail').toString();
  late String date = data.get('date').toString();
  late String content = data.get('content').toString();
  late String status = data.get('status').toString();
  late String writer = data.get('writer_email').toString();
  late String writerID = data.get('writer_uid').toString();
  late String createAt = data.get('createAt').toDate().toString();
  late int imageCount = data.get('pictureCount');

  String resultPath = "";
  List<String> originalPath = []; // 이미지에 대한 original path를 저장
  List<PreferredSizeWidget> _appBarList = <PreferredSizeWidget>[];

  // 이미지의 링크를 얻어오는 method
  Future<String> getImagePath(String path) async {
    Reference reference = FirebaseStorage.instance.ref(path);
    resultPath = await reference.getDownloadURL();
    return resultPath;
  }

  // 모든 이미지의 path를 로딩함
  Future<List<String>> getAllImages() async {
    // 이미지가 존재하는 경우
    if (imageCount != 0) {
      List<String> imageUrl = [];
      for (int i = 0; i < imageCount; i++) {
        String path = data.get('picture' + i.toString()).toString();
        originalPath.add(path);
        resultPath = await getImagePath(path);
        imageUrl.add(resultPath);
      }
      return imageUrl;
    }
    // 이미지가 존재하지 않는 경우
    else {
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

      List<String> imageUrl = [];
      originalPath.add(path);
      resultPath = await getImagePath(originalPath[0].toString());
      imageUrl.add(resultPath);
      return imageUrl;
    }
  }

  @override
  void initState() {
    super.initState();
    getAllImages();
    WriteDataDetail writingData = WriteDataDetail(title, item, place, detail, date, content, status, writer, createAt);
    _appBarList.add(MyWritingAppBar(data, _type, imageCount, originalPath));
    _appBarList.add(OtherWritingAppBar());
    FirebaseFirestore.instance.collection('Users').doc(writerID).get().then((value) {
      user = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    String userID = FirebaseAuth.instance.currentUser!.uid.toString();
    int appBarContext = (userID == writerID) ? 0 : 1;
    double imageSize = (imageCount == 0) ? 100 : MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: _appBarList.elementAt(appBarContext),
      body: FutureBuilder(
        future: getAllImages(),
        builder: (BuildContext context, AsyncSnapshot<List<String>> snapshot) {
          if(snapshot.connectionState == ConnectionState.done) {
            if(snapshot.hasData) {
              return Stack(
                children: <Widget>[
                  ListView(
                    children: <Widget>[
                      CarouselSlider(
                        options: CarouselOptions(
                          height: MediaQuery.of(context).size.width,
                          initialPage: 0,
                          viewportFraction: 1.0,
                          aspectRatio: 1/1,
                          enlargeCenterPage: false,
                          enableInfiniteScroll: false,
                        ),
                        items: snapshot.data!.map((item) => Container(
                          child: Center(
                              child: Image.network(item, width: imageSize)
                          ),
                        )).toList(),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 15.0, right: 15.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            //--------------------------------
                            Text(
                              title,
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 20.0,
                              ),
                            ),
                            SizedBox(
                              height: 2.0,
                            ),
                            //--------------------------------
                            Text(
                              createAt,
                              style: TextStyle(
                                fontWeight: FontWeight.w500,
                                fontSize: 15.0,
                                color: Colors.grey,
                              ),
                            ),
                            //--------------------------------
                            Divider(
                              height: 20.0,
                              thickness: 1.0,
                            ),
                            Row(
                              children: [
                                //--------------------------------
                                Text(
                                  '물품 : ',
                                  style: TextStyle(
                                    fontWeight: FontWeight.w500,
                                    fontSize: 18.0,
                                  ),
                                ),
                                //--------------------------------
                                Text(
                                  item,
                                  style: TextStyle(
                                    fontWeight: FontWeight.w500,
                                    fontSize: 18.0,
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 3.5,
                            ),
                            Row(
                              children: [
                                //--------------------------------
                                Text(
                                  '장소 : ',
                                  style: TextStyle(
                                    fontWeight: FontWeight.w500,
                                    fontSize: 18.0,
                                  ),
                                ),
                                //--------------------------------
                                Text(
                                  place,
                                  style: TextStyle(
                                    fontWeight: FontWeight.w500,
                                    fontSize: 18.0,
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 3.5,
                            ),
                            Row(
                              children: [
                                //--------------------------------
                                Text(
                                  '장소상세 : ',
                                  style: TextStyle(
                                    fontWeight: FontWeight.w500,
                                    fontSize: 18.0,
                                  ),
                                ),
                                //--------------------------------
                                Text(
                                  detail,
                                  style: TextStyle(
                                    fontWeight: FontWeight.w500,
                                    fontSize: 18.0,
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 3.5,
                            ),
                            Row(
                              children: [
                                //--------------------------------
                                Text(
                                  '날짜 : ',
                                  style: TextStyle(
                                    fontWeight: FontWeight.w500,
                                    fontSize: 18.0,
                                  ),
                                ),
                                //--------------------------------
                                Text(
                                  date,
                                  style: TextStyle(
                                    fontWeight: FontWeight.w500,
                                    fontSize: 18.0,
                                  ),
                                ),
                              ],
                            ),
                            Divider(
                              height: 20.0,
                              thickness: 1.0,
                            ),
                            //----------------------------------------------------
                            Text(
                              content,
                              style: TextStyle(
                                fontWeight: FontWeight.w500,
                                fontSize: 18.0,
                              ),
                            ),
                          ],
                        ),
                      ),
                      //----------------------------------------------------
                      Container(height: 200),
                    ],
                  ),
                  Positioned(
                    left: 0,
                    right: 0,
                    bottom: 0,
                    child: Container(
                      color: Colors.white,
                      padding: EdgeInsets.symmetric(horizontal: 15.0, vertical: 15.0),
                      child: Column(
                        children: [
                          Row(
                            children: [
                              CircleAvatar(
                                backgroundImage: AssetImage('assets/Crang.png'),
                                radius: 15.0,
                              ),
                              SizedBox(width: 10),
                              Text(user.get('nickname').toString(),
                                  style: TextStyle(fontWeight: FontWeight.bold)),
                            ],
                          ),
                          //------------------------------------------------------------
                          SizedBox(height: 5.0),
                          MaterialButton(
                            onPressed: () {},
                            child: Text('메시지 보내기',
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white)),
                            color: const Color(0xff6990FF),
                            minWidth: 400.0,
                          ),
                        ],
                      ),
                    ),
                  )
                ]
              );
            }
            else if(snapshot.hasError) {
              return Text("Unexpected Error Occured...");
            }
            else {
              return CircularProgressIndicator();
            }
          }
          else if(snapshot.connectionState == ConnectionState.waiting) {
            return SkeletonAnimation(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.height * 0.55,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10.0),
                        color: Colors.grey[300]),
                  ),
                ],
              ),
            );
          }
          else if(snapshot.connectionState == ConnectionState.active) {
            return Text("ConnectionState = active");
          }
          else {
            return Text("Error! - Network Failure...");
          }
        }
      ),
    );
  }
}

class WriteDataDetail {
  String title;
  String item;
  String place;
  String detail;
  String date;
  String content;
  String status;
  String writter_email;
  String createAt;

  WriteDataDetail(this.title, this.item, this.place,
      this.detail, this.date, this.content,
      this.status, this.writter_email, this.createAt);
}