import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:webview_test/Utils/Functions.dart';
import 'package:webview_test/Utils/StaticObjects.dart';
import 'package:webview_test/components/ChatBotClass.dart';

class ChatScreen extends StatefulWidget {
  final ChatBotClass bot;
  ChatScreen({@required this.bot});
  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          color: Colors.blue,
          child: Column(
            children: <Widget>[
              ListTile(
                leading: Container(
                  child: InkWell(
                    onTap: () {
                      setState(() {
                        if (widget.bot.favorite) {
                          removeFromFavNDChangeAllBots(widget.bot);
                          widget.bot.favorite = false;
                        } else {
                          addFavNDchangeAllBots(
                              widget.bot, StaticObjects.email);
                          widget.bot.favorite = true;
                        }
                      });
                    },
                    child: Image(
                      image: widget.bot.favorite
                          ? AssetImage('images/followingWhite.png')
                          : AssetImage('images/followWhite.png'),
                      height: 20,
                    ),
                  ),
                ),
                trailing: FlatButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Container(
                    margin: EdgeInsets.only(left: 40.0),
                    child: Icon(
                      Icons.cancel,
                      textDirection: TextDirection.rtl,
                    ),
                  ),
                ),
                title: Container(
                  margin: EdgeInsets.only(left: 25),
                  child: Image(
                    image: AssetImage('images/drawerTitle.png'),
                    height: 55,
                  ),
                ),
              ),
              Flexible(
                child: InAppWebView(
                  initialUrl: widget.bot.href,
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
