import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:webview_test/Utils/StaticObjects.dart';
import 'package:webview_test/components/Builders.dart';

import '../components/ChatBotClass.dart';

//var ref = Firestore.instance.collection(StaticObjects.email);

Future<List<Widget>> getbotsFromDB(String email, String doc) async {
  var ref = Firestore.instance.collection(email).document(doc);
  List<Widget> bots = [];
  await ref.get().then((snap) async {
    if (snap.exists) {
      var maps = await snap.data[doc];
      for (var map in maps) {
        Map<String, dynamic> botmap = {
          'href': map['href'],
          'image': map['image'],
          'title': map['title'],
          'favorite': map['favorite']
        };
        if (doc == 'All Bots') {
          bots.add(Chatbot(
            bot: ChatBotClass.fromJson(botmap),
          ));
          StaticObjects.appBots = bots;
        } else {
          bots.add(FavBot(
            bot: ChatBotClass.fromJson(botmap),
          ));
          StaticObjects.favList.add(ChatBotClass.fromJson(botmap));
          StaticObjects.favBots = bots;
        }
      }
      print('Static bots ${StaticObjects.appList}');
    } else {
      print('snap not exist');
    }
  });
}

List<Map<String, dynamic>> getfavorites(List<Map<String, dynamic>> allbots) {
  List<Map<String, dynamic>> favorites = [];
  for (var bot in allbots) {
    if (bot['favorite']) {
      favorites.add(bot);
    }
  }
  return favorites;
}

addFavNDchangeAllBots(ChatBotClass bot, String email) async {
  var ref = Firestore.instance.collection(email);
  ChatBotClass newBot = bot;
  newBot.favorite = true;
  StaticObjects.favList.add(newBot);
  StaticObjects.favBots.add(FavBot(
    bot: newBot,
  ));
  for (int i = 0; i < StaticObjects.appList.length; i++) {
    if (StaticObjects.appList[i].href == bot.href) {
      StaticObjects.appList[i].favorite = true;
    }
  }
  await ref
      .document('favorites')
      .setData({'favorites': chatbotlistToMap(StaticObjects.favList)});
  await ref
      .document('All Bots')
      .setData({'All Bots': chatbotlistToMap(StaticObjects.appList)});
  StaticObjects.appBots = chatBotListToWidgetList(StaticObjects.appList, false);
  StaticObjects.favBots = chatBotListToWidgetList(StaticObjects.favList, true);
}

removeFromFavNDChangeAllBots(ChatBotClass bot) async {
  var ref = Firestore.instance.collection(StaticObjects.email);
  var index = -1;
  for (int i = 0; i < StaticObjects.favList.length; i++) {
    if (StaticObjects.favList[i].href == bot.href) {
      StaticObjects.favList.removeAt(i);
    }
  }
  print('favList ${StaticObjects.favList}');
  for (int i = 0; i < StaticObjects.appList.length; i++) {
    if (StaticObjects.appList[i].href == bot.href) {
      StaticObjects.appList[i].favorite = false;
      index = i;
    }
  }
  print('appList ${StaticObjects.appList}');
  ref
      .document('favorites')
      .setData({'favorites': chatbotlistToMap(StaticObjects.favList)});
  ref
      .document('All Bots')
      .setData({'All Bots': chatbotlistToMap(StaticObjects.appList)});

  StaticObjects.appBots = chatBotListToWidgetList(StaticObjects.appList, false);
}

List<Widget> chatBotListToWidgetList(List<ChatBotClass> list, bool favorite) {
  List<Widget> botlist = [];
  for (var bot in list) {
    if (favorite)
      botlist.add(FavBot(
        bot: bot,
      ));
    else
      botlist.add(Chatbot(
        bot: bot,
      ));
  }
  return botlist;
}

List<Map<String, dynamic>> chatbotlistToMap(List<ChatBotClass> list) {
  List<Map<String, dynamic>> mapList = [];
  for (var bot in list) {
    mapList.add(bot.toJson());
  }
  return mapList;
}

List<Widget> searchByHashtag(String key) {
  List<Widget> searchBots = [];
  for (var bot in StaticObjects.appList) {
    if (bot.title.toLowerCase().contains(key.toLowerCase())) {
      searchBots.add(Chatbot(
        bot: bot,
      ));
    }
  }
  return searchBots;
}
