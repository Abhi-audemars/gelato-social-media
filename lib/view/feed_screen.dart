import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shimmer/shimmer.dart';
import 'inbox_screen.dart';
import '../utils/global_vairable.dart';
import '../widgets/post_card.dart';

class FeedScreen extends StatefulWidget {
  const FeedScreen({Key? key}) : super(key: key);

  @override
  State<FeedScreen> createState() => _FeedScreenState();
}

class _FeedScreenState extends State<FeedScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).brightness == Brightness.light
          ? Colors.grey[300]
          : Colors.grey[900],
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Theme.of(context).brightness == Brightness.dark
            ? Colors.grey[900]
            : Colors.grey[300],
        title: Shimmer.fromColors(
          baseColor: Colors.purple,
          highlightColor: Colors.pinkAccent,
          child: Text(
            'GELATO',
            style: GoogleFonts.poppins(
              textStyle:
                  const TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
            ),
          ),
        ),
        centerTitle: false,
        actions: [
          // Padding(
          //   padding: const EdgeInsets.symmetric(horizontal: 12.0),
          //   child: GestureDetector(
          //     onTap: () {
          //       Navigator.push(context,
          //           MaterialPageRoute(builder: (context) =>const InboxScreen(),),);
          //     },
          //     child:
          //     // SvgPicture.asset(
          //     //   sendIcon,
          //     //   color: Theme.of(context).brightness == Brightness.dark
          //     //       ? primaryColor
          //     //       : Colors.black,
          //     //   height: 20,
          //     // ),
          //     Icon(Icons.chat_sharp)
          //   ),
          // )
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const InboxScreen(),
                  ),
                );
              },
              child: Container(
                height: 30,
                width: 40,
                decoration: BoxDecoration(
                  color: Theme.of(context).brightness == Brightness.dark
                      ? Colors.grey[900]
                      : Colors.grey[300],
                  borderRadius: BorderRadius.circular(40),
                  boxShadow: [
                    BoxShadow(
                      color: Theme.of(context).brightness == Brightness.light
                          ? Colors.grey.shade600
                          : Colors.black,
                      offset: const Offset(6, 6),
                      blurRadius: 10,
                    ),
                    BoxShadow(
                      color: Theme.of(context).brightness == Brightness.light
                          ? Colors.white
                          : const Color.fromARGB(
                              255,
                              53,
                              53,
                              53,
                            ),
                      offset: const Offset(
                        -4,
                        -4,
                      ),
                      blurRadius: 2,
                    )
                  ],
                ),
                child: const Icon(
                  Icons.chat_bubble_outline_outlined,
                  color: Colors.purple,
                ),
              ),
            ),
          ),
        ],
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance.collection('posts').snapshots(),
        builder: (context,
            AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return circularIndicator(context);
          } else if (snapshot.hasData) {
            return ListView.builder(
              itemCount: snapshot.data!.docs.length,
              itemBuilder: (context, index) {
                return PostCard(post: snapshot.data!.docs[index]);
              },
            );
          } else if (snapshot.hasError) {
            return const Center(child: Text('Something went Wrong!'));
          } else {
            return const Center(
              child: Text(
                  'You have no Feed to Show Start following people to get feed from peoples'),
            );
          }
        },
      ),
    );
  }
}
