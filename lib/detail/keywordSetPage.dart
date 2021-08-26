import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class EditKeywordPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MyStatefulWidget();
  }
}

class MyStatefulWidget extends StatefulWidget {
  @override
  MyStatefulWidgetState createState() => MyStatefulWidgetState();
}

class MyStatefulWidgetState extends State<MyStatefulWidget> {
  final String userID = FirebaseAuth.instance.currentUser!.uid.toString(); // 현재 접속중인 사용자의 uid
  final String title = '키워드 설정';  // 타이틀 텍스트
  final String hintText = '추가할 키워드를 입력해주세요'; // 입력창 힌트 텍스트
  final String noInput = '키워드를 입력해 주세요!'; // 입력없이 버튼을 눌렀을 때 뜨는 텍스트
  final String maxKeyword = '키워드는 5개 까지 등록할 수 있습니다.'; // 키워드를 5개 초과로 설정하려 할 때 뜨는 텍스트
  final String btnText = '추가'; // 버튼 텍스트

  @override
  Widget build(BuildContext context) {
    final TextEditingController _keyword = TextEditingController(); //키워드 입력창 컨트롤러
    final Size? size = MediaQuery.of(context).size; //화면 사이즈 접근하기 위한 객체
    return Scaffold(
        appBar: AppBar(
          elevation: 0,
          backgroundColor: const Color(0xff6990FF),
          centerTitle: true,
          title: Text(
            title,
            style: TextStyle(
              fontWeight: FontWeight.w500,
              color: Colors.white,
            ),
          ),
        ),
        body: Container(
            margin: EdgeInsets.only(top: 10),
            padding: EdgeInsets.fromLTRB(5, 0, 5, 0),
            child: Column(children: [
              Row(
                children: [
                  SizedBox(
                    width: size!.width * 0.8,
                    child: TextFormField(
                      controller: _keyword,
                      cursorColor: Colors.black,
                      decoration: new InputDecoration(
                          border: InputBorder.none,
                          focusedBorder: InputBorder.none,
                          enabledBorder: InputBorder.none,
                          errorBorder: InputBorder.none,
                          disabledBorder: InputBorder.none,
                          contentPadding: EdgeInsets.only(
                              left: 15, bottom: 11, top: 11, right: 15),
                          hintText: hintText),
                    ),
                  ),
                  TextButton(
                      onPressed: () {
                        // 아무 입력 없이 버튼을 눌렀을 떄
                        if (_keyword.text == "") {
                          ScaffoldMessenger.of(context)
                              .showSnackBar(SnackBar(content: Text(noInput)));
                          return;
                        }
                        String id = ''; // field 접근용 id
                        CollectionReference col = FirebaseFirestore.instance.collection('Keyword');
                        int num = 5; //keyword 가 입력될 인덱스
                        col
                            .where('userID', isEqualTo: userID)
                            .limit(1)
                            .get()
                            .then((QuerySnapshot querySnapshot) {
                          querySnapshot.docs.forEach((doc) {
                            id = doc.id;
                            num = 5;
                            for (int i = 0; i < 5; i++)
                              if (doc
                                  .get('keyword' + i.toString())
                                  .toString() ==
                                  "") {
                                num = i;
                                break;
                              } // 비어있는 인덱스 찾기

                            // 비어있는 keyword 가 없을떄
                            if (num >= 5) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(content: Text(maxKeyword)));
                            } else {
                              // keyword 입력
                              col
                                  .doc(id)
                                  .update({'keyword$num': _keyword.text});
                              //현재 입력한 내용 지우기
                              _keyword.text = '';
                            }
                          });
                        });
                      },
                      child: Text(
                        btnText,
                        style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                            fontSize: 17),
                      )),
                ],
              ),
              // 구분을 위해 삽입하는 divider
              Container(
                margin: EdgeInsets.fromLTRB(15, 0, 15, 0),
                child: Divider(
                  thickness: 2,
                ),
              ),
              // 입력한 keyword에 대한 UI 컴포넌트를 동적으로 삽입하는 부분
              StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection('Keyword').where("userID", isEqualTo: userID)
                    .snapshots(),
                builder: (context, snapshot) {
                  final documents = snapshot.data!.docs;
                  String id = "";
                  FirebaseFirestore.instance
                      .collection('Keyword')
                      .where('userID', isEqualTo: userID)
                      .limit(1)
                      .get()
                      .then((value) {
                    id = value.docs.single.id;
                  });
                  return Expanded(
                      child: ListView.builder(
                          itemCount: 5, //int.parse(docments.single.get('keywordNum')),
                          itemBuilder: (BuildContext context, int index) {
                            // keyword 가 비어 있다면
                            if (documents.single.get('keyword$index') == "") {
                              return Container(); // 아무것도 출력하지 않는다.
                            } else {
                              //------------------------------------------------
                              // TODO : 수정 필요
                              // timestamp를 사용하여 keyword가 변경된 시각을 기록해야 함.
                              return Container(
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.all(
                                      Radius.circular(2),
                                    ),
                                    border: Border.all(
                                      color: Color(0xff6990FF),
                                      width: 1,
                                    ),
                                  ),
                                  margin: EdgeInsets.fromLTRB(10, 5, 10, 5),
                                  padding: EdgeInsets.fromLTRB(5, 5, 5, 5),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      Text(
                                        documents.single.get('keyword$index'),
                                        style: TextStyle(
                                            fontSize: 20,
                                            fontWeight: FontWeight.bold
                                        ),
                                      ),
                                      IconButton(
                                        onPressed: () {
                                          FirebaseFirestore.instance
                                              .collection('Keyword')
                                              .doc(id)
                                              .update({'keyword$index': ""});
                                        },
                                        icon: Image.asset(
                                            "assets/keywordListDelete.png",
                                            width: 58,
                                            height: 58,
                                            scale: 4
                                        ),
                                      ),
                                    ],
                                  ));
                              //------------------------------------------------
                            }
                          }
                          )
                  );
                },
              )
            ])
        )
    );
  }
}