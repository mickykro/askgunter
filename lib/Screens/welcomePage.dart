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
        color: Color(0xff008eff),
        child: Center(
          child: Column(
            children: <Widget>[
              SizedBox(
                height: 120.0,
              ),
              Container(
                  margin: EdgeInsets.symmetric(horizontal: 20),
                  child: Image.asset('images/drawerTitle.png')),
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
                color: Colors.white,
                text: 'Login via Google',
              ),
              SizedBox(
                height: 15,
              ),
              InkWell(
                onTap: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => RegisterPage()));
                },
                child: Container(
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(25),
                      color: Colors.lightGreenAccent),
                  padding: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                  margin: EdgeInsets.symmetric(horizontal: 70),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Icon(Icons.mail),
                      SizedBox(
                        width: 5,
                      ),
                      Text(
                        'Log In via Email ',
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
