import 'package:flutter/material.dart';

class CategoryPage extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
            color: Colors.transparent
          ),
          Container(
            color: Colors.white,
            height: 400,
          )
        ],
      )
    );
  }
}
