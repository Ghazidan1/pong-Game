import 'package:flutter/material.dart';

class Ball extends StatelessWidget {
  final double diam = 25;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: diam,
      height: diam,
      decoration:
          BoxDecoration(color: Colors.amber[600], shape: BoxShape.circle),
    );
  }
}
