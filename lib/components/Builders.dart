import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:webview_test/Screens/ChatScreen.dart';
import 'package:webview_test/Screens/MyHomePage.dart';
import 'package:webview_test/Screens/welcomePage.dart';
import 'package:webview_test/components/ChatBotClass.dart';
import 'package:webview_test/Utils/Functions.dart';
import 'package:webview_test/Utils/StaticObjects.dart';

class DialogBuidler extends StatelessWidget {
  final url;
  DialogBuidler({this.url});
  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Container(
        width: 1000,
        height: 550,
        child: InAppWebView(
          initialUrl: url,
        ),
      ),
    );
  }
}

class AnimatedDialog extends StatelessWidget {
  final url;

  final title;
  final anim1;
  AnimatedDialog({this.title, this.url, this.anim1});
  @override
  Widget build(BuildContext context) {
    return Opacity(
      opacity: anim1.value,
      child: Container(
        width: 500,
        height: 650,
        margin: EdgeInsets.only(top: 30.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              title,
              style: TextStyle(
                decoration: TextDecoration.none,
                color: Colors.white,
                fontSize: 25.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            DialogBuidler(
              url: url,
            ),
          ],
        ),
      ),
    );
  }
}

class WebButton extends StatelessWidget {
  final image;
  final url;
  final title;

  WebButton({this.image, this.url, this.title});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        decoration: BoxDecoration(
          shape: BoxShape.rectangle,
          color: Colors.white,
        ),
        child: RaisedButton(
          color: Colors.black26,
          elevation: 50.0,
          highlightElevation: 20.0,
          onPressed: () {
            showGeneralDialog(
                barrierColor: Colors.black.withOpacity(0.5),
                transitionBuilder: (context, a1, a2, widget) {
                  final curvedValue =
                      Curves.easeInOutBack.transform(a1.value) - 1.0;
                  return Transform(
                    transform: Matrix4.translationValues(
                        curvedValue * -300, curvedValue * -300, 0.0),
                    child: AnimatedDialog(
                      anim1: a1,
                      url: url,
                      title: title,
                    ),
                  );
                },
                transitionDuration: Duration(milliseconds: 300),
                barrierDismissible: true,
                barrierLabel: '',
                context: context,
                pageBuilder: (context, animation1, animation2) {});
          },
          child: Padding(
            padding: (title == 'ask Gunter')
                ? EdgeInsets.symmetric(vertical: 30.0, horizontal: 10.0)
                : EdgeInsets.symmetric(vertical: 39.0, horizontal: 10.0),
            child: Center(
              child: Image(
                image: image,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class EmPwTextFeild extends StatelessWidget {
  TextEditingController controller;
  Icon icon;
  String hintText;
  EmPwTextFeild({this.controller, this.icon, this.hintText});
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10.0, horizontal: 30.0),
      child: TextField(
        controller: controller,
        // Todo: validate email
        decoration: InputDecoration(
            prefixIcon: icon,
            hintText: hintText,
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.black),
              borderRadius: BorderRadius.circular(20.0),
            )),
      ),
    );
  }
}

class SocialButton extends StatelessWidget {
  Function socialLogin;
  Color color;
  Image logo;
  String text;
  Color textColor;

  SocialButton(
      {@required this.socialLogin,
      @required this.color,
      @required this.text,
      @required this.logo,
      @required this.textColor});
  @override
  Widget build(BuildContext context) {
    return FlatButton(
      onPressed: socialLogin,
      child: Container(
        margin: EdgeInsets.only(top: 10.0, left: 60.0, right: 60.0),
        padding: EdgeInsets.symmetric(
          vertical: 5,
        ),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(25.0),
          color: color,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            logo,
            SizedBox(
              width: 5.0,
            ),
            Text(
              text,
              style: TextStyle(fontWeight: FontWeight.bold, color: textColor),
            )
          ],
        ),
      ),
    );
  }
}

class Chatbot extends StatefulWidget {
  ChatBotClass bot;
  bool isFavorite;
  Chatbot({Key key, @required this.bot}) : super(key: key);

  @override
  _ChatbotState createState() => _ChatbotState();
}

class _ChatbotState extends State<Chatbot> {
  Firestore ref = Firestore.instance;
  FirebaseAuth auth = FirebaseAuth.instance;
  /**
   * a method to get the main title only
   * */
  String getName(String title) {
//  title = title.replaceAll(RegExp(r'\s+'), "");
    var split = title.split('#');

    String titleName = "";
    if (split[0].split('/\W+/').length > 1) {
      var name = split[0].split(" ");
      for (var i; i < name.length - 1; i++) {
        titleName += name[i].trim();
      }
    } else
      titleName = split[0].trim();

    return (titleName.length > 0) ? titleName : 'default';
  }

  /**
   * a method to get the hashtags
   * */
  String getSubtitle(String title) {
    var index = title.indexOf("#");
    var split = title.substring(index);

    var splitChat = split.split("Chat");

    var text = splitChat[0].trim();
    return text;
  }

  /**
   * a method that updates favorites in database
   * */

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(top: 5.0),
      margin: EdgeInsets.all(5.0),
      decoration: BoxDecoration(boxShadow: [
        BoxShadow(offset: Offset.zero, color: Colors.black38, blurRadius: 10.0)
      ], color: Colors.white, borderRadius: BorderRadius.circular(15)),
      child: ListTile(
        leading: ClipOval(
          child: (widget.bot.image != null)
              ? Image.network(
                  widget.bot.image,
                  fit: BoxFit.fitHeight,
                  height: 130,
                  width: 60,
                )
              : Image.asset('images/askgunterLogoNoSub.png'),
        ),
        trailing: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            InkWell(
                onTap: () {
                  setState(() {
                    /**
                     * happens when pressing follow/following
                     * */
                    print(widget.bot.favorite);
                    if (!widget.bot.favorite) {
                      addFavNDchangeAllBots(widget.bot, StaticObjects.email);
                      widget.bot.favorite = true;
                    } else {
                      removeFromFavNDChangeAllBots(widget.bot);
                      widget.bot.favorite = false;
                    }

                    print(widget.bot.favorite);
                  });
//
                },
                child: widget.bot.favorite
                    ? Image(
                        image: AssetImage('images/following.png'),
                        height: 20.0,
                      )
                    : Image(
                        image: AssetImage('images/follow.png'),
                        height: 20.0,
                      )),
            Flexible(
              child: Container(
                margin: EdgeInsets.only(top: 10.0),
                child: RaisedButton(
                  color: Colors.blue,
                  child: Text(
                    'Chat',
                    style: TextStyle(color: Colors.white),
                  ),
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => ChatScreen(bot: widget.bot)));
                  },
                ),
              ),
            )
          ],
        ),
        title: Text(
          getName(widget.bot.title),
          textAlign: TextAlign.start,
        ),
        subtitle: Container(
            child: Text(
          getSubtitle(widget.bot.title),
          overflow: TextOverflow.ellipsis,
          maxLines: 2,
          softWrap: true,
        )),
      ),
    );
    ;
  }
}

class FavBot extends StatefulWidget {
  ChatBotClass bot;
  FavBot({Key key, @required this.bot}) : super(key: key);
  @override
  _FavBotState createState() => _FavBotState();
}

class _FavBotState extends State<FavBot> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(top: 5.0, bottom: 5.0),
      margin: EdgeInsets.all(2.0),
      decoration: BoxDecoration(boxShadow: [
        BoxShadow(offset: Offset.zero, color: Colors.black38, blurRadius: 10.0)
      ], color: Colors.white),
      child: ListTile(
        leading: ClipOval(
          child: Image.network(
            widget.bot.image,
            fit: BoxFit.fitHeight,
            height: 130,
            width: 60,
          ),
        ),
        trailing: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            InkWell(
                onTap: () {
                  setState(() {
                    print(widget.bot.favorite);
                    if (!widget.bot.favorite) {
                      addFavNDchangeAllBots(widget.bot, StaticObjects.email);
                      widget.bot.favorite = true;
                    } else {
                      removeFromFavNDChangeAllBots(widget.bot);
                      widget.bot.favorite = true;
                    }
                    print(widget.bot.favorite);
                  });
                },
                child: widget.bot.favorite
                    ? Image(
                        image: AssetImage('images/following.png'),
                        height: 20.0,
                      )
                    : Image(
                        image: AssetImage('images/follow.png'),
                        height: 20.0,
                      )),
            Flexible(
              child: Container(
                margin: EdgeInsets.only(top: 10.0),
                child: RaisedButton(
                  color: Colors.blue,
                  child: Text(
                    'Chat',
                    style: TextStyle(color: Colors.white),
                  ),
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => ChatScreen(bot: widget.bot)));
                  },
                ),
              ),
            )
          ],
        ),
      ),
    );
    ;
  }
}

class SideBarFav extends StatefulWidget {
  List<Widget> allBots;
  Function setter;
  FirebaseUser user;
  FirebaseAuth auth = FirebaseAuth.instance;
  final GlobalKey containerKey = GlobalKey();

  SideBarFav({@required this.allBots, this.setter});

  @override
  _SideBarState createState() => _SideBarState();
}

class _SideBarState extends State<SideBarFav> {
  bool isSideBarOpenned = false;

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.width;
    return Stack(
      children: <Widget>[
        AnimatedPositioned(
          top: 0,
          bottom: 0,
          left: isSideBarOpenned ? 0 : -screenWidth,
          right: isSideBarOpenned ? 0 : screenWidth,
          duration: Duration(milliseconds: 400),
          child: AnimatedOpacity(
            opacity: isSideBarOpenned ? 0.9 : 00,
            duration: Duration(milliseconds: 500),
            child: Container(
              color: Color(0xff008eff),
            ),
          ),
        ),
        AnimatedPositioned(
          top: 0,
          bottom: 0,
          left: isSideBarOpenned ? 0 : -screenWidth,
          right: isSideBarOpenned ? 0 : screenWidth - 125,
          duration: Duration(milliseconds: 500),
          child: Row(
            children: <Widget>[
              Expanded(
                child: Stack(
                  children: <Widget>[
                    Container(
                      color: Colors.white,
                      child: Column(
                        children: <Widget>[
                          Container(
                            key: widget.containerKey,
                            decoration: BoxDecoration(
                              color: Colors.blue,
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: <Widget>[
                                Container(
                                  margin: EdgeInsets.all(15),
                                  child: CircleAvatar(
                                    radius: 55,
                                    backgroundColor: Colors.white,
                                    child: CircleAvatar(
                                        radius: 50,
                                        backgroundImage: (StaticObjects
                                                    .user.photoUrl !=
                                                null)
                                            ? NetworkImage(
                                                StaticObjects.user.photoUrl)
                                            : AssetImage(
                                                'images/askgunterLogoNoSub.png')),
                                  ),
                                ),
                                Container(
                                  margin: EdgeInsets.all(15),
                                  child:
                                      (StaticObjects.user.displayName != null)
                                          ? Text(
                                              StaticObjects.user.displayName,
                                              style: TextStyle(
                                                color: Colors.white,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            )
                                          : Text(
                                              StaticObjects.user.email,
                                              style: TextStyle(
                                                color: Colors.white,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                ),
                                Row(
                                  children: <Widget>[
                                    Expanded(
                                      child: Container(
                                          color: Colors.white,
                                          padding: EdgeInsets.symmetric(
                                              horizontal: 20, vertical: 20),
                                          margin: EdgeInsets.only(bottom: 3),
                                          child: Text(
                                            'My Assistants',
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                                color: Color(0xff008eff),
                                                fontWeight: FontWeight.bold,
                                                fontSize: 20),
                                          )),
                                    ),
                                  ],
                                )
                              ],
                            ),
                          ),
                          Expanded(
                            child: ListView(
                              children: <Widget>[
                                ...widget.allBots,
                              ],
                            ),
                          ),
                          Align(
                            alignment: Alignment.bottomRight,
                            child: Container(
                                margin: EdgeInsets.only(bottom: 20, right: 10),
                                child: FlatButton(
                                  onPressed: () {
                                    /**
                                     * signOut button says logOut
                                     * */
                                    widget.auth.signOut();
                                    Navigator.pushReplacement(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                WelcomePage()));
                                  },
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: <Widget>[
                                      Text(
                                        'log Out',
                                        style: TextStyle(
                                            color: Colors.blue,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      SizedBox(
                                        width: 10,
                                      ),
                                      Icon(Icons.exit_to_app)
                                    ],
                                  ),
                                )),
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Align(
                alignment: Alignment(0, -0.9),
                child: GestureDetector(
                  onTap: () async {
//                print(StaticObjects.email);
//                await getbotsFromDB(StaticObjects.email, 'favorites');
                    setState(() {
                      widget.setter();
                      isSideBarOpenned = !isSideBarOpenned;
                    });
                  },
                  child: Container(
                    decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.5),
                        borderRadius: BorderRadius.only(
                            topRight: Radius.circular(25),
                            bottomRight: Radius.circular(25))),
                    width: 45,
                    height: 50,
                    child:
                        isSideBarOpenned ? Icon(Icons.clear) : Icon(Icons.menu),
                  ),
                ),
              ),
              SizedBox(
                width: 80,
              )
            ],
          ),
        ),
      ],
    );
  }
}
