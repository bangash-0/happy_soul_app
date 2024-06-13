import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gradient_app_bar/flutter_gradient_app_bar.dart';
import 'package:happy_soul/constants.dart';
import 'package:happy_soul/screens/psychiatrist_data/patient_report.dart';
import 'package:happy_soul/screens/services/firebase_msg_api.dart';

import '../login_screen.dart';

class PsychiatristScreen extends StatefulWidget {
  static const String id = 'psychiatrist_screen';

  const PsychiatristScreen({super.key});

  @override
  State<PsychiatristScreen> createState() => _PsychiatristScreenState();
}

class _PsychiatristScreenState extends State<PsychiatristScreen> {
  final List<Map<String, String>> meeting_req = [];
  String patient_fcm_token = '';

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    addInitialRequests();
  }

  void addInitialRequests() {
    String? userEmail = FirebaseAuth.instance.currentUser!.email;
    meeting_req.clear();

    FirebaseFirestore.instance
        .collection('meeting_requests')
        .get()
        .then((value) {
      for (var element in value.docs) {
        if (userEmail != element['psychiatrist_email']) {
          continue;
        }
        setState(() {
          meeting_req.add({
            'doctor_name': element['doctor_name'],
            'user_email': element['user_email'],
            'status': element['status'],
            'meeting_id': element['meeting_id'],
            'user_name': element['user_name'],
            'fcm_token': element['user_fcm_token']
          });
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: GradientAppBar(
        title: const Text('Patient Request'),
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            kPrimaryColor,
            kSecondaryColor,
          ],
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(
                top: 7.0, bottom: 7.0, right: 7.0, left: 3.0),
            child: Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.5), // Shadow color
                    spreadRadius: 2, // Spread radius
                    blurRadius: 5, // Blur radius
                    offset: const Offset(0, 3), // Offset from the top
                  ),
                ],
              ),
              child: IconButton(
                padding: EdgeInsets.zero,
                // Set padding to zero
                iconSize: 35.0,
                icon: const Icon(Icons.person_outline, color: Colors.red),
                // Set icon color to red
                onPressed: () {
                  showMenu(
                    context: context,
                    position: RelativeRect.fromLTRB(
                        MediaQuery.of(context).size.width, 75, 0, 0),
                    items: [

                      PopupMenuItem(
                        child: ListTile(
                          leading: const Icon(Icons.logout),
                          title: const Text('Sign Out'),
                          onTap: () async {
                            // Call the signOut function to log the user out
                            await FirebaseAuth.instance.signOut();
                            Navigator.pushReplacementNamed(context, LoginScreen.id);
                          },
                        ),
                      ),
                    ],
                  );
                  // Navigator.pushNamed(context, RegistrationScreen.id);
                },
              ),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: showCallRequests(meeting_req),
        ),
      ),
    );
  }

  Widget request(var reqData) {
    return TextButton(
      onPressed: () async {
        List<int> score = [];

        String? patientEmail = reqData['user_email'];


        // Get the weekly report from the database
        // Query to find messages sent by the user with the provided email
        CollectionReference messagesCollection =
        FirebaseFirestore.instance
            .collection('weekly_report-$patientEmail');

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

        Navigator.pushNamed(context, PatientReport.id,
            arguments: score);
      },
      style: ElevatedButton.styleFrom(
        padding: EdgeInsets.zero,
        backgroundColor: Colors.transparent,
        shadowColor: Colors.transparent,
      ),
      child: Container(
        height: 160,
        alignment: Alignment.center,
        child: Card(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'Request for consultation from',
                style: TextStyle(color: Colors.black, fontSize: 16),
              ),
              Text(
                reqData['user_name']?.toString() ?? 'User Name',
                style: const TextStyle(
                    color: Colors.black,
                    fontSize: 18,
                    fontWeight: FontWeight.bold),
              ),
              Text(
                'Response : ${reqData['status']}',
                style: TextStyle(
                    color: reqData['status'] == 'accepted'
                        ? Colors.green
                        : Colors.red,
                    fontSize: 16),
              ),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red[400],
                      foregroundColor: Colors.white,
                    ),
                    onPressed: () {
                      updateRequestStatus(reqData?? '', 'cancelled');
                    },
                    child: const Text('Cancel Request'),
                  ),
                  const SizedBox(width: 10),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green[400],
                      foregroundColor: Colors.white,
                    ),
                    onPressed: () {
                      updateRequestStatus(reqData?? '', 'accepted');
                    },
                    child: const Text('Accept Request'),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  List<Widget> showCallRequests(var meetingReq) {
    List<Widget> widgets = [];
    for (int i = 0; i < meetingReq.length; i++) {
      widgets.add(request(meetingReq[i]));
    }
    return widgets;
  }

  Future<void> updateRequestStatus(var meetingId, String status) async {
    sendFCMNotification( meetingId['fcm_token'] , "Your request has been $status");

    await FirebaseFirestore.instance
        .collection('meeting_requests')
        .where('meeting_id', isEqualTo: meetingId['meeting_id'])
        .get()
        .then((value) {
      for (var element in value.docs) {
        setState(() {
          element.reference.update({'status': status});
          meetingId['status'] = status;
        });
      }
    });
  }

}
