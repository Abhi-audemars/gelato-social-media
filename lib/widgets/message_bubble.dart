// ignore_for_file: deprecated_member_use, use_key_in_widget_constructors, overridden_fields

import 'package:flutter/material.dart';
import 'package:readmore/readmore.dart';
import '../utils/colors.dart';

class MessageBubble extends StatelessWidget {
  final String message;
  final bool isMe;
  @override
  final Key key;
  final String username;
  final String userImage;
  const MessageBubble(
    this.message,
    this.isMe,
    this.username, {
    required this.key,
    required this.userImage,
  });
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
      children: [
        !isMe
            ? Padding(
                padding: const EdgeInsets.only(left: 14.0),
                child: CircleAvatar(
                  radius: 16,
                  backgroundColor: Colors.grey,
                  backgroundImage: NetworkImage(userImage),
                ),
              )
            : Container(),
        Container(
          decoration: BoxDecoration(
            border: Border.all(
              color: Theme.of(context).brightness == Brightness.dark
                  ? Colors.grey.shade900
                  : Colors.grey.shade200,
            ),
            color: !isMe
                ? Colors.transparent
                : Theme.of(context).brightness == Brightness.dark
                    ? Colors.grey.shade900
                    : Colors.grey.shade200,
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(20),
              topRight: Radius.circular(20),
              bottomLeft: Radius.circular(20),
              bottomRight: Radius.circular(20),
            ),
          ),
          constraints:
              BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.7),
          padding: const EdgeInsets.symmetric(
            vertical: 10,
            horizontal: 16,
          ),
          margin: const EdgeInsets.symmetric(
            horizontal: 8,
            vertical: 4,
          ),
          child: Column(
            crossAxisAlignment:
                isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
            children: [
              ReadMoreText(
                message,
                trimCollapsedText: ' show more',
                trimExpandedText: ' show less',
                trimLines: 3,
                trimMode: TrimMode.Line,
                lessStyle: const TextStyle(color: secondaryColor, fontSize: 12),
                moreStyle: const TextStyle(color: secondaryColor, fontSize: 12),
                textAlign: isMe ? TextAlign.end : TextAlign.start,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
