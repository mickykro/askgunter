import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_facebook_login/flutter_facebook_login.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:webview_test/Screens/MyHomePage.dart';
import 'package:http/http.dart' as http;
import 'package:webview_test/Utils/HttpRequest.dart';

void logInFacebook(BuildContext context, FacebookLogin facebookLogin,
    FirebaseAuth _auth) async {
  final result = await facebookLogin.logIn(['email']);
  final token = result.accessToken.token;
  print(token);
  final graphResponse = await http.get(
      'https://graph.facebook.com/v2.12/me?fields=name,first_name,last_name,email&access_token=${token}');
  print(graphResponse.body);

  print(result);
  if (result.status == FacebookLoginStatus.loggedIn) {
    print('connected to facebook');
    final credentials = FacebookAuthProvider.getCredential(accessToken: token);
    _auth.signInWithCredential(credentials).then((value) {
      if (value.user == null) {
        print('mistake');
      } else
        print('logged in');
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => HttpRequest()));
    });
  } else {
    print('something went wrong');
  }
}

void signInWithGoogle(BuildContext context, GoogleSignIn _googleSignIn,
    FirebaseAuth _auth) async {
  final GoogleSignInAccount googleSignInAccount = await _googleSignIn.signIn();
  final GoogleSignInAuthentication googleSignInAuthentication =
      await googleSignInAccount.authentication;

  final AuthCredential credential = GoogleAuthProvider.getCredential(
    accessToken: googleSignInAuthentication.accessToken,
    idToken: googleSignInAuthentication.idToken,
  );

  final AuthResult authResult = await _auth.signInWithCredential(credential);
  final FirebaseUser user = authResult.user;

  assert(!user.isAnonymous);
  assert(await user.getIdToken() != null);

  final FirebaseUser currentUser = await _auth.currentUser();

  if (currentUser != null)
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) => HttpRequest()));
}

void SignInEmailPassword(
    BuildContext context,
    TextEditingController emailController,
    TextEditingController passwordController,
    FirebaseAuth _auth) {
  {
    print('trying to connect to firebase');
    if (emailController.text != null && passwordController.text.length > 5) {
      _auth
          .signInWithEmailAndPassword(
              email: emailController.text, password: passwordController.text)
          .whenComplete(() {
        if (_auth.currentUser() != null) {
          Navigator.pushReplacement(
              context, MaterialPageRoute(builder: (context) => HttpRequest()));
        }
//                          TODO: alert wrong password or email
      });
    }
  }
}
