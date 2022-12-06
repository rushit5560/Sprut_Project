import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
class SprutCircularProgressBar extends StatelessWidget {
  

  @override
  Widget build(BuildContext context) {
    return  Platform.isAndroid?CircularProgressIndicator():CupertinoActivityIndicator();
  }
}