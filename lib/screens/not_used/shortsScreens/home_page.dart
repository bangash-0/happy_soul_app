import 'package:card_swiper/card_swiper.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'FormPopUP.dart';
import 'content_screen.dart';

class ShortsScreen1 extends StatefulWidget {
  static const String id = 'shorts_screen';

  @override
  State<ShortsScreen1> createState() => _ShortsScreen1State();
}

class _ShortsScreen1State extends State<ShortsScreen1> {

  FirebaseFirestore firestore = FirebaseFirestore.instance;

  final List<String> videos = [
    'https://assets.mixkit.co/videos/preview/mixkit-taking-photos-from-different-angles-of-a-model-34421-large.mp4',

  ];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // getVideos();
  }

  Future<void> getVideos() async {
    await firestore.collection('shorts').get().then((value) {
      for (var element in value.docs) {
        setState(() {
          videos.add(element['src']);
        });
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      // Set the theme to dark directly
      theme: ThemeData.dark(),
      home: Scaffold(
        body: SafeArea(
          child: Stack(
            children: [
              // We need swiper for every content
              Swiper(
                itemBuilder: (BuildContext context, int index) {
                  // videos.shuffle();
                  return ContentScreen(
                    src: videos[index],
                  );
                },
                itemCount: videos.length,
                scrollDirection: Axis.vertical,
              ),
            ],
          ),
        ),
        floatingActionButton: Visibility(
          visible: FirebaseAuth.instance.currentUser!.email == 'dev.bilawalhussain@gmail.com' ? true : false,
          child: FloatingActionButton(
            onPressed: () {
              showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return FormPopup();
                  }); // showDialog
            },
            child: const Icon(Icons.add),
          ),
        ),
      ),
    );
  }
}
