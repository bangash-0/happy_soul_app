import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gradient_app_bar/flutter_gradient_app_bar.dart';
import 'package:happy_soul/constants.dart';
import 'package:happy_soul/screens/quotes/quotes_list.dart';

import 'FormPopUP.dart';

class QuotesCategories extends StatelessWidget {
  static const String id = 'QuotesCategories';

  QuotesCategories({super.key});

  List<Map<String, String>> quote_categories = [
    {
      'category': 'Motivational',
      'destination_id': '1',
      'image': 'images/quotes/motivation_1.jpg',
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: GradientAppBar(
        gradient: const LinearGradient(
          colors: [kPrimaryColor, kSecondaryColor],
        ),
        title: const Text('Quotes'),
        actions: [
          Visibility(
            visible: FirebaseAuth.instance.currentUser?.email == 'dev.bilawalhussain@gmail.com',
            child: IconButton(
              icon: const Icon(Icons.add),
              onPressed: () {
                // Navigator.pushNamed(context, FormPopup.id);
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return FormPopup();
                  },
                );
              },
            ),
          ),
        ],
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [kPrimaryColor, kSecondaryColor],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: GridView.count(
          crossAxisCount: 2,
          controller: ScrollController(keepScrollOffset: false),
          shrinkWrap: true,
          childAspectRatio: (1 / 1),
          scrollDirection: Axis.vertical,
          children: List.generate(
            quote_categories.length,
            (index) {
              return categoryItem(quote_categories[index], context);
            },
          ),
        ),
      ),
    );
  }

  Widget categoryItem(var item, var context) {
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(15),
          border: Border.all(
            color: const Color(0xFF4087DB),
            width: 2,
          ),
        ),
        child: TextButton(
          style: ButtonStyle(
            padding: MaterialStateProperty.all(
              const EdgeInsets.all(0),
            ),
            shape: MaterialStateProperty.all(
              RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
            ),
          ),
          onPressed: () {
            Navigator.pushNamed(
              context,
              QuotesList.id,
              arguments: item['category'],
            );
          },
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(15),
                child: SizedBox.fromSize(
                  size: const Size.square(90),
                  child: Image.asset(item['image'], fit: BoxFit.cover),
                ),
              ),
              Text(
                item['category'],
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 20.0,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
