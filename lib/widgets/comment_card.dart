// ignore_for_file: prefer_typing_uninitialized_variables

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:readmore/readmore.dart';

import '/models/user.dart';
import '/controller/user_provider.dart';
import '/resources/firestore_methods.dart';
import '../utils/colors.dart';

class CommentCard extends StatefulWidget {
  final comment;
  final postId;
  const CommentCard({
    Key? key,
    required this.comment,
    this.postId,
  }) : super(key: key);

  @override
  State<CommentCard> createState() => _CommentCardState();
}

class _CommentCardState extends State<CommentCard> {
  @override
  Widget build(BuildContext context) {
    UserModel user = Provider.of<UserProvider>(context).user;
    return Container(
      padding: const EdgeInsets.symmetric(
        vertical: 18,
        horizontal: 16,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Wrap(
            children: [
              CircleAvatar(
                radius: 18,
                backgroundColor: secondaryColor,
                backgroundImage: NetworkImage(widget.comment['profilePic']),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.7,
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Text(
                            '${widget.comment['name']} ',
                            style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                overflow: TextOverflow.ellipsis),
                          ),
                          Expanded(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                ReadMoreText(
                                  widget.comment['text'],
                                  trimCollapsedText: ' show more',
                                  trimExpandedText: ' show less',
                                  trimLines: 3,
                                  trimMode: TrimMode.Line,
                                  lessStyle: const TextStyle(
                                      color: secondaryColor, fontSize: 12),
                                  moreStyle: const TextStyle(
                                      color: secondaryColor, fontSize: 12),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    Row(
                      children: [
                        Text(
                          DateFormat.yMMMd()
                              .format(DateTime.parse(
                                  widget.comment['datePublished'].toString()))
                              .toString(),
                          style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w400,
                            color: secondaryColor,
                          ),
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        Text(
                          '${widget.comment['likes'].length} like',
                          style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w400,
                            color: secondaryColor,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
          GestureDetector(
            onTap: () async {
              await FirestoreMethods().likeComment(
                widget.postId,
                user.uid,
                widget.comment['likes'],
                widget.comment['commentId'],
              );
            },
            child: Container(
              padding: const EdgeInsets.all(8),
              child: widget.comment['likes'].contains(user.uid)
                  ? const Icon(
                      Icons.favorite,
                      color: Colors.red,
                      size: 15,
                    )
                  : const Icon(
                      Icons.favorite_outline,
                      size: 15,
                    ),
            ),
          )
        ],
      ),
    );
  }
}
