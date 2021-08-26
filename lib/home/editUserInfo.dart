import 'package:flutter/material.dart';

class EditUserInfoPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MyStatefulWidget();
  }
}
class MyStatefulWidget extends StatefulWidget {
  @override
  State<MyStatefulWidget> createState() => MyStatefulWidgetState();
}

class MyStatefulWidgetState extends State<MyStatefulWidget> {
  final TextEditingController _controller = TextEditingController();
  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    // final Size size = MediaQuery.of(context).size;
    return Scaffold(
        appBar: AppBar(
          elevation: 0,
          backgroundColor: const Color(0xff6990FF),
          centerTitle: true,
          title: Text("프로필 수정", style: TextStyle(
            fontWeight: FontWeight.w500,
            color: Colors.white,
          ),
          ),
        ),
        body: Center(
            child: Column(
              children: <Widget>[
                Padding(padding: EdgeInsets.only(top: 30)),
                Image.asset("assets/Crang.png", scale: 0.5),
                Padding(padding: EdgeInsets.only(top: 30)),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Column(
                      children: [
                        Text("학번", textScaleFactor: 2, style: TextStyle(fontWeight: FontWeight.bold)),
                        Padding(padding: EdgeInsets.only(bottom:30)),
                        Text("닉네임", textScaleFactor: 2, style: TextStyle(fontWeight: FontWeight.bold))
                      ],
                    ),
                    Padding(padding: EdgeInsets.only(right: 90),),
                    Column(
                      children: [
                        Text("20000000", textScaleFactor: 2, style: TextStyle(fontWeight: FontWeight.bold)),
                        Padding(padding: EdgeInsets.only(bottom:30)),
                        // Text("크랑이", textScaleFactor: 2, style: TextStyle(fontWeight: FontWeight.bold)),
                        // TextFormField(
                        //   decoration: new InputDecoration(
                        //     contentPadding: const EdgeInsets.symmetric(vertical: 1.0),
                        //     enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: const Color(0xff6990FF))),
                        //     focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: const Color(0xff6990FF))),
                        //     hintText: 'student ID'
                        //   )
                        // )
                      ],
                    )
                  ],
                ),
              ],
            )
        )

    );
  }
}















