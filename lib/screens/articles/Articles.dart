import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gradient_app_bar/flutter_gradient_app_bar.dart';
import 'package:happy_soul/screens/articles/article_display.dart';
import '../../constants.dart';
import 'FormPopUP.dart';

class Articles extends StatefulWidget {
  static const String id = 'articles';

  const Articles({super.key});

  @override
  State<Articles> createState() => _ArticlesState();
}

class _ArticlesState extends State<Articles> {

  List<Map<String, String>> article_category = [
    {
      'category': 'Introspection',
      'id': '1',
    },
    {
      'category': 'Goal Setting',
      'id': '2',
    },
    {
      'category': 'Habit Building',
      'id': '3',
    },
    {
      'category': 'Motivational',
      'id': '4',
    },
    {
      'category': 'Health & Fitness',
      'id': '5',
    },
  ];

  String _selectedCategory = 'Introspection';

  FirebaseFirestore firestore = FirebaseFirestore.instance;

  List<Map<String, String>> articles = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    addInitialArticles();
  }

   void addInitialArticles(){
    firestore.collection('articles-Introspection').get().then((value) {
      articles.clear();
      for (var element in value.docs) {
        setState(() {
          articles.add({
            'title': element['title'],
            'image': element['image'],
            'category': element['category'],
            'link': element['link'],
          });
        });
      }
    });
   }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: GradientAppBar(
        gradient: const LinearGradient(
          colors: [
            kPrimaryColor,
            kSecondaryColor,
          ],
        ),
        title: const Text('Articles'),
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              kPrimaryColor,
              kSecondaryColor,
            ],
          ),
        ),
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Container(
                  color: const Color(0xFF63BCBC),
                  child: Row(
                    children: buildMenuItem(article_category),
                  ),
                ),
              ),
              SingleChildScrollView(
                scrollDirection: Axis.vertical,
                child: Column(
                  children: buildArticleWidgets(articles, context),
                ),
              ),
            ],
          ),
        ),
      ),

      floatingActionButton: Visibility(
        visible: FirebaseAuth.instance.currentUser!.email == 'dev.bilawalhussain@gmail.com' ? true : false,
        child: FloatingActionButton(
          onPressed: () async {

        
            showDialog(
              context: context,
              builder: (BuildContext context) {
                return FormPopup();
              },
            );
          },
          backgroundColor: Colors.white,
          child: const Icon(Icons.add),
        ),
      ),
    );
  }

  Widget buildCustomTextButton(var text, var func) {
    return TextButton(
      style: ButtonStyle(
        textStyle: MaterialStateProperty.all(
          const TextStyle(fontWeight: FontWeight.normal),
        ),
        padding: MaterialStateProperty.all(
          const EdgeInsets.only(top: 0, bottom: 0, left: 10, right: 10),
        ),
        shape: MaterialStateProperty.all(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(0.0),
          ),
        ),
      ),
      onPressed: () {
        // Navigator.pushNamed(context, ArticleDisplay.id);
        func();
      },
      child: Text(
        text,
        style: const TextStyle(fontSize: 18, color: Colors.white),
      ),
    );
  }

  Widget buildArticleWidget(var img, var title, var link, context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: TextButton(
        style: ButtonStyle(
          padding: MaterialStateProperty.all(
            const EdgeInsets.all(0),
          ),
          shape: MaterialStateProperty.all(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30.0),
            ),
          ),
        ),
        onPressed: () {
          // Navigator.pushNamed(context, ArticleDisplay.id);
          Navigator.pushNamed(
            context,
            Article_Display.id,
            arguments: link,
          );
        },
        child: Column(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(30.0),

              // Adjust the radius as needed
              child: SizedBox.fromSize(
                size: const Size.fromHeight(200),
                child: Image.network(
                  img, // Adjust path to your image
                  fit: BoxFit.fitWidth,

                ),
              ),
            ),
            const SizedBox(height: 10),
            // Add some spacing between image and text
            Text(
              title,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 20, color: Colors.white),
            ),
          ],
        ),
      ),
    );
  }

  List<Widget> buildMenuItem(List<Map<String, String>> menuItems) {
    return menuItems.map((item) {
      return buildCustomTextButton(
        item['category']!,
        () {
          _selectedCategory = item['category']!;

          firestore.collection('articles-$_selectedCategory').get().then((value) {
            articles.clear();
            for (var element in value.docs) {
              articles.add({
                'title': element['title'],
                'image': element['image'],
                'category': element['category'],
                'link': element['link'],
              });
            }
            setState(() {});
          });
        },
      );
    }).toList();
  }

  List<Widget> buildArticleWidgets(List<Map<String, String>> articles, var context) {
    return articles.map((article) {
      return buildArticleWidget(
        article['image']!,
        article['title']!,
        article['link']!,
        context
      );
    }).toList();
  }
}
