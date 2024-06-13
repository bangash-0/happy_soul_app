import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gradient_app_bar/flutter_gradient_app_bar.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:happy_soul/screens/happy_chunks.dart';
import 'package:happy_soul/screens/login_screen.dart';
import 'package:happy_soul/screens/widgets/chat_item.dart';
import '../constants.dart';
import 'activities/breating_activity.dart';
import 'models/chats_provider.dart';
import 'widgets/text_and_voice_field.dart';

class ChattingScreen extends StatefulWidget {
  static const String id = 'chatting_screen';

  const ChattingScreen({super.key});

  @override
  State<ChattingScreen> createState() => _ChattingScreenState();
}

class _ChattingScreenState extends State<ChattingScreen> {
  String? selected_country = "Pakistan";

  ValueNotifier<bool> helpMenu = ValueNotifier<bool>(true);

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  void getCountry() {
    // get current user email
    String? userEmail = FirebaseAuth.instance.currentUser!.email;

    // if user exists
    if (userEmail != null) {
      // get the user document
      FirebaseFirestore.instance
          .collection('users')
          .doc(userEmail)
          .get()
          .then((value) {
        // get the location field
        String? country = value['country'];
        // set the location
        setState(() {
          selected_country = country;
        });
      });
    }
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
        title: const Text(
          'Express your Feelings',
          style: TextStyle(
              color: Colors.white, fontSize: 18.0, fontWeight: FontWeight.bold),
        ),
        actions: [
          // Location Icon
          Padding(
            padding: const EdgeInsets.all(7.0),
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
                iconSize: 30.0,
                icon: const Icon(Icons.location_on, color: Colors.blue),
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: const Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Location',
                              style: TextStyle(color: Colors.black),
                            ),
                            Divider(
                              color: Colors.black, // Adjust color as needed
                              thickness: 1.0, // Adjust thickness as needed
                            ),
                          ],
                        ),
                        content: StatefulBuilder(
                          builder:
                              (BuildContext context, StateSetter setState) {
                            // Default selected country
                            return Column(
                              mainAxisSize: MainAxisSize.min,
                              children: <Widget>[
                                // Radio button for America
                                RadioListTile(
                                  controlAffinity:
                                      ListTileControlAffinity.trailing,
                                  // Align control to the right
                                  dense: true,
                                  // Reduce the height of the tile
                                  title: const Text(
                                    'Pakistan',
                                    style: TextStyle(fontSize: 16.0),
                                  ),
                                  // Country name
                                  value: 'Pakistan',
                                  groupValue: selected_country,
                                  onChanged: (value) {
                                    setState(() {
                                      selected_country = value;
                                      updateCountry(selected_country!);
                                    });
                                    Navigator.pop(context,
                                        selected_country); // Close dialog after selection
                                  },
                                ),
                                RadioListTile(
                                  controlAffinity:
                                      ListTileControlAffinity.trailing,
                                  // Align control to the right
                                  dense: true,
                                  // Reduce the height of the tile
                                  title: const Text(
                                    'America',
                                    style: TextStyle(fontSize: 16.0),
                                  ),
                                  // Country name
                                  value: 'America',
                                  groupValue: selected_country,
                                  onChanged: (value) {
                                    setState(() {
                                      selected_country = value;
                                      updateCountry(selected_country!);
                                    });
                                    Navigator.pop(context,
                                        selected_country); // Close dialog after selection
                                  },
                                ),
                                RadioListTile(
                                  controlAffinity:
                                      ListTileControlAffinity.trailing,
                                  // Align control to the right
                                  dense: true,
                                  // Reduce the height of the tile
                                  title: const Text(
                                    'Saudi Arabia',
                                    style: TextStyle(fontSize: 16.0),
                                  ),
                                  // Country name
                                  value: 'Saudi Arabia',
                                  groupValue: selected_country,
                                  onChanged: (value) {
                                    setState(() {
                                      selected_country = value;
                                      updateCountry(selected_country!);
                                    });
                                    Navigator.pop(context,
                                        selected_country); // Close dialog after selection
                                  },
                                ),
                                // Add more RadioListTile widgets for other countries
                              ],
                            );
                          },
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ),

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
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('images/chat_bot_bg.png'),
            fit: BoxFit.fitWidth,
          ),
        ),
        child: Column(
          children: [
            ValueListenableBuilder(
              valueListenable: helpMenu,
              builder: (BuildContext context, bool value, Widget? child) {
                return value
                    ? Padding(
                        padding: const EdgeInsets.all(6.0),
                        child: Container(
                          decoration: BoxDecoration(
                            color: const Color(0xFF3C8682),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey
                                    .withOpacity(0.5), // Shadow color
                                spreadRadius: 2, // Spread radius
                                blurRadius: 1, // Blur radius
                                offset:
                                    const Offset(0, 3), // Offset from the top
                              ),
                            ],
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          width: 380,
                          height: 60,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              // Happy Chunks Button
                              Container(
                                decoration: BoxDecoration(
                                  color: const Color(0xFF3C8682),
                                  borderRadius: BorderRadius.circular(50.0),
                                  gradient: const LinearGradient(
                                    colors: [
                                      Color(0xFF7FB9EF),
                                      Color(0xFF589BA1),
                                    ],
                                  ),
                                ),
                                child: ElevatedButton(
                                  onPressed: () {
                                    String? userEmail = FirebaseAuth
                                        .instance.currentUser!.email;

                                    if (userEmail != 'bot@gmail.com') {
                                      // get the user document
                                      Navigator.pushNamed(
                                          context, HappyChunksMenu.id);
                                    } else {
                                      showDialog(
                                        context: context,
                                        builder: (BuildContext context) {
                                          return AlertDialog(
                                            title: const Text(
                                              'Alert',
                                              style: TextStyle(
                                                  color: Colors.black),
                                            ),
                                            content: const Text(
                                              'To use this feature, please login first',
                                              style: TextStyle(
                                                  fontSize: 16.0,
                                                  color: Colors.black),
                                            ),
                                            actions: <Widget>[
                                              TextButton(
                                                onPressed: () {
                                                  Navigator.pushNamed(
                                                      context, LoginScreen.id);
                                                },
                                                child: const Text('Login'),
                                              ),
                                            ],
                                          );
                                        },
                                      );
                                    }
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.transparent,
                                    foregroundColor: Colors.white,
                                    shadowColor: Colors.transparent,
                                  ),
                                  child: const Text(
                                    'Happy Chunks',
                                    style: TextStyle(
                                        fontSize: 16.0,
                                        fontWeight: FontWeight.normal),
                                  ),
                                ),
                              ),

                              // Crisis Support Button
                              Container(
                                decoration: BoxDecoration(
                                  color: const Color(0xFF3C8682),
                                  borderRadius: BorderRadius.circular(50.0),
                                  gradient: const LinearGradient(
                                    begin: Alignment.bottomLeft,
                                    end: Alignment.topRight,
                                    colors: [
                                      Color(0xFFab9a9b),
                                      Color(0xFFe02d06),
                                    ],
                                  ),
                                ),
                                child: ElevatedButton(
                                  onPressed: () {
                                    // Replace with your desired action (e.g., navigation)
                                    Navigator.pushNamed(
                                        context, BreathingActivity.id);
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.transparent,
                                    foregroundColor: Colors.white,
                                    shadowColor: Colors.transparent,
                                  ),
                                  child: const Text(
                                    'Crisis Moment',
                                    style: TextStyle(
                                        fontSize: 17.0,
                                        fontWeight: FontWeight.normal),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      )
                    : const SizedBox();
              },
            ),
            Expanded(
              child: Consumer(
                builder: (context, WidgetRef ref, child) {
                  final chats = ref.watch(chatProvider).reversed.toList();
                  return ListView.builder(
                    reverse: true,
                    itemCount: chats.length,
                    itemBuilder: (context, index) {
                      return ChatItem(
                        message: chats[index].message,
                        isMe: chats[index].isMe,
                      );
                    },
                  );
                },
              ),
            ),
            TextAndVoiceField(
              Location: selected_country,
            ),
          ],
        ),
      ),
    );
  }

  Future<void> updateCountry(String country) async {
    // get current user email
    String? userEmail = FirebaseAuth.instance.currentUser!.email;

    //   if user exists
    if (userEmail != null) {
      // get the user document

      final snapshot = await FirebaseFirestore.instance
          .collection('users')
          .where('email', isEqualTo: userEmail)
          .get();
      snapshot.docs.forEach((doc) {
        // update the location field
        doc.reference.update({'country': country});
      });
    }
  }
}
