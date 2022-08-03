import 'package:flutter/material.dart';

import 'ball.dart';
import 'bat.dart';

enum Direction { up, down, left, right }

class Pong extends StatefulWidget {
  const Pong({Key? key}) : super(key: key);

  @override
  State<Pong> createState() => _PongState();
}

class _PongState extends State<Pong> with SingleTickerProviderStateMixin {
  late Animation animation;
  late AnimationController animationController;

  late double width;
  late double height;
  late double posX;
  late double posY;
  late Direction vDir;
  late Direction hDir;
  double batWidth = 0;
  double batHeight = 0;
  double batPosition = 0;
  final int ballSpeed = 5;

  void checkBorders() {
    if (posX <= 0 && hDir == Direction.left) {
      hDir = Direction.right;
    } else if (posX >= width - 25 && hDir == Direction.right) {
      hDir = Direction.left;
    }
    if (posY <= 0 && vDir == Direction.up) {
      vDir = Direction.down;
    } else if (posY >= height - 25 && vDir == Direction.down) {
      vDir = Direction.up;
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    vDir = Direction.down;
    hDir = Direction.right;
    posX = 0;
    posY = 0;
    animationController = AnimationController(
      duration: const Duration(minutes: 10000),
      vsync: this,
    );
    animation = Tween(begin: 0, end: 100).animate(animationController);
    animation.addListener(() {
      setState(() {
        hDir == Direction.right ? posX += ballSpeed : posX -= ballSpeed;

        vDir == Direction.down ? posY += ballSpeed : posY -= ballSpeed;
      });
      checkBorders();
    });
    animationController.forward();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
      height = constraints.maxHeight;
      width = constraints.maxWidth;
      batWidth = width / 5;
      batHeight = height / 20;
      return Stack(
        children: [
          Positioned(
            child: Ball(),
            top: posY,
            left: posX,
          ),
          Positioned(
            child: Bat(width: batWidth, height: batHeight),
            bottom: 0,
          )
        ],
      );
    });
  }
}
