import 'dart:convert';

class Post {
  Post({
    required this.description,
    required this.username,
    required this.uid,
    required this.postId,
    required this.datePublished,
    required this.profImage,
    required this.postUrl,
    required this.likes,
  });

  String description;
  String username;
  String uid;
  String postId;
  final String datePublished;
  String postUrl;
  String profImage;
  final List likes;
  factory Post.fromJson(String str) => Post.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());
  factory Post.fromMap(Map<String, dynamic> json) => Post(
        description: json["description"],
        username: json["username"],
        uid: json["uid"],
        postId: json["postId"],
        datePublished: json["datePublished"],
        likes: json["likes"],
        postUrl: json["postUrl"],
        profImage: json["profImage"],
      );

  Map<String, dynamic> toMap() => {
        "description": description,
        "username": username,
        "uid": uid,
        "postId": postId,
        "datePublished": datePublished,
        "profImage": profImage,
        "postUrl": postUrl,
        "likes": likes,
      };
}
