import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  int i = 0;
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.cyan,
          title: const Text("FIRST THING IG  "),
          centerTitle: true,
        ),
        floatingActionButton: FloatingActionButton(
            onPressed: () {
              setState(() {
                i++;
              });
            },
          ),
        body:
          Container(
            alignment: Alignment.center,
            child: Text("$i"),
          )
                

      ),   

    );  

  }
}

 randomColor() {
    Random random = Random();
    return Color.fromARGB(
      255,
      random.nextInt(256),
      random.nextInt(256),
      random.nextInt(256),
    );
}
