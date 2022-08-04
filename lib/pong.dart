import 'dart:math';

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
  double xRandom = 1;
  double yRandom = 1;

  double randomSpeed() {
    Random random = Random();
    //min=0.0 max= 1.5
    double randomDouble = (random.nextInt(101) + 50) / 100;
    print("Random $randomDouble");
    return randomDouble;
  }

  void checkBorders() {
    double ballDiameter = 25;
    if (posX <= 0 && hDir == Direction.left) {
      hDir = Direction.right;
      xRandom = randomSpeed();
    } else if (posX >= width - ballDiameter && hDir == Direction.right) {
      hDir = Direction.left;
      xRandom = randomSpeed();
    }
    if (posY <= 0 && vDir == Direction.up) {
      vDir = Direction.down;
      yRandom = randomSpeed();
    } else if (posY >= height - ballDiameter - batHeight &&
        vDir == Direction.down) {
      if (posX >= batPosition - ballDiameter &&
          posX <= batPosition + batWidth + ballDiameter) {
        vDir = Direction.up;
        yRandom = randomSpeed();
      } else {
        animationController.stop();
        dispose();
      }
    }
  }

  void moveBat(DragUpdateDetails update) {
    setState(() {
      batPosition += update.delta.dx;
    });
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
        hDir == Direction.right
            ? posX += (ballSpeed * xRandom).round()
            : posX -= (ballSpeed * xRandom).round();

        vDir == Direction.down
            ? posY += (ballSpeed * yRandom).round()
            : posY -= (ballSpeed * yRandom).round();
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
      batWidth = width / 4;
      batHeight = height / 25;
      return Stack(
        children: [
          Positioned(
            child: Ball(),
            top: posY,
            left: posX,
          ),
          Positioned(
            bottom: 0,
            left: batPosition,
            child: GestureDetector(
                onHorizontalDragUpdate: (DragUpdateDetails update) {
                  moveBat(update);
                },
                child: Bat(width: batWidth, height: batHeight)),
          )
        ],
      );
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    animationController.dispose();

    super.dispose();
  }
}
