import 'package:flutter/material.dart';

class CustomVisibilityDetector extends StatefulWidget {
  final Widget child;
  final Size cellSize;
  final VoidCallback onVisibilityChanged;

  CustomVisibilityDetector({
    required this.child,
    required this.cellSize,
    required this.onVisibilityChanged,
  });

  @override
  State<CustomVisibilityDetector> createState() =>
      _CustomVisibilityDetectorState();
}

class _CustomVisibilityDetectorState extends State<CustomVisibilityDetector> {
  bool _isVisible = false;

  Widget _handleScroll(BuildContext context) {
    print("HandleSCroll");
    final RenderBox? renderBox = context.findRenderObject() as RenderBox?;
    if (renderBox == null || !renderBox.hasSize)
      return SizedBox(
        height: widget.cellSize.height,
        width: widget.cellSize.width,
      );

    final position = renderBox.localToGlobal(Offset.zero);
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.height;
    final visibleInHeight = position.dy >= 0 && position.dy <= screenHeight;
    final visibleInWidth = position.dx >= 0 && position.dx <= screenWidth;
    print(position);
    if (visibleInHeight && visibleInWidth) {
      return widget.child;
      // // setState(() {
      // _isVisible = visibleInHeight;
      // if (_isVisible) {
      //   widget.onVisibilityChanged();
      // }
      // });
    }
    return SizedBox(
      height: widget.cellSize.height,
      width: widget.cellSize.width,
    );
  }

  @override
  Widget build(BuildContext context) {
    print("BUILD");
    Widget? child;
    // WidgetsBinding.instance.addPersistentFrameCallback((_) {
    print("POST FRAME");
    setState(() {
      child = _handleScroll(context);
    });

    // });
    // if (child != null) {
    //   return child!;
    // }

    return SizedBox(
      height: widget.cellSize.height,
      width: widget.cellSize.width,
      child: child,
    );
  }
}

// class PostListOfProducts {
//   String? nazwa;
//   int? kalorie;
//   int? ig;
//
//   PostListOfProducts({this.nazwa, this.kalorie, this.ig});
//
//   PostListOfProducts.fromJson(Map<String, dynamic> json) {
//     nazwa = json['nazwa'];
//     kalorie = json['kalorie'];
//     ig = json['ig'];
//   }
// }
//
// class ApiDataSingleton {
//   List<PostListOfProducts> _products = [];
//
//   static final ApiDataSingleton instance = ApiDataSingleton._internal();
//
//   factory ApiDataSingleton() {
//     return instance;
//   }
//
//   ApiDataSingleton._internal();
//
//   /// Get product suggestions without calling the API multiple times.
//   ///
//   /// This method fetches product suggestions from the API based on the user's query.
//   /// If the suggestions haven't been fetched yet, it retrieves the data from the API.
//   ///
//   /// Parameters:
//   ///   - query: The user's search query for product suggestions.
//   ///
//   /// Returns:
//   ///   A Future that resolves to a list of product suggestions.
//   Future<List<PostListOfProducts>> productSuggestions(String query) async {
//     if (_products.isEmpty) {
//       // Fetch data from the API if it hasn't been fetched yet
//       _products = await PostListOfProductsAPI.getUserSuggestions(query)
//           .catchError((e) => throw e);
//     }
//
//     // Use data if it's already fetched
//     return Future.value(_products);
//   }
// }
//
// class PostListOfProductsAPI {
//   /// Fetch user suggestions from the API.
//   ///
//   /// This method retrieves user suggestions from the API based on the user's query.
//   ///
//   /// Parameters:
//   ///   - query: The user's search query for product suggestions.
//   ///
//   /// Returns:
//   ///   A Future that resolves to a list of user suggestions.
//   static Future<List<PostListOfProducts>> getUserSuggestions(
//       String query) async {
//     try {
//       SharedPreferences prefs = await SharedPreferences.getInstance();
//       final token = await prefs.getString('token');
//       final loginEmail = await prefs.getString('dietetyk');
//
//       Response response = await post(Uri.parse('https://some_page.com'),
//           headers: <String, String>{
//             'Accept': 'application/json',
//             'Authorization': 'Bearer $token',
//           },
//           body: <String, String>{
//             'loginEmail': loginEmail,
//           });
//
//       if (response.statusCode == 200) {
//         final List products = json.decode(response.body);
//
//         return products
//             .map((json) => PostListOfProducts.fromJson(json))
//             .where((PostListOfProducts) {
//           final nameLower = PostListOfProducts.nazwa!.toLowerCase();
//           final queryLower = query.toLowerCase();
//           return nameLower.contains(queryLower);
//         }).toList();
//       } else {
//         throw Exception("Error occurred: ${response.statusCode}");
//       }
//     } catch (e) {
//       throw e;
//     }
//   }
// }
//
// /// A widget representing a dropdown with type-ahead search.
// ///
// /// This widget displays a dropdown with type-ahead search functionality
// /// for selecting products based on user input.
// ///
// /// Usage:
// /// ```dart
// /// Widget dropDown = AppDropDown();
// /// ```
// Widget AppDropDown() {
//   return TypeAheadField<PostListOfProducts?>(
//     hideSuggestionsOnKeyboardHide: false,
//     textFieldConfiguration: TextFieldConfiguration(
//       controller: _typeAheadController,
//       decoration: const InputDecoration(
//         prefixIcon: Icon(Icons.search),
//         border: OutlineInputBorder(),
//         hintText: 'Wyszukaj produkt',
//       ),
//     ),
//     suggestionsCallback: ApiDataSingleton.instance.productSuggestions,
//     itemBuilder: (context, PostListOfProducts? suggestion) {
//       final post = suggestion!;
//       return ListTile(
//         title: Text(post.nazwa!),
//       );
//     },
//     noItemsFoundBuilder: (context) => const SizedBox(
//       height: 50,
//       child: Center(
//         child: Text(
//           'Brak produktów',
//           style: TextStyle(fontSize: 16),
//         ),
//       ),
//     ),
//     onSuggestionSelected: (PostListOfProducts? suggestion) {
//       final post = suggestion!;
//       _name = post.nazwa.toString();
//       _kcal = post.kalorie!.toInt();
//       _ig = post.ig!.toInt();
//       _typeAheadController.text = post.nazwa.toString();
//     },
//   );
// }
