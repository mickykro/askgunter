import 'dart:convert';

import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:async';

import 'dart:convert'; // Contains the JSON encoder

import 'package:http/http.dart'; // Contains a client for making API calls
import 'package:html/parser.dart'; // Contains HTML parsers to generate a Document object
import 'package:html/dom.dart';
import 'package:webview_test/Screens/MyHomePage.dart';
//import 'package:webview_test/Screens/Router.dart';

import 'package:webview_test/Screens/welcomePage.dart';
import 'package:webview_test/components/Builders.dart';

import '../components/ChatBotClass.dart';
import 'Functions.dart';
import 'StaticObjects.dart';
//import 'package:webview_test/Utils/Functions.dart';
//import 'package:webview_test/Utils/SharedPrefs.dart';
//import 'package:webview_test/Utils/staticObjects.dart';
//import 'package:webview_test/components/ChatBotClass.dart'; // Contains DOM related classes for extracting data from elements

/** First Page*/

class HttpRequest extends StatefulWidget {
  @override
  _HttpRequestState createState() => _HttpRequestState();
}

/** empty List of Map that will contain all bots Maps in the futurue*/
List<Map<String, dynamic>> CardsMap = [];
List<Widget> bots = [];

class _HttpRequestState extends State<HttpRequest> {
  bool fav = false;

  Future getData() async {
    FirebaseAuth auth = FirebaseAuth.instance;
    FirebaseUser user = await auth.currentUser();
    if (user != null) {
      StaticObjects.user = user;
      /**
       * if user isnt null then pull list from firebase
       * */
      var ref = Firestore.instance.collection(user.email);
      await ref.document('All Bots').get().then((snap) async {
        if (snap.exists) {
          List<Map<String, dynamic>> tofavorites = [];
          var maps = await snap.data['All Bots'];
          for (var map in maps) {
            Map<String, dynamic> botmap = {
              'href': map['href'],
              'image': map['image'],
              'title': map['title'],
              'favorite': map['favorite']
            };
            tofavorites.add(botmap);

            ChatBotClass bot = ChatBotClass.fromJson(botmap);
            bots.add(Chatbot(
              bot: bot,
            ));
            StaticObjects.appList.add(bot);
          }
          ref
              .document('favorites')
              .setData({'favorites': getfavorites(tofavorites)});
        } else {
          var client = Client();
          var request =
              await HttpClient().getUrl(Uri.parse('https://askgunter.com'));
          var response = await request.close();
          await for (var contents in response.transform(Utf8Decoder())) {
            var parser = parse(contents);
            /** get the list of all the bots Elements from the url  */
            var robots = parser.getElementsByClassName(
                'elementor-element elementor-element-45ac11e elementor-posts--align-center elementor-grid-3 elementor-grid-tablet-2 elementor-grid-mobile-1 elementor-posts--thumbnail-top elementor-widget elementor-widget-posts');
            if (robots.isNotEmpty) {
              /** empty List of maps the will Update cardMap */
              List<Map<String, dynamic>> linkMap = [];

              for (var bot in robots) {
                for (var card in bot.children[0].children[0].children) {
                  if (card.children[0].attributes['href'] ==
                      'https://askgunter.com/calling-my-squad/') {
                    fav = true;
                  } else {
                    fav = false;
                  }
                  ChatBotClass bot = ChatBotClass.fromJson({
                    'title': card.children[1].text,
                    'href': card.children[0].attributes['href'],
                    'image': card
                        .children[0].children[0].children[0].attributes['src'],
                    'favorite': fav
                  });
                  linkMap.add(bot.toJson());
                  bots.add(Chatbot(
                    bot: bot,
                  ));
                  StaticObjects.appList.add(bot);
                }
              }
              CardsMap = linkMap;

              FirebaseUser user = await FirebaseAuth.instance.currentUser();
              var ref = Firestore.instance.collection(user.email);
              ref.document('All Bots').setData({'All Bots': CardsMap});
              ref
                  .document('favorites')
                  .setData({'favorites': getfavorites(CardsMap)});
            }
          }
        }

        await getbotsFromDB(user.email, 'All Bots');
        await getbotsFromDB(user.email, 'favorites');
      });

      /** when done checking, Route to MyHomePage */
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => MyHomePage()));
    } else {
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => WelcomePage()));
    }
//    else {
//      var client = Client();
//      var request =
//          await HttpClient().getUrl(Uri.parse('https://askgunter.com'));
//      var response = await request.close();
//      await for (var contents in response.transform(Utf8Decoder())) {
//        var parser = parse(contents);
//        /** get the list of all the bots Elements from the url  */
//        var robots = parser.getElementsByClassName(
//            'elementor-element elementor-element-45ac11e elementor-posts--align-center elementor-grid-3 elementor-grid-tablet-2 elementor-grid-mobile-1 elementor-posts--thumbnail-top elementor-widget elementor-widget-posts');
//        if (robots.isNotEmpty) {
//          /** empty List of maps the will Update cardMap */
//          List<Map<String, dynamic>> linkMap = [];
//          List<String> prefsBots = [];
//
//          for (var bot in robots) {
//            for (var card in bot.children[0].children[0].children) {
//              if (card.children[0].attributes['href'] ==
//                  'https://askgunter.com/calling-my-squad/') {
//                fav = true;
//              } else {
//                fav = false;
//              }
//              ChatBotClass bot = ChatBotClass.fromJson({
//                'title': card.children[1].text,
//                'href': card.children[0].attributes['href'],
//                'image':
//                    card.children[0].children[0].children[0].attributes['src'],
//                'favorite': fav
//              });
//              linkMap.add(bot.toJson());
//              bots.add(Chatbot(
//                bot: bot,
//              ));
//            }
//          }
//          CardsMap = linkMap;
//
//          FirebaseUser user = await FirebaseAuth.instance.currentUser();
//          var ref =
//              Firestore.instance.collection(user.email).document('All Bots');
//          ref.setData({'All Bots': CardsMap});
//        }
//      }
//    }
  }

  // stopping the loading
  bool isLoading = false;

  /**
   * a method that gets a List of bot straight from DB
   * */

  /**
   * method that checks if user is signed in already (to fireabseAuth)
   * */
  void isSignedIn(BuildContext context) async {
    FirebaseAuth _auth = FirebaseAuth.instance;

    if (await _auth.currentUser() != null) {
      /** get the current user and extract his email to StaticObjects */
      FirebaseUser user = await _auth.currentUser();

      await getbotsFromDB(user.email, 'All Bots');
      await getbotsFromDB(user.email, 'favorites');

      /** when done checking, Route to MyHomePage */
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => MyHomePage()));
    } else {
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => WelcomePage()));
    }
  }

  @override
  void initState() {
    super.initState();
    /** as soon as the app starts
     * 1) getData = creates a list of all bots and put it in CardMap
     * 2) when getData is done puts CardMap in StaticObjects
     * 3) checks if signed in and Routes to the relevant page
     * */
    getData();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        color: Color(0xff008eff),
        child: Align(
          alignment: Alignment(MediaQuery.of(context).size.width / 2, 0),
          child: Stack(
            fit: StackFit.loose,
            alignment: Alignment.center,
            children: <Widget>[
              Container(
                margin: EdgeInsets.symmetric(vertical: 10),
                child: Image.asset(
                  'images/loadingCloud.gif',
                ),
              ),
              Image.asset(
                'images/askgunterLogoWSub.png',
                height: 80,
              )
            ],
          ),
        ));
  }
}
