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
      body: Container(
        decoration: BoxDecoration(
            gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [Colors.blueGrey, Colors.orangeAccent])),
        child: Center(
          child: Column(
            children: <Widget>[
              SizedBox(
                height: 30.0,
              ),
              Image(
                image: AssetImage('images/askGunter.png'),
              ),
              Text(
                'Ask Gunter',
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 25.0,
                    color: Colors.white),
              ),
              Text(
                'your personal travel assistant',
                style: TextStyle(fontSize: 12.0, color: Colors.white),
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
                color: Colors.white,
                text: 'Login via Google',
              ),
              SizedBox(
                height: 15.0,
              ),
              Text(
                ' Sign in via Email & Password',
                style: TextStyle(fontSize: 15.0, color: Colors.white),
              ),
              EmPwTextFeild(
                controller: emailController,
                hintText: ' Enter your email here',
                icon: Icon(Icons.mail),
              ),
              EmPwTextFeild(
                controller: passwordController,
                hintText: ' Enter your password here',
                icon: Icon(CupertinoIcons.padlock_solid),
              ),
              InkWell(
                onTap: () {
                  SignInEmailPassword(
                      context, emailController, passwordController, _auth);
                },
                highlightColor: Colors.orange.withOpacity(0.7),
                splashColor: Colors.blue,
                child: Container(
                  padding:
                      EdgeInsets.symmetric(horizontal: 20.0, vertical: 5.0),
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
              SizedBox(
                height: 10.0,
              ),
              Text(
                'Not registered yet? ',
                style: TextStyle(color: Colors.white),
              ),
              FlatButton(
                onPressed: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => RegisterPage()));
                },
                child: Text(
                  'Register Now!',
                  textAlign: TextAlign.start,
                  style: TextStyle(color: Colors.blueAccent),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
