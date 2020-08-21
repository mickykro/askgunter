import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';

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
