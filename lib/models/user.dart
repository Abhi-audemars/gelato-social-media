import 'dart:convert';

class UserModel {
  UserModel({
    required this.username,
    required this.uid,
    required this.email,
    required this.bio,
    required this.photoUrl,
    required this.follower,
    required this.following,
    required this.status,
  });
  String status;
  String username;
  String uid;
  String email;
  String bio;
  String photoUrl;
  List follower;
  List following;

  factory UserModel.fromJson(String str) => UserModel.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory UserModel.fromMap(Map<String, dynamic> json) => UserModel(
        username: json["username"],
        status: json["status"],
        uid: json["uid"],
        email: json["email"],
        bio: json["bio"],
        photoUrl: json["photoUrl"],
        follower: List.from(json["follower"].map((x) => x)),
        following: List.from(json["following"].map((x) => x)),
      );

  Map<String, dynamic> toMap() => {
        "status": status,
        "username": username,
        "uid": uid,
        "email": email,
        "bio": bio,
        "photoUrl": photoUrl,
        "follower": List.from(follower.map((x) => x)),
        "following": List.from(following.map((x) => x)),
      };
}
