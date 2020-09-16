import 'package:flutter/material.dart';

class ChatBotClass {
  String href;
  String title;
  String image;
  bool favorite;

  ChatBotClass();

  String gettitle() => title;
  String gethref() => href;
  String getimage() => image;
  bool getfavorite() => favorite;

  settitle(String title) => this.title = title;
  setimage(String image) => this.image = image;
  sethref(String href) => this.href = href;
  setfav(bool fav) => this.favorite = fav;

  Map<String, dynamic> toJson() =>
      {'href': href, 'title': title, 'image': image, 'favorite': favorite};

  ChatBotClass.fromJson(Map<String, dynamic> json)
      : href = json['href'],
        title = json['title'],
        image = json['image'],
        favorite = json['favorite'];

  @override
  String toString() {
    return 'ChatBotClass{href: $href, title: $title, image: $image, favorite: $favorite}';
  }
}
