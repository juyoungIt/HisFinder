import 'package:badges/badges.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';
import 'chatroom.dart';

final db = FirebaseFirestore.instance;
final user = FirebaseAuth.instance.currentUser;

class ChatRoomList extends StatefulWidget {
  @override
  _ChatRoomListState createState() => _ChatRoomListState();
}

class _ChatRoomListState extends State<ChatRoomList> {
  @override
  Widget build(BuildContext context) {
    return _chatRoomBody(context);
  }

  Widget _chatRoomBody(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      // stream: db.collection("chatroom").snapshots(),
      stream: db
          .collection("chatroom")
          .where("participants", arrayContains: user!.uid)
          .orderBy("lastDate", descending: true)
          .snapshots(),
      builder: (context, snapshot) {
        if(snapshot.hasError){
          print(snapshot.error);
        }
        if (snapshot.connectionState == ConnectionState.none && snapshot.hasData == null) {
          return Center(
              child: SizedBox(
                height: 5,
                width: 5,
                child: CircularProgressIndicator(),
              )
          );
        }
        else if (snapshot.data != null && snapshot.data!.docs.length == 0) {
          return Center(child: Text("현재 진행 중인 채팅이 없습니다"));
        }
        else if (snapshot.data != null) {
          // return ListView(
          //   children: snapshot.data!.docs.map((DocumentSnapshot document) {
          //   Map<String, dynamic> data = document.data()! as Map<String, dynamic>;
          //   return ListTile(
          //     title: Text(data['participants'][0]),
          //     subtitle: Text(data['lastMessage']),
          //   );
          //   }).toList(),
          // );
          return _chatRoomList(context, snapshot.data!.docs);
        }
        else {
          return Center(child: Text("예상하지 못한 오류가 발생했습니다"));
        }
      },
    );
  }

  Widget _chatRoomList(BuildContext context, List<DocumentSnapshot> documents) {
    return Column(
      children: [
        Container(
          // height: MediaQuery.of(context).size.height,
          child: Padding(
            padding: EdgeInsets.fromLTRB(15, 10, 15, 0),
            child: ListView.separated(
                separatorBuilder: (BuildContext context, int index) {
                  return Container(child: const Divider());
                },
                shrinkWrap: true,
                itemCount: documents.length,
                itemBuilder: (context, index) {
                  return _chatRoomItem(context, documents[index]);
                }),
          ),
        ),
      ],
    );
  }

  Widget _chatRoomItem(BuildContext context, DocumentSnapshot document) {
    List<dynamic> participants = document["participants"];
    participants.removeWhere(
            (element) => element.toString() == user!.uid);
    Future _getInitialData() async {
      String participantsString = "";
      if (participants.length > 0) {
        DocumentSnapshot ds = await db.collection('Users').doc(participants[0]).get();  //유저 아이디로 유저 정보 가져오기
        // participantsString = participants[0];  //닉네임 가져오기
        if(!ds.exists) participantsString = "unknown";
        else participantsString = ds['nickname'];  //닉네임 가져오기
      } else {
        participantsString = "unknown";
      }
      // }
      return participantsString;
    }

    Timestamp tt = document["lastDate"];
    DateTime dateTime =
    DateTime.fromMicrosecondsSinceEpoch(tt.microsecondsSinceEpoch);
    String date = DateFormat.Md().add_Hm().format(dateTime);
    return Container(
      padding: EdgeInsets.fromLTRB(8, 10, 8, 10),
      child: FutureBuilder(
          future: _getInitialData(),
          builder: (context, result) {
            if (result.hasData) {
              return InkWell(
                onTap: () =>
                {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            ChatRoomView(
                              chatRoomID: document.id,
                              chatRoomName: result.data.toString(),
                            ),
                      )),
                },
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          width: MediaQuery
                              .of(context)
                              .size
                              .width * 0.7,
                          alignment: Alignment.topLeft,
                          child: Text(
                            result.data.toString(),
                            style: TextStyle(fontFamily: 'avenir',fontSize: 20),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        Container(
                          child: document['unreadCount']
                          [user!.uid]
                              >=
                              1
                              ? Badge(
                            badgeContent: Text(
                              document['unreadCount']
                              [user!.uid]
                                  >
                                  99
                                  ? "99+"
                                  : document['unreadCount']
                              [user!.uid]
                                  .toString(),
                              style: TextStyle(color: Colors.white),
                            ),
                            badgeColor: Colors.pinkAccent,
                          )
                              : SizedBox(
                            width: 1,
                            height: 1,
                          ),
                        )
                      ],
                    ),
                    Padding(padding: EdgeInsets.only(bottom: 5.0)),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          width: MediaQuery
                              .of(context)
                              .size
                              .width * 0.7,
                          child: Text(
                            document['lastMessage'],
                            style: TextStyle(
                              fontFamily: 'avenir',
                              // color: Theme
                              //     .of(context)
                              //     .accentTextTheme
                              //     .bodyText1!
                              //     .color!
                              //     .withOpacity(0.65),
                              fontSize: 15,
                              fontWeight: document['unreadCount']
                              [user!.uid]
                                  >=
                                  1
                                  ? FontWeight.bold
                                  : FontWeight.normal,
                            ),
                            overflow: TextOverflow.ellipsis,
                            maxLines: 2,
                          ),
                        ),
                        Container(
                          alignment: Alignment.bottomRight,
                          child: Text(
                            date,
                            style: TextStyle(
                              fontFamily: 'avenir',
                              // color: Theme
                              //     .of(context)
                              //     .accentTextTheme
                              //     .bodyText1!
                              //     .color!
                              //     .withOpacity(0.65),
                              fontSize: 13,
                            ),
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              );
            } else {
              return LinearProgressIndicator();
            }
          }),
    );
  }
}