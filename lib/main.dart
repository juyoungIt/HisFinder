import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:untitled/start/signIn.dart';

import 'notificationController.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return MyAppTemplate();
  }
}

class MyAppTemplate extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false, // delete the top banner (debug sign)
      home: SignInPage(), // call the Sign in Page
      initialBinding: BindingsBuilder(
            () {
          Get.put(NotificationController());
        },
      ),
    );
  }
}

