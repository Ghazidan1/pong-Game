import 'package:flutter/material.dart';

class Bat extends StatelessWidget {
  final double width;
  final double height;

  const Bat({required this.width, required this.height});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      color: Colors.blueAccent[200],
    );
  }
}
