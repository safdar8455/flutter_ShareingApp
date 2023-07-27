import 'package:flutter/material.dart';
import 'package:ride_sharing/rideSignup.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:ride_sharing/riderLogin.dart';
import 'firebase_options.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:fluttertoast/fluttertoast.dart';

final databaseReference = FirebaseDatabase.instance.ref();

void showStyledToast(
    String message, Color backgroundColor, BuildContext context) {
  FToast fToast = FToast();
  fToast.init(context);

  Widget toast = Container(
    padding: EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(8.0),
      color: backgroundColor,
    ),
    child: Text(
      message,
      style: TextStyle(color: Colors.white, fontSize: 16.0),
    ),
  );

  fToast.showToast(
    child: toast,
    gravity: ToastGravity.BOTTOM,
    toastDuration: Duration(seconds: 2),
  );
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: login_Screen(),
    );
  }
}
