import 'package:flutter/material.dart';
import 'package:untitled/category/categorySearchResult.dart';
import 'package:untitled/notification/notificationList.dart';

class CategoryPage extends StatelessWidget {
  late final String _type;

  CategoryPage(this._type);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
          elevation: 0.0,
          title: Text(
            'Category',
            style: TextStyle(
              color: Colors.black,
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
                icon: Image.asset("assets/category_black.png", width: 65, height: 65, scale: 2.5),
                onPressed: () {
                  Navigator.pop(context);
                }),
          ),
          actions: [
            Padding(
              padding: const EdgeInsets.fromLTRB(0, 0, 10, 0),
              child: IconButton(
                  icon: Image.asset("assets/notice_black.png", width: 73, height: 76, scale: 3),
                  onPressed: () {
                    Navigator.pop(context);
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => NotificationListPage()),
                    );
                  }),
            ),
          ],
          backgroundColor: Colors.white
      ),
      body: Stack(
        children: <Widget>[
          Container(
            color: Colors.black38
          ),
          Container(
            height: 400,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                bottomRight: Radius.circular(20.0),
                bottomLeft: Radius.circular(20.0),
              )
          ),
            child: GridView.count(
              physics: NeverScrollableScrollPhysics(),
              crossAxisCount: 3,
              children: <Widget>[
                // 학생증
                Container(
                  child: Column(
                    children: <Widget>[
                      SizedBox(
                        width: 70,
                        height: 70,
                        child: IconButton(
                            icon: Image.asset("assets/sid_card.png", width: 65, height: 65, scale: 1),
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => CategorySearchResultPage(_type, "학생증")),
                              );
                            }
                        ),
                      ),
                      Text("학생증")
                    ]
                  ),
                ),
                // 일반카드
                Container(
                  child: Column(
                      children: <Widget>[
                        SizedBox(
                          width: 70,
                          height: 70,
                          child: IconButton(
                              icon: Image.asset("assets/gen_card.png", width: 65, height: 65, scale: 1),
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(builder: (context) => CategorySearchResultPage(_type, "일반카드(개인/세탁카드)")),
                                );
                              }
                          ),
                        ),
                        Text("일반카드")
                      ]
                  ),
                ),
                // 에어팟, 버즈
                Container(
                  child: Column(
                      children: <Widget>[
                        SizedBox(
                          width: 70,
                          height: 70,
                          child: IconButton(
                              icon: Image.asset("assets/podAndBuz.png", width: 65, height: 65, scale: 1),
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(builder: (context) => CategorySearchResultPage(_type, "에어팟, 버즈")),
                                );
                              }
                          ),
                        ),
                        Text("에어팟, 버즈")
                      ]
                  ),
                ),
                // 전자기기
                Container(
                  child: Column(
                      children: <Widget>[
                        SizedBox(
                          width: 70,
                          height: 70,
                          child: IconButton(
                              icon: Image.asset("assets/electronics.png", width: 65, height: 65, scale: 1),
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(builder: (context) => CategorySearchResultPage(_type, "전자기기")),
                                );
                              }
                          ),
                        ),
                        Text("전자기기")
                      ]
                  ),
                ),
                // 지갑, 돈
                Container(
                  child: Column(
                      children: <Widget>[
                        SizedBox(
                          width: 70,
                          height: 70,
                          child: IconButton(
                              icon: Image.asset("assets/wallet.png", width: 65, height: 65, scale: 1),
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(builder: (context) => CategorySearchResultPage(_type, "돈, 지갑")),
                                );
                              }
                          ),
                        ),
                        Text("지갑, 돈")
                      ]
                  ),
                ),
                // 화장품
                Container(
                  child: Column(
                      children: <Widget>[
                        SizedBox(
                          width: 70,
                          height: 70,
                          child: IconButton(
                              icon: Image.asset("assets/cosmetics.png", width: 65, height: 65, scale: 1),
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(builder: (context) => CategorySearchResultPage(_type, "화장품")),
                                );
                              }
                          ),
                        ),
                        Text("화장품")
                      ]
                  ),
                ),
                // 악세서리
                Container(
                  child: Column(
                      children: <Widget>[
                        SizedBox(
                          width: 70,
                          height: 70,
                          child: IconButton(
                              icon: Image.asset("assets/accessory.png", width: 65, height: 65, scale: 1),
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(builder: (context) => CategorySearchResultPage(_type, "악세서리")),
                                );
                              }
                          ),
                        ),
                        Text("악세서리")
                      ]
                  ),
                ),
                // 필기구
                Container(
                  child: Column(
                      children: <Widget>[
                        SizedBox(
                          width: 70,
                          height: 70,
                          child: IconButton(
                              icon: Image.asset("assets/writing.png", width: 65, height: 65, scale: 1),
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(builder: (context) => CategorySearchResultPage(_type, "필기구")),
                                );
                              }
                          ),
                        ),
                        Text("필기구")
                      ]
                  ),
                ),
                // 기타
                Container(
                  child: Column(
                      children: <Widget>[
                        SizedBox(
                          width: 70,
                          height: 70,
                          child: IconButton(
                              icon: Image.asset("assets/another.png", width: 65, height: 65, scale: 1),
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(builder: (context) => CategorySearchResultPage(_type, "기타")),
                                );
                              }
                          ),
                        ),
                        Text("기타")
                      ]
                  ),
                ),
              ],
            )
          )
        ],
      )
    );
  }
}
