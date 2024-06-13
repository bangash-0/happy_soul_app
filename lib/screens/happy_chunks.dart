import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gradient_app_bar/flutter_gradient_app_bar.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:happy_soul/constants.dart';
import 'package:happy_soul/screens/quotes/quotes_categories.dart';
import 'package:happy_soul/screens/services/ai_handler_gemini.dart';
import 'package:happy_soul/screens/services/ai_handler_gpt.dart';
import 'package:happy_soul/screens/Tracking/weekly_tracking.dart';

import 'comfort_box.dart';

class HappyChunksMenu extends StatelessWidget {
  static const String id = 'happy_chunks_menu';

  const HappyChunksMenu({Key? key}) : super(key: key);

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
        title: const Text('Happy Chunks'),
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
          physics: const NeverScrollableScrollPhysics(),
          child: Column(
            children: <Widget>[
              // Expanded(child: Container()),
              _buildImage('images/banner.png', 150.0),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Column(
                  children: [
                    _buildButton(
                      buttonText: 'Peaceful Mind Quotes',
                      imagePath: 'images/inwateronsecondscreen.png',
                      onPressed: () {
                        Navigator.pushNamed(context, QuotesCategories.id);
                      },
                    ),
                    _buildButton(
                      buttonText: 'Comfort Box',
                      imagePath: 'images/comfortbox.PNG',
                      onPressed: () {
                        Navigator.pushNamed(context, ComfortBox.id);
                      },
                    ),
                    _buildButton(
                      buttonText: 'Generate Report',
                      imagePath: 'images/generateRecord.png',
                      onPressed: () {
                        SetUserSentimentScore();
                        // Navigator.pushNamed(context, WeeklyReport.id);
                      },
                    ),
                    _buildButton(
                      buttonText: 'Progress Tracker',
                      imagePath: 'images/progress_tracker.PNG',
                      onPressed: () async {
                        // var response = getMessagesByUserEmail();
                        List<int> score = [];

                        String? userEmail =
                            FirebaseAuth.instance.currentUser?.email;

                        // Get the weekly report from the database
                        // Query to find messages sent by the user with the provided email
                        CollectionReference messagesCollection =
                            FirebaseFirestore.instance
                                .collection('weekly_report-$userEmail');

                        QuerySnapshot querySnapshot =
                            await messagesCollection.get();

                        querySnapshot.docs.forEach((doc) {
                          String scoreString = doc['score'];
                          try {
                            int parsedScore = int.parse(scoreString);
                            score.add(parsedScore);
                          } catch (e) {
                            print('Unable to parse score: $e');
                          }
                        });

                        Navigator.pushNamed(context, WeeklyReport.id,
                            arguments: score);
                      },
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildImage(String imagePath, double size) {
    return ClipRRect(
      child: SizedBox.fromSize(
        size: Size.fromRadius(size),
        child: Image.asset(imagePath, fit: BoxFit.fitWidth),
      ),
    );
  }

  Widget _buildButton({
    required String buttonText,
    required String imagePath,
    required VoidCallback onPressed,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5.0, horizontal: 8.0),
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(7),
          ),
        ),
        child: SizedBox(
          // width: double.infinity,
          height: 60,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              ClipRRect(
                child: SizedBox.fromSize(
                  size: const Size.fromRadius(30),
                  child: Image.asset(imagePath, fit: BoxFit.fitHeight),
                ),
              ),
              const SizedBox(width: 20),
              Text(
                buttonText,
                style: const TextStyle(
                  fontSize: 18.0,
                  color: Color(0xFF097B74),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

Future<String?> SetUserSentimentScore() async {
  List<Map<String, dynamic>> messages = [
    {
      'role': 'system',
      'content':
          'i have given you messages, try to score them from 0-100 based on, check message positivity, sadness, rudeness, every possible aspect and return answer a number from 0-100. remember only return an integer as output, nothing else. Just give a number'
    },
    {
      'role': 'system',
      'content':
          'Answer should only be an integer between 0-100. Remember, only a number.'
    },
  ];
  String? userEmail = FirebaseAuth.instance.currentUser?.email;

// Reference to your Firestore collection containing messages
  CollectionReference messagesCollection =
      FirebaseFirestore.instance.collection('chat-$userEmail');
  CollectionReference journalCollection =
      FirebaseFirestore.instance.collection('journal_written-$userEmail');

// Query to find messages sent by the user with the provided email
  QuerySnapshot queryChatSnapshot = await messagesCollection.get();

  QuerySnapshot queryJournalSnapshot = await journalCollection.get();

// Extract messages from the documents
  queryChatSnapshot.docs.forEach((doc) {
    var user = {
      "role": "user",
      "content": doc['user'],
    };
    messages.add(user);
  });

  queryJournalSnapshot.docs.forEach((doc) {
    var user = {
      "role": "user",
      "content": doc['content'],
    };
    messages.add(user);
  });

  AIHandlerGemini AI = AIHandlerGemini();
  final response = await AI.talkWithGemini(messages);

// AIHandlerGPT AI = AIHandlerGPT();
// final response = await AI.chatComplete(messages);

  CollectionReference trackerCollection =
      FirebaseFirestore.instance.collection('weekly_report-$userEmail');

  Map<String, dynamic> userData = {
    'score': response,
    'date': DateTime.now(),
// Add more fields as needed
  };

  trackerCollection.add(userData).then((value) {
    print('Report Gen -> $response');

    Fluttertoast.showToast(
        msg: "Report Generated Successfully!",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.black54,
        textColor: Colors.white,
        fontSize: 16.0);

  }).catchError((error) {
    Fluttertoast.showToast(
        msg: "Report Generation Failed!",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.black54,
        textColor: Colors.white,
        fontSize: 16.0);
  });

  return response;
}
