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
                // ?????????
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
                                MaterialPageRoute(builder: (context) => CategorySearchResultPage(_type, "?????????")),
                              );
                            }
                        ),
                      ),
                      Text("?????????")
                    ]
                  ),
                ),
                // ????????????
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
                                  MaterialPageRoute(builder: (context) => CategorySearchResultPage(_type, "????????????(??????/????????????)")),
                                );
                              }
                          ),
                        ),
                        Text("????????????")
                      ]
                  ),
                ),
                // ?????????, ??????
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
                                  MaterialPageRoute(builder: (context) => CategorySearchResultPage(_type, "?????????, ??????")),
                                );
                              }
                          ),
                        ),
                        Text("?????????, ??????")
                      ]
                  ),
                ),
                // ????????????
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
                                  MaterialPageRoute(builder: (context) => CategorySearchResultPage(_type, "????????????")),
                                );
                              }
                          ),
                        ),
                        Text("????????????")
                      ]
                  ),
                ),
                // ??????, ???
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
                                  MaterialPageRoute(builder: (context) => CategorySearchResultPage(_type, "???, ??????")),
                                );
                              }
                          ),
                        ),
                        Text("??????, ???")
                      ]
                  ),
                ),
                // ?????????
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
                                  MaterialPageRoute(builder: (context) => CategorySearchResultPage(_type, "?????????")),
                                );
                              }
                          ),
                        ),
                        Text("?????????")
                      ]
                  ),
                ),
                // ????????????
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
                                  MaterialPageRoute(builder: (context) => CategorySearchResultPage(_type, "????????????")),
                                );
                              }
                          ),
                        ),
                        Text("????????????")
                      ]
                  ),
                ),
                // ?????????
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
                                  MaterialPageRoute(builder: (context) => CategorySearchResultPage(_type, "?????????")),
                                );
                              }
                          ),
                        ),
                        Text("?????????")
                      ]
                  ),
                ),
                // ??????
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
                                  MaterialPageRoute(builder: (context) => CategorySearchResultPage(_type, "??????")),
                                );
                              }
                          ),
                        ),
                        Text("??????")
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
