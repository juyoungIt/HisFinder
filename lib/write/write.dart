import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:untitled/start/Signin.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';

enum SegmentType { news, map, paper }
class WritePage extends StatelessWidget {
  // this is key
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _contentController = TextEditingController();
  final TextEditingController _dateController = TextEditingController();
  final TextEditingController _detailController = TextEditingController();

  int _currentSelection = 0;
  Map<int, Widget> _children = {
    0: Text('주웠어요'),
    1: Text('찾아요'),
  };
  int _segmented = 0;
  int _sliding = 0;

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return Scaffold(
        body: Column(
            children: <Widget>[
            AppBar(
              elevation: 0.0,
              title: Text("Writing"),
              centerTitle: true,
              backgroundColor: Color(0xff6990FF),
              leading: IconButton(icon: Image.asset("assets/prev.png", scale: 4), onPressed: null),
              actions: <Widget>[
                TextButton(
                  onPressed: () {
                    print("selection type = ");
                    print("title = " + _titleController.text.toString());
                    print("content = " + _contentController.text.toString());
                    print("things kinds = ");
                    print("place = ");
                    print("date = " + _dateController.text.toString());
                    print("detail = " + _detailController.text.toString());
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => SigninPage()),
                    );
                  },
                  child: Text(
                    '완료',
                    style: TextStyle(
                      fontFamily: 'avenir',
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
            Expanded(
              child: Container(
                height: 1000,
                child: ListView(
                  children: [
                    Stack (
                      alignment: Alignment.center,
                      children: <Widget>[
                        Container(color: Colors.white),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Stack(
                              children: <Widget>[
                                Padding(
                                  padding: EdgeInsets.only(left: 12, right: 12, top: 12, bottom: 50),
                                  child: Padding(
                                    padding: EdgeInsets.all(size.width*0.05),
                                    child: Form(child: Column(
                                      key: _formKey,
                                      crossAxisAlignment: CrossAxisAlignment.end,
                                      children: <Widget>[
                                        // selection part here...
                                        // Container(
                                        //   alignment: Alignment.center,
                                        //   child: Container(
                                        //     width: 130,
                                        //     padding: EdgeInsets.all(0),
                                        //     alignment: Alignment.center,
                                        //     decoration: BoxDecoration(
                                        //       border: Border.all(
                                        //         width: 2,
                                        //         color: Color(0xff6990FF)),
                                        //       borderRadius: BorderRadius.all(
                                        //           Radius.circular(8.0) // POINT
                                        //       ),
                                        //       ),
                                        //     child: CustomSlidingSegmentedControl<SegmentType>(
                                        //       children: {
                                        //         SegmentType.news: Text(
                                        //           '주웠어요',
                                        //           style: TextStyle(color: Colors.white),
                                        //         ),
                                        //         SegmentType.map: Text(
                                        //           '찾아요',
                                        //           style: TextStyle(color: Colors.black),
                                        //         ),
                                        //       },
                                        //       elevation: 0,
                                        //       innerPadding: 0,
                                        //       padding: 10,
                                        //       backgroundColor: Colors.white,
                                        //       thumbColor: Color(0xff6990FF),
                                        //       textColor: Colors.black,
                                        //       duration: Duration(milliseconds: 300),
                                        //       curve: Curves.easeInToLinear,
                                        //       onValueChanged: (v) {
                                        //         print(v);
                                        //       },
                                        //     ),
                                        //   ),
                                        // ),
                                        Container(
                                          padding: new EdgeInsets.symmetric(vertical: 30.0, horizontal: 10.0),
                                          alignment: Alignment.center,
                                          child: CupertinoSlidingSegmentedControl(
                                              children: {
                                                0: Text('주웠어요'),
                                                1: Text('찾아요'),
                                              },
                                              groupValue: _sliding,
                                              onValueChanged: (newValue) {
                                                // my logic here...
                                              }),
                                        ),
                                        Divider(thickness: 1),
                                        // photo part here...
                                        Positioned(
                                          left: size.width*0.09,
                                          right: size.width*0.09,
                                          bottom: 0,
                                          child: SizedBox(
                                            height: 50,
                                            child: RaisedButton(
                                                color: Colors.grey,
                                                child: Text('Selet Photo', style: TextStyle(color: Colors.white)),
                                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
                                                onPressed: () {
                                                  // if(_formKey.currentState.validator()) {
                                                  //   print('Button Pressed!');
                                                  // }
                                                }
                                            ),
                                          ),
                                        ),
                                        Divider(thickness: 1),
                                        // 제목
                                        TextFormField(
                                            controller: _titleController,
                                            decoration: InputDecoration (
                                              contentPadding: new EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
                                              hintText: "제목",
                                              border: InputBorder.none,
                                              focusedBorder: InputBorder.none,
                                              enabledBorder: InputBorder.none,
                                              errorBorder: InputBorder.none,
                                              disabledBorder: InputBorder.none,
                                            ),
                                            validator: (String? value) {
                                              if (value == null || value.isEmpty) {
                                                return '아이디를 입력해주세요!';
                                              } else {
                                                var inputID = value;
                                                return null;
                                              }
                                            }
                                        ),
                                        // divider
                                        Divider(thickness: 1),
                                        // 물건에 대한 설명
                                        Container(
                                          height: 200,
                                          child: TextField (
                                            controller: _contentController,
                                            keyboardType: TextInputType.multiline,
                                            maxLines: null,
                                            decoration: InputDecoration(
                                              contentPadding: new EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
                                              hintText: "물건에 대한 설명을 적어주세요",
                                              border: InputBorder.none,
                                              focusedBorder: InputBorder.none,
                                              enabledBorder: InputBorder.none,
                                              errorBorder: InputBorder.none,
                                              disabledBorder: InputBorder.none,
                                            ),
                                          ),
                                        ),
                                        // 물건 종류
                                        Divider(thickness: 1),
                                        DropdownButtonFormField<String>(
                                          hint: Text("물건종류"),
                                          decoration: InputDecoration (
                                            border: InputBorder.none,
                                            focusedBorder: InputBorder.none,
                                            enabledBorder: InputBorder.none,
                                            errorBorder: InputBorder.none,
                                            disabledBorder: InputBorder.none,
                                          ),
                                          items: ["A", "B", "C"]
                                              .map((label) => DropdownMenuItem(
                                            child: Text(label),
                                            value: label,
                                          ))
                                              .toList(),
                                          onChanged: (_) {
                                            // my logic here...
                                          },
                                        ),
                                        Divider(thickness: 1),
                                        // 장소
                                        DropdownButtonFormField<String>(
                                          hint: Text(" 장소"),
                                          decoration: InputDecoration (
                                            border: InputBorder.none,
                                            focusedBorder: InputBorder.none,
                                            enabledBorder: InputBorder.none,
                                            errorBorder: InputBorder.none,
                                            disabledBorder: InputBorder.none,
                                          ),
                                          items: ["A", "B", "C"]
                                              .map((label) => DropdownMenuItem(
                                            child: Text(label),
                                            value: label,
                                          ))
                                              .toList(),
                                          onChanged: (_) {
                                            // my logic here...
                                          },
                                        ),
                                        Divider(thickness: 1),
                                        // BirthDatePicker(
                                        //   onDateTimeChanged: (dateTime) {
                                        //
                                        //   }, initDateStr: '1970-01-01',
                                        // ),
                                        // DatePicker
                                        TextFormField(
                                          controller: _dateController,
                                          decoration: InputDecoration (
                                            contentPadding: new EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
                                            hintText: "습득/분실날짜",
                                            border: InputBorder.none,
                                            focusedBorder: InputBorder.none,
                                            enabledBorder: InputBorder.none,
                                            errorBorder: InputBorder.none,
                                            disabledBorder: InputBorder.none,
                                          ),
                                          onTap: () {
                                            DatePicker.showDatePicker(context,
                                                showTitleActions: true,
                                                minTime: DateTime(1970, 1, 1),
                                                maxTime: DateTime.now(),
                                                onChanged: (date) {
                                                  print('change $date');
                                                }, onConfirm: (date) {
                                                  print('confirm $date');
                                                }, currentTime: DateTime.now(), locale: LocaleType.ko);
                                          },
                                        ),
                                        Divider(thickness: 1),
                                        // 상세정보
                                        TextFormField(
                                          controller: _detailController,
                                          decoration: InputDecoration(
                                            contentPadding: new EdgeInsets.symmetric(vertical: 1.0, horizontal: 10.0),
                                            hintText: "상세정보를 적어주세요",
                                            border: InputBorder.none,
                                            focusedBorder: InputBorder.none,
                                            enabledBorder: InputBorder.none,
                                            errorBorder: InputBorder.none,
                                            disabledBorder: InputBorder.none,
                                          ),
                                          validator: (String? value){ },
                                        ),
                                        Divider(thickness: 1),
                                      ],
                                    ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ]
        )
    );
  }
}

// Date picker widget
class BirthDatePicker extends StatelessWidget {
  final void Function(DateTime) onDateTimeChanged;
  final String initDateStr;

  BirthDatePicker({
    required this.onDateTimeChanged,
    required this.initDateStr,
  });

  @override
  Widget build(BuildContext context) {
    final initDate =
    DateFormat('yyyy-MM-dd').parse(initDateStr ?? '2000-01-01');
    return SizedBox(
      height: 300,
      child: CupertinoDatePicker(
        minimumYear: 1900,
        maximumYear: DateTime.now().year,
        initialDateTime: initDate,
        maximumDate: DateTime.now(),
        onDateTimeChanged: onDateTimeChanged,
        mode: CupertinoDatePickerMode.date,
      ),
    );
  }
}