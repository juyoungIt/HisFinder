import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:untitled/start/Signin.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:firebase_picture_uploader/firebase_picture_uploader.dart';

class WritePage extends StatelessWidget {
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
                if (InputFormTemplate._formKey.currentState!.validate()) {
                  // 여기서 각각의 데이터를 document의 형태로 저장해야 함.
                  print("the input result");
                  print("selection : " + ((InputFormTemplate.segmented.toString() != "1") ? "습득물" : "분실물"));
                  for(int i=0 ; i<InputFormTemplate._profilePictures.length-1 ; i++)
                    print("Picture " + i.toString() + " - " + InputFormTemplate._profilePictures[i].storageReference.fullPath);
                  print("title : " + InputFormTemplate._titleController.text);
                  print("content : " + InputFormTemplate._contentController.text);
                  print("item : " + InputFormTemplate.item);
                  print("place : " + InputFormTemplate.place);
                  print("date : " + InputFormTemplate._dateController.text);
                  print("detail : " + InputFormTemplate._detailController.text);
                }
                else {
                  ScaffoldMessenger.of(context)
                      .showSnackBar(SnackBar(content: Text('글을 등록하기에 정보가 충분하지 않습니다.')));
                }
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
        body: Padding(
          padding: new EdgeInsets.symmetric(horizontal: 20.0),
          child: Column(
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
          ),
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

  // 각 Form에 입력되는 값을 가져오기 위한 Controller
  static final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  static final TextEditingController _titleController = TextEditingController();
  static final TextEditingController _contentController = TextEditingController();
  static final TextEditingController _dateController = TextEditingController();
  static final TextEditingController _detailController = TextEditingController();
  static int segmented = 0;
  static var item;
  static var place;

  // Set default `_initialized` and `_error` state to false
  bool _initialized = false;
  bool _error = false;
  static List<UploadJob> _profilePictures = [];
  int curUploadedImages = 0;

  // Define an async function to initialize FlutterFire
  void initializeFlutterFire() async {
    try {
      // Wait for Firebase to initialize and set `_initialized` state to true
      await Firebase.initializeApp();
      setState(() {
        _initialized = true;
      });
    } catch(e) {
      // Set `_error` state to true if Firebase initialization fails
      setState(() {
        _error = true;
      });
    }
  }

  @override
  void initState() {
    initializeFlutterFire();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final profilePictureTile = new Material(
      color: Colors.transparent,
      child: new Column(
        children: <Widget>[
          PictureUploadWidget(
            initialImages: _profilePictures,
            onPicturesChange: profilePictureCallback,
            buttonStyle: PictureUploadButtonStyle(
              backgroundColor: Color(0xff6990FF),
              height: 80
            ),
            buttonText: "$curUploadedImages" + ' / 5',
            localization: PictureUploadLocalization(),
            settings: PictureUploadSettings(
                uploadDirectory: '/write_images/',
                imageSource: ImageSourceExtended.askUser,
                onErrorFunction: onErrorCallback,
                minImageCount: 0,
                maxImageCount: 5,
                imageManipulationSettings: const ImageManipulationSettings(
                    enableCropping: true, compressQuality: 75)),
            enabled: true,
          ),
        ],
      ),
    );

    return Form(
      key: _formKey,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          // 글의 종류를 선택하는 부분
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[SizedBox(
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
          ]),

          // 업로드할 사진을 선택하는 부분
          Column(
              children: <Widget>[profilePictureTile]
          ),

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
                errorBorder: InputBorder.none,
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
                errorBorder: InputBorder.none,
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
            hint: Text("  물건종류"),
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
            onChanged: (label) {
              item = label;
            },
              validator: (item) {
                if(item == null)
                  return "분실/습득한 물건을 입력해주세요.";
              }
          ),
          Divider(thickness: 1),
          // 분실/습득 장소를 선택하는 부분
          DropdownButtonFormField<String>(
            hint: Text("  장소"),
            decoration: InputDecoration (
              border: InputBorder.none,
              focusedBorder: InputBorder.none,
              enabledBorder: InputBorder.none,
              errorBorder: InputBorder.none,
              disabledBorder: InputBorder.none,
            ),
            items: ["현동홀", "뉴턴홀", "올네이션스홀", "느헤미야홀", "그레이스스쿨",
              "언어교육원", "효암채플", "비전관", "창조관", "벧엘관", "로뎀관", "하용조관",
              "갈대상자관", "기타"]
                .map((label) => DropdownMenuItem(
              child: Text(label),
              value: label,
            ))
                .toList(),
            onChanged: (label) {
              place = label;
            },
              validator: (place) {
                if(place == null)
                  return "습득/분실 장소를 입력해주세요.";
              }
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
            validator: (value) {
              if(value!.length < 1)
                return "분실/습득날짜를 입력해주세요.";
              },
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
              errorBorder: InputBorder.none,
              disabledBorder: InputBorder.none,
            ),
            validator: (value) {
              if(value!.length < 1)
                return "상세정보를 입력해주세요.";
            },
          ),
          Divider(thickness: 1),
        ],
      ),
    );
  }

  // callback function
  void profilePictureCallback({required List<UploadJob> uploadJobs, required bool pictureUploadProcessing}) {
    _profilePictures = uploadJobs;
    // 업로드된 사진의 수를 표시하기 위한 부분
    setState(() {
      curUploadedImages = _profilePictures.length-1;
    });
  }
  // error callback function
  void onErrorCallback(error, stackTrace) {
    print(error);
    print(stackTrace);
  }
}