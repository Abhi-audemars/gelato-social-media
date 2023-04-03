import 'dart:convert';

class Activity {
  Activity({
    required this.profilePic,
    required this.postUrl,
    required this.uid,
    required this.name,
    required this.datePublished,
    required this.isLike,
  });
  bool isLike;
  String profilePic;
  String postUrl;
  String uid;
  String name;
  final String datePublished;
  factory Activity.fromJson(String str) => Activity.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());
  factory Activity.fromMap(Map<String, dynamic> json) => Activity(
        profilePic: json["profilePic"],
        uid: json["uid"],
        name: json["name"],
        datePublished: json["datePublished"],
        postUrl: json["postUrl"],
        isLike: json['isLike'],
      );

  Map<String, dynamic> toMap() => {
        "profilePic": profilePic,
        "postUrl": postUrl,
        "uid": uid,
        "name": name,
        "datePublished": datePublished,
        "isLike": isLike,
      };
}
