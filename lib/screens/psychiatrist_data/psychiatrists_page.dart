import 'dart:convert';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_gradient_app_bar/flutter_gradient_app_bar.dart';
import 'package:happy_soul/constants.dart';
import 'package:happy_soul/screens/not_used/chat_page.dart';
import 'package:happy_soul/screens/chatting_screen.dart';
import 'package:happy_soul/screens/psychiatrist_data/meeting_request_screen.dart';
import 'package:http/http.dart';
import 'package:uuid/v4.dart';

import '../services/firebase_msg_api.dart';
import 'FormPopUP.dart';
import 'psychiatrist_display.dart';

class psychiatrist_details extends StatefulWidget {
  static const String id = 'psychiatrist_details';
  final country;

  const psychiatrist_details({super.key, required this.country});

  @override
  State<psychiatrist_details> createState() => _psychiatrist_detailsState();
}

class _psychiatrist_detailsState extends State<psychiatrist_details> {
  final List<Map<String, String>> dr_details = [];

  FirebaseFirestore firestore = FirebaseFirestore.instance;
  String psychiatrist_fcm_token = '';

  @override
  void initState() {
    super.initState();
    addInitialDoctors();
  }

  void addInitialDoctors() {


    firestore
        .collection('psychiatrist_data-${widget.country}')
        .get()
        .then((value) {
      dr_details.clear();
      for (var element in value.docs) {
        setState(() {
          dr_details.add({
            'name': element['name'],
            'country': element['country'],
            'description': element['description'],
            'address': element['address'],
            'experience': element['experience'],
            'image': element['image'],
            'email': element['email'],
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
        actions: [
          Visibility(
            visible:
                FirebaseAuth.instance.currentUser?.email == 'dev.bilawalhussain@gmail.com',
            child: IconButton(
              icon: const Icon(Icons.add),
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return FormPopup();
                  },
                );
              },
            ),
          ),
          IconButton(
            onPressed: () {
              Navigator.pushNamed(context, meetingRequest.id);
            },
            icon: const Icon(Icons.queue_play_next),
          ),
        ],
        title: const Text('Doctors'),
      ),
      body: GridView.count(
        crossAxisCount: 2,
        controller: ScrollController(keepScrollOffset: false),
        shrinkWrap: true,
        childAspectRatio: (1 / 1.5),
        scrollDirection: Axis.vertical,
        children: List.generate(
          dr_details.length,
          (index) {
            return buildDoctorTile(dr_details[index], context);
          },
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: Container(
        height: 50,
        width: 300,
        margin: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(50),
          gradient: const LinearGradient(
            colors: [
              kPrimaryColor,
              kSecondaryColor,
            ],
          ),
        ),
        child: ElevatedButton(
          onPressed: () {
            // Your button action
            Navigator.pushNamed(context, ChattingScreen.id);
          },
          style: ElevatedButton.styleFrom(
            // padding: EdgeInsets.zero, // Remove default padding
            backgroundColor: Colors.transparent, // Transparent background
            shadowColor: Colors.transparent, // Remove default shadow
          ),
          child: const Text(
            'AI Consultation',
            style: TextStyle(
                color: Colors.white, fontSize: 20.0), // Text color contrast
          ),
        ),
      ),
    );
  }

  Widget buildDoctorTile(var dr, var context) {
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: Column(
        children: [
          LayoutBuilder(
            builder: (context, constraints) {
              // Calculate the dynamic size based on available constraints
              final double size = constraints.maxWidth;
              return TextButton(
                style: ButtonStyle(
                  padding: MaterialStateProperty.all(
                    const EdgeInsets.all(0),
                  ),
                ),
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                        builder: (context) =>
                            PsychiatristDetailsDisplay(doctor: dr)),
                  );
                },
                child: Container(
                  width: size,
                  height: size,
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        kPrimaryColor,
                        kSecondaryColor,
                      ],
                    ),
                    borderRadius: BorderRadius.circular(15.0),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.5),
                        spreadRadius: 5,
                        blurRadius: 7,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: ClipRRect(
                      child: SizedBox.fromSize(
                        size: const Size.fromRadius(48),
                        child: Image.network(dr['image'], fit: BoxFit.cover),
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
          const SizedBox(height: 8.0),
          Text(
            dr['name'],
            style: const TextStyle(
              fontSize: 20.0,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
            textAlign: TextAlign.center,
            maxLines: 1,
          ),
          const SizedBox(height: 10.0),
          Container(
            height: 40.0,
            decoration: BoxDecoration(
              color: Colors.blue,
              borderRadius: BorderRadius.circular(50.0),
              gradient: const LinearGradient(
                colors: [
                  kPrimaryColor,
                  kSecondaryColor,
                ],
              ),
            ),
            child: TextButton(
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: const Text("Request Consultation", style: TextStyle(color: Colors.black, fontSize: 18),),
                      actions: [
                        TextButton(
                          onPressed: () {
                            Navigator.pop(context, false); // Dismiss the dialog and return false
                          },
                          child: const Text("No"),
                        ),
                        TextButton(
                          onPressed: () {
                            Navigator.pop(context, true); // Dismiss the dialog and return true
                          },
                          child: const Text("Yes"),
                        ),
                      ],
                    );
                  },
                ).then((value) async {
                  if (value != null && value) {
                    // "Yes" was pressed
                    // Do something here
                    String? userEmail = FirebaseAuth.instance.currentUser?.email;
                    var fcm_token = '';

                    // get user name
                    String? userName = '';

                    await FirebaseFirestore.instance
                        .collection('users')
                        .where('email', isEqualTo: userEmail)
                        .get()
                        .then((value) {
                      for (var element in value.docs) {
                        setState(() {
                          userName = element['name'];
                          fcm_token = element['fcm_token'];
                        });
                      }
                    });

                    await FirebaseFirestore.instance
                        .collection('users')
                        .where('email', isEqualTo: dr['email'])
                        .get()
                        .then((value) {
                      for (var element in value.docs) {
                        setState(() {
                          psychiatrist_fcm_token = element['fcm_token'];
                        });
                      }
                    });

                    if(userName == null || userName == '')
                    {
                      print('User name not found');
                    }
                    else{
                      await firestore.collection('meeting_requests').add({
                        'doctor_name': dr['name'],
                        'user_email': userEmail,
                        'psychiatrist_email': dr['email'],
                        'user_name': userName,
                        'status': 'Pending',
                        'meeting_id': const UuidV4().generate(),
                        'user_fcm_token': fcm_token,
                        'psychiatrist_fcm_token': psychiatrist_fcm_token,
                      }).then((value) => sendFCMNotification(psychiatrist_fcm_token, "Consultation Request from $userName"));
                    }

                  } else {
                    // "No" was pressed or dialog was dismissed
                    // Do something here
                  }
                });
              },
              style: TextButton.styleFrom(
                foregroundColor: Colors.white,
              ),
              child: const Text('Consult Now'),
            ),

          ),
        ],
      ),
    );
  }

}
