

##  Package
A CrossScroll is a flutter Package that permits it’s child views to be scrolled vertically and Horizontally. This is important because in many cases you need content to be scrolled on both side. 


### List of features
- The vertical scrollbar wil never  hides when the scrolling on horizontal axis and vice versa. The scrollBar never hides with scrolling on any directions.
- Support track onClick scrolls.
- Support thumb Drag scrolls.
- Support All feature `SingleChildScrollView` have.
## Tested Platform

#### WEB
- MicroSoft Edge

![cross_scroll web test](https://user-images.githubusercontent.com/73336909/149651423-d1dc936f-cfc0-4581-bb79-19e1fc4ec533.gif)




















#### Windows
- Windows 10

![cross_scroll window test](https://user-images.githubusercontent.com/73336909/149651492-2ce542a7-7343-4651-81b1-d3eccf3f9bda.gif)












## Getting started



## CrossScroll
```dart
CrossScroll(verticalBar: sc,
      horizontalBar:sc ,
      child: Column(
        children: [
          for (var i = 1; i < 11; i++)
            Row(
              children: [
                for (var i = 1; i < 11; i++)
                  Container(
                    margin:const EdgeInsets.all(2),
                    width: MediaQuery.of(context).size.width/2,
                    height: MediaQuery.of(context).size.height/2,
                    color: colors[random.nextInt(13).round().toInt()],
                  ),
              ],
            )

        ],
      ),
    )

```




#### CrossScrollBar
```dart
final CrossScrollBar _crossScrollBar= const CrossScrollBar(
  isAlwaysShown:true,
  hoverThickness: 8,
  thickness :8,
  radius : Radius.elliptical(8, 8),
  showTrackOnHover: true,
  trackVisibility: false,
);
```












#### CrossScrollStyle
```dart
 final CrossScrollStyle _crossScrollStyle =  CrossScrollStyle(
    physics: BouncingScrollPhysics(),
    clipBehavior:Clip.hardEdge,
    dragStartBehavior: DragStartBehavior.start,
    keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.manual,
    reverse: false,
    padding:const EdgeInsets.symmetric(vertical: 2),
  );

```








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











## Additional information

TODO: Tell users more about the package: where to find more information, how to 
contribute to the package, how to file issues, what response they can expect 
from the package authors, and more.
