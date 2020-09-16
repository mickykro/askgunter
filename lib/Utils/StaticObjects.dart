import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../components/ChatBotClass.dart';

class StaticObjects {
  static FirebaseUser user;
  static String email = user.email;

  static List<Widget> appBots = [];
  static List<ChatBotClass> appList = [];
  static List<Widget> favBots = [];
  static List<ChatBotClass> favList = [];

  static List<Widget> searchBots = [];
}
