// ignore_for_file: avoid_print

import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '/view/post_detail_screen.dart';
import '/view/profile_screen.dart';
import '/utils/colors.dart';
import '../utils/global_vairable.dart';
import '../widgets/animated_dialogue.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({Key? key}) : super(key: key);

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController searchController = TextEditingController();
  bool _isShowUsers = false;
  bool _isTyping = false;
  @override
  void dispose() {
    super.dispose();
    searchController.dispose();
  }

  late OverlayEntry _popupDialog;
  OverlayEntry _createPopupDialog(var doc) {
    return OverlayEntry(
      builder: (context) => AnimatedDialog(
        child: _createPopupContent(doc),
      ),
    );
  }

  Widget _createPopupContent(var doc) => Container(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Stack(
          children: [
            BackdropFilter(
              filter: ImageFilter.blur(
                sigmaX: 5.0,
                sigmaY: 5.0,
              ),
              child: Container(),
            ),
            Align(
              alignment: Alignment.center,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(16.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    _createPhotoTitle(doc),
                    Container(
                      constraints: const BoxConstraints(maxHeight: 500),
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: NetworkImage(doc['postUrl']),
                        ),
                      ),
                      width: double.infinity,
                      child: Image.network(
                        doc['postUrl'],
                        fit: BoxFit.fitWidth,
                      ),
                    ),
                    _createActionBar(doc),
                  ],
                ),
              ),
            ),
          ],
        ),
      );
  Widget _createActionBar(var doc) => Container(
        color: Theme.of(context).brightness == Brightness.dark
            ? secondaryColor
            : Colors.white,
        padding: const EdgeInsets.symmetric(vertical: 5.0),
        child: Padding(
          padding: const EdgeInsets.all(5.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Icon(
                Icons.favorite_border,
                color: Theme.of(context).brightness == Brightness.dark
                    ? Colors.white
                    : Colors.black,
              ),
              GestureDetector(
                child: SvgPicture.asset(
                  commentIcon,
                  color: Theme.of(context).brightness == Brightness.dark
                      ? Colors.white
                      : Colors.black,
                  height: 20,
                ),
                // onPanStart: (_) => Navigator.push(
                //   context,
                //   MaterialPageRoute(
                //     builder: (context) => CommentsSceeen(
                //       snap: doc,
                //     ),
                //   ),
                // ),
              ),
              SvgPicture.asset(
                sendIcon,
                color: Theme.of(context).brightness == Brightness.dark
                    ? Colors.white
                    : Colors.black,
                height: 20,
              ),
              blankSpace(0, 5),
              Icon(
                Icons.more_vert_rounded,
                color: Theme.of(context).brightness == Brightness.dark
                    ? Colors.white
                    : Colors.black,
              )
            ],
          ),
        ),
      );
  Widget _createPhotoTitle(var doc) => Container(
        color: Theme.of(context).brightness == Brightness.dark
            ? secondaryColor
            : Colors.white,
        padding: const EdgeInsets.fromLTRB(10.0, 5.0, 10.0, 5.0),
        width: double.infinity,
        child: Padding(
          padding: const EdgeInsets.all(5.0),
          child: Row(
            children: [
              CircleAvatar(
                radius: 14,
                backgroundColor: secondaryColor,
                backgroundImage: NetworkImage(doc['profImage']),
              ),
              Text(
                '   ${doc['username']}',
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      );
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      bottom: false,
      child: Scaffold(
        extendBody: true,
        backgroundColor: Theme.of(context).brightness == Brightness.light
            ? Colors.grey[300]
            : Colors.grey[900],
        appBar: AppBar(
          backgroundColor: Theme.of(context).brightness == Brightness.dark
              ? Colors.grey[900]
              : Colors.grey[300],
          title: SizedBox(
            child: Row(
              children: [
                _isTyping
                    ? Padding(
                        padding: const EdgeInsets.only(left: 8.0, right: 12),
                        child: GestureDetector(
                          onTap: () {
                            setState(() {
                              _isTyping = false;
                              _isShowUsers = false;
                              searchController.text = '';
                            });
                          },
                          child: const Icon(
                            Icons.arrow_back_ios,
                            color: Colors.white,
                          ),
                        ),
                      )
                    : Container(),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      vertical: 20,
                      horizontal: 12,
                    ),
                    child: TextFormField(
                      onTap: () {
                        setState(() {
                          _isTyping = true;
                          _isShowUsers = true;
                        });
                      },
                      onChanged: (value) {
                        setState(() {
                          _isShowUsers = true;
                        });
                      },
                      controller: searchController,
                      decoration: InputDecoration(
                        hintText: 'Search',
                        prefixIcon: !_isTyping
                            ? Icon(
                                Icons.search,
                                color: Theme.of(context).brightness ==
                                        Brightness.dark
                                    ? Colors.white
                                    : Colors.black,
                              )
                            : null,
                        fillColor:
                            Theme.of(context).brightness == Brightness.dark
                                ? Colors.grey.shade600
                                : Colors.white,
                        filled: true,
                        border: OutlineInputBorder(
                          borderSide: BorderSide.none,
                          borderRadius: BorderRadius.circular(15),
                        ),
                        contentPadding: const EdgeInsets.all(8),
                      ),
                      style: const TextStyle(fontSize: 14),
                      onFieldSubmitted: (_) {
                        setState(() {
                          _isShowUsers = true;
                        });
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        body: _isShowUsers
            ? FutureBuilder(
                future: FirebaseFirestore.instance
                    .collection('users')
                    .where('username',
                        isGreaterThanOrEqualTo: searchController.text.trim())
                    .get(),
                builder: (context,
                    AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>>
                        snapshot) {
                  print(snapshot);
                  if (!snapshot.hasData) {
                    return circularIndicator(context);
                  }
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return circularIndicator(context);
                  }
                  return ListView.builder(
                    itemCount: snapshot.data!.docs.length,
                    itemBuilder: (context, index) {
                      var doc = snapshot.data!.docs[index];
                      return ListTile(
                        onTap: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => ProfileScreen(
                                doc['uid'],
                              ),
                            ),
                          );
                        },
                        leading: CircleAvatar(
                          radius: 25,
                          backgroundImage: NetworkImage(doc['photoUrl']),
                        ),
                        title: Text(doc['username']),
                        subtitle: Text(doc['bio']),
                      );
                    },
                  );
                },
              )
            : FutureBuilder(
                future: FirebaseFirestore.instance.collection('posts').get(),
                builder: (context,
                    AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>>
                        snapshot) {
                  if (!snapshot.hasData) {
                    return circularIndicator(context);
                  }
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return circularIndicator(context);
                  }
                  return Stack(
                    children: [
                      MasonryGridView.builder(
                        gridDelegate:
                            const SliverSimpleGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 3),
                        // crossAxisCount: 3,
                        itemCount: (snapshot.data! as dynamic).docs.length,
                        itemBuilder: (context, index) {
                          var doc = (snapshot.data! as dynamic).docs[index];
                          return GestureDetector(
                            onTap: () => Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => PostDetailScreen(
                                  post: (snapshot.data! as dynamic).docs[index],
                                ),
                              ),
                            ),

                            onLongPress: () {
                              _popupDialog = _createPopupDialog(doc);
                              Overlay.of(context).insert(_popupDialog);
                            },
                            // remove the OverlayEntry from Overlay, so it would be hidden
                            onLongPressEnd: (details) => _popupDialog.remove(),
                            child: Image.network(
                              doc['postUrl'],
                              fit: BoxFit.cover,
                            ),
                          );
                        },
                        mainAxisSpacing: 8.0,
                        crossAxisSpacing: 8.0,
                      ),
                    ],
                  );
                },
              ),
      ),
    );
  }
}
