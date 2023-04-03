// ignore_for_file: avoid_print, empty_catches

import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:uuid/uuid.dart';

import '/models/comment.dart';
import '/resources/storage_methods.dart';
import '../models/activity.dart';
import '../models/post.dart';

class FirestoreMethods {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  updateStatus(String status) async {
    try {
      await _firestore
          .collection('users')
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .update({
        'status': status,
      });
    } catch (e) {}
  }

  uploadPost(
    String uid,
    String description,
    String username,
    String profImage,
    Uint8List file,
  ) async {
    String res = 'Something went wrong';
    try {
      String photoUrl =
          await StorageMethods().uploadImageToStorage('posts', file, true);
      String postId = const Uuid().v1();
      Post post = Post(
        description: description,
        uid: uid,
        username: username,
        postId: postId,
        datePublished: DateTime.now().toString(),
        postUrl: photoUrl,
        profImage: profImage,
        likes: [],
      );
      _firestore.collection('posts').doc(postId).set(post.toMap());
      res = 'success';
    } catch (e) {
      res = e.toString();
    }
    return res;
  }

  likePost(
    String postId,
    String uid,
    String profilePic,
    String name,
    String postUrl,
    String posterUid,
    List likes,
  ) async {
    try {
      if (likes.contains(uid)) {
        await _firestore.collection('posts').doc(postId).update({
          'likes': FieldValue.arrayRemove([uid])
        });
      } else {
        Activity activity = Activity(
          profilePic: profilePic,
          postUrl: postUrl,
          uid: uid,
          name: name,
          datePublished: DateTime.now().toString(),
          isLike: true,
        );
        await _firestore
            .collection('users')
            .doc(posterUid)
            .collection('activity')
            .add(activity.toMap());
        await _firestore.collection('posts').doc(postId).update({
          'likes': FieldValue.arrayUnion([uid])
        });
      }
    } catch (e) {
      print(e.toString());
    }
  }

  postComment(
    String postId,
    String text,
    String uid,
    String name,
    String profilePic,
    String postUrl,
    String posterUId,
  ) async {
    try {
      if (text.isNotEmpty) {
        String commentId = const Uuid().v1();
        Comment comment = Comment(
          profilePic: profilePic,
          text: text,
          uid: uid,
          name: name,
          commentId: commentId,
          datePublished: DateTime.now().toString(),
          likes: [],
        );
        await _firestore
            .collection('posts')
            .doc(postId)
            .collection('comments')
            .doc(commentId)
            .set(comment.toMap());
        Activity activity = Activity(
          profilePic: profilePic,
          postUrl: postUrl,
          uid: uid,
          name: name,
          datePublished: DateTime.now().toString(),
          isLike: false,
        );
        await _firestore
            .collection('users')
            .doc(posterUId)
            .collection('activity')
            .add(activity.toMap());
      } else {
        print('Text is Empty');
      }
    } catch (e) {}
  }

  likeComment(String postId, String uid, List likes, String commentId) async {
    try {
      if (likes.contains(uid)) {
        await _firestore
            .collection('posts')
            .doc(postId)
            .collection('comments')
            .doc(commentId)
            .update({
          'likes': FieldValue.arrayRemove([uid])
        });
      } else {
        await _firestore
            .collection('posts')
            .doc(postId)
            .collection('comments')
            .doc(commentId)
            .update({
          'likes': FieldValue.arrayUnion([uid])
        });
      }
    } catch (e) {
      print(e.toString());
    }
  }

  deletePost(String postId) async {
    try {
      await _firestore.collection('posts').doc(postId).delete();
    } catch (e) {
      print(e.toString());
    }
  }

  followUser(
    String uid,
    String followId,
  ) async {
    try {
      DocumentSnapshot snap =
          await _firestore.collection('users').doc(uid).get();
      List following = (snap.data() as dynamic)['following'];

      if (following.contains(followId)) {
        await _firestore.collection('users').doc(followId).update({
          'follower': FieldValue.arrayRemove([uid])
        });
        await _firestore.collection('users').doc(uid).update({
          'following': FieldValue.arrayRemove([followId])
        });
      } else {
        await _firestore.collection('users').doc(followId).update({
          'follower': FieldValue.arrayUnion([uid])
        });
        await _firestore.collection('users').doc(uid).update({
          'following': FieldValue.arrayUnion([followId])
        });
      }
    } catch (e) {
      print(e.toString());
    }
  }
}
