// ignore_for_file: prefer_typing_uninitialized_variables

import 'dart:ui';

import 'package:flutter/material.dart';

class FrostedGlass extends StatelessWidget {
  const FrostedGlass({
    Key? key,
    required this.onPressed,
    required this.label,
    this.borderColor = Colors.transparent,
    this.textColor,
    this.width,
    this.height,
    this.child,
  }) : super(key: key);
  final width;
  final height;
  final child;
  final Function()? onPressed;
  final Widget label;
  final Color borderColor;
  final Color? textColor;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(15),
      child: InkWell(
        onTap: onPressed,
        child: SizedBox(
          width: width,
          height: height,
          // color: Colors.transparent,
          child: Stack(
            children: [
              BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
                child: Container(),
              ),
              Container(
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    border: Border.all(color: borderColor),
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        Colors.grey.withOpacity(0.25),
                        Colors.grey.withOpacity(0.25),
                      ],
                    )),
              ),
              Center(child: label)
            ],
          ),
        ),
      ),
    );
  }
}
