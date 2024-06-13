import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gradient_app_bar/flutter_gradient_app_bar.dart';
import 'package:happy_soul/constants.dart';
import 'package:happy_soul/screens/journals/journal_display.dart';
import 'package:happy_soul/screens/journals/write_journal.dart';

class JournalList extends StatefulWidget {
  static const String id = 'journal_list';

  const JournalList({Key? key}) : super(key: key);

  @override
  State<JournalList> createState() => _JournalListState();
}

class _JournalListState extends State<JournalList> {
  List<Map<String, String>> journalList = [];
  var image_path = 'images/journal.PNG';

  @override
  void initState() {
    super.initState();
    getDataFromFirestore();
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
        title: const Text('Journal List'),
      ),
      body: Container(
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [kPrimaryColor, kSecondaryColor],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: GridView.count(
          crossAxisCount: 2,
          controller: ScrollController(keepScrollOffset: false),
          shrinkWrap: true,
          childAspectRatio: (1 / 1),
          scrollDirection: Axis.vertical,
          children: List.generate(
            journalList.length,
                (index) {
              return categoryItem(journalList[index], context);
            },
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushNamed(
            context,
            JournalWrittingScreen.id,
          );
        },
        backgroundColor: Colors.white,
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget categoryItem(var journal, var context) {
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.transparent,
          borderRadius: BorderRadius.circular(15),
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
              JournalDisplayScreen.id,
              arguments: journal['content'],
            );
          },
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(15),
                child: SizedBox.fromSize(
                  size: const Size.square(120),
                  child: Image.asset('images/journal.PNG', fit: BoxFit.cover),
                ),
              ),
              Text(
                journal['date'],
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 15.0,
                  color: Color(0xFFE0E0E0),
                ),
              ),
              Text(
                journal['title'],
                maxLines: 1,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 20.0,
                  // fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void getDataFromFirestore() {
    // Get a reference to the Firestore instance
    FirebaseFirestore firestore = FirebaseFirestore.instance;

    String? userEmail = FirebaseAuth.instance.currentUser?.email;

    // Reference to the collection where you stored the data
    CollectionReference collectionRef = firestore.collection('/journal_written-$userEmail');

    // Subscribe to real-time updates
    collectionRef.snapshots().listen((QuerySnapshot querySnapshot) {
      // Clear the existing data before updating with new data
      setState(() {
        journalList.clear();

        // Loop through the documents in the query snapshot
        for (var doc in querySnapshot.docs) {
          // Access fields from the document
          var currentDate = doc['currentDate'];
          var title = doc['title'];
          var content = doc['content'];

          // Create a map containing the data and add it to the list
          journalList.add({
            'date': currentDate,
            'title': title,
            'content': content,
          });
        }
      });
    });
  }

}
