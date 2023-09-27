import 'package:flutter/material.dart';

class Tabular extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Material(
      type: MaterialType.transparency,
      child: ListView(
        scrollDirection: Axis.horizontal,
        // shrinkWrap: true,
        children: [
          Container(
            // width: MediaQuery.of(context).size.width * 2,
            color: Colors.red,
            height: 50,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                for (var i = 1; i < 30; i++)
                  SizedBox(width: 90, height: 50, child: Text('Column $i')),
              ],
            ),
          ),
          ListView(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            scrollDirection: Axis.vertical,
            children: [
              Container(
                width: 50,
                color: Colors.grey,
                // height: (MediaQuery.of(context).size.height - 50) * 2,
                child: Column(
                  children: [
                    for (var i = 1; i < 80; i++)
                      SizedBox(height: 40, width: 40, child: Text('$i'))
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: CustomScrollView(
          slivers: <Widget>[
            SliverGrid(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3, // Number of columns
              ),
              delegate: SliverChildBuilderDelegate(
                (BuildContext context, int index) {
                  // Replace this with your grid item widget
                  return Card(
                    margin: EdgeInsets.all(8.0),
                    child: Center(
                      child: Text("Item $index"),
                    ),
                  );
                },
                childCount: 30, // Number of items
              ),
            ),
          ],
        ),
      ),
    );
  }
}
