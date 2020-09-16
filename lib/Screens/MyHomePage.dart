import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:webview_test/Utils/Functions.dart';
import 'package:webview_test/Utils/StaticObjects.dart';
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
    print('appbots ${StaticObjects.appBots}');
    return Scaffold(
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(70),
          child: AppBar(
            backgroundColor: Colors.white,
            title: Container(
              child: Image(
                image: AssetImage('images/LogoBlue.png'),
                height: 40,
              ),
            ),
          ),
        ),
        /**
         * mainScreen will load from class MainScreen for cleaner code
         * */
        body: MainScreen(
          allBots: StaticObjects.appBots,
        ));
    ;
  }
}

class MainScreen extends StatefulWidget {
  List<Widget> allBots;
  TextEditingController searchConroller;
  bool isTyping = false;

  /**
   * gets the Firestore Document refernce of currentUsers favorite list
   * */

  MainScreen({this.allBots});

  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  void newFavState() async {
    FirebaseUser user = await FirebaseAuth.instance.currentUser();

    await getbotsFromDB(StaticObjects.email, 'All Bots');

    this.setState(() {
      /**
       * refresh the mainScreen
       * than getFavorites from Database - go to Functions to see function
       * calls fillbots again with favorites to make sure favorites will be updated
       *
       * */

      StaticObjects.appBots =
          chatBotListToWidgetList(StaticObjects.appList, false);
      StaticObjects.favBots =
          chatBotListToWidgetList(StaticObjects.favList, true);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        Container(
          color: Color(0xff008eff),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
//              Container(
//                  margin: EdgeInsets.symmetric(vertical: 15.0, horizontal: 15),
//                  child: Image(
//                    image: AssetImage('images/drawerTitle.png'),
//                  )),
              Container(
                margin: EdgeInsets.symmetric(vertical: 20),
                child: Text(
                  'Dont feel lost, Chat with an expert',
                  style: TextStyle(color: Colors.white, fontSize: 20),
                ),
              ),
              Container(
                margin:
                    EdgeInsets.only(top: 10, left: 10, right: 10, bottom: 10),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Colors.white),
                child: TextField(
                    controller: widget.searchConroller,
                    onChanged: (value) {
                      setState(() {
                        /**
                         * fills all bots of main screen with search methods
                         * fillSearchBots & findByHashtag - go to Functions
                         * */
                        widget.allBots = searchByHashtag(value);
//
//                        widget.allBots = fillSearchbots(
//                            findByHashtag(StaticObjects.changedMap, value));
                      });
                    },
                    decoration: InputDecoration(
                      prefixIcon: Icon(Icons.search),
                      hintText: 'enter key to search',
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.black),
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                    )),
              ),
              Flexible(
                flex: 6,
                child: Container(
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15.0),
                      color: Colors.white),
                  margin:
                      EdgeInsets.only(left: 10, right: 10, top: 10, bottom: 40),
                  child: ListView(
                    children: (widget.allBots.length > 0)
                        ? <Widget>[...widget.allBots]
                        : <Widget>[
                            Container(
                                color: Colors.blue,
                                margin: EdgeInsets.all(10),
                                child: Text(
                                  "No Bots to Match your search\n\n please try another keyWord ",
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                      fontSize: 20),
                                  textAlign: TextAlign.center,
                                ))
                          ],
                  ),
                ),
              )
            ],
          ),
        ),
        /**
         * side bar that contains all favorites
         * */
        SideBarFav(
          allBots: StaticObjects.favBots,
          /**
           * newFavState is a method that refreshes the mainScreen
           * to make sure the favorites are updated
           * */
          setter: newFavState,
        )
      ],
    );
  }
}
