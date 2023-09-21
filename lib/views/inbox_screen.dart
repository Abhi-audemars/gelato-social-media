import 'package:badges/badges.dart'as badge;
import 'package:cloud_firestore/cloud_firestore.dart';
import '/utils/colors.dart';
import '/utils/global_vairable.dart';
import 'message_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class InboxScreen extends StatefulWidget {
  const InboxScreen({Key? key}) : super(key: key);

  @override
  State<InboxScreen> createState() => _InboxScreenState();
}

class _InboxScreenState extends State<InboxScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // UserModel user = Provider.of<UserProvider>(context).user;
    return Scaffold(
      appBar: AppBar(
          title: Text(
        'Inbox',
        style: TextStyle(
            color: Theme.of(context).brightness == Brightness.dark
                ? primaryColor
                : Colors.black),
      )),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: StreamBuilder(
                stream: FirebaseFirestore.instance
                    .collection(
                        'chat/${FirebaseAuth.instance.currentUser!.uid}/receiver')
                    .snapshots(),
                builder: (context,
                    AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>>
                        snapshot) {

                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return circularIndicator(context);
                  } else if (snapshot.hasData) {
                    return ListView.builder(
                      itemCount: snapshot.data!.docs.length,
                      itemBuilder: (context, index) {
                        var doc = snapshot.data!.docs[index];
                        return StreamBuilder(
                          stream: FirebaseFirestore.instance
                              .collection('users')
                              .doc(doc.data()['uid'])
                              .snapshots(),
                          builder: (context,
                              AsyncSnapshot<
                                      DocumentSnapshot<Map<String, dynamic>>>
                                  snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return circularIndicator(context);
                            } else if (snapshot.hasData) {
                              return Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 4.0),
                                child: ListTile(
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => MessageScreen(
                                          user: snapshot.data!.data()!['uid'],
                                        ),
                                      ),
                                    );
                                  },
                                  leading: badge.Badge(
                                    // position:
                                    //     const BadgePosition(bottom: -5, end: 0),
                                    position:const badge.BadgePosition(bottom: -5,end: 0),
                                    elevation: 0,
                                    borderRadius: BorderRadius.circular(8),
                                    borderSide: const BorderSide(
                                      color: Colors.white,
                                      width: 1.5,
                                    ),
                                    badgeContent: const Text('',
                                        style: TextStyle(color: Colors.white)),
                                    showBadge:
                                        snapshot.data!.data()!['status'] ==
                                            'Online',
                                    animationType: badge.BadgeAnimationType.scale,
                                    badgeColor:
                                        const Color.fromARGB(255, 21, 228, 28),
                                    child: CircleAvatar(
                                      backgroundColor: secondaryColor,
                                      radius: 24,
                                      backgroundImage: NetworkImage(
                                          snapshot.data!.data()!['photoUrl']),
                                    ),
                                  ),
                                  title:
                                      Text(snapshot.data!.data()!['username']),
                                  subtitle:
                                      Text(snapshot.data!.data()!['status']),
                                  trailing:
                                      const Icon(Icons.camera_alt_outlined),
                                ),
                              );
                            }

                            return const Center(
                              child: Text('Something Went Down.'),
                            );
                          },
                        );
                      },
                    );
                  } else {
                    return const Center(
                      child: Text('Something Went Down.'),
                    );
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
