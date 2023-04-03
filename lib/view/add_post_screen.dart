// ignore_for_file: use_build_context_synchronously

import 'dart:typed_data';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';

import '/models/user.dart';
import '/controller/user_provider.dart';
import '/resources/firestore_methods.dart';
import '/utils/utils.dart';

class AddPostScreen extends StatefulWidget {
  final Function(int) navigate;
  const AddPostScreen({Key? key, required this.navigate}) : super(key: key);

  @override
  State<AddPostScreen> createState() => _AddPostScreenState();
}

class _AddPostScreenState extends State<AddPostScreen> {
  Uint8List? _file;
  final TextEditingController _descriptionController = TextEditingController();
  bool _isLoading = false;
  @override
  dispose() {
    super.dispose();
    _descriptionController.dispose();
  }

  postImage(String uid, String username, String profImage) async {
    setState(() {
      _isLoading = true;
    });
    try {
      String res = await FirestoreMethods().uploadPost(
        uid,
        _descriptionController.text.trim(),
        username,
        profImage,
        _file!,
      );
      if (res == "success") {
        setState(() {
          _isLoading = false;
        });
        clearImage();
        showSnackBar('Posted!', context);
      } else {
        setState(() {
          _isLoading = false;
        });
        showSnackBar(res, context);
        widget.navigate(0);
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      showSnackBar(e.toString(), context);
    }
  }

  _selectImage(BuildContext context) {
    return showDialog(
      context: context,
      builder: (context) {
        return BackdropFilter(
          filter: ImageFilter.blur(
            sigmaX: 5.0,
            sigmaY: 5.0,
          ),
          child: SimpleDialog(
            backgroundColor: Colors.transparent,
            shape: const RoundedRectangleBorder(
              side: BorderSide(color: Colors.white),
            ),
            title: const Text(
              'Create Post',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            alignment: Alignment.center,
            elevation: 5,
            children: [
              SimpleDialogOption(
                padding: const EdgeInsets.all(20),
                child: const Text('Take a Photo'),
                onPressed: () async {
                  Navigator.of(context).pop();
                  Uint8List file =
                      await pickImage(ImageSource.camera, 1500, 1500, 100);
                  setState(() {
                    _file = file;
                  });
                },
              ),
              SimpleDialogOption(
                padding: const EdgeInsets.all(20),
                child: const Text('Choose from Gallery'),
                onPressed: () async {
                  Navigator.of(context).pop();
                  Uint8List file = await pickImage(
                    ImageSource.gallery,
                  );
                  setState(() {
                    _file = file;
                  });
                },
              ),
              SimpleDialogOption(
                padding: const EdgeInsets.all(20),
                child: const Text('Cancel'),
                onPressed: () async {
                  Navigator.of(context).pop();
                },
              )
            ],
          ),
        );
      },
    );
  }

  void clearImage() {
    setState(() {
      _file = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    UserModel user = Provider.of<UserProvider>(context).user;
    return _file == null
        ? Scaffold(
            backgroundColor: Theme.of(context).brightness == Brightness.light
                ? Colors.grey[300]
                : Colors.grey[900],
            appBar: AppBar(
              backgroundColor: Theme.of(context).brightness == Brightness.dark
                  ? Colors.grey[900]
                  : Colors.grey[300],
              title: Text(
                'Add a post',
                style: TextStyle(
                    color: Theme.of(context).brightness == Brightness.dark
                        ? Colors.white
                        : Colors.pink,
                    fontWeight: FontWeight.bold),
              ),
              centerTitle: true,
            ),
            body: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Center(
                //   child: IconButton(
                //     icon: const Icon(Icons.upload),
                //     splashRadius: 50,
                //     iconSize: 40,
                //     onPressed: _isLoading
                //         ? () {}
                //         : () {
                //             _selectImage(context);
                //           },
                //   ),
                // ),
                GestureDetector(
                  onTap: _isLoading
                      ? () {}
                      : () {
                          _selectImage(context);
                        },
                  child: Center(
                    child: Lottie.network(
                        'https://assets1.lottiefiles.com/datafiles/0n1EohAEO6UEuwf/data.json',
                        height: 200,
                        width: 200),
                  ),
                ),
                const Text(
                  'Click on a icon above to choose from different options.',
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(color: Colors.grey),
                )
              ],
            ),
          )
        : Scaffold(
            appBar: AppBar(
              backgroundColor: Theme.of(context).brightness == Brightness.dark
                  ? Colors.grey[900]
                  : Colors.grey[300],
              leading: IconButton(
                onPressed: clearImage,
                icon: Icon(
                  Icons.arrow_back,
                  color: Theme.of(context).brightness == Brightness.dark
                      ? Colors.white
                      : Colors.black,
                ),
                splashRadius: 25,
              ),
              title: Text(
                'Add a post',
                style: TextStyle(
                  color: Theme.of(context).brightness == Brightness.dark
                      ? Colors.white
                      : Colors.black,
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => postImage(
                    user.uid,
                    user.username,
                    user.photoUrl,
                  ),
                  child: Container(
                    height: 40,
                    width: 40,
                    decoration: BoxDecoration(
                      color: Theme.of(context).brightness == Brightness.dark
                          ? Colors.grey[900]
                          : Colors.grey[300],
                      borderRadius: BorderRadius.circular(40),
                      boxShadow: [
                        BoxShadow(
                          color:
                              Theme.of(context).brightness == Brightness.light
                                  ? Colors.grey.shade600
                                  : Colors.black,
                          offset: const Offset(6, 6),
                          blurRadius: 10,
                        ),
                        BoxShadow(
                          color:
                              Theme.of(context).brightness == Brightness.light
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
                      Icons.send,
                      color: Colors.purple,
                    ),
                  ),
                  // const Text(
                  //   'Post',
                  //   style: TextStyle(
                  //     color: Colors.blueAccent,
                  //     fontWeight: FontWeight.bold,
                  //     fontSize: 16,
                  //   ),
                  // ),
                ),
              ],
            ),
            body: Column(
              children: [
                _isLoading
                    ? LinearProgressIndicator(
                        color: Theme.of(context).brightness == Brightness.dark
                            ? Colors.purple
                            : Colors.yellow,
                      )
                    : const Padding(padding: EdgeInsets.zero),
                const Divider(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CircleAvatar(
                      backgroundImage: NetworkImage(user.photoUrl),
                    ),
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.45,
                      child: TextField(
                        controller: _descriptionController,
                        decoration: const InputDecoration(
                          hintText: 'Write a caption...',
                          border: InputBorder.none,
                        ),
                        maxLines: 5,
                      ),
                    ),
                    const Divider(),
                  ],
                ),
                SizedBox(
                  height: 300,
                  width: double.infinity,
                  child: AspectRatio(
                    aspectRatio: 487 / 451,
                    child: Container(
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: MemoryImage(_file!),
                          fit: BoxFit.cover,
                          alignment: FractionalOffset.topCenter,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
  }
}
