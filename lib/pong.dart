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
  int score = 0;

  double randomSpeed() {
    Random random = Random();
    //min=0.0 max= 1.5
    double randomDouble = (random.nextInt(101) + 50) / 100;
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
        score++;
        yRandom = randomSpeed();
      } else {
        animationController.stop();
        showAlert(context);
      }
    }
  }

  void moveBat(DragUpdateDetails update) {
    setState(() {
      batPosition += update.delta.dx;
    });
  }

  void showAlert(BuildContext context) {
    showDialog(
        context: context,
        builder: (BuildContext) {
          return AlertDialog(
            title: Center(
                child: Text(
              "Game Over",
              style: TextStyle(
                  color: Colors.redAccent[700],
                  fontWeight: FontWeight.bold,
                  fontSize: 32.0),
            )),
            content: Container(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: 0.0),
                    child: Text(
                      score.toString(),
                      style: TextStyle(
                          fontSize: 48,
                          fontWeight: FontWeight.bold,
                          color: Colors.green[600]),
                    ),
                  ),
                  Text(
                    "Would you like to play again?",
                    style: TextStyle(fontSize: 18),
                  )
                ],
              ),
            ),
            actions: [
              TextButton(
                  onPressed: () {
                    setState(() {
                      posX = 0;
                      posY = 0;
                      score = 0;
                    });
                    Navigator.of(context).pop();
                    animationController.repeat();
                  },
                  child: Text("Yes")),
              TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                    dispose();
                  },
                  child: Text("No"))
            ],
          );
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
    return GestureDetector(
      onHorizontalDragUpdate: (DragUpdateDetails update) {
        moveBat(update);
      },
      child: LayoutBuilder(
          builder: (BuildContext context, BoxConstraints constraints) {
        height = constraints.maxHeight;
        width = constraints.maxWidth;
        batWidth = width / 4;
        batHeight = height / 25;
        return Stack(
          children: [
            Positioned(right: 25, top: 1, child: Text("Score :$score")),
            Positioned(
              child: Ball(),
              top: posY,
              left: posX,
            ),
            Positioned(
              bottom: 0,
              left: batPosition,
              child: Bat(width: batWidth, height: batHeight),
            )
          ],
        );
      }),
    );
  }

  @override
  void dispose() {
    // TODO: implement dispose
    animationController.dispose();

    super.dispose();
  }
}
