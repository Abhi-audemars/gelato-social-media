// ignore_for_file: use_build_context_synchronously, must_be_immutable
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:insta_clone/utils/frosted_glass.dart';
import '/view/message_screen.dart';
import '/resources/auth_methods.dart';
import '/resources/firestore_methods.dart';
import '/view/login_screen.dart';
import '/view/post_detail_screen.dart';
import '/utils/utils.dart';
import '../utils/global_vairable.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

class ProfileScreen extends StatefulWidget {
  String uid;
  ProfileScreen(this.uid, {Key? key}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  var userData = {};
  int postLen = 0;
  int followers = 0;
  int following = 0;
  bool isFollowing = false;
  bool _isloading = false;
  @override
  void initState() {
    if (widget.uid == 'Current') {
      widget.uid = FirebaseAuth.instance.currentUser!.uid.toString();
    }
    super.initState();
    getData();
  }

  getData() async {
    setState(() {
      _isloading = true;
    });
    try {
      var snap = await FirebaseFirestore.instance
          .collection('users')
          .doc(widget.uid)
          .get();
      var postSnap = await FirebaseFirestore.instance
          .collection('posts')
          .where('uid', isEqualTo: widget.uid)
          .get();
      postLen = postSnap.docs.length;
      userData = snap.data()!;
      followers = snap.data()!['follower'].length;
      following = snap.data()!['following'].length;
      isFollowing = snap
          .data()!['follower']
          .contains(FirebaseAuth.instance.currentUser!.uid);
    } catch (e) {
      showSnackBar(e.toString(), context);
    }
    setState(() {
      _isloading = false;
    });
  }

  @override
  void dispose() {
    super.dispose();
    widget.uid = '';
  }

  var top = 0.0;

  @override
  Widget build(BuildContext context) {
    return _isloading
        ? circularIndicator(context)
        : Scaffold(
            backgroundColor: Theme.of(context).brightness == Brightness.dark
                ? Colors.grey[900]
                : Colors.grey[300],
            body: CustomScrollView(
              scrollDirection: Axis.vertical,
              slivers: [
                SliverAppBar(
                  pinned: true,
                  expandedHeight: 250,
                  flexibleSpace: LayoutBuilder(
                    builder: (context, index) {
                      top = index.biggest.height;
                      return FlexibleSpaceBar(
                        background: Container(
                          alignment: Alignment.bottomLeft,
                          decoration: BoxDecoration(
                            image: DecorationImage(
                              fit: BoxFit.cover,
                              image: NetworkImage(userData['photoUrl']),
                            ),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.only(
                                left: 10, right: 10, bottom: 5),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  child: FrostedGlass(
                                    onPressed: () {},
                                    label: Column(
                                      children: [
                                        Text(
                                          postLen.toString(),
                                          style: const TextStyle(
                                              color: Colors.white,
                                              fontSize: 25,
                                              fontWeight: FontWeight.bold),
                                        ),
                                        const Text(
                                          'Posts',
                                          style:
                                              TextStyle(color: Colors.white70),
                                        )
                                      ],
                                    ),
                                    height: 50.0,
                                    // width: 40.0,
                                  ),
                                ),
                                const SizedBox(width: 20),
                                Expanded(
                                  child: FrostedGlass(
                                    onPressed: () {},
                                    label: Column(
                                      children: [
                                        Text(
                                          followers.toString(),
                                          style: const TextStyle(
                                              color: Colors.white,
                                              fontSize: 25,
                                              fontWeight: FontWeight.bold),
                                        ),
                                        const Text(
                                          'Followers',
                                          style:
                                              TextStyle(color: Colors.white70),
                                        )
                                      ],
                                    ),
                                    height: 50.0,
                                    // width: 40.0,
                                  ),
                                ),
                                const SizedBox(width: 20),
                                Expanded(
                                  child: FrostedGlass(
                                    onPressed: () {},
                                    label: Column(
                                      children: [
                                        Text(
                                          following.toString(),
                                          style: const TextStyle(
                                              color: Colors.white,
                                              fontSize: 25,
                                              fontWeight: FontWeight.bold),
                                        ),
                                        const Text(
                                          'Following',
                                          style:
                                              TextStyle(color: Colors.white70),
                                        )
                                      ],
                                    ),
                                    height: 50.0,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        centerTitle: true,
                        title: AnimatedOpacity(
                          duration: const Duration(milliseconds: 300),
                          opacity: top <= 130 ? 1.0 : 0.0,
                          child: Padding(
                            padding: const EdgeInsets.only(top: 15, left: 28),
                            child: ListTile(
                              leading: CircleAvatar(
                                backgroundImage:
                                    NetworkImage(userData['photoUrl']),
                              ),
                              title: Text(
                                userData['username'],
                                style: TextStyle(
                                    color: Theme.of(context).brightness ==
                                            Brightness.dark
                                        ? Colors.white
                                        : Colors.black,
                                    fontWeight: FontWeight.bold),
                              ),
                              subtitle: Text(userData['bio']),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
                SliverToBoxAdapter(
                  child: Column(
                    children: [
                      Text(
                        userData['username'],
                        style: GoogleFonts.poppins(
                          textStyle: const TextStyle(
                              fontWeight: FontWeight.w500, fontSize: 20),
                        ),
                      ),
                      Text(
                        userData['bio'],
                        style: GoogleFonts.poppins(
                          textStyle: const TextStyle(
                              fontWeight: FontWeight.normal,
                              fontSize: 15,
                              color: Colors.grey),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Expanded(
                              child: FirebaseAuth.instance.currentUser!.uid ==
                                      widget.uid
                                  ? Theme.of(context).brightness ==
                                          Brightness.dark
                                      ? FrostedGlass(
                                          label: const Text('Sign Out'),
                                          height: 40.0,
                                          borderColor:
                                              Theme.of(context).brightness ==
                                                      Brightness.dark
                                                  ? Colors.grey.shade300
                                                  : Colors.grey.shade900,
                                          textColor:
                                              Theme.of(context).brightness ==
                                                      Brightness.dark
                                                  ? Colors.white
                                                  : Colors.black,
                                          onPressed: () async {
                                            await FirestoreMethods()
                                                .updateStatus('Offline');
                                            await AuthMethods().signOut();

                                            Navigator.pushAndRemoveUntil(
                                                context,
                                                MaterialPageRoute(
                                                  builder: (context) =>
                                                      const LoginScreen(),
                                                ),
                                                (route) => false);
                                          },
                                        )
                                      : Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 10),
                                          child: InkWell(
                                            onTap: () async {
                                              await FirestoreMethods()
                                                  .updateStatus('Offline');
                                              await AuthMethods().signOut();

                                              Navigator.pushAndRemoveUntil(
                                                  context,
                                                  MaterialPageRoute(
                                                    builder: (context) =>
                                                        const LoginScreen(),
                                                  ),
                                                  (route) => false);
                                            },
                                            child: Container(
                                              height: 40,
                                              decoration: BoxDecoration(
                                                color: Theme.of(context)
                                                            .brightness ==
                                                        Brightness.dark
                                                    ? Colors.grey[900]
                                                    : Colors.grey[300],
                                                borderRadius:
                                                    BorderRadius.circular(20),
                                                boxShadow: [
                                                  BoxShadow(
                                                    color: Theme.of(context)
                                                                .brightness ==
                                                            Brightness.light
                                                        ? Colors.grey.shade600
                                                        : Colors.black,
                                                    offset: const Offset(6, 6),
                                                    blurRadius: 15,
                                                  ),
                                                  BoxShadow(
                                                    color: Theme.of(context)
                                                                .brightness ==
                                                            Brightness.light
                                                        ? Colors.white
                                                        : const Color.fromARGB(
                                                            255, 53, 53, 53),
                                                    offset:
                                                        const Offset(-6, -6),
                                                    blurRadius: 2,
                                                  )
                                                ],
                                              ),
                                              child: const Center(
                                                child: Text(
                                                  'Sign out',
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ),
                                              ),
                                            ),
                                          ),
                                        )
                                  : isFollowing
                                      ? Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceAround,
                                          children: [
                                            Theme.of(context).brightness ==
                                                    Brightness.dark
                                                ? Expanded(
                                                    child: FrostedGlass(
                                                      label: const Text(
                                                        'Unfollow',
                                                        style: TextStyle(
                                                            fontWeight:
                                                                FontWeight
                                                                    .bold),
                                                      ),
                                                      height: 40.0,
                                                      textColor: Theme.of(
                                                                      context)
                                                                  .brightness ==
                                                              Brightness.dark
                                                          ? Colors.white
                                                          : Colors.black,
                                                      onPressed: () async {
                                                        await FirestoreMethods()
                                                            .followUser(
                                                                FirebaseAuth
                                                                    .instance
                                                                    .currentUser!
                                                                    .uid,
                                                                userData[
                                                                    'uid']);
                                                        setState(
                                                          () {
                                                            isFollowing = false;
                                                            followers--;
                                                          },
                                                        );
                                                      },
                                                    ),
                                                  )
                                                : Expanded(
                                                    child: GestureDetector(
                                                      onTap: () async {
                                                        await FirestoreMethods()
                                                            .followUser(
                                                                FirebaseAuth
                                                                    .instance
                                                                    .currentUser!
                                                                    .uid,
                                                                userData[
                                                                    'uid']);
                                                        setState(
                                                          () {
                                                            isFollowing = false;
                                                            followers--;
                                                          },
                                                        );
                                                      },
                                                      child: Container(
                                                        height: 40,
                                                        decoration:
                                                            BoxDecoration(
                                                          color: Theme.of(context)
                                                                      .brightness ==
                                                                  Brightness
                                                                      .dark
                                                              ? Colors.grey[900]
                                                              : Colors
                                                                  .grey[300],
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(20),
                                                          boxShadow: [
                                                            BoxShadow(
                                                              color: Theme.of(context)
                                                                          .brightness ==
                                                                      Brightness
                                                                          .light
                                                                  ? Colors.grey
                                                                      .shade600
                                                                  : Colors
                                                                      .black,
                                                              offset:
                                                                  const Offset(
                                                                      6, 6),
                                                              blurRadius: 10,
                                                            ),
                                                            BoxShadow(
                                                              color: Theme.of(context)
                                                                          .brightness ==
                                                                      Brightness
                                                                          .light
                                                                  ? Colors.white
                                                                  : const Color
                                                                          .fromARGB(
                                                                      255,
                                                                      53,
                                                                      53,
                                                                      53),
                                                              offset:
                                                                  const Offset(
                                                                      -4, -4),
                                                              blurRadius: 2,
                                                            )
                                                          ],
                                                        ),
                                                        child: const Center(
                                                          child: Text(
                                                            'Unfollow ',
                                                            style: TextStyle(
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold),
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                            const SizedBox(width: 4),
                                            Theme.of(context).brightness ==
                                                    Brightness.dark
                                                ? Expanded(
                                                    child: FrostedGlass(
                                                      label: const Text(
                                                        'Message',
                                                        style: TextStyle(
                                                            fontWeight:
                                                                FontWeight
                                                                    .bold),
                                                      ),
                                                      height: 40.0,
                                                      textColor: Theme.of(
                                                                      context)
                                                                  .brightness ==
                                                              Brightness.dark
                                                          ? Colors.white
                                                          : Colors.black,
                                                      onPressed: () async {
                                                        Navigator.of(context)
                                                            .push(
                                                          MaterialPageRoute(
                                                            builder: (context) =>
                                                                MessageScreen(
                                                              user: userData[
                                                                  'uid'],
                                                            ),
                                                          ),
                                                        );
                                                      },
                                                    ),
                                                  )
                                                : Expanded(
                                                    child: GestureDetector(
                                                      onTap: () async {
                                                        Navigator.of(context)
                                                            .push(
                                                          MaterialPageRoute(
                                                            builder: (context) =>
                                                                MessageScreen(
                                                              user: userData[
                                                                  'uid'],
                                                            ),
                                                          ),
                                                        );
                                                      },
                                                      child: Container(
                                                        height: 40,
                                                        decoration:
                                                            BoxDecoration(
                                                          color: Theme.of(context)
                                                                      .brightness ==
                                                                  Brightness
                                                                      .dark
                                                              ? Colors.grey[900]
                                                              : Colors
                                                                  .grey[300],
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(20),
                                                          boxShadow: [
                                                            BoxShadow(
                                                              color: Theme.of(context)
                                                                          .brightness ==
                                                                      Brightness
                                                                          .light
                                                                  ? Colors.grey
                                                                      .shade600
                                                                  : Colors
                                                                      .black,
                                                              offset:
                                                                  const Offset(
                                                                      6, 6),
                                                              blurRadius: 10,
                                                            ),
                                                            BoxShadow(
                                                              color: Theme.of(context)
                                                                          .brightness ==
                                                                      Brightness
                                                                          .light
                                                                  ? Colors.white
                                                                  : const Color
                                                                      .fromARGB(
                                                                      255,
                                                                      53,
                                                                      53,
                                                                      53,
                                                                    ),
                                                              offset:
                                                                  const Offset(
                                                                -4,
                                                                -4,
                                                              ),
                                                              blurRadius: 2,
                                                            )
                                                          ],
                                                        ),
                                                        child: const Center(
                                                          child: Text(
                                                            'Message',
                                                            style: TextStyle(
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold),
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                          ],
                                        )
                                      :
                                      // Theme.of(context).brightness ==
                                      //         Brightness.dark
                                      //     ?
                                      Padding(
                                          padding: const EdgeInsets.only(
                                              left: 20, right: 20),
                                          child: FrostedGlass(
                                            label: const Text(
                                              'Follow',
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold),
                                            ),
                                            height: 40.0,
                                            borderColor: Colors.white,
                                            textColor: Colors.white,
                                            onPressed: () async {
                                              await FirestoreMethods()
                                                  .followUser(
                                                      FirebaseAuth.instance
                                                          .currentUser!.uid,
                                                      userData['uid']);
                                              setState(
                                                () {
                                                  isFollowing = true;
                                                  followers++;
                                                },
                                              );
                                            },
                                          ),
                                        )
                              // : Expanded(
                              //     child: GestureDetector(
                              //       onTap: () async {
                              //         await FirestoreMethods()
                              //             .followUser(
                              //                 FirebaseAuth.instance
                              //                     .currentUser!.uid,
                              //                 userData['uid']);
                              //         setState(
                              //           () {
                              //             isFollowing = true;
                              //             followers++;
                              //           },
                              //         );
                              //       },
                              //       child: Container(
                              //         height: 40,
                              //         decoration: BoxDecoration(
                              //           color: Theme.of(context)
                              //                       .brightness ==
                              //                   Brightness.dark
                              //               ? Colors.grey[900]
                              //               : Colors.grey[300],
                              //           borderRadius:
                              //               BorderRadius.circular(20),
                              //           boxShadow: [
                              //             BoxShadow(
                              //               color: Theme.of(context)
                              //                           .brightness ==
                              //                       Brightness.light
                              //                   ? Colors.grey.shade600
                              //                   : Colors.black,
                              //               offset:
                              //                   const Offset(6, 6),
                              //               blurRadius: 10,
                              //             ),
                              //             BoxShadow(
                              //               color: Theme.of(context)
                              //                           .brightness ==
                              //                       Brightness.light
                              //                   ? Colors.white
                              //                   : const Color
                              //                           .fromARGB(
                              //                       255, 53, 53, 53),
                              //               offset:
                              //                   const Offset(-4, -4),
                              //               blurRadius: 2,
                              //             )
                              //           ],
                              //         ),
                              //         child: const Center(
                              //           child: Text('Follow '),
                              //         ),
                              //       ),
                              //     ),
                              //   ),
                              ),
                        ],
                      ),
                      const Divider(
                        thickness: 2.0,
                      ),
                      const Padding(
                        padding: EdgeInsets.only(left: 5, top: 15),
                        child: Align(
                          alignment: Alignment.topLeft,
                          child: Text('Recent posts'),
                        ),
                      ),
                      FutureBuilder(
                        future: FirebaseFirestore.instance
                            .collection('posts')
                            .where('uid', isEqualTo: widget.uid)
                            .get(),
                        builder: (context,
                            AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>>
                                snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return circularIndicator(context);
                          }
                          return Padding(
                            padding: const EdgeInsets.all(4.0),
                            child: MasonryGridView.builder(
                              shrinkWrap: true,
                              primary: false,
                              itemCount: snapshot.data!.docs.length,
                              gridDelegate:
                                  const SliverSimpleGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 2,
                              ),
                              itemBuilder: (context, index) {
                                var data = snapshot.data!.docs[index];
                                return Padding(
                                  padding: const EdgeInsets.all(4.0),
                                  child: GestureDetector(
                                    onTap: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              PostDetailScreen(post: data),
                                        ),
                                      );
                                    },
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(12),
                                      child: Image(
                                        image: NetworkImage(
                                          data['postUrl'],
                                        ),
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  ),
                                );
                              },
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
  }

  Widget buildStateColumn(int num, String label) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          num.toString(),
          style: const TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          label,
          style: const TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w400,
            color: Colors.grey,
          ),
        ),
      ],
    );
  }
}
