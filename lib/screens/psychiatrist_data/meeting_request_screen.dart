import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gradient_app_bar/flutter_gradient_app_bar.dart';

import '../../constants.dart';

class meetingRequest extends StatefulWidget {
  static const String id = 'meetingRequest';

  const meetingRequest({super.key});

  @override
  State<meetingRequest> createState() => _meetingRequestState();
}

class _meetingRequestState extends State<meetingRequest> {
  final List<Map<String, String>> meeting_req = [];

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
        if (element['user_email'] != userEmail) {
          continue;
        }
        setState(() {
          meeting_req.add({
            'doctor_name': element['doctor_name'],
            'user_email': element['user_email'],
            'status': element['status'],
            'meeting_id': element['meeting_id'],
          });
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: GradientAppBar(
        title: const Text('Meeting Requests'),
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            kPrimaryColor,
            kSecondaryColor,
          ],
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: showCallRequests(meeting_req),
        ),
      ),
    );
  }

  Widget request(var req_data) {
    return Container(
      height: 160,
      alignment: Alignment.center,
      child: Card(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'You have requested consultation from',
              style: TextStyle(color: Colors.black, fontSize: 16),
            ),
            Text(
              req_data['doctor_name'],
              style: const TextStyle(
                  color: Colors.black,
                  fontSize: 18,
                  fontWeight: FontWeight.bold),
            ),
            Text(
              'Response : ${req_data['status']}',
              style: TextStyle(
                  color: req_data['status'] == 'accepted'
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
                  onPressed: () async {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: const Text(
                            "Cancel Request",
                            style: TextStyle(color: Colors.black, fontSize: 18),
                          ),
                          actions: [
                            TextButton(
                              onPressed: () {
                                Navigator.pop(context,
                                    false); // Dismiss the dialog and return false
                              },
                              child: const Text("No"),
                            ),
                            TextButton(
                              onPressed: () {
                                Navigator.pop(context,
                                    true); // Dismiss the dialog and return true
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
                        String? userEmail =
                            FirebaseAuth.instance.currentUser?.email;

                        await FirebaseFirestore.instance
                            .collection('meeting_requests')
                            .where('meeting_id',
                                isEqualTo: req_data['meeting_id'])
                            .get()
                            .then((value) {
                          for (var element in value.docs) {
                            setState(() {
                              element.reference.delete();
                            });

                          }
                        });

                      }

                      String meetingIdToRemove = req_data['meeting_id'];

                      meeting_req.removeWhere((meeting) => meeting['meeting_id'] == meetingIdToRemove);

                    });
                  },
                  child: const Text('Cancel Request'),
                ),
                const SizedBox(width: 10),
              ],
            )
          ],
        ),
      ),
    );
  }

  List<Widget> showCallRequests(var meeting_req) {
    List<Widget> widgets = [];
    for (int i = 0; i < meeting_req.length; i++) {
      widgets.add(request(meeting_req[i]));
    }
    return widgets;
  }

}
