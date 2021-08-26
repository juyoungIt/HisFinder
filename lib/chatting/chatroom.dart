import 'dart:async';
import 'dart:io';
import 'dart:isolate';
import 'package:flutter/services.dart';
import 'package:path/path.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
// import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
// import 'package:full_screen_image/full_screen_image.dart';
// import 'package:cached_network_image/cached_network_image.dart';
// @dart=2.9

final db = FirebaseFirestore.instance;

class ChatRoomView extends StatefulWidget {
  final String chatRoomID;
  final String chatRoomName;
  ChatRoomView(
      {Key? key, required this.chatRoomID, required this.chatRoomName});
  @override
  _ChatRoomViewState createState() => _ChatRoomViewState(
      chatRoomID: this.chatRoomID, chatRoomName: this.chatRoomName);
}

class _ChatRoomViewState extends State<ChatRoomView>
    with WidgetsBindingObserver {
  _ChatRoomViewState({Key? key, required this.chatRoomID, required this.chatRoomName});

  final scaffoldKey = GlobalKey<ScaffoldState>();
  String chatRoomID;
  String chatRoomName;
  late String receiverID;
  List<String> tokens = <String>[];

  final _focusNode = FocusNode();
  final _messageController = TextEditingController();
  late File imageFile;

  final ScrollController _scrollController = ScrollController();

  late Stream chatStream;
  late StreamSubscription chatStreamSub;
  late List<DocumentSnapshot> docs;

  late int _unreadCount;
  late bool _shouldScroll;

  int loadCount = 20;
  int moreLoadCount = 20;
  bool _isOnDataFirstCalled = true;
  bool _isMessagesLoaded = false;
  bool _hasMore = true;
  DocumentSnapshot? lastDocument;
  List<DocumentSnapshot> _messages = <DocumentSnapshot>[];
  QuerySnapshot? messageQuery;

  @override
  void initState() {
    super.initState();
    if (chatRoomID.startsWith("chatInit")) {
      getInitialChatInfo();
    } else {
      setStream(chatRoomID);
    }

    _shouldScroll = false;
    _scrollController
      ..addListener(() {
        if (_scrollController.position.pixels ==
            _scrollController.position.maxScrollExtent) {
          if (!chatRoomID.startsWith("chatInit")) {
            _loadMessages(chatRoomID);
          }
        }
      });
  }

  @override
  void dispose() {
    // print("good bye!");
    if (!chatRoomID.startsWith("chatInit")) {
      userOffLine(chatRoomID);
      WidgetsBinding.instance!.removeObserver(this);
    }
    _focusNode.unfocus();
    _focusNode.dispose();

    if(chatStreamSub!=null) {
      chatStreamSub.cancel();
    }
    _messages.clear();
    lastDocument = null;
    messageQuery = null;
    _hasMore = true;
    _isMessagesLoaded = false;
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    if (!chatRoomID.startsWith('chatInit')) {
      if (state == AppLifecycleState.paused ||
          state == AppLifecycleState.inactive ||
          state == AppLifecycleState.detached) {
        // print("app paused");
        userOffLine(chatRoomID);
      } else if (state == AppLifecycleState.resumed) {
        // print("app resumed");
        userOnLine(chatRoomID);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    _messageController.addListener(() {
      setState(() {});
    });
    return Scaffold(
        key: scaffoldKey,
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(40.0),
          child:
          AppBar(
            elevation: 0,
            // leading: IconButton(
            //   icon: Image.asset("images/이전@4x.png", scale: 4),
            //   onPressed: () {
            //     Navigator.push(
            //         context,
            //         PageRouteBuilder(
            //           pageBuilder: (context, animation1, animation2) => SignIn(),
            //           transitionDuration: Duration(seconds: 0),
            //         )
            //     );
            //   },
            // ),
            backgroundColor: const Color(0xff6990FF),
            centerTitle: true,
            title: chatRoomName != null ? Text(chatRoomName, style: TextStyle(
              fontFamily: 'avenir',
              fontWeight: FontWeight.w500,
              color: Colors.white,
            ),) : Text("Loading..."),
          ),
        ),
        body: Stack(
          children: <Widget>[
            Padding(
                padding: EdgeInsets.fromLTRB(0, 0, 0, 75),
                child: chatRoomID.startsWith("chatInit")
                    ? chatRoomName != null
                    ? Center(
                  child: Text(
                    "Send the first message",
                    style: TextStyle(
                      // color: Theme.of(context)
                      //     .textTheme
                      //     .bodyText1!
                      //     .color
                    ),
                  ),
                )
                    : Container()
                    : _isMessagesLoaded
                    ? ListView.builder(
                    reverse: true,
                    controller: _scrollController,
                    itemCount: _hasMore
                        ? _messages.length + 1
                        : _messages.length,
                    itemBuilder: (context, index) {
                      if (_shouldScroll) {
                        WidgetsBinding.instance!
                            .addPostFrameCallback((_) => ScrollToEnd());
                      }
                      if (index == _messages.length) {
                        return Container();
                      }
                      else {
                        if (_unreadCount > 0 && index == _unreadCount) {
                          // _unreadIndex = index;
                          return Column(
                            children: [
                              chatMessageItem(
                                  context, _messages[index], index==_messages.length-1 ? _messages[index] : _messages[index+1]),
                              Container(
                                width: 150,
                                alignment: Alignment.center,
                                child: Text(
                                  "여기까지 읽었습니다",
                                  style: TextStyle(
                                    // color: Theme.of(context)
                                    //     .textTheme
                                    //     .bodyText1!
                                    //     .color
                                  ),
                                ),
                              ),
                            ],
                          );
                        } else {
                          return chatMessageItem(
                              context, _messages[index], index==_messages.length-1 ? _messages[index] : _messages[index+1]);
                        }
                      }
                    })
                    : Container()
            ),
            Align(
                alignment: Alignment.bottomLeft,
                child: SafeArea(
                  child: Container(    // 메시지 입력, 보내기 버튼 감싼 컨테이너
                    margin: EdgeInsets.symmetric(horizontal: 13.0),
                    decoration: BoxDecoration(
                        color: const Color(0xf7eeeeee),
                        borderRadius: BorderRadius.circular(15.0)),
                    padding: EdgeInsets.only(left:16, right:5, top:4, bottom:1),
                    child: Row(
                      children: [
                        Expanded(
                          child: TextField(   // 메시지 입력필드
                            controller:  _messageController,
                            minLines: 1,
                            maxLines: 3,
                            decoration: InputDecoration(
                              hintText: '메세지 입력',
                              border: InputBorder.none,
                              suffixIcon: IconButton(   // 전송 버튼
                                  icon: Icon(Icons.send_rounded, color: Colors.grey,),
                                  onPressed: () {
                                    if(_messageController.text.trim().isNotEmpty) {
                                      setState(() {
                                        String temp = _messageController.text;
                                        _messageController.clear();
                                        _saveMessage(false, temp);
                                        _shouldScroll = true;
                                      });
                                    }
                                    else _scrollToBottom();
                                  }
                              ),
                            ),
                          ),
                          // child: TextField(
                          //   style: TextStyle(fontSize: 15),
                          //   focusNode: _focusNode,
                          //   controller: _messageController,
                          //   minLines: 1,
                          //   maxLines: 3,
                          //   decoration: InputDecoration(
                          //       border: InputBorder.none,
                          //       filled: true,
                          //       fillColor: const Color(0xf7eeeeee),
                          //       hintText: 'Write a message',
                          //       hintStyle: TextStyle(
                          //           color: Theme.of(context)
                          //               .textTheme
                          //               .bodyText1!
                          //               .color!
                          //               .withOpacity(0.30)),
                          //       suffixIcon: _messageController.text.isNotEmpty
                          //           ? IconButton(
                          //         icon: Icon(
                          //           Icons.send_rounded,
                          //         ),
                          //         onPressed: () {
                          //           setState(() {
                          //             String temp = _messageController.text;
                          //             _messageController.clear();
                          //             _saveMessage(false, temp);
                          //             _shouldScroll = true;
                          //           });
                          //         },
                          //       )
                          //           : IconButton(
                          //           icon: Icon(Icons.camera_alt),
                          //           onPressed: () {
                          //             _showChoiceDialog(context);
                          //           })),
                          // ),
                        ),
                      ],
                    ),
                  ),
                )
            )
          ],
        ));
  }

  void _scrollToBottom() {
    if (_scrollController.hasClients) {
      _scrollController.jumpTo(_scrollController.position.minScrollExtent);
    }
  }

  Widget chatMessageItem(BuildContext context, DocumentSnapshot document1, DocumentSnapshot document2) {
    bool isSender = document1['sender'] == "IoWY4yaZWSTCRpSqQUKpx8SzMfs1";
    Timestamp tt = document1["date"];
    Timestamp tt2 = document2["date"];
    String date = "";
    date = DateFormat('kk:mma').format(tt.toDate()).toString();
    final nextTime = tt;
    final time = tt2;
    final timeToDate = DateFormat('yyyy-MM-dd')
        .format(time.toDate())
        .toString();
    final nextTimeToDate = DateFormat('yyyy-MM-dd')
        .format(nextTime.toDate())
        .toString();
    return Column(
      children: [
        (nextTimeToDate != timeToDate || tt==tt2) ? Column(
          children: [
            // Text(DateTime.now().toString()),
            SizedBox(
              height: 18,
            ),
            Container(
              alignment: Alignment.center,
              child: Text(
                DateFormat('yyyy-MM-dd').format(tt.toDate()).toString(),
                style: TextStyle(color: Colors.grey, fontSize: 13.5),
              ),
              width: 100,
              height: 20,
              decoration: BoxDecoration(
                  color: const Color(0xf7eeeeee),
                  borderRadius: BorderRadius.circular(8.0)),
            ),
            SizedBox(
              height: 18,
            )
          ],
        ) : Container(),
        Container(
          padding: EdgeInsets.all(8),
          child: FractionallySizedBox(
              child: isSender
                  ? Row(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  document1["isRead"]==false
                      ? SizedBox(width:15, child: Text("1", style: TextStyle(fontSize: 12, color: const Color(0xffff8c8c)),))
                      : Text(""),
                  Text(
                    date,
                    style: TextStyle(
                        color: Colors.grey, fontSize: 13.5
                      // color: Theme.of(context)
                      //     .accentTextTheme
                      //     .bodyText1!
                      //     .color
                    ),
                  ),
                  messagebody(document1["type"], document1["content"], isSender,
                      context)
                ],
              )
                  : Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  messagebody(document1['type'], document1["content"], isSender,
                      context),
                  Text(
                    date,
                    style: TextStyle(
                        color: Colors.grey, fontSize: 13.5
                      // color: Theme.of(context)
                      //     .accentTextTheme
                      //     .bodyText1!
                      //     .color
                    ),
                  ),
                ],
              )),
        ),
      ],
    );
  }

  Widget messagebody(
      String type, String content, bool isSender, BuildContext context) {
    return Flexible(
      child: type == 'image'
          ? Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(
            width: MediaQuery.of(context).size.width * 0.7,
            height: MediaQuery.of(context).size.width * 0.8,
            // child: FullScreenWidget(
            //     child: Hero(
            //         tag: content,
            //         child: CachedNetworkImage(
            //             placeholder: (context, url) => Container(
            //               child: Center(
            //                 child: SizedBox(
            //                   width: 20,
            //                   height: 20,
            //                   child: CircularProgressIndicator(),
            //                 ),
            //               ),
            //               color: Theme.of(context).backgroundColor,
            //             ),
            //             imageUrl: content,
            //             fit: BoxFit.cover))),
          ))
          : Card(
        elevation: 0,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(15,10,15,10),
          child: ConstrainedBox(
            constraints: BoxConstraints(
                maxWidth: MediaQuery.of(context).size.width * 0.7),
            child: Text(
              content,
              style: TextStyle(fontSize: 15),
            ),
          ),
        ),
        color: isSender
            ? const Color(0xffcedaff)
            : const Color(0xf7eeeeee),
      ),
    );
  }

  //when chatroomID starts with "chatInit"
  //글이나 댓글을 통해서 채팅을 시작하는 경우
  Future getInitialChatInfo() async {
    tokens = chatRoomID.split('/');
    receiverID = tokens[1];
    if (tokens.length == 3) {
      String senderID = "IoWY4yaZWSTCRpSqQUKpx8SzMfs1";
      QuerySnapshot docSnapshots = await db
          .collection('chatroom')
          .where('participants', arrayContains: senderID)
          .get();
      // .getDocuments();
      if (docSnapshots.docs.isNotEmpty) {
        for (int docIndex = 0;
        docIndex < docSnapshots.docs.length;
        docIndex++) {
          if (docSnapshots.docs[docIndex]['participants'].length == 2 &&
              docSnapshots.docs[docIndex]['participants']
                  .contains(receiverID)) {
            // print("already exists");
            chatRoomID = docSnapshots.docs[docIndex].id;
            await setStream(chatRoomID);
            setState(() {});
          }
        }
      }
      // chatRoomName = await _getReceiverNick(receiverID);
      chatRoomName = tokens[1];
    } else {
      chatRoomName = "에러가 발생했습니다. 재시도해주세요.";
    }
    setState(() {});
  }

  Future _getReceiverNick(String receiverID) async {
    String result = "";
    DocumentSnapshot ds =
    await db.collection('user').doc(receiverID).get();
    if (ds.data != null) {
      result = ds["nickName"];
    } else {
      result = "에러가 발생했습니다. 재시도해주세요.";
    }
    return result;
  }

  Future setStream(String CRID) async {
    //get receiverID
    //채팅방 리스트를 통해 채팅방에 들어온 경우
    if (!chatRoomID.startsWith('chatInit')) {
      await db
          .collection('chatroom')
          .doc(chatRoomID)
          .get()
          .then((result) async {
        List<dynamic> participants = result.data()!['participants'];
        participants
            .removeWhere((element) => element == "IoWY4yaZWSTCRpSqQUKpx8SzMfs1");
        receiverID = participants[0];
      });
    }
    //add widget binding observer
    WidgetsBinding.instance!.addObserver(this);
    //make user online
    await userOnLine(CRID);
    //register stream and stream subscriber
    await _loadMessages(CRID);
    chatStream = db
        .collection('chatroom')
        .doc(CRID)
        .collection('messages')
        .orderBy('date', descending: true)
        .snapshots();
    chatStreamSub = chatStream.listen(null);
    chatStreamSub.onData((snapshot) {
      if (snapshot.documents[0]["sender"] != "IoWY4yaZWSTCRpSqQUKpx8SzMfs1") {
        if (_isOnDataFirstCalled) {
          _isOnDataFirstCalled = false;
        } else {
          _messages.insert(0, snapshot.documents[0]);
          // print(
          //     "On Data, new message: ${_messages[0].data["content"]} message list length: ${_messages.length.toString()} PID: ${Isolate.current.debugName}");
          setState(() {});
        }
        if (_scrollController.hasClients) {
          if (_scrollController.position.pixels > 50) {
            if (_unreadCount != 0) {
              _unreadCount += 1;
            }
            String latestMessage = snapshot.documents[0]["content"];
            scaffoldKey.currentState!.showSnackBar(
              SnackBar(
                content: Text(latestMessage),
                action: SnackBarAction(
                  label: "보기",
                  onPressed: () => {
                    setState(() {
                      if (_unreadCount != 0) {
                        _unreadCount += 1;
                      }
                      _shouldScroll = true;
                    })
                  },
                ),
                duration: Duration(seconds: 1),
              ),
            );
          } else {
            setState(() {
              _shouldScroll = true;
            });
          }
        }
      }
    });
    setState(() {});
  }

  Future userOnLine(String CRID) async {
    //make user online
    DocumentReference docRef = db.collection('chatroom').doc(CRID);
    await db.runTransaction((transaction) async {
      final freshSnapshot = await transaction.get(docRef);
      // final freshSnapshot = docRef.get('adsf')
      final fresh = freshSnapshot.data()! as Map;
      _unreadCount = fresh["unreadCount"]["IoWY4yaZWSTCRpSqQUKpx8SzMfs1"];
      List<dynamic> onlineUsers = fresh["onlineUser"];
      if (!onlineUsers.contains("IoWY4yaZWSTCRpSqQUKpx8SzMfs1")) {
        onlineUsers.add("IoWY4yaZWSTCRpSqQUKpx8SzMfs1");
      }
      await transaction.update(docRef, {
        'onlineUser': onlineUsers,
        'unreadCount.${"IoWY4yaZWSTCRpSqQUKpx8SzMfs1"}': 0,
      });
    });
    if (receiverID != null) {
      await db
          .collection('chatroom')
          .doc(CRID)
          .collection('messages')
          .where('sender', isEqualTo: receiverID)
          .where('isRead', isEqualTo: false)
          .get()
          .then((value) => value.docs.forEach((element) {
        element.reference.update({'isRead': true});
      }));
    }
    // await globals.dbUser.userOnDB.get().then((userSnapshot) {
    //   globals.dbUser.userOnDB
    //       .updateData({"unreadCount": FieldValue.increment(-_unreadCount)});
    // });
  }

  Future userOffLine(String CRID) async {
    DocumentReference docRef = db.collection('chatroom').doc(CRID);
    await db.runTransaction((transaction) async {
      final freshSnapshot = await transaction.get(docRef);
      final fresh = freshSnapshot.data()! as Map;
      List<dynamic> onlineUsers = fresh["onlineUser"];
      onlineUsers.removeWhere((element) => element == "IoWY4yaZWSTCRpSqQUKpx8SzMfs1");
      await transaction.update(docRef, {'onlineUser': onlineUsers});
    });
  }

  Future _showChoiceDialog(BuildContext context) {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text(
              "Choose option",
              style: TextStyle(color: Theme.of(context).accentColor),
            ),
            content: SingleChildScrollView(
                child: ListBody(
                  children: [
                    Divider(
                      height: 1,
                      color: Theme.of(context).accentColor,
                    ),
                    ListTile(
                      onTap: () {
                        _openGallery(context);
                      },
                      title: Text("Gallery"),
                      leading: Icon(
                        Icons.account_box,
                        color: Theme.of(context).accentColor,
                      ),
                    ),
                    Divider(height: 1,
                        color: Theme.of(context).accentColor),
                    ListTile(
                      onTap: () {
                        _openCamera(context);
                      },
                      title: Text("Camera"),
                      leading: Icon(
                        Icons.camera,
                        color: Theme.of(context).accentColor,
                      ),
                    ),
                  ],
                )),
          );
        });
  }

  Future _showLoadedImage(BuildContext context) {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("선택된 사진"),
            content: SingleChildScrollView(
              child: ListBody(
                children: [
                  Container(
                    child: Image.file(imageFile),
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      IconButton(
                        icon: Icon(Icons.send),
                        onPressed: () async {
                          Navigator.pop(context);
                          await uploadImageToFirebase(context);
                        },
                      ),
                      IconButton(
                        icon: Icon(Icons.clear),
                        onPressed: () {
                          Navigator.pop(context);
                        },
                      )
                    ],
                  ),
                ],
              ),
            ),
          );
        });
  }

  Future uploadImageToFirebase(BuildContext context) async {
    String fileName = basename(imageFile.path);
    Reference firebaseStorageRef =
    FirebaseStorage.instance.ref().child('chatroom/$fileName');
    UploadTask uploadTask = firebaseStorageRef.putFile(imageFile);
    TaskSnapshot taskSnapshot = await uploadTask;
    // .onComplete;
    taskSnapshot.ref.getDownloadURL().then((value) {
      setState(() {
        _shouldScroll = true;
        _focusNode.unfocus();
        _saveMessage(true, value);
      });
    });
  }

  void _openGallery(BuildContext context) async {
    await ImagePicker()
        .getImage(
      source: ImageSource.gallery,
    )
        .then((value) {
      setState(() async {
        imageFile = File(value!.path);
        await _showLoadedImage(context);
        Navigator.pop(context);
      });
    });
  }

  void _openCamera(BuildContext context) async {
    await ImagePicker()
        .getImage(
      source: ImageSource.camera,
    )
        .then((value) {
      setState(() async {
        imageFile = File(value!.path);
        await _showLoadedImage(context);
        Navigator.pop(context);
      });
    });
  }

  Future _loadMessages(String CRID) async {
    if (!_hasMore) {
      return;
    }
    var ref = db.collection('chatroom').doc(CRID).collection("messages");
    if (lastDocument == null) {
      await ref
          .orderBy('date', descending: true)
          .limit(loadCount)
          .get()
          .then((value) {
        messageQuery = value;
      });
    } else {
      await ref
          .orderBy('date', descending: true)
          .limit(loadCount)
          .startAfterDocument(lastDocument!)
          .get()
          .then((value) {
        messageQuery = value;
      });
    }
    if (messageQuery!.docs.length < loadCount) {
      _hasMore = false;
    }
    lastDocument = messageQuery!.docs[messageQuery!.docs.length - 1];
    _messages.addAll(messageQuery!.docs);
    _isMessagesLoaded = true;
    // print("message list length: " + _messages.length.toString());
    setState(() {});
  }

  void _saveMessage(bool isImage, String content) async {
    DateTime _now = DateTime.now();
    if (chatRoomID.startsWith("chatInit")) {
      CollectionReference chatroomRef = db.collection('chatroom');
      List<String> _particitants = <String>[];
      _particitants.add("IoWY4yaZWSTCRpSqQUKpx8SzMfs1");
      _particitants.add(receiverID);
      await chatroomRef.add({
        // 'isAnonymous': tokens[2] == 'anonymous',
        'lastDate': _now,
        'participants': _particitants,
        'onlineUser': ["IoWY4yaZWSTCRpSqQUKpx8SzMfs1"],
        'lastMessage': isImage ? '<Photo>' : content,
        'unreadCount': {
          receiverID: 1,
          "IoWY4yaZWSTCRpSqQUKpx8SzMfs1": 0,
        }
      }).then((docRef) async {
        CollectionReference msgsRef = docRef.collection('messages');
        if (isImage) {
          await msgsRef.add({
            'type': 'image',
            'content': content,
            'date': _now,
            'sender': "IoWY4yaZWSTCRpSqQUKpx8SzMfs1",
            'isRead': false,
          });
        } else {
          await msgsRef.add({
            'type': 'text',
            'content': content,
            'date': _now,
            'sender': "IoWY4yaZWSTCRpSqQUKpx8SzMfs1",
            'isRead': false,
          });
        }
        chatRoomID = docRef.id;
      }).then((value) async {
        await setStream(chatRoomID);
        setState(() {});
      });
      db
          .collection('user')
          .doc(receiverID)
          .update({"unreadCount": FieldValue.increment(1)});
    } else {
      DocumentReference chatroomRef =
      db.collection('chatroom').doc(chatRoomID);
      DocumentSnapshot docSnapshot = await chatroomRef.get();
      CollectionReference msgsRef = chatroomRef.collection('messages');
      bool isRead = docSnapshot['onlineUser'].length > 1;
      if (isImage) {
        await msgsRef.add({
          'type': 'image',
          'content': content,
          'date': _now,
          'sender': "IoWY4yaZWSTCRpSqQUKpx8SzMfs1",
          'isRead': isRead,
        }).then((DocRef) async {
          await DocRef.get().then((DocSnapshot) {
            _messages.insert(0, DocSnapshot);
          });
          // print(
          //     "On Save Message,new message: ${_messages[0].data["content"]} message list length: ${_messages.length.toString()}");
          setState(() {});
        });
      } else {
        await msgsRef.add({
          'type': 'text',
          'content': content,
          'date': _now,
          'sender': "IoWY4yaZWSTCRpSqQUKpx8SzMfs1",
          'isRead': isRead,
        }).then((DocRef) async {
          await DocRef.get().then((DocSnapshot) {
            _messages.insert(0, DocSnapshot);
          });
          // print(
          //     "On Save Message, new message: ${_messages[0].data["content"]} message list length: ${_messages.length.toString()}");
          setState(() {});
        });
      }
      await db.runTransaction((transaction) async {
        final freshSnapshot = await transaction.get(chatroomRef);
        final fresh = freshSnapshot.data()! as Map;
        List<dynamic> onlineUsers = fresh["onlineUser"];
        if (onlineUsers.contains(receiverID)) {
          await transaction.update(chatroomRef, {
            'lastDate': _now,
            'lastMessage': isImage ? '<Photo>' : content,
          });
        } else {
          await transaction.update(chatroomRef, {
            'lastDate': _now,
            'lastMessage': isImage ? '<Photo>' : content,
            'unreadCount.$receiverID': fresh['unreadCount'][receiverID], //+ 1,
          });
          db
              .collection('user')
              .doc(receiverID)
              .update({"unreadCount": FieldValue.increment(1)});
        }
      });
    }
    //_focusNode.unfocus();
    _messageController.clear();
  }

  void ScrollToEnd() async {
    if (_shouldScroll) {
      _scrollController.jumpTo(_scrollController.position.minScrollExtent);
      _shouldScroll = false;
      if (_unreadCount != 0) {
        _unreadCount += 1;
      }
    }
  }
}