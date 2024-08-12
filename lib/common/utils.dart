// ignore_for_file: unused_import

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class ToastM {
  void toastMessage(String message) {
    Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
    );
  }
}
