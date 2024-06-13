import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gradient_app_bar/flutter_gradient_app_bar.dart';
import 'package:happy_soul/constants.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class JournalWrittingScreen extends StatefulWidget {
  static const String id = 'journal_writting_screen';

  const JournalWrittingScreen({super.key});

  @override
  _JournalWrittingScreenState createState() => _JournalWrittingScreenState();
}

class _JournalWrittingScreenState extends State<JournalWrittingScreen> {
  final TextEditingController _journalTitle = TextEditingController();
  final TextEditingController _journalContent = TextEditingController();

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
        title: const Text('Journal'),
      ),
      body: Container(
        color: Colors.grey[100],
        height: double.infinity,
        child: SingleChildScrollView(
          // Wrap with SingleChildScrollView for scrolling
          child: Column(
            children: [
              TextField(
                controller: _journalTitle,
                maxLines: null, // Allow unlimited lines
                decoration: InputDecoration(
                  hintText: 'Enter Title',
                  enabledBorder: const OutlineInputBorder(
                    borderSide: BorderSide(
                        color: Colors
                            .transparent), // Transparent border removes underline
                  ),
                  focusedBorder: const OutlineInputBorder(
                    borderSide: BorderSide(
                        color: Colors
                            .white), // Optional: Change border color on focus
                  ),
                  fillColor: Colors.grey[100],
                  // Add background color
                  filled: true, // Enable background color filling
                ),
                style: const TextStyle(fontSize: 16.0), // Adjust font size
              ),
              TextField(
                controller: _journalContent,
                maxLines: null, // Allow unlimited lines
                decoration: InputDecoration(
                  hintText: 'Write your journal here...',
                  enabledBorder: const OutlineInputBorder(
                    borderSide: BorderSide(
                        color: Colors
                            .transparent), // Transparent border removes underline
                  ),
                  focusedBorder: const OutlineInputBorder(
                    borderSide: BorderSide(
                        color: Colors
                            .white), // Optional: Change border color on focus
                  ),
                  fillColor: Colors.grey[100],
                  // Add background color
                  filled: true, // Enable background color filling
                ),
                style: const TextStyle(fontSize: 16.0), // Adjust font size
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // save data to data base
          sendDataToFirestore();
        },
        child: const Icon(Icons.save),
      ),
    );
  }

  void sendDataToFirestore() {
    // Get a reference to the Firestore instance
    FirebaseFirestore firestore = FirebaseFirestore.instance;

    // Define the data to be sent
    var currentDate = '${DateTime.now().day}-${DateTime.now().month}-${DateTime.now().year}';
    String title = _journalTitle.text;
    String content = _journalContent.text;
    var fullDate = DateTime.now();
    String? userEmail = FirebaseAuth.instance.currentUser?.email;

    // Send data to Firestore
    firestore.collection('/journal_written-$userEmail').add({
      'currentDate': currentDate,
      'title': title,
      'content': content,
      'fullDate': fullDate,
      'id': firestore.collection('/journal_written').doc().id,

    }).then((value) {
      print("Data sent successfully!");
    }).catchError((error) {
      print("Failed to send data: $error");
    });
  }
}
