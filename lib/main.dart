import 'package:flutter/material.dart';
import 'package:simple_pong/pong.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Pong Deno',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: Scaffold(
          appBar: AppBar(title: Text("Simple Pong")),
          body: SafeArea(
            child: Pong(),
          ),
        ));
  }
}
