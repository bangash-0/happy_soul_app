import 'package:flutter/material.dart';
import 'package:flutter_gradient_app_bar/flutter_gradient_app_bar.dart';
import 'package:happy_soul/constants.dart';

class JournalDisplayScreen extends StatefulWidget {
  static const String id = 'journal_display_screen';
  const JournalDisplayScreen({super.key});

  @override
  _JournalDisplayScreenState createState() => _JournalDisplayScreenState();
}

class _JournalDisplayScreenState extends State<JournalDisplayScreen> {
  final TextEditingController _journalController = TextEditingController();

  @override
  Widget build(BuildContext context) {

    var journalText = '';
    final text = ModalRoute.of(context)!.settings.arguments;
    if(text != null){
      journalText = text as String;
    }

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
                  controller: TextEditingController(text: journalText), // Set the initial value using TextEditingController
                  onChanged: (value) {
                    // Update the journalText variable when the text changes
                    journalText = value;
                  },
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
                )
              ],
            ),
          ),
        ),

    );
  }
}
