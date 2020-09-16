import 'dart:ffi';
import 'dart:math';
import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:webview_test/Utils/HttpRequest.dart';
import 'package:webview_test/components/Builders.dart';
import 'package:webview_test/Screens/MyHomePage.dart';
import 'package:webview_test/Screens/RegisterPage.dart';
import 'package:webview_test/Screens/welcomePage.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // todo: add router to app
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: HttpRequest(),
    );
  }
}
