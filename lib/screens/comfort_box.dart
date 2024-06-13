import 'package:flutter/material.dart';
import 'package:flutter_gradient_app_bar/flutter_gradient_app_bar.dart';
import 'package:happy_soul/constants.dart';
import 'Shorts/home_page.dart';
import 'articles/Articles.dart';
import 'harmony/home/screens/home.dart';
import 'journals/journal_list.dart';

class ComfortBox extends StatefulWidget {
  static const String id = 'comfort_box';

  const ComfortBox({super.key});

  @override
  State<ComfortBox> createState() => _ComfortBoxState();
}

class _ComfortBoxState extends State<ComfortBox> {

  List<Map<String, String>> box_category = [
    {
      'category': 'Read an Article',
      'destination_id': '1',
      'image': 'images/comfort_box/reading.PNG',
    },
    {
      'category': 'Write a Journal',
      'destination_id': '2',
      'image': 'images/comfort_box/writing.PNG',
    },
    {
      'category': 'Listen Harmony',
      'destination_id': '3',
      'image': 'images/comfort_box/listening.PNG',
    },
    {
      'category': 'Play Shorts',
      'destination_id': '4',
      'image': 'images/comfort_box/watching.PNG',
    },
  ];

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
        title: const Text('Comfort Box'),
      ),
      body: Container(
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              kPrimaryColor,
              kSecondaryColor,
            ],
          ),
        ),
        child: SingleChildScrollView(
          child: Column(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(15),
                child: SizedBox.fromSize(
                  size: const Size.fromRadius(100),
                  child: Image.asset('images/comfort_box/cm_bg.png', fit: BoxFit.fitWidth),
                ),
              ),
              GridView.count(
                crossAxisCount: 2,
                controller: ScrollController(keepScrollOffset: false),
                shrinkWrap: true,
                childAspectRatio: (1 / 1.3),
                scrollDirection: Axis.vertical,
                children: List.generate(
                  box_category.length,
                      (index) {
                    return category(box_category[index]);
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget category(var category) {
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: Column(
        children: [
          LayoutBuilder(
            builder: (context, constraints) {
              // Calculate the dynamic size based on available constraints
              final double size = constraints.maxWidth;
              return TextButton(
                onPressed: () {
                  if(category['destination_id'] == '1'){
                    Navigator.pushNamed(context, Articles.id);
                  }
                  else if(category['destination_id'] == '2'){
                    Navigator.pushNamed(context, JournalList.id);
                  }
                  else if(category['destination_id'] == '3'){
                    Navigator.pushNamed(context, HarmonyHomeScreen.id);
                  }
                  else if(category['destination_id'] == '4'){
                    Navigator.pushNamed(context, ShortsScreen.id);
                  }
                },
                child: Container(
                  width: size,
                  height: size,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(15.0),
                    border: Border.all(
                      color: Color(0xFF0DAEB8),
                      width: 5.0,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.4),
                        spreadRadius: 3,
                        blurRadius: 8,
                        offset: const Offset(6, 6),
                      ),
                    ],
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(15),
                      child: SizedBox.fromSize(
                        size: const Size.fromRadius(48),
                        child: Image.asset(category['image'], fit: BoxFit.cover),
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
          const SizedBox(height: 10.0),
          Text(
            category['category'],
            style: const TextStyle(
              fontSize: 20.0,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }

}
