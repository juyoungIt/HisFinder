import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:skeleton_text/skeleton_text.dart';

enum menu { update, del, complete }

class MyDetail extends StatefulWidget {
  final DocumentSnapshot data;
  MyDetail(this.data);

  @override
  _MyDetailState createState() => _MyDetailState(data);
}

class _MyDetailState extends State<MyDetail> {
  final DocumentSnapshot data;
  _MyDetailState(this.data);

  late String title = data.get('title').toString();
  late String item = data.get('item').toString();
  late String place = data.get('place').toString();
  late String detail = data.get('detail').toString();
  late String date = data.get('date').toString();
  late String content = data.get('content').toString();
  late String status = data.get('status').toString();
  late String writer = data.get('writer_email').toString();
  late String createAt = data.get('createAt').toDate().toString();
  late int imageCount = data.get('pictureCount');
  String resultPath = "";

  // 이미지의 링크를 얻어오는 method
  Future<String> getImagePath(String path) async {
    Reference reference = FirebaseStorage.instance.ref(path);
    resultPath = await reference.getDownloadURL();
    return resultPath;
  }

  // 모든 이미지의 path를 로딩함
  Future<List<String>> getAllImages() async {
    List<String> imageUrl = [];
    for(int i=0 ; i<imageCount ; i++) {
      String path = data.get('picture'+i.toString()).toString();
      resultPath = await getImagePath(path);
      imageUrl.add(resultPath);
    }
    return imageUrl;
  }

  @override
  void initState() {
    super.initState();
    getAllImages();
    WriteDataDetail data = WriteDataDetail(title, item, place, detail, date, content, status, writer, createAt);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
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
        actions: [
          PopupMenuButton<menu>(
            onSelected: (menu value) {
              setState(() {
                switch (value) {
                  case menu.update:
                  //update
                    break;
                  case menu.del:
                    break;
                  case menu.complete:
                  //complete
                    break;
                }
              });
            },
            itemBuilder: (context) => [
              PopupMenuItem(
                child: Text('수정'),
                value: menu.update,
              ),
              PopupMenuItem(
                child: Text('삭제'),
                value: menu.del,
              ),
              PopupMenuItem(
                child: Text('완료'),
                value: menu.complete,
              ),
            ],
          ),
        ],
      ),
      body: FutureBuilder(
        future: getAllImages(),
        builder: (BuildContext context, AsyncSnapshot<List<String>> snapshot) {
          if(snapshot.connectionState == ConnectionState.done) {
            if(snapshot.hasData) {
              return ListView(
                children: [
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
                          child: Image.network(item)
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
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 15.0),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            CircleAvatar(
                              backgroundImage: AssetImage('assets/Crang.png'),
                              radius: 15.0,
                            ),
                            SizedBox(width: 10),
                            Text(writer,
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
                        SizedBox(
                          height: 15.0,
                        ),
                      ],
                    ),
                  ),
                ],
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