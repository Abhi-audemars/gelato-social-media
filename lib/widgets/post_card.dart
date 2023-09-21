// ignore_for_file: prefer_typing_uninitialized_variables

import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get_time_ago/get_time_ago.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../views/message_screen.dart';
import '/models/user.dart';
import '/controller/user_provider.dart';
import '/resources/firestore_methods.dart';
import '../views/comment_screen.dart';
import '/utils/colors.dart';
import '/utils/global_vairable.dart';
import '/utils/utils.dart';
import '/widgets/like_animation.dart';

class PostCard extends StatefulWidget {
  final post;
  const PostCard({Key? key, required this.post}) : super(key: key);

  @override
  State<PostCard> createState() => _PostCardState();
}

class _PostCardState extends State<PostCard>
    with SingleTickerProviderStateMixin {
  bool isLikeAnimating = false;
  int commentLength = 0;
  var postUrl;
  var posterUId;

  late TransformationController controller;
  late AnimationController animationController;
  Animation<Matrix4>? animation;
  OverlayEntry? entry;

  @override
  void initState() {
    super.initState();
    controller = TransformationController();
    animationController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 200))
      ..addListener(() {
        controller.value = animation!.value;
      })
      ..addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          removeOverlay();
        }
      });
    getComment();
    getPost();
  }

  @override
  dispose() {
    controller.dispose();
    animationController.dispose();
    super.dispose();
  }

  getPost() async {
    await FirebaseFirestore.instance
        .collection('posts')
        .doc(widget.post['postId'])
        .get()
        .then((value) {
      postUrl = value.data()!['postUrl'];
      posterUId = value.data()!['uid'];
    });
  }

  getComment() async {
    try {
      QuerySnapshot snap = await FirebaseFirestore.instance
          .collection('posts')
          .doc(widget.post['postId'])
          .collection('comments')
          .get();

      commentLength = snap.docs.length;
    } on Exception catch (e) {
      showSnackBar(e.toString(), context);
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final UserModel user = Provider.of<UserProvider>(context).user;
    var date = widget.post['datePublished'];
    var finalDate = DateTime.parse(date.toString());
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10),
        decoration: BoxDecoration(
          color: Theme.of(context).brightness == Brightness.dark
              ? Colors.grey[900]
              : Colors.grey[300],
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Theme.of(context).brightness == Brightness.light
                  ? Colors.grey.shade600
                  : Colors.black,
              offset: const Offset(6, 6),
              blurRadius: 15,
            ),
            BoxShadow(
              color: Theme.of(context).brightness == Brightness.light
                  ? Colors.white
                  : const Color.fromARGB(255, 53, 53, 53),
              offset: const Offset(-6, -6),
              blurRadius: 2,
            )
          ],
        ),
        child: Column(
          children: [
            //Header
            Container(
              padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 10)
                  .copyWith(right: 0),
              child: Row(
                children: [
                  Container(
                    height: 40,
                    width: 40,
                    decoration: BoxDecoration(
                      color: Colors.amber,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Image.network(
                        widget.post['profImage'],
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(left: 8),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            widget.post['username'],
                            style: GoogleFonts.poppins(
                              textStyle: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                          ),
                          Text(
                            GetTimeAgo.parse(finalDate),
                            style: GoogleFonts.poppins(
                              textStyle: const TextStyle(
                                fontWeight: FontWeight.normal,
                                fontSize: 12,
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () async {
                      await showMenuDialogue(context, user);
                    },
                    child: const Padding(
                      padding: EdgeInsets.only(right: 8),
                      child: Icon(Icons.more_horiz_rounded),
                    ),
                  ),
                ],
              ),
              // IMAGE SECTION
            ),
            GestureDetector(
              onDoubleTap: () async {
                setState(() {
                  isLikeAnimating = true;
                });
                await FirestoreMethods().likePost(
                  widget.post['postId'],
                  user.uid,
                  user.photoUrl,
                  user.username,
                  postUrl,
                  posterUId,
                  widget.post['likes'],
                );
              },
              child: Stack(
                alignment: Alignment.center,
                children: [
                  buildImage(),
                  AnimatedOpacity(
                    duration: const Duration(milliseconds: 100),
                    opacity: isLikeAnimating ? 1 : 0,
                    child: LikeAnimation(
                      isAnimating: isLikeAnimating,
                      duration: const Duration(
                        milliseconds: 200,
                      ),
                      onEnd: () {
                        setState(() {
                          isLikeAnimating = false;
                        });
                      },
                      child: Image.asset(
                        'assets/images/heart_filled.png',
                        color: Colors.white,
                        height: 200,
                        width: 200,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            // Like Comment
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                LikeAnimation(
                  isAnimating: widget.post['likes'].contains(user.uid),
                  smallLike: true,
                  child: _footerButton(
                    child: widget.post['likes'].contains(user.uid)
                        ? Image.asset(
                            'assets/images/heart_filled.png',
                            color: Colors.red,
                            height: 20,
                          )
                        : Image.asset(
                            'assets/images/heart_outlined.png',
                            color:
                                Theme.of(context).brightness == Brightness.dark
                                    ? Colors.white
                                    : Colors.black,
                            height: 20,
                          ),
                    onPressed: () async {
                      await FirestoreMethods().likePost(
                        widget.post['postId'],
                        user.uid,
                        user.photoUrl,
                        user.username,
                        postUrl,
                        posterUId,
                        widget.post['likes'],
                      );
                    },
                  ),
                ),
                _footerButton(
                  child: SvgPicture.asset(
                    commentIcon,
                    color: Theme.of(context).brightness == Brightness.dark
                        ? Colors.white
                        : Colors.black,
                    height: 20,
                  ),
                  onPressed: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => CommentsSceeen(
                        snap: widget.post,
                      ),
                    ),
                  ),
                ),
                _footerButton(
                  child: Icon(
                    Icons.ios_share_rounded,
                    color: Theme.of(context).brightness == Brightness.dark
                        ? Colors.white
                        : Colors.black,
                    size: 20,
                  ),
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => MessageScreen(
                          user: posterUId,
                        ),
                      ),
                    );
                  },
                ),
              ],
            ),
            const Divider(
              color: secondaryColor,
            ),
            // Desciption

            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      DefaultTextStyle(
                        style: Theme.of(context)
                            .textTheme
                            .titleSmall!
                            .copyWith(fontWeight: FontWeight.w800),
                        child: Text(
                          '${widget.post['likes'].length} likes',
                          // style: Theme.of(context).textTheme.bodyText2,
                        ),
                      ),
                      InkWell(
                        onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => CommentsSceeen(
                              snap: widget.post,
                            ),
                          ),
                        ),
                        child: Text(
                          '$commentLength comments',
                          style: const TextStyle(color: secondaryColor),
                        ),
                      )
                    ],
                  ),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.only(top: 8),
                    child: RichText(
                      text: TextSpan(
                        style: const TextStyle(
                          color: primaryColor,
                        ),
                        children: [
                          TextSpan(
                            text: widget.post['username'] + ' ',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Theme.of(context).brightness ==
                                      Brightness.dark
                                  ? Colors.white
                                  : Colors.black,
                            ),
                          ),
                          TextSpan(
                            text: widget.post['description'],
                            style: TextStyle(
                              color: Theme.of(context).brightness ==
                                      Brightness.dark
                                  ? Colors.white
                                  : Colors.black,
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  showMenuDialogue(BuildContext context, UserModel user) async {
    showDialog(
      context: context,
      builder: (context) {
        return Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            BackdropFilter(
              filter: ImageFilter.blur(
                sigmaX: 5.0,
                sigmaY: 5.0,
              ),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  decoration: BoxDecoration(
                      color: Colors.transparent,
                      borderRadius: BorderRadius.circular(15),
                      border: Border.all(color: Colors.white)),
                  child: ListView(
                    shrinkWrap: true,
                    children: [
                      (user.uid == widget.post['uid']
                          ? 'Delete'
                          : 'Do Nothing'),
                      'Close'
                    ]
                        .map((e) => Column(
                              children: [
                                e != 'Delete' && e != 'Do Nothing'
                                    ? const Divider()
                                    : Container(),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: GestureDetector(
                                    onTap: e == 'Delete'
                                        ? () async {
                                            Navigator.pop(context);
                                            await FirestoreMethods().deletePost(
                                                widget.post['postId']);
                                          }
                                        : () {
                                            Navigator.pop(context);
                                          },
                                    child: Center(
                                      child: Container(
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.8,
                                        padding: const EdgeInsets.symmetric(
                                          vertical: 12,
                                          horizontal: 16,
                                        ),
                                        child: Text(
                                          e,
                                          style: const TextStyle(
                                              fontSize: 16,
                                              color: Colors.white),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ))
                        .toList(),
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  Padding _footerButton({
    required Widget child,
    required Function()? onPressed,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 8),
      child: GestureDetector(
        onTap: onPressed,
        child: child,
      ),
    );
  }

  void resetAnimation() {
    animation = Matrix4Tween(begin: controller.value, end: Matrix4.identity())
        .animate(
            CurvedAnimation(parent: animationController, curve: Curves.ease));
    animationController.forward(from: 0);
  }

  buildImage() {
    return Builder(builder: (context) {
      return InteractiveViewer(
        transformationController: controller,
        clipBehavior: Clip.none,
        panEnabled: false,
        onInteractionEnd: (details) {
          resetAnimation();
        },
        onInteractionStart: (details) {
          if (details.pointerCount < 2) return;

          showOverlay(context);
        },
        child: Container(
          constraints: const BoxConstraints(minHeight: 400, maxHeight: 600),
          width: double.infinity,
          color: secondaryColor,
          child: Image.network(
            widget.post['postUrl'].toString(),
            fit: BoxFit.cover,
          ),
        ),
      );
    });
  }

  showOverlay(BuildContext context) {
    entry = OverlayEntry(builder: (context) {
      return Positioned(child: buildImage());
    });
    final overlay = Overlay.of(context);
    overlay.insert(entry!);
  }

  removeOverlay() {
    entry?.remove();
    entry = null;
  }
}
