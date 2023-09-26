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
        title: 'Cross Scroll',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: Example()

        // Example(),
        );
  }
}

class Example extends StatelessWidget {
  Example({Key? key}) : super(key: key);
  final random = Random();
  @override
  Widget build(BuildContext context) {
    return NewCrossScroll(
      ///Optional
      // normalColor: Colors.blue,
      ///Optional
      // hoverColor: Colors.red,
      ///Optional
      // dimColor: Colors.red.withOpacity(0.4),
      ///design track and thumb
      // verticalBar: const CrossScrollBar(),
      // horizontalBar: const CrossScrollBar(),

      child: Column(
        children: [
          for (var i = 1; i < 30; i++)
            Row(
              children: [
                for (var i = 1; i < 30; i++)
                  Container(
                      margin: const EdgeInsets.all(2),
                      width: 500,
                      height: 300,

                      ///get random color for container
                      color: Color.fromARGB(255, random.nextInt(255),
                          random.nextInt(255), random.nextInt(255))),
              ],
            )
        ],
      ),
    );
  }
}

// class MyWidget extends StatelessWidget {
//   const MyWidget({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     bool _isExpanded = false;
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Expanded Container'),
//       ),
//       body: LayoutBuilder(builder: (context, constraints) {
//         return CrossScroll(
//           child: StatefulBuilder(builder: (context, setState) {
//             return Column(
//               children: [
//                 GestureDetector(
//                   onTap: () {
//                     setState(() {
//                       _isExpanded = !_isExpanded;
//                     });
//                   },
//                   child: Container(
//                     width: _isExpanded
//                         ? constraints.maxWidth * 1.2
//                         : constraints.maxWidth,
//                     height: _isExpanded
//                         ? constraints.maxHeight * 1.2
//                         : constraints.maxHeight * 0.5,
//                     color: Colors.blue,
//                     child: Center(
//                       child: Text(
//                         _isExpanded
//                             ? 'you will not see scrollBar --->'
//                             : 'Tap to Expand',
//                         style: const TextStyle(
//                           fontSize: 30,
//                           color: Colors.black,
//                         ),
//                       ),
//                     ),
//                   ),
//                 ),
//               ],
//             );
//           }),
//         );
//       }),
//     );
//   }
// }
