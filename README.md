

##  Package
A CrossScroll is a flutter Package that permits it’s child views to be scrolled vertically and Horizontally. This is important because in many cases you need content to be scrolled on both side. 


### List of features
- The vertical scrollbar wil never  hides when the scrolling on horizontal axis and vice versa. The scrollBar never hides with scrolling on any directions.
- Support track onClick scrolls.
- Support thumb Drag scrolls.
- Support All feature `SingleChildScrollView` have.
## Tested Platform
#### WEB

![cross_scroll web test](https://user-images.githubusercontent.com/73336909/149651423-d1dc936f-cfc0-4581-bb79-19e1fc4ec533.gif)
- MicroSoft Edge




#### Windows

![cross_scroll window test](https://user-images.githubusercontent.com/73336909/149651492-2ce542a7-7343-4651-81b1-d3eccf3f9bda.gif)
- Windows 10


## Getting started

TODO: List prerequisites and provide or point to information on how to
start using the package.

## Widget Details
`
CrossScroll(

      verticalBar: sc,
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

`

## Example

```dart

class Example extends StatelessWidget {
  Example({Key? key}) : super(key: key);
  final random = math.Random();
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
    Color.fromARGB(249, 20, 141, 150),
    Color.fromARGB(223, 18, 10, 32),
    Color.fromARGB(223, 109, 170, 39),
    Color.fromARGB(223, 131, 98, 8),

  ];

  CrossScrollBar sc= const CrossScrollBar(

    showTrackOnHover: true,
    trackVisibility: false,
  );
  @override
  Widget build(BuildContext context) {


    return CrossScroll(

      verticalBar: sc,
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
    );


  }
}
```

## Additional information

TODO: Tell users more about the package: where to find more information, how to 
contribute to the package, how to file issues, what response they can expect 
from the package authors, and more.
