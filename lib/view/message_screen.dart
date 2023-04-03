import 'package:badges/badges.dart'as badge;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:insta_clone/utils/global_vairable.dart';

import '../utils/colors.dart';
import '../widgets/message.dart';
import '../widgets/new_message.dart';

// ignore: must_be_immutable
class MessageScreen extends StatefulWidget {
  MessageScreen({Key? key, required this.user}) : super(key: key);
  String user;
  @override
  State<MessageScreen> createState() => _MessageScreenState();
}

class _MessageScreenState extends State<MessageScreen> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('users')
            .doc(widget.user)
            .snapshots(),
        builder: (context,
            AsyncSnapshot<DocumentSnapshot<Map<String, dynamic>>> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return circularIndicator(context);
          }

          return Scaffold(
            appBar: AppBar(
                title: Row(
              children: [
               badge.Badge(
                  position: const badge.BadgePosition(bottom: -8, end: 0),
                  elevation: 0,
                  borderRadius: BorderRadius.circular(8),
                  badgeContent:
                      const Text('', style: TextStyle(color: Colors.white)),
                  showBadge: snapshot.data!.data()!['status'] == 'Online',
                  animationType: badge.BadgeAnimationType.scale,
                  badgeColor: const Color.fromARGB(255, 21, 228, 28),
                  child: CircleAvatar(
                    backgroundColor: secondaryColor,
                    radius: 16,
                    backgroundImage:
                        NetworkImage(snapshot.data!.data()!['photoUrl']),
                  ),
                ),
                const SizedBox(width: 5),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      snapshot.data!.data()!['username'],
                      style: TextStyle(
                        fontSize: 16,
                        color: Theme.of(context).brightness == Brightness.dark
                            ? primaryColor
                            : Colors.black,
                      ),
                    ),
                    Text(
                      snapshot.data!.data()!['status'],
                      style: TextStyle(
                        fontWeight: FontWeight.w300,
                        fontSize: 12,
                        color: Theme.of(context).brightness == Brightness.dark
                            ? Colors.grey.shade300
                            : Colors.grey.shade900,
                      ),
                    ),
                  ],
                )
              ],
            )),
            body: Column(
              children: [
                Expanded(
                    child: Messages(
                  user: widget.user,
                  userImage: snapshot.data!.data()!['photoUrl'],
                  chatName: snapshot.data!.data()!['username'],
                )),
                NewMessage(user: widget.user),
              ],
            ),
          );
        });
  }
}
