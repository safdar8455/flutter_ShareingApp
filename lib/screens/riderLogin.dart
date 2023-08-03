import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:ride_sharing/main.dart';
import 'package:ride_sharing/screens/homePage.dart';
import 'package:ride_sharing/screens/rideSignup.dart';
import 'package:ride_sharing/widget/progressBar.dart';
import 'package:ride_sharing/widget/showTost.dart';
import 'package:flutter/services.dart';

class login_Screen extends StatefulWidget {
  @override
  State<login_Screen> createState() => login_ScreenState();
}

class login_ScreenState extends State<login_Screen> {
  TextEditingController userEmailCtrl = TextEditingController();
  TextEditingController userPassCtrl = TextEditingController();
  bool _isPasswordVisible = false;

  void navigateToHomeScreen() {
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) => home_Screen()));
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        // appBar: AppBar(
        //   centerTitle: true,
        //   title: Text(
        //     'Login Screen',
        //     style: TextStyle(
        //         color: Colors.white, fontSize: 25, fontWeight: FontWeight.w400),
        //   ),
        //   backgroundColor: Colors.blue.shade900,
        // ),
        body: Container(
      height: double.infinity,
      width: double.infinity,
      child: Center(
        child: Container(
          width: 350,
          child: SingleChildScrollView(
              child: Column(
            children: [
              SizedBox(height: 80),
              Image.asset(
                'assets/images/logo.png',
                height: 60.0,
              ),
              SizedBox(
                height: 50.0,
              ),
              Padding(
                  padding: EdgeInsets.only(left: 20.0, right: 20.0),
                  child: TextField(
                    controller: userEmailCtrl,
                    decoration: InputDecoration(
                        hintText: 'Enter Your Email',
                        hintStyle: TextStyle(
                          color: Colors.blue.shade300,
                          fontSize: 20.0,
                        ),
                        suffixIcon:
                            Icon(Icons.email, color: Colors.blue.shade900),
                        enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(
                              color: const Color.fromARGB(255, 0, 14, 36)),
                        )),
                  )),
              SizedBox(
                height: 40.0,
              ),
              Padding(
                  padding: EdgeInsets.only(left: 20.0, right: 20.0),
                  child: TextField(
                    controller: userPassCtrl,
                    obscureText: _isPasswordVisible,
                    decoration: InputDecoration(
                        hintText: 'Password',
                        hintStyle: TextStyle(
                          color: Colors.blue.shade300,
                          fontSize: 20.0,
                        ),
                        suffixIcon: IconButton(
                          icon: Icon(
                            _isPasswordVisible
                                ? Icons.visibility_off
                                : Icons.visibility,
                            color: Colors.blue.shade900,
                          ),
                          onPressed: () {
                            setState(() {
                              _isPasswordVisible = !_isPasswordVisible;
                            });
                          },
                        ),
                        enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(
                              color: const Color.fromARGB(255, 0, 14, 36)),
                        )),
                  )),
              SizedBox(height: 20.0),
              ElevatedButton(
                  onPressed: () {
                    signInUser(context);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue.shade900,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(21.0),
                    ),
                  ),
                  child: Padding(
                    padding: EdgeInsets.only(
                        top: 4.0, bottom: 4.0, left: 8.0, right: 8.0),
                    child: Text('Login',
                        style: TextStyle(
                            fontSize: 30.0,
                            color: Colors.white,
                            letterSpacing: 3.0,
                            fontWeight: FontWeight.bold)),
                  )),
              SizedBox(height: 20.0),
              InkWell(
                  onTap: () {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return ProgressBar(
                          icon: Icon(Icons.access_time_filled),
                          onCompleted: () {
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => signUp_Screen()),
                            );
                          },
                        );
                      },
                    );
                  },
                  child: Text(
                    'Create new account',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.blue.shade900,
                    ),
                  )),
            ],
          )),
        ),
      ),
    ));
  }

  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  void signInUser(BuildContext context) async {
    try {
      final UserCredential userCredential =
          await _firebaseAuth.signInWithEmailAndPassword(
        email: userEmailCtrl.text,
        password: userPassCtrl.text,
      );

      final User? user = userCredential.user;
      if (user != null) {
        final uid = user.uid;
        final DatabaseEvent event = await databaseReference.child(uid).once();
        var userData = event.snapshot.value;
        if (userData != null) {
          await showDialog(
            context: context,
            builder: (BuildContext context) {
              return ProgressBar(
                  icon: Icon(Icons.access_time_filled),
                  onCompleted: navigateToHomeScreen);
            },
          );
        } else {
          showStyledToast('Details not found....', Colors.red, context);
        }
      } else {
        showStyledToast(
            'Failed to sign in. Please try again.', Colors.red, context);
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        showStyledToast(
            'User not found. Please register yourself.', Colors.red, context);
      } else if (e.code == 'wrong-password') {
        showStyledToast(
            'Incorrect password. Please try again.', Colors.red, context);
      } else {
        showStyledToast(
            'An error occurred. Please try again later.', Colors.red, context);
      }
    } catch (e) {
      print('Error: $e');
      showStyledToast('An unexpected error occurred. Please try again later.',
          Colors.red, context);
    }
  }
}
