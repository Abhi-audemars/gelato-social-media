// ignore_for_file: library_private_types_in_public_api

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

// ignore: must_be_immutable
class NewMessage extends StatefulWidget {
  NewMessage({
    Key? key,
    required this.user,
  }) : super(key: key);
  String user;
  @override
  _NewMessageState createState() => _NewMessageState();
}

class _NewMessageState extends State<NewMessage> {
  final _controller = TextEditingController();
  var _enteredMessage = '';

  Future<void> _sendMessage() async {
    FocusScope.of(context).unfocus();
    final user = FirebaseAuth.instance.currentUser!.uid;
    final DocumentSnapshot<Map<String, dynamic>> username;

    username =
        await FirebaseFirestore.instance.collection('users').doc(user).get();

    FirebaseFirestore.instance
        .collection('chat')
        .doc(widget.user)
        .collection('receiver')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .set(
      {
        'uid': FirebaseAuth.instance.currentUser!.uid,
        'updated': Timestamp.now(),
      },
    );
    FirebaseFirestore.instance
        .collection('chat')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .collection('receiver')
        .doc(widget.user)
        .set(
      {
        'uid': widget.user,
        'updated': Timestamp.now(),
      },
    );
    FirebaseFirestore.instance
        .collection(
            'chat/${widget.user}/receiver/${FirebaseAuth.instance.currentUser!.uid}/message/')
        .add(
      {
        'text': _enteredMessage,
        'createdAt': Timestamp.now(),
        'userId': user,
        'username': username['username'],
      },
    );
    FirebaseFirestore.instance
        .collection(
            'chat/${FirebaseAuth.instance.currentUser!.uid}/receiver/${widget.user}/message/')
        .add(
      {
        'text': _enteredMessage,
        'createdAt': Timestamp.now(),
        'userId': user,
        'username': username['username'],
      },
    );
    _controller.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 8),
      padding: const EdgeInsets.all(8),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _controller,
              textCapitalization: TextCapitalization.sentences,
              autocorrect: true,
              enableSuggestions: true,
              decoration: InputDecoration(
                contentPadding: const EdgeInsets.symmetric(horizontal: 12),
                suffixIcon: GestureDetector(
                  onTap: _enteredMessage.trim() != '' ? _sendMessage : () {},
                  child: Padding(
                    padding: const EdgeInsets.all(15),
                    child: Text(
                      'Send',
                      style: TextStyle(
                        fontSize: 16,
                        color: _enteredMessage.trim() != ''
                            ? Colors.blue
                            : Colors.blue.shade800,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(50),
                ),
                hintText: 'Message...',
              ),
              onChanged: (value) {
                setState(() {
                  _enteredMessage = value;
                });
              },
            ),
          ),
        ],
      ),
    );
  }
}
