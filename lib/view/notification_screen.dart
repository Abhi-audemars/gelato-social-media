import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get_time_ago/get_time_ago.dart';
import 'package:google_fonts/google_fonts.dart';
import '../utils/global_vairable.dart';

class ActivityScreen extends StatefulWidget {
  const ActivityScreen({Key? key}) : super(key: key);

  @override
  State<ActivityScreen> createState() => ActivityScreenState();
}

class ActivityScreenState extends State<ActivityScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).brightness == Brightness.light
          ? Colors.grey[300]
          : Colors.grey[900],
      appBar: AppBar(
        backgroundColor: Theme.of(context).brightness == Brightness.light
            ? Colors.grey[300]
            : Colors.grey[900],
        title: Text(
          'Notifications',
          style: TextStyle(
            fontSize: 18,
            color: Theme.of(context).brightness == Brightness.light
                ? Colors.black
                : Colors.white,
          ),
        ),
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection(
                '/users/${FirebaseAuth.instance.currentUser!.uid}/activity')
            .orderBy('datePublished', descending: true)
            .snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (!snapshot.hasData) {
            return circularIndicator(context);
          }
          return ListView.builder(
            itemCount: snapshot.data!.docs.length,
            itemBuilder: (context, index) {
              var doc = snapshot.data!.docs[index];
              var date = doc['datePublished'];
              var finalDate = DateTime.parse(date.toString());
              var activityItem = ListTile(
                leading: CircleAvatar(
                  backgroundColor: Colors.grey,
                  radius: 22,
                  backgroundImage: NetworkImage(doc['profilePic']),
                ),
                title: Row(
                  children: [
                    Text(
                      '${doc['name']} ',
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                    ),
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.38,
                      child: Text(
                        !doc['isLike']
                            ? 'commented on your post'
                            : 'liked your post',
                        style: const TextStyle(
                          fontSize: 14,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ),
                  ],
                ),
                subtitle: Text(
                  GetTimeAgo.parse(finalDate),
                  style: GoogleFonts.poppins(
                    textStyle: const TextStyle(
                      fontWeight: FontWeight.normal,
                      fontSize: 12,
                    ),
                  ),
                ),
                trailing: SizedBox(
                  width: 50,
                  height: 50,
                  child: Image.network(
                    doc['postUrl'],
                    fit: BoxFit.cover,
                  ),
                ),
              );
              return activityItem;
            },
          );
        },
      ),
    );
  }
}
