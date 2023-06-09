

import 'package:flutter/material.dart';

class LayoutScreen extends StatelessWidget {
  final Widget child;

  const LayoutScreen({Key? key, required this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: child);
  }
}
