import 'package:flutter/material.dart';
import 'package:untitled/home/home.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:firebase_picture_uploader/firebase_picture_uploader.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class DataContainer {
  int _segmented = 0;
  late String _item;
  late String _place;

  // setter & getter
  void setSegmented(int segmented) {
    this._segmented = segmented;
  }
  void setItem(String item) {
    this._item = item;
  }
  void setPlace(String place) {
    this._place = place;
  }
  int getSegmented() {
    return this._segmented;
  }
  String getItem() {
    return this._item;
  }
  String getPlace() {
    return this._place;
  }
}

class WritePage extends StatelessWidget {
  // firebase 에 대한 instance
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  // Form 으로부터 전달되는 정보들을 관리하기 위한 Controller 들의 선언
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>(); // form 에 대한 접근을 위해 사용되는 key
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _contentController = TextEditingController();
  final TextEditingController _dateController = TextEditingController();
  final TextEditingController _detailController = TextEditingController();
  final DataContainer dataContainer = DataContainer(); // segment, item, place 를 담는 container class
  final List<UploadJob> _profilePictures = [];

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return Scaffold(
        appBar: AppBar(
          elevation: 0.0,
          title: Text("Writing"),
          centerTitle: true,
          backgroundColor: Color(0xff6990FF),
          leading: IconButton(icon: Image.asset("assets/prev.png", scale: 4), onPressed: (){Navigator.pop(context);}),
          // 이 부분에 입력된 글을 바탕으로 DB에 값을 저장하는 동작 추가되어야 함
          actions: <Widget>[
            TextButton(
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  int length = (_profilePictures.length == 5) ? _profilePictures.length : _profilePictures.length-1;

                  // 습득물이 선택된 경우
                  if(dataContainer.getSegmented() != 1) {
                    firestore.collection("Founds").add({
                      for(int i=0 ; i<length ; i++)
                        'picture' + i.toString() : _profilePictures[i].storageReference.fullPath,
                      'title': _titleController.text,
                      'content': _contentController.text,
                      'item': dataContainer.getItem(),
                      'place': dataContainer.getPlace(),
                      'date': _dateController.text,
                      'detail': _detailController.text,
                      'createAt': Timestamp.now(),
                      'status': false
                    });
                    ScaffoldMessenger.of(context)
                        .showSnackBar(SnackBar(content: Text('작성하신 글이 등록되었습니다.')));
                  }
                  // 분실물이 선택된 경우
                  else {
                    firestore.collection("Losts").add({
                      for(int i=0 ; i<length ; i++)
                        'picture' + i.toString() : _profilePictures[i].storageReference.fullPath,
                      'title': _titleController.text,
                      'content': _contentController.text,
                      'item': dataContainer.getItem(),
                      'place': dataContainer.getPlace(),
                      'date': _dateController.text,
                      'detail': _detailController.text,
                      'createAt': Timestamp.now(),
                      'status': false
                    });
                    ScaffoldMessenger.of(context)
                        .showSnackBar(SnackBar(content: Text('작성하신 글이 등록되었습니다.')));
                  }
                  // 글이 성공적으로 작성되었으므로 홈화면으로 다시 이동
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => MyHomePage()),
                  );
                }
                else {
                  // 글을 작성하기 위한 form에 입력된 data 형식이 유효하지 않은 경우
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
                          InputForm.init(this._formKey, this._titleController,
                              this._contentController, this._dateController, this._detailController,
                              this.dataContainer, this._profilePictures),
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
  // data field (constructor의 사용을 통해서 초기화 됨)
  late final GlobalKey<FormState> _formKey; // form에 대한 접근을 위해 사용되는 key
  late final TextEditingController _titleController;
  late final TextEditingController _contentController;
  late final TextEditingController _dateController;
  late final TextEditingController _detailController;
  late final DataContainer dataContainer;
  late List<UploadJob> _profilePictures;

  // constructor
  InputForm.init(
    GlobalKey<FormState> formKey, TextEditingController titleController,
      TextEditingController contentController,
      TextEditingController dateController,
      TextEditingController detailController,
      DataContainer dataContainer,
      List<UploadJob> profilePictures) {
    this._formKey = formKey;
    this._titleController = titleController;
    this._contentController = contentController;
    this._dateController = dateController;
    this._detailController = detailController;
    this.dataContainer = dataContainer;
    this._profilePictures = profilePictures;
  }

  @override
  State<StatefulWidget> createState() {
    return InputFormTemplate.init(this._formKey, this._titleController,
        this._contentController, this._dateController, this._detailController,
        this.dataContainer, this._profilePictures);
  }
}

// 글에 대한 정보를 입력받느 Form Template 의 정보들을 호출함
class InputFormTemplate extends State<InputForm> {
  // data field (constructor 를 통해서 초기화 됨)
  late final GlobalKey<FormState> _formKey;
  late final TextEditingController _titleController;
  late final TextEditingController _contentController;
  late final TextEditingController _dateController;
  late final TextEditingController _detailController;
  late final DataContainer dataContainer;
  late List<UploadJob> _profilePictures;
  int curUploadedImages = 0; // 현재 업로드가 이뤄진 이미지의 수

  // constructor (주어진 data field 를 초기화 하는 역할을 수행)
  InputFormTemplate.init(
      GlobalKey<FormState> formKey,
      TextEditingController titleController,
      TextEditingController contentController,
      TextEditingController dateController,
      TextEditingController detailController,
      DataContainer dataContainer,
      List<UploadJob> profilePictures) {
    this._formKey = formKey;
    this._titleController = titleController;
    this._contentController = contentController;
    this._dateController = dateController;
    this._detailController = detailController;
    this.dataContainer = dataContainer;
    this._profilePictures = profilePictures;
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
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
                    groupValue: dataContainer.getSegmented(),
                    onValueChanged: (newValue) {
                      setState(() {
                        dataContainer.setSegmented(newValue as int);
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
          Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[SizedBox(
                width: size.width * 0.85,
                child: DropdownButtonFormField<String>(
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
                    onChanged: (label) {
                      dataContainer.setItem(label!);
                    },
                    validator: (label) {
                      if(label == null)
                        return "분실/습득한 물건을 입력해주세요.";
                    }
                ),
              ),
              ]),
          Divider(thickness: 1),
          // 분실/습득 장소를 선택하는 부분
          Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[SizedBox(
                width: size.width * 0.85,
                child: DropdownButtonFormField<String>(
                    hint: Text("장소"),
                    decoration: InputDecoration (
                      border: InputBorder.none,
                      focusedBorder: InputBorder.none,
                      enabledBorder: InputBorder.none,
                      errorBorder: InputBorder.none,
                      disabledBorder: InputBorder.none,
                    ),
                    items: ["현동홀", "뉴턴홀", "올네이션스홀", "느헤미야홀", "그레이스스쿨",
                      "언어교육원", "효암채플", "코너스톤홀", "오석관", "기숙사", "학관", "기타"]
                        .map((label) => DropdownMenuItem(
                      child: Text(label),
                      value: label,
                    ))
                        .toList(),
                    onChanged: (label) {
                      dataContainer.setPlace(label!);
                    },
                    validator: (label) {
                      if(label == null)
                        return "습득/분실 장소를 입력해주세요.";
                    }
                ),
              ),
              ]),
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