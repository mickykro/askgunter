import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_facebook_login/flutter_facebook_login.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:webview_test/Screens/MyHomePage.dart';
import 'package:http/http.dart' as http;
import 'package:webview_test/Screens/RegisterPage.dart';
import 'package:webview_test/Utils/AuthFunctions.dart';
import 'package:webview_test/components/Builders.dart';

class WelcomePage extends StatelessWidget {
  final _auth = FirebaseAuth.instance;
  final facebookLogin = FacebookLogin();
  bool isLoggedIn = false;
  GoogleSignIn _googleSignIn = GoogleSignIn(
    scopes: [
      'email',
      'https://www.googleapis.com/auth/contacts.readonly',
    ],
  );

  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  void signOutGoogle() async {
    await _googleSignIn.signOut();

    print("User Sign Out");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: Container(
          color: Colors.white,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              Container(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    Container(
                        margin: EdgeInsets.symmetric(horizontal: 20),
                        child: Image.asset('images/askgunterLogoWSub.png')),
                    SizedBox(
                      height: 10,
                    ),
                    Text(
                      'your personal assistant',
                      style: TextStyle(fontSize: 18.0, color: Colors.white),
                    ),
                    SocialButton(
                      socialLogin: () async {
                        logInFacebook(context, facebookLogin, _auth);
                      },
                      text: 'Login via Facecbook',
                      textColor: Colors.white,
                      logo: Image(
                        image: AssetImage('images/facebook1.png'),
                        height: 30.0,
                      ),
                      color: Color(0xff3b5999),
                    ),
                    SocialButton(
                      socialLogin: () async {
                        signInWithGoogle(context, _googleSignIn, _auth);
                      },
                      logo: Image(
                        image: AssetImage('images/google.png'),
                        height: 30.0,
                      ),
                      textColor: Colors.black,
                      color: Colors.grey,
                      text: 'Login via Google',
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    Container(
                      margin: EdgeInsets.symmetric(
                          vertical: 10.0, horizontal: 30.0),
                      child: TextField(
                        controller: emailController,
                        decoration: InputDecoration(
                            prefixIcon: Icon(Icons.email),
                            hintText: 'Enter your Email here ',
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.black),
                              borderRadius: BorderRadius.circular(20.0),
                            )),
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.symmetric(
                          vertical: 10.0, horizontal: 30.0),
                      child: TextField(
                        controller: passwordController,
                        decoration: InputDecoration(
                            prefixIcon: Icon(CupertinoIcons.padlock_solid),
                            hintText: 'Enter your Password here ',
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.black),
                              borderRadius: BorderRadius.circular(20.0),
                            )),
                      ),
                    ),
                    InkWell(
                      onTap: () {
                        print('trying to connect to firebase');
                        if (emailController.text != null &&
                            passwordController.text.length > 5) {
                          _auth
                              .signInWithEmailAndPassword(
                                  email: emailController.text,
                                  password: passwordController.text)
                              .catchError((err) {
                            print(err);
                            _auth
                                .createUserWithEmailAndPassword(
                                    email: emailController.text,
                                    password: passwordController.text)
                                .whenComplete(() => Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => MyHomePage(
                                              Connection: 'email',
                                            ))));
                          })
                              // todo: add loading animation
                              .whenComplete(() => Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => MyHomePage(
                                            Connection: 'email',
                                          ))));
                        }
                      },
                      highlightColor: Colors.orange.withOpacity(0.7),
                      splashColor: Colors.blue,
                      child: Container(
                        padding: EdgeInsets.symmetric(
                            horizontal: 20.0, vertical: 5.0),
//                  margin: EdgeInsets.symmetric(horizontal: 60.0),
                        decoration: BoxDecoration(
                          boxShadow: [
                            BoxShadow(
                                color: Colors.black54,
                                offset: Offset(4.0, 4.0), //(x,y)
                                blurRadius: 4.0),
                          ],
                          color: Colors.black26,
                          borderRadius: BorderRadius.circular(25.0),
                        ),
                        child: Text(
                          'Login',
                          style: TextStyle(
                              fontSize: 20.0,
                              fontWeight: FontWeight.bold,
                              color: Colors.white.withOpacity(0.8)),
                        ),
                      ),
                    ),
//              InkWell(
//                onTap: () {
//                  Navigator.push(context,
//                      MaterialPageRoute(builder: (context) => RegisterPage()));
//                },
//                child: Container(
//                  decoration: BoxDecoration(
//                      borderRadius: BorderRadius.circular(25),
//                      color: Colors.lightGreenAccent),
//                  padding: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
//                  margin: EdgeInsets.symmetric(horizontal: 70),
//                  child: Row(
//                    mainAxisAlignment: MainAxisAlignment.center,
//                    children: <Widget>[
//                      Icon(Icons.mail),
//                      SizedBox(
//                        width: 5,
//                      ),
//                      Text(
//                        'Log In via Email ',
//                      ),
//                    ],
//                  ),
//                ),
//              ),
                  ],
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  Text('Join us'),
                  Icon(Icons.arrow_right),
                  InkWell(
                    onTap: () {
                      showGeneralDialog(
                          barrierColor: Colors.black.withOpacity(0.5),
                          transitionBuilder: (context, a1, a2, widget) {
                            final curvedValue =
                                Curves.easeInOutBack.transform(a1.value) - 1.0;
                            return Transform(
                              transform: Matrix4.translationValues(
                                  0, curvedValue * -300, 0.0),
                              child: AnimatedDialog(
                                anim1: a1,
                                url:
                                    'https://chats.landbot.io/v3/H-683850-C220R6OYPA55C6CR/',
                                title: '',
                              ),
                            );
                          },
                          transitionDuration: Duration(milliseconds: 1000),
                          barrierDismissible: true,
                          barrierLabel: '',
                          context: context,
                          pageBuilder: (context, animation1, animation2) {});
                    },
                    child: Container(
//                        margin: EdgeInsets.only(
//                            right: 10.0, bottom: 20.0, top: 10.0, left: 10.0),
                      padding: EdgeInsets.all(5.0),
                      decoration: BoxDecoration(
                          color: Colors.blue,
                          borderRadius: BorderRadius.circular(30)),
                      child: Image.asset(
                        'images/chatlogo.png',
                        height: 50,
                      ),
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
