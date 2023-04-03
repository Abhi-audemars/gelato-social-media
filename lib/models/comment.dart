import 'dart:convert';

class Comment {
  Comment({
    required this.profilePic,
    required this.text,
    required this.uid,
    required this.name,
    required this.commentId,
    required this.datePublished,
    required this.likes,
  });

  String profilePic;
  String text;
  String uid;
  String name;
  final String commentId;
  final String datePublished;
  final List likes;
  factory Comment.fromJson(String str) => Comment.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());
  factory Comment.fromMap(Map<String, dynamic> json) => Comment(
        profilePic: json["profilePic"],
        text: json["text"],
        uid: json["uid"],
        name: json["name"],
        commentId: json["commentId"],
        likes: json["likes"],
        datePublished: json["datePublished"],
      );

  Map<String, dynamic> toMap() => {
        "profilePic": profilePic,
        "text": text,
        "uid": uid,
        "name": name,
        "commentId": commentId,
        "datePublished": datePublished,
        "likes": likes,
      };
}
