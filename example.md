
## Example

```dart

class Example extends StatelessWidget {
  Example({Key? key}) : super(key: key);
  final random = math.Random();
  final List<Color> colors = const [
    Color(0xfabd0505),
    Color(0xdfe0c919),
    Color(0xfd3cd506),
    Color(0xdfaf08ba),
    Color(0xffdc0e79),
    Color(0xf80bdbab),
    Color(0xff0b32c2),
    Color(0xfaea5709),
    Color(0xf8d808e7),
    Color(0xdf5d0ce7),
    Color.fromARGB(249, 4, 152, 163),
    Color.fromARGB(223, 18, 10, 32),
    Color.fromARGB(248, 93, 165, 5),
    Color.fromARGB(248, 224, 169, 37),

  ];
  CrossScrollStyle _crossScrollStyle = CrossScrollStyle(
    physics: BouncingScrollPhysics(),
    clipBehavior: Clip.hardEdge,
    dragStartBehavior: DragStartBehavior.start,
    keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.manual,
    reverse: false,
    padding: const EdgeInsets.symmetric(vertical: 2),
  );

  CrossScrollBar _crossScrollBar = const CrossScrollBar(
    isAlwaysShown: true,
    hoverThickness: 8,
    thickness: 8,
    radius: Radius.elliptical(8, 8),
    showTrackOnHover: true,
    trackVisibility: false,
  );

  @override
  Widget build(BuildContext context) {
    return CrossScroll(
     
      ///Horizontal scroll
      horizontalScroll: _crossScrollStyle,
      
      ///Vertical scroll
      verticalScroll: _crossScrollStyle,

      ///Vertical Thumb Style
      verticalBar: _crossScrollBar,
   
      ///Horizontal Thumb Style
      horizontalBar: _crossScrollBar,

      child: Column(
        children: [
          for (var i = 1; i < 11; i++)
            Row(
              children: [
                for (var i = 1; i < 11; i++)
                  Container(
                    margin: const EdgeInsets.all(2),
                    width: MediaQuery
                        .of(context)
                        .size
                        .width / 2,
                    height: MediaQuery
                        .of(context)
                        .size
                        .height / 2,
                    color: colors[random.nextInt(13).round().toInt()],
                  ),
              ],
            )

        ],
      ),
    );
  }
}
```



