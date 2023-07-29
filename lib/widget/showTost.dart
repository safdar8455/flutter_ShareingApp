import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class StyledToast extends StatelessWidget {
  final String message;
  final Color backgroundColor;

  StyledToast({required this.message, required this.backgroundColor});

  @override
  Widget build(BuildContext context) {
    return Container(
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
  }
}

void showStyledToast(
    String message, Color backgroundColor, BuildContext context) {
  FToast fToast = FToast();
  fToast.init(context);

  Widget toast =
      StyledToast(message: message, backgroundColor: backgroundColor);

  fToast.showToast(
    child: toast,
    gravity: ToastGravity.BOTTOM,
    toastDuration: Duration(seconds: 2),
  );
}
