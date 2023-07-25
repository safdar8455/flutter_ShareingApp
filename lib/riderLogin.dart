import 'package:flutter/material.dart';

class login_Screen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text(
            'Login Screen',
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
                        obscureText: true,
                        decoration: InputDecoration(
                            hintText: 'Password',
                            hintStyle: TextStyle(
                              color: Colors.blue.shade300,
                              fontSize: 20.0,
                            ),
                            suffixIcon: Icon(Icons.visibility_off,
                                color: Colors.blue.shade900),
                            enabledBorder: UnderlineInputBorder(
                              borderSide: BorderSide(
                                  color: const Color.fromARGB(255, 0, 14, 36)),
                            )),
                      )),
                  SizedBox(height: 40.0),
                  ElevatedButton(
                      onPressed: () {},
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
                ],
              ),
            ),
          ),
        ));
  }
}
