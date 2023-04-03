// ignore_for_file: override_on_non_overriding_member, must_be_immutable

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '/view/profile_screen.dart';
import '/widgets/follow_button.dart';

import 'message_bubble.dart';

class Messages extends StatelessWidget {
  Messages({
    Key? key,
    required this.user,
    required this.userImage,
    required this.chatName,
  }) : super(key: key);
  String user;
  String chatName;
  final String userImage;
  @protected
  @mustCallSuper
  @override
  void initState() {
    getUid();
  }

  getUid() async {}

  @override
  Widget build(BuildContext context) {
    getUid();
    return StreamBuilder(
      stream: FirebaseFirestore.instance
          .collection(
              'chat/${FirebaseAuth.instance.currentUser!.uid}/receiver/$user/message/')
          .orderBy(
            'createdAt',
            descending: true,
          )
          .snapshots(),
      builder: (ctx, AsyncSnapshot<QuerySnapshot> snapShotChat) {
        if (snapShotChat.hasError) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        } else {
          if (snapShotChat.hasData) {
            debugPrint(snapShotChat.data!.docs[0]['username']);
            return ListView.builder(
              reverse: true,
              itemCount: snapShotChat.data!.docs.length,
              itemBuilder: (ctx, index) => Column(
                children: [
                  index == snapShotChat.data!.docs.length - 1
                      ? Column(
                          children: [
                            CircleAvatar(
                              radius: 50,
                              backgroundColor: Colors.grey,
                              backgroundImage: NetworkImage(userImage),
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            Text(
                             chatName,
                              style: TextStyle(
                                color: Theme.of(context).brightness ==
                                        Brightness.dark
                                    ? Colors.white
                                    : Colors.black,
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                              ),
                            ),
                            Text(
                              'Instagram',
                              style: TextStyle(
                                color: Theme.of(context).brightness ==
                                        Brightness.dark
                                    ? Colors.white
                                    : Colors.black,
                                fontSize: 14,
                              ),
                            ),
                            const SizedBox(
                              height: 3,
                            ),
                            Text(
                              'You follow each other on instagram',
                              style: TextStyle(
                                color: Theme.of(context).brightness ==
                                        Brightness.dark
                                    ? Colors.grey.shade500
                                    : Colors.grey.shade500,
                                fontSize: 14,
                              ),
                            ),
                            SizedBox(
                              width: 130,
                              child: FollowButton(
                                label: 'View Profile',
                                backgroundColor: Theme.of(context).brightness ==
                                        Brightness.dark
                                    ? Colors.grey.shade800
                                    : Colors.grey.shade200,
                                borderColor: Colors.transparent,
                                textColor: Theme.of(context).brightness ==
                                        Brightness.dark
                                    ? Colors.white
                                    : Colors.black,
                                onPressed: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            ProfileScreen(user),
                                      ));
                                },
                              ),
                            )
                          ],
                        )
                      : Container(),
                  MessageBubble(
                    snapShotChat.data!.docs[index]['text'],
                    snapShotChat.data!.docs[index]['userId'] ==
                        FirebaseAuth.instance.currentUser!.uid,
                    snapShotChat.data!.docs[index]['username'],
                    userImage: userImage,
                    key: ValueKey(snapShotChat.data!.docs[index].id),
                  ),
                ],
              ),
            );
          } else {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
        }
      },
    );
  }
}
