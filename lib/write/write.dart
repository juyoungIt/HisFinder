import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:untitled/start/Signin.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:firebase_picture_uploader/firebase_picture_uploader.dart';

class WritePage extends StatelessWidget {
  // this is key
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _contentController = TextEditingController();
  final TextEditingController _dateController = TextEditingController();
  final TextEditingController _detailController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return Scaffold(
        appBar: AppBar(
          elevation: 0.0,
          title: Text("Writing"),
          centerTitle: true,
          backgroundColor: Color(0xff6990FF),
          // 이전으로 돌아가는 동작 추가해야 함
          leading: IconButton(icon: Image.asset("assets/prev.png", scale: 4), onPressed: null),
          // 이 부분에 입력된 글을 바탕으로 DB에 값을 저장하는 동작 추가되어야 함
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
        body: Column(
            children: <Widget>[
            // 글을 입력하는 Form이 시작되는 부분
            Container(
              child: Expanded(
                child: SizedBox(
                  height: 1000,
                  child: ListView(
                    children: [
                      InputForm(),
                    ],
                  ),
                ),
              ),
            ),
          ]
        )
    );
  }
}

// 글에 대한 정보를 입력받는 Form Template 의 출력을 호출함
class InputForm extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return InputFormTemplate();
  }
}

// 글에 대한 정보를 입력받느 Form Template 의 정보들을 호출함
class InputFormTemplate extends State<InputForm> {

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _contentController = TextEditingController();
  final TextEditingController _dateController = TextEditingController();
  final TextEditingController _detailController = TextEditingController();
  int segmented = 0;

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          // 글의 종류를 선택하는 부분
          SizedBox(
            width: 200,
            height: 100,
            child: CupertinoSegmentedControl(
                unselectedColor: Colors.white,
                selectedColor: Color(0xff6990FF),
                borderColor: Color(0xff6990FF),
                padding: EdgeInsets.all(0),
                children: {
                  0: Text('습득물'),
                  1: Text('분실물'),
                },
                groupValue: segmented,
                onValueChanged: (newValue) {
                  setState(() {
                    segmented = newValue as int;
                  });
                }
            ),
          ),

          // 업로드할 사진을 선택하는 부분
          // 관련 라이브러리 찾음 이걸 어떻게 적용할 것인지가 또 관건이 된다...

          Divider(thickness: 1),
          // 글의 제목을 입력하는 부분
          TextFormField(
              controller: _titleController,
              decoration: InputDecoration (
                contentPadding: new EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
                hintText: "제목",
                border: InputBorder.none,
                focusedBorder: InputBorder.none,
                enabledBorder: InputBorder.none,
                errorBorder: OutlineInputBorder(borderSide: BorderSide(width: 2, color: const Color(0xffff0000))),
                disabledBorder: InputBorder.none,
              ),
              validator: (value) {
                if(value!.length < 1)
                  return "제목을 입력해주세요.";
              }
          ),
          Divider(thickness: 1),

          // 글에 대한 body를 기록하는 부분 (contents)
          Container(
            height: 200,
            child: TextFormField (
              controller: _contentController,
              keyboardType: TextInputType.multiline,
              maxLines: null,
              decoration: InputDecoration(
                contentPadding: new EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
                hintText: "물건에 대한 설명을 적어주세요",
                border: InputBorder.none,
                focusedBorder: InputBorder.none,
                enabledBorder: InputBorder.none,
                errorBorder: OutlineInputBorder(borderSide: BorderSide(width: 2, color: const Color(0xffff0000))),
                disabledBorder: InputBorder.none,
              ),
                validator: (value){
                  if(value!.length < 1)
                    return "글의 내용을 입력해주세요";
                }
            ),
          ),
          Divider(thickness: 1),

          // 물건의 종류를 선택하는 부분
          DropdownButtonFormField<String>(
            hint: Text("물건종류"),
            decoration: InputDecoration (
              border: InputBorder.none,
              focusedBorder: InputBorder.none,
              enabledBorder: InputBorder.none,
              errorBorder: InputBorder.none,
              disabledBorder: InputBorder.none,
            ),
            items: ["학생증", "일반카드(개인/세탁카드)", "에어팟, 버즈"
              , "화장품", "돈, 지갑", "전자기기", "악세서리", "필기구", "기타"]
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
          // 분실/습득 장소를 선택하는 부분
          DropdownButtonFormField<String>(
            hint: Text("장소"),
            decoration: InputDecoration (
              border: InputBorder.none,
              focusedBorder: InputBorder.none,
              enabledBorder: InputBorder.none,
              errorBorder: InputBorder.none,
              disabledBorder: InputBorder.none,
            ),
            items: ["평봉필드", "학관", "기숙사"]
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
          // 분실/습득한 날짜를 선택하는 부분
          TextFormField(
            controller: _dateController,
            showCursor: true,
            readOnly: true,
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
                  onChanged: (date) { }, // 사용자가 선택한 날짜 값이 바뀐 경우
                  onConfirm: (date) {
                    _dateController.text = date.toString().substring(0, 10);
                    // print('confirm $date');
                  },
                  currentTime: DateTime.now(),
                  locale: LocaleType.ko
              );
            },
          ),
          Divider(thickness: 1),
          // 분실한 물건, 장소 등에 대한 상세정보를 기록하는 부분
          TextFormField(
            controller: _detailController,
            decoration: InputDecoration(
              contentPadding: new EdgeInsets.symmetric(vertical: 1.0, horizontal: 10.0),
              hintText: "상세정보를 적어주세요",
              border: InputBorder.none,
              focusedBorder: InputBorder.none,
              enabledBorder: InputBorder.none,
              errorBorder: OutlineInputBorder(borderSide: BorderSide(width: 2, color: const Color(0xffff0000))),
              disabledBorder: InputBorder.none,
            ),
              validator: (value){ }
          ),
          Divider(thickness: 1),
        ],
      ),
    );
  }
}