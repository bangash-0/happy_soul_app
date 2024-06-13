import 'package:flutter/material.dart';
import 'package:flutter_gradient_app_bar/flutter_gradient_app_bar.dart';


class ReadArticles extends StatelessWidget {
  static const String id = 'read_articles';

  ReadArticles({super.key});

  List<String> articlesList = [
    'The best way to predict your future is to create it.',
    'The only way to do great work is to love what you do.',
    'The best time to plant a tree was 20 years ago. The second best time is now.',
    'Your limitation—it’s only your imagination.',
    'Push yourself, because no one else is going to do it for you.',
    'Great things never come from comfort zones.',
    'Dream it. Wish it. Do it.',
    'Success doesn’t just find you. You have to go out and get it.',
    'The harder you work for something, the greater you’ll feel when you achieve it.',
    'Dream bigger. Do bigger.',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: GradientAppBar(
        gradient: const LinearGradient(
          colors: [
            Color.fromARGB(255, 25, 178, 238),
            Color.fromARGB(200, 21, 236, 229)
          ],
        ),
        title: const Text('Read Articles'),
      ),
      body: GridView.count(
        crossAxisCount: 1,
        controller: ScrollController(keepScrollOffset: false),
        shrinkWrap: true,
        childAspectRatio: (1 / 0.25),
        scrollDirection: Axis.vertical,
        children: List.generate(
          articlesList.length,
              (index) {
            return articleItem(articlesList[index]);
          },
        ),
      ),
    );
  }

  Widget articleItem(String article) {
    return TextButton(

      onPressed: () {
      //   navigate to article display page
      },

      style: ButtonStyle(
        backgroundColor: MaterialStateProperty.all<Color>(Colors.white),
        shape: MaterialStateProperty.all<RoundedRectangleBorder>(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(0),
          ),
        ),
        padding: MaterialStateProperty.all<EdgeInsetsGeometry>(
          const EdgeInsets.all(0),
        ),
        textStyle: MaterialStateProperty.all<TextStyle>(
          const TextStyle(
            color: Colors.black,
            fontSize: 16,
            fontWeight: FontWeight.normal,
          ),
        ),
      ),

      child: Container(
        decoration: const BoxDecoration(
          border: Border(
            bottom: BorderSide(
              color: Colors.black,
              width: 1,
            ),
          ),
        ),
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Text(
              article.split(' ').length <= 10
                  ? article
                  : '${article.substring(0, 50)}...',
              style: const TextStyle(
                color: Colors.black,
                fontSize: 20,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
