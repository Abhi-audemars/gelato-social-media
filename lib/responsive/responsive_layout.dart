import 'package:flutter/cupertino.dart';

import '../utils/global_vairable.dart';

class ResponsiveLayout extends StatefulWidget {
  final Widget webScreenLayout;
  final Widget mobileScreenLayout;

  const ResponsiveLayout({
    Key? key,
    required this.webScreenLayout,
    required this.mobileScreenLayout,
  }) : super(key: key);

  @override
  State<ResponsiveLayout> createState() => _ResponsiveLayoutState();
}

class _ResponsiveLayoutState extends State<ResponsiveLayout> {
  @override
  void initState() {
    super.initState();
  }


  @override
  Widget build(BuildContext context) {

    return LayoutBuilder(builder: (context, constraints) {
      if (constraints.maxWidth > webScreenWidth) {
        return widget.webScreenLayout;
      }
      return widget.mobileScreenLayout;
    });
  }
}
