import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:ride_sharing/main.dart';

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

class signUp_Screen extends StatefulWidget {
  @override
  State<signUp_Screen> createState() => signUp_ScreenState();
}

class signUp_ScreenState extends State<signUp_Screen> {
  TextEditingController userNameCtrl = TextEditingController();
  TextEditingController userEmailCtrl = TextEditingController();
  TextEditingController userPhoneCtrl = TextEditingController();
  TextEditingController userPasswrdCtrl1 = TextEditingController();
  TextEditingController userPasswrdCtrl2 = TextEditingController();
  bool _isPasswordVisible = false;
  bool _isConfirmPasswordVisible = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text(
            'Signup Screen',
            style: TextStyle(
                color: Colors.white, fontSize: 25, fontWeight: FontWeight.w400),
          ),
          backgroundColor: Colors.blue.shade900,
        ),
        body: Container(
          height: double.infinity,
          width: double.infinity,
          child: Center(
            child: Container(
              width: 350,
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    SizedBox(height: 30),
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
                          controller: userNameCtrl,
                          keyboardType: TextInputType.name,
                          decoration: InputDecoration(
                              hintText: 'Enter Your Name',
                              hintStyle: TextStyle(
                                color: Colors.blue.shade300,
                                fontSize: 20.0,
                              ),
                              suffixIcon: Icon(Icons.account_box_rounded,
                                  color: Colors.blue.shade900),
                              enabledBorder: UnderlineInputBorder(
                                borderSide: BorderSide(
                                    color:
                                        const Color.fromARGB(255, 0, 14, 36)),
                              )),
                        )),
                    SizedBox(
                      height: 40.0,
                    ),
                    Padding(
                        padding: EdgeInsets.only(left: 20.0, right: 20.0),
                        child: TextField(
                          controller: userEmailCtrl,
                          keyboardType: TextInputType.emailAddress,
                          decoration: InputDecoration(
                              hintText: 'Enter Your Email',
                              hintStyle: TextStyle(
                                color: Colors.blue.shade300,
                                fontSize: 20.0,
                              ),
                              suffixIcon: Icon(Icons.email,
                                  color: Colors.blue.shade900),
                              enabledBorder: UnderlineInputBorder(
                                borderSide: BorderSide(
                                    color:
                                        const Color.fromARGB(255, 0, 14, 36)),
                              )),
                        )),
                    SizedBox(
                      height: 40.0,
                    ),
                    Padding(
                        padding: EdgeInsets.only(left: 20.0, right: 20.0),
                        child: TextField(
                          controller: userPhoneCtrl,
                          keyboardType: TextInputType.phone,
                          decoration: InputDecoration(
                              hintText: 'Enter Your Phone Number',
                              hintStyle: TextStyle(
                                color: Colors.blue.shade300,
                                fontSize: 20.0,
                              ),
                              suffixIcon: Icon(Icons.phone,
                                  color: Colors.blue.shade900),
                              enabledBorder: UnderlineInputBorder(
                                borderSide: BorderSide(
                                    color:
                                        const Color.fromARGB(255, 0, 14, 36)),
                              )),
                        )),
                    SizedBox(height: 40.0),
                    Padding(
                        padding: EdgeInsets.only(left: 20.0, right: 20.0),
                        child: TextField(
                          controller: userPasswrdCtrl1,
                          keyboardType: TextInputType.visiblePassword,
                          obscureText: !_isPasswordVisible,
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
                                    color:
                                        const Color.fromARGB(255, 0, 14, 36)),
                              )),
                        )),
                    SizedBox(height: 40.0),
                    Padding(
                        padding: EdgeInsets.only(left: 20.0, right: 20.0),
                        child: TextField(
                          controller: userPasswrdCtrl2,
                          keyboardType: TextInputType.visiblePassword,
                          obscureText: !_isConfirmPasswordVisible,
                          decoration: InputDecoration(
                              hintText: 'Confirm Password',
                              hintStyle: TextStyle(
                                color: Colors.blue.shade300,
                                fontSize: 20.0,
                              ),
                              suffixIcon: IconButton(
                                icon: Icon(
                                  _isConfirmPasswordVisible
                                      ? Icons.visibility_off
                                      : Icons.visibility,
                                  color: Colors.blue.shade900,
                                ),
                                onPressed: () {
                                  setState(() {
                                    _isConfirmPasswordVisible =
                                        !_isConfirmPasswordVisible;
                                  });
                                },
                              ),
                              enabledBorder: UnderlineInputBorder(
                                borderSide: BorderSide(
                                    color:
                                        const Color.fromARGB(255, 0, 14, 36)),
                              )),
                        )),
                    SizedBox(height: 40.0),
                    ElevatedButton(
                      onPressed: () {
                        if (userNameCtrl.text.isEmpty) {
                          showStyledToast('Username should not be empty...',
                              Colors.red, context);
                        } else if (!userEmailCtrl.text.contains('@')) {
                          showStyledToast(
                              'Email is not valid', Colors.red, context);
                        } else if (!(userPhoneCtrl.text.length == 11)) {
                          showStyledToast(
                              'Phone number is not valid', Colors.red, context);
                        } else if (userPasswrdCtrl1.text.length < 6 ||
                            userPasswrdCtrl2.text.length < 6) {
                          showStyledToast(
                              'Password or Confirm Password must be greater than 6 characters...',
                              Colors.red,
                              context);
                        } else if (userPasswrdCtrl1.text !=
                            userPasswrdCtrl2.text) {
                          showStyledToast(
                              'Passwords do not match', Colors.red, context);
                        } else {
                          getRegistration(context);
                          userNameCtrl.clear();
                          userEmailCtrl.clear();
                          userPhoneCtrl.clear();
                          userPasswrdCtrl1.clear();
                          userPasswrdCtrl2.clear();
                          showStyledToast('Successfully Signed Up.....',
                              Colors.green, context);
                        }
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
                        child: Text(
                          'SignUp',
                          style: TextStyle(
                            fontSize: 30.0,
                            color: Colors.white,
                            letterSpacing: 3.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ));
  }

  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  void getRegistration(BuildContext context) async {
    _firebaseAuth.createUserWithEmailAndPassword(
        email: userEmailCtrl.text.toString(),
        password: userPasswrdCtrl1.text.toString());
    Map userData = {
      'name': userNameCtrl.text.trim(),
      'email': userEmailCtrl.text.trim(),
      'phone': userPhoneCtrl.text.trim(),
    };
    databaseReference.child('clintData').set(userData);
  }
}
