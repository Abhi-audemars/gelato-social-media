
import 'package:flutter/material.dart';
import 'package:insta_clone/utils/frosted_glass.dart';

class Demo extends StatefulWidget {
  const Demo({super.key});

  @override
  State<Demo> createState() => _DemoState();
}

class _DemoState extends State<Demo> {
  var top = 0.0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[900],
      body: Center(
        child: FrostedGlass(
            height: 50.0,
            width: 200.0,
            onPressed: () {},
            label:const Text('Button'),
            textColor: Colors.black),
      ),
    );
  }
}
