// ignore_for_file: prefer_typing_uninitialized_variables

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '/models/user.dart';
import '/controller/user_provider.dart';
import '/resources/firestore_methods.dart';
import '/utils/colors.dart';
import '../utils/global_vairable.dart';
import '../widgets/comment_card.dart';

class CommentsSceeen extends StatefulWidget {
  final snap;
  const CommentsSceeen({Key? key, this.snap}) : super(key: key);

  @override
  State<CommentsSceeen> createState() => _CommentsSceeenState();
}

class _CommentsSceeenState extends State<CommentsSceeen> {
  final TextEditingController commentController = TextEditingController();
  var postUrl;
  var posterUId;
  @override
  void initState() {
    super.initState();
    getPost();
  }

  getPost() async {
    await FirebaseFirestore.instance
        .collection('posts')
        .doc(widget.snap['postId'])
        .get()
        .then((value) {
      postUrl = value.data()!['postUrl'];
      posterUId = value.data()!['uid'];
    });
  }

  @override
  void dispose() {
    super.dispose();
    commentController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final UserModel user = Provider.of<UserProvider>(context).user;
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Comments',
          style: TextStyle(
            color: Theme.of(context).brightness == Brightness.dark
                ? Colors.white
                : Colors.black,
          ),
        ),
      ),
      backgroundColor: Theme.of(context).brightness == Brightness.dark
          ? Colors.black
          : Colors.white,
      body: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('posts')
            .doc(widget.snap['postId'])
            .collection('comments')
            .orderBy('datePublished', descending: true)
            .snapshots(),
        builder: (context,
            AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return circularIndicator(context);
          }
          if (snapshot.hasData) {
            return ListView.builder(
              itemCount: snapshot.data!.docs.length,
              itemBuilder: (context, index) {
                return CommentCard(
                  comment: snapshot.data!.docs[index],
                  postId: widget.snap['postId'],
                );
              },
            );
          }
          return Container();
        },
      ),
      bottomNavigationBar: SafeArea(
          child: Container(
        height: kToolbarHeight,
        margin: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        padding: const EdgeInsets.only(
          left: 16,
          right: 8,
        ),
        child: Row(
          children: [
            CircleAvatar(
              radius: 16,
              backgroundImage: NetworkImage(user.photoUrl),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(left: 16, right: 8),
                child: TextField(
                  controller: commentController,
                  decoration: InputDecoration(
                    hintText: 'Comment as ${user.username}',
                    border: InputBorder.none,
                  ),
                ),
              ),
            ),
            InkWell(
              onTap: () async {
                await FirestoreMethods().postComment(
                  widget.snap['postId'],
                  commentController.text.trim(),
                  user.uid,
                  user.username,
                  user.photoUrl,
                  postUrl,
                  posterUId,
                );
                setState(() {
                  commentController.text = '';
                });
              },
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
                child: const Text(
                  'Post',
                  style: TextStyle(
                    color: blueColor,
                  ),
                ),
              ),
            )
          ],
        ),
      )),
    );
  }
}
