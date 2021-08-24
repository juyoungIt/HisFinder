import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:untitled/detail/keywordSetPage.dart';

import 'editUserInfo.dart';

class UserInfoPage extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: BodyWidget()
    );
  }
}

class BodyWidget extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _BodyWidget();
}

class _BodyWidget extends State<BodyWidget> {
  final User? user = FirebaseAuth.instance.currentUser; // load the current user information

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return Container(
        padding: EdgeInsets.only(top:7),
        color: Colors.white,
        child: Column(
          children: [
            Row(
              children: [
                Padding(padding: EdgeInsets.fromLTRB(30,40,0,40)),
                Image.asset("assets/Crang.png", scale: 2),
                Padding(padding: EdgeInsets.only(right:20)),
                Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("juyoungryan", style:TextStyle(fontSize: 20, fontWeight: FontWeight.w500)),
                      Padding(padding: EdgeInsets.only(bottom:5)),
                      Text(user!.email.toString(), style:TextStyle(fontSize: 20, color: Colors.grey, fontWeight: FontWeight.w300))
                    ]
                )
              ],
            ),
            SizedBox(
              width:size.width * 0.95,
              height:40,
              child: RaisedButton(
                  elevation: 0,
                  padding: EdgeInsets.fromLTRB(150, 0, 150, 0),
                  color: Colors.white,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(3)),
                      side: BorderSide(color: const Color(0xff6990FF))
                  ),
                  child: Text('프로필 수정', textScaleFactor:1.17),
                  onPressed: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => EditUserInfoPage()),
                    );
                  }
              ),
            ),
            Divider(
              color: Colors.transparent,
            ),
            Stack(
              alignment: Alignment.center,
              children: [
                SizedBox(
                  width:size.width * 0.93,
                  height:40,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('내 글 보기',textScaleFactor: 1.5),
                      Image.asset("assets/next.png", scale: 3)
                    ],
                  ),
                ),
                SizedBox(
                  width:size.width * 0.95,
                  height:40,
                  child: RaisedButton(
                      elevation: 0,
                      color: Colors.transparent,
                      onPressed: () {
                        // Navigator.push(
                        //   context,
                        //   PageRouteBuilder(
                        //     pageBuilder: (context, animation1, animation2) => MyPage(),
                        //     transitionDuration: Duration(seconds: 0),
                        //   )
                        // );
                      }
                  ),
                ),
              ],
            ),
            Divider(
              indent:MediaQuery.of(context).size.width * 0.025,
              endIndent: MediaQuery.of(context).size.width * 0.025,
            ),
            Container(
              child: SizedBox(
                width:size.width * 0.93,
                height:40,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('키워드 알림',textScaleFactor: 1.3),
                    GestureDetector(
                        onTap: (){
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => EditKeywordPage()),
                          );
                        },
                        child: Image.asset("assets/setting.png", scale: 10)
                    )
                  ],
                ),
              ),
            ),
            StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection('Keyword')
                    .where('userID', isEqualTo: user!.uid.toString())
                    .snapshots(),
                builder: (context, snapshot) {
                  final docments = snapshot.data!.docs;

                  // keyword list
                  return Expanded(
                    child: ListView.builder(
                        physics: ClampingScrollPhysics(), // 스크롤 방지
                        itemCount: 5,
                        itemBuilder: (BuildContext context, int index) {
                          if (docments.isEmpty) {
                            // 데이터가 없다면
                            return Container(); // 아무것도 생성하지 않는다
                          }

                          if (docments.single.get('keyword$index') == "") {
                            // 키워드가 비워져 있다면
                            return Container(); // 아무것도 생성하지 않는다
                          }

                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Divider(),
                              Padding(
                                padding: const EdgeInsets.fromLTRB(18, 5, 0, 5),
                                child: Text(
                                  docments.single.get('keyword$index'), // get keyword
                                  style: TextStyle(
                                    fontSize: 20,
                                  ),
                                ),
                              ),
                            ],
                          );
                        }),
                  );
                }),
            Divider(
              indent:size.width * 0.025,
              endIndent: size.width * 0.025,
            ),
          ],
        )
    );
  }
}