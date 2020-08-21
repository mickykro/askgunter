import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'MyHomePage.dart';

class RegisterPage extends StatelessWidget {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  final _auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
            gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [Colors.blueGrey, Colors.orangeAccent])),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'Ask Gunter',
              style: TextStyle(
                  fontSize: 35.0,
                  color: Colors.deepOrange.withOpacity(0.6),
                  fontFamily: 'AlfaSlabOne'),
            ),
            Image(
              image: AssetImage('images/globe1.png'),
              height: 300,
            ),
            Container(
              margin: EdgeInsets.symmetric(vertical: 10.0, horizontal: 30.0),
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
              margin: EdgeInsets.symmetric(vertical: 10.0, horizontal: 30.0),
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
                      .createUserWithEmailAndPassword(
                          email: emailController.text,
                          password: passwordController.text)
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
                padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 5.0),
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
                  'Register now',
                  style: TextStyle(
                      fontSize: 20.0,
                      fontWeight: FontWeight.bold,
                      color: Colors.white.withOpacity(0.8)),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
