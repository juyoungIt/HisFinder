import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:untitled/home/home.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:firebase_picture_uploader/firebase_picture_uploader.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

// for data transfer between class
class DataContainer {
  int _segmented = 0;  // segment bar selection value
  late String _item;   // lost / find item
  late String _place;  // lost / find place

  // setter
  void setSegmented(int segmented) {
    this._segmented = segmented;
  }
  void setItem(String item) {
    this._item = item;
  }
  void setPlace(String place) {
    this._place = place;
  }
  // getter
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

class UpdateWritePage extends StatelessWidget {
  final FirebaseFirestore firestore = FirebaseFirestore.instance; // the instance of firebase
  // the controller of text form fields
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _contentController = TextEditingController();
  final TextEditingController _dateController = TextEditingController();
  final TextEditingController _detailController = TextEditingController();
  final DataContainer dataContainer = DataContainer(); // include segmented, item, place value
  final List<UploadJob> _profilePictures = []; // store the uploaded pictures
  final User? user = FirebaseAuth.instance.currentUser; // load the current user information
  late final DocumentSnapshot snap;

  // constructor
  UpdateWritePage(DocumentSnapshot snap, String type) {
    this.snap = snap;
    dataContainer.setSegmented((type == "Founds") ? 0 : 1);
    for(int i=0 ; i<snap.get('pictureCount') ; i++) {
      UploadJob upload = new UploadJob();
      // upload.action = actionUpload;
      // upload.storageReference!.fullPath =
      // ????????? path??? ???????????? ?????? ??? ?????? ????????? ????????? ????????? ??????
      _profilePictures.add(upload);
    }
    // Map<String,dynamic> jsonData = jsonDecode(snap.get('uploadedImages').toString());
    // _profilePictures = (json.decode(snap.get('uploadedImages').toString()) as List).map((i) => UploadJob.fromJson(i)).toList();
    _titleController.text = snap.get('title').toString();
    _contentController.text = snap.get('content').toString();
    dataContainer.setItem(snap.get('item').toString());
    dataContainer.setPlace(snap.get('place').toString());
    _dateController.text = snap.get('date').toString();
    _detailController.text = snap.get('detail').toString();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          elevation: 0.0,
          title: Text(
              "Writing",
              style: TextStyle(
                fontFamily: 'avenir',
                fontStyle: FontStyle.italic,
                fontWeight: FontWeight.w400,
              ),
              textScaleFactor: 1.4
          ),
          centerTitle: true,
          backgroundColor: Color(0xff6990FF),
          // leading: IconButton(icon: Image.asset("assets/prev.png", scale: 4), onPressed: (){Navigator.pop(context);}),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  // calulate current uploaded images
                  int length = (_profilePictures.length == 5) ? _profilePictures.length : _profilePictures.length-1;
                  if(dataContainer.getSegmented() != 1) {
                    firestore.collection("Founds").doc(snap.id).update({
                      'pictureCount': length,
                      for(int i=0 ; i<length ; i++)
                        'picture' + i.toString() : _profilePictures[i].storageReference!.fullPath,
                      'title': _titleController.text,
                      'content': _contentController.text,
                      'item': dataContainer.getItem(),
                      'place': dataContainer.getPlace(),
                      'date': _dateController.text,
                      'detail': _detailController.text
                    });
                    ScaffoldMessenger.of(context)
                        .showSnackBar(SnackBar(content: Text('???????????? ???????????? ?????????????????????.')));
                  }
                  // lost
                  else {
                    firestore.collection("Losts").doc(snap.id).update({
                      'pictureCount': length,
                      for(int i=0 ; i<length ; i++)
                        'picture' + i.toString() : _profilePictures[i].storageReference!.fullPath,
                      'title': _titleController.text,
                      'content': _contentController.text,
                      'item': dataContainer.getItem(),
                      'place': dataContainer.getPlace(),
                      'date': _dateController.text,
                      'detail': _detailController.text
                    });
                    ScaffoldMessenger.of(context)
                        .showSnackBar(SnackBar(content: Text('???????????? ???????????? ?????????????????????.')));
                  }
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => MyHomePage()),
                  );
                }
                else {
                  ScaffoldMessenger.of(context)
                      .showSnackBar(SnackBar(content: Text('?????? ??????????????? ????????? ???????????? ????????????.')));
                }
              },
              child: Text(
                '??????',
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

class InputForm extends StatefulWidget {
  // data field
  late final GlobalKey<FormState> _formKey;
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

// draw the input form field
class InputFormTemplate extends State<InputForm> {
  // data field
  late final GlobalKey<FormState> _formKey;
  late final TextEditingController _titleController;
  late final TextEditingController _contentController;
  late final TextEditingController _dateController;
  late final TextEditingController _detailController;
  late final DataContainer dataContainer;
  late List<UploadJob> _profilePictures;
  int curUploadedImages = 0; // the number of current uploaded images

  // constructor
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
    // the object of image uploader tile (image tiles)
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
                    enableCropping: true, compressQuality: 75)
            ),
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
          // segment selector (lost & found)
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
                      0: Text('?????????'),
                      1: Text('?????????'),
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
          // image uploader
          Column(
              children: <Widget>[profilePictureTile]
          ),

          Divider(thickness: 1),
          // title form field
          TextFormField(
              controller: _titleController,
              decoration: InputDecoration (
                contentPadding: new EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
                hintText: "?????? (??????)",
                border: InputBorder.none,
                focusedBorder: InputBorder.none,
                enabledBorder: InputBorder.none,
                errorBorder: InputBorder.none,
                disabledBorder: InputBorder.none,
              ),
              validator: (value) {
                if(value!.length < 1)
                  return "????????? ??????????????????.";
              }
          ),
          Divider(thickness: 1),

          // the content form field
          Container(
            height: 200,
            child: TextFormField (
                controller: _contentController,
                keyboardType: TextInputType.multiline,
                maxLines: null,
                decoration: InputDecoration(
                  contentPadding: new EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
                  hintText: "????????? ?????? ????????? ??????????????? (??????)",
                  border: InputBorder.none,
                  focusedBorder: InputBorder.none,
                  enabledBorder: InputBorder.none,
                  errorBorder: InputBorder.none,
                  disabledBorder: InputBorder.none,
                ),
                validator: (value){
                  if(value!.length < 1)
                    return "?????? ????????? ??????????????????";
                }
            ),
          ),
          Divider(thickness: 1),

          // the date form field
          TextFormField(
            controller: _dateController,
            showCursor: true,
            readOnly: true,
            decoration: InputDecoration (
              contentPadding: new EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
              hintText: "??????/???????????? (??????)",
              border: InputBorder.none,
              focusedBorder: InputBorder.none,
              enabledBorder: InputBorder.none,
              errorBorder: InputBorder.none,
              disabledBorder: InputBorder.none,
            ),
            validator: (value) {
              if(value!.length < 1)
                return "??????/??????????????? ??????????????????.";
            },
            onTap: () {
              DatePicker.showDatePicker(context,
                  showTitleActions: true,
                  minTime: DateTime(1970, 1, 1),
                  maxTime: DateTime.now(),
                  onChanged: (date) { }, // ???????????? ????????? ?????? ?????? ?????? ??????
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

          // the item form field (dropdown)
          Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[SizedBox(
                width: size.width * 0.85,
                child: DropdownButtonFormField<String>(
                    hint: Text("???????????? (??????)"),
                    value: dataContainer.getItem().toString(),
                    decoration: InputDecoration (
                      border: InputBorder.none,
                      focusedBorder: InputBorder.none,
                      enabledBorder: InputBorder.none,
                      errorBorder: InputBorder.none,
                      disabledBorder: InputBorder.none,
                    ),
                    items: ["?????????", "????????????(??????/????????????)", "?????????, ??????"
                      , "?????????", "???, ??????", "????????????", "????????????", "?????????", "??????"]
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
                        return "??????/????????? ????????? ??????????????????.";
                    }
                ),
              ),
              ]),
          Divider(thickness: 1),

          // the place form field (dropdown)
          Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[SizedBox(
                width: size.width * 0.85,
                child: DropdownButtonFormField<String>(
                    hint: Text("?????? (??????)"),
                    value: dataContainer.getPlace().toString(),
                    decoration: InputDecoration (
                      border: InputBorder.none,
                      focusedBorder: InputBorder.none,
                      enabledBorder: InputBorder.none,
                      errorBorder: InputBorder.none,
                      disabledBorder: InputBorder.none,
                    ),
                    items: ["?????????", "?????????", "??????????????????", "???????????????", "??????????????????",
                      "???????????????", "????????????", "???????????????", "?????????", "?????????", "??????", "??????"]
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
                        return "??????/?????? ????????? ??????????????????";
                    }
                ),
              ),
              ]),
          Divider(thickness: 1),

          // the detail information form
          TextFormField(
            controller: _detailController,
            decoration: InputDecoration(
              contentPadding: new EdgeInsets.symmetric(vertical: 1.0, horizontal: 10.0),
              hintText: "????????? ????????? ??? ????????? ?????????????????? (??????)",
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
    // ???????????? ????????? ?????? ???????????? ?????? ??????
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