import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:untitled/home/home.dart';

enum menu { update, del, complete }

class MyWritingAppBar extends StatefulWidget implements PreferredSizeWidget {
  final DocumentSnapshot data;
  final String _type;
  final int imageCount;
  final List<String> originalPath;

  MyWritingAppBar(this.data, this._type, this.imageCount, this.originalPath);

  @override
  Size get preferredSize => const Size.fromHeight(65);

  @override
  _MyWritingAppBarState createState()
    => _MyWritingAppBarState(data, _type, imageCount, originalPath);
}

class _MyWritingAppBarState extends State<MyWritingAppBar> {
  final DocumentSnapshot data;
  final String _type;
  final int imageCount;
  final List<String> originalPath;

  _MyWritingAppBarState(this.data, this._type, this.imageCount, this.originalPath);

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
      backgroundColor: Color(0xff6990FF),
      actions: [
        PopupMenuButton<menu>(
          onSelected: (menu value) {
            setState(() {
              switch (value) {
                case menu.update:
                  // 글의 업데이트에 대한 로직을 여기에 넣어야 함
                  break;
                case menu.del:
                  // 알림창을 통해서 해당 글을 삭제할 것인지를 사용자에게 다시 물어봄
                  // CupertinoAlertDialog(
                  //   title: Text("게시글 삭제"),
                  //   content: Text( "삭제한 내용은 복구할 수 없습니다. 정말 삭제하"),
                  //   actions: <Widget>[
                  //     CupertinoDialogAction(
                  //         isDefaultAction: true,
                  //         onPressed: (){
                  //           Navigator.pop(context);
                  //         },
                  //         child: Text("취소")
                  //     ),
                  //     CupertinoDialogAction(
                  //         textStyle: TextStyle(color: Colors.red),
                  //         isDefaultAction: true,
                  //         onPressed: () {
                  //
                  //         },
                  //         child: Text("삭제")
                  //     ),
                  //   ],
                  // );
                  // 글에 연동된 이미지를 storage 로부터 삭제하는 과정
                  for(int i=0 ; i<imageCount ; i++) {
                    Reference deleteImageRef = FirebaseStorage.instance.ref(originalPath[i]);
                    deleteImageRef.delete(); // 연결된 사진
                  }
                  // 해당 글에 대한 document 를 삭제
                  FirebaseFirestore.instance.collection(_type).doc(data.id).delete(); // 문서삭제
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(
                      builder: (BuildContext context) => MyHomePage(),
                    ),
                        (route) => false,
                  );
                  ScaffoldMessenger.of(context)
                      .showSnackBar(SnackBar(content: Text('해당 글이 삭제되었습니다.')));
                  break;
                case menu.complete:
                  FirebaseFirestore.instance.collection(_type).doc(data.id).update({'status': true}); // 문서업데이트
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(
                      builder: (BuildContext context) => MyHomePage(),
                    ),
                        (route) => false,
                  );
                  ScaffoldMessenger.of(context)
                      .showSnackBar(SnackBar(content: Text('해당 글이 종료되었습니다.')));
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
    );
  }
}
