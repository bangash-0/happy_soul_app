import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gradient_app_bar/flutter_gradient_app_bar.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import '../../constants.dart';
import 'quote_display.dart';

class QuotesList extends StatefulWidget {
  static const String id = 'quotes_list';

  const QuotesList({Key? key}) : super(key: key);

  @override
  State<QuotesList> createState() => _QuotesListState();
}

class _QuotesListState extends State<QuotesList> {
  final storageRef = FirebaseStorage.instance.ref();
  List<String> imageUrls = [];
  var folderLocation = 'Motivational';
  var fisrtTime = true;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final text = ModalRoute.of(context)?.settings.arguments;

    if (fisrtTime) {
      if (text is String) {
        folderLocation = '/Quotes/$text';
        _fetchImages();
      }
      fisrtTime = false;
    }

    final storageRef = FirebaseStorage.instance.ref();

    List<Map<String, String>> quote_categories = [
      {
        'category': 'Motivational',
        'destination_id': '1',
        'image': 'images/quotes/motivational.png',
      },
      {
        'category': 'Attitude',
        'destination_id': '2',
        'image': 'images/quotes/attitude.PNG',
      },
      {
        'category': 'Friendship',
        'destination_id': '3',
        'image': 'images/quotes/friendship.jpg',
      },
      {
        'category': 'Positive',
        'destination_id': '4',
        'image': 'images/quotes/positive.png',
      },
      {
        'category': 'Health and Fitness',
        'destination_id': '5',
        'image': 'images/quotes/healthandfiness.png',
      },
      {
        'category': 'Affirmations',
        'destination_id': '6',
        'image': 'images/quotes/affirmation.png',
      },
      {
        'category': 'Study',
        'destination_id': '7',
        'image': 'images/quotes/study.png',
      },
      {
        'category': 'Happiness',
        'destination_id': '8',
        'image': 'images/quotes/happy.png',
      },
    ];

    return Scaffold(
      appBar: GradientAppBar(
        title: const Text('Quotes'),
        gradient: const LinearGradient(
          colors: [
            kPrimaryColor,
            kSecondaryColor,
          ],
        ),
      ),
      // ...
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Container(
                color: const Color(0xFF63BCBC),
                child: Row(
                  children: buildMenuItem(quote_categories),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(5.0),
              child: SingleChildScrollView(
                scrollDirection: Axis.vertical,
                child: StaggeredGrid.count(
                  crossAxisCount: 2,
                  mainAxisSpacing: 5,
                  crossAxisSpacing: 5,
                  children: imageUrls.map((imageUrl) {
                    return StaggeredGridTile.count(
                      crossAxisCellCount: 1,
                      mainAxisCellCount: 1,
                      // Check if image is portrait
                      child: TextButton(
                        style: ButtonStyle(
                          padding: MaterialStateProperty.all(
                            const EdgeInsets.all(0),
                          ),
                        ),
                        onPressed: () {
                          // Navigator.pushNamed(context, ArticleDisplay.id);
                          Navigator.pushNamed(
                            context,
                            QuoteDisplay.id,
                            arguments: imageUrl,
                          );
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            image: DecorationImage(
                              image: NetworkImage(imageUrl),
                              fit: BoxFit.cover,
                            ),
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ),
            ),
          ],
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
        func();
      },
      child: Text(
        text,
        style: const TextStyle(fontSize: 18, color: Colors.white),
      ),
    );
  }

  Future<void> _fetchImages() async {
    final ListResult result = await storageRef.child(folderLocation).listAll();
    final urls =
        await Future.wait(result.items.map((ref) => ref.getDownloadURL()));
    setState(() {
      imageUrls = urls;
    });
  }

  List<Widget> buildMenuItem(List<Map<String, String>> menuItems) {
    return menuItems.map((item) {
      return buildCustomTextButton(
        item['category']!,
        () {
          // Navigator.pushNamed(context, ArticleDisplay.id);
          setState(() {
            folderLocation = '/Quotes/${item['category']}';
            _fetchImages();
          });
        },
      );
    }).toList();
  }
}
