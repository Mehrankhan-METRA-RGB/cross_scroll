import 'dart:math';

import 'package:cross_scroll/cross_scroll.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(

        primarySwatch: Colors.blue,
      ),
      home:  Example(),
    );
  }
}

class Example extends StatelessWidget {
  Example({Key? key}) : super(key: key);
  final random = Random();
  final List<Color> colors = const [
    Color(0xdfde2929),
    Color(0xdfe0c919),
    Color(0xfd3cd506),
    Color(0xdfaf08ba),
    Color(0xffdc0e79),
    Color(0xf80bdbab),
    Color(0xff0b32c2),
    Color(0xfad7a306),
    Color(0xdf0877b3),
    Color(0xdf5d0ce7),
  ];
  @override
  Widget build(BuildContext context) {
    CrossScrollBar _crossScroll= const CrossScrollBar(showTrackOnHover: false,trackVisibility: true,);

    return CrossScroll(
      verticalBar: _crossScroll,
      horizontalBar:_crossScroll ,

      child: Column(
        children: [
          for (var i = 1; i < 20; i++)
            Row(
              children: [
                for (var i = 1; i < 20; i++)
                  Container(
                    margin:const EdgeInsets.all(2),
                    width: 500,
                    height: 300,
                    color: colors[random.nextInt(9).round().toInt()],
                  ),
              ],
            )

        ],
      ),
    );


  }
}
