import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:webview_test/components/Builders.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_facebook_login/flutter_facebook_login.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:webview_test/Screens/welcomePage.dart';

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.Connection}) : super(key: key);

  final String Connection;
  final String title = 'Ask gunter';

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final auth = FirebaseAuth.instance;
  InAppWebViewController _controller;
  final TextController = TextEditingController();
  final facebook = FacebookLogin();
  final google = GoogleSignIn();

  String url = "www.google.com";
  String FinalUrl = "https://www.google.co.il";
  double progress = 0;
  bool isAlert = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.black12,
          title: Text(widget.title),
          leading: Container(
            child: FlatButton(
              onPressed: () {
                auth.signOut();
                if (widget.Connection == 'facebook') {
                  facebook.logOut();
                } else if (widget.Connection == 'google') {
                  google.signOut();
                }
                Navigator.pushReplacement(context,
                    MaterialPageRoute(builder: (context) => WelcomePage()));
              },
              child: Icon(CupertinoIcons.back),
            ),
          ),
        ),
        body: Container(
          decoration: BoxDecoration(
              gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [Colors.blueGrey, Colors.orangeAccent])),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Container(
                  margin: EdgeInsets.symmetric(horizontal: 10.0),
                  child: Row(
                    children: <Widget>[
                      WebButton(
                        image: AssetImage('images/askGunter.png'),
                        url:
                            "https://chats.landbot.io/v3/H-632679-2HBXLM7BNUDNPZBR/index.html",
                        title: 'ask Gunter',
                      ),
                      SizedBox(
                        width: 10.0,
                      ),
                      WebButton(
                        image: AssetImage('images/bookaway.png'),
                        url:
                            'https://chats.landbot.io/v3/H-645849-4Q2ANZ3W11WKWMRV/index.html',
                        title: 'BookAway',
                      )
                    ],
                  ))
            ],
          ),
        ));
  }
}
