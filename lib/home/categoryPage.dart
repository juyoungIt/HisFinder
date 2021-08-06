import 'package:flutter/material.dart';

class CategoryPage extends StatelessWidget {

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
                icon: Image.asset("assets/category.png", width: 65, height: 65, scale: 2.5),
                onPressed: () {
                  Navigator.pop(context);
                }),
          ),
          actions: [
            Padding(
              padding: const EdgeInsets.fromLTRB(0, 0, 10, 0),
              child: IconButton(
                  icon: Image.asset("assets/notice.png", width: 73, height: 76, scale: 3),
                  onPressed: () {
                    // Bell Button Action
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
              crossAxisCount: 3,
              children: <Widget>[
                // 학생증
                Container(
                  child: Column(
                    children: <Widget>[
                      IconButton(
                          icon: Image.asset("assets/user.png", width: 65, height: 65, scale: 1),
                          onPressed: () {
                            // 데이터 선별적으로 긁어오는 로직은 여기에
                          }
                      ),
                      Text("학생증")
                    ]
                  ),
                ),
                // 일반카드
                Container(
                  child: Column(
                      children: <Widget>[
                        IconButton(
                            icon: const Icon(Icons.volume_up),
                            onPressed: () {
                              // 데이터 선별적으로 긁어오는 로직은 여기에
                            }
                        ),
                        Text("일반카드")
                      ]
                  ),
                ),
                // 에어팟, 버즈
                Container(
                  child: Column(
                      children: <Widget>[
                        IconButton(
                            icon: const Icon(Icons.volume_up),
                            onPressed: () {
                              // 데이터 선별적으로 긁어오는 로직은 여기에
                            }
                        ),
                        Text("에어팟, 버즈")
                      ]
                  ),
                ),
                // 전자기기
                Container(
                  child: Column(
                      children: <Widget>[
                        IconButton(
                            icon: const Icon(Icons.volume_up),
                            onPressed: () {
                              // 데이터 선별적으로 긁어오는 로직은 여기에
                            }
                        ),
                        Text("전자기기")
                      ]
                  ),
                ),
                // 지갑, 돈
                Container(
                  child: Column(
                      children: <Widget>[
                        IconButton(
                            icon: const Icon(Icons.volume_up),
                            onPressed: () {
                              // 데이터 선별적으로 긁어오는 로직은 여기에
                            }
                        ),
                        Text("지갑, 돈")
                      ]
                  ),
                ),
                // 화장품
                Container(
                  child: Column(
                      children: <Widget>[
                        IconButton(
                            icon: const Icon(Icons.volume_up),
                            onPressed: () {
                              // 데이터 선별적으로 긁어오는 로직은 여기에
                            }
                        ),
                        Text("화장품")
                      ]
                  ),
                ),
                // 악세서리
                Container(
                  child: Column(
                      children: <Widget>[
                        IconButton(
                            icon: const Icon(Icons.volume_up),
                            onPressed: () {
                              // 데이터 선별적으로 긁어오는 로직은 여기에
                            }
                        ),
                        Text("악세서리")
                      ]
                  ),
                ),
                // 필기구
                Container(
                  child: Column(
                      children: <Widget>[
                        IconButton(
                            icon: const Icon(Icons.volume_up),
                            onPressed: () {
                              // 데이터 선별적으로 긁어오는 로직은 여기에
                            }
                        ),
                        Text("필기구")
                      ]
                  ),
                ),
                // 기타
                Container(
                  child: Column(
                      children: <Widget>[
                        IconButton(
                            icon: const Icon(Icons.volume_up),
                            onPressed: () {
                              // 데이터 선별적으로 긁어오는 로직은 여기에
                            }
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
