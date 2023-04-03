// ignore_for_file: prefer_typing_uninitialized_variables

import 'package:flutter/material.dart';
import '/widgets/post_card.dart';

class PostDetailScreen extends StatelessWidget {
  final post;
  const PostDetailScreen({Key? key, this.post}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Photo',
          style: TextStyle(
            color: Theme.of(context).brightness == Brightness.dark
                ? Colors.white
                : Colors.black,
          ),
        ),
      ),
      body: ListView(
        children: [
          PostCard(post: post),
        ],
      ),
    );
  }
}
