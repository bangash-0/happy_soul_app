import 'package:card_swiper/card_swiper.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'content_screen.dart';
import 'FormPopUP.dart';

class ShortsScreen extends StatefulWidget {
  static const String id = 'shorts_screen';

  @override
  State<ShortsScreen> createState() => _ShortsScreenState();
}

class _ShortsScreenState extends State<ShortsScreen> {
  final List<String> videos = [
    'https://firebasestorage.googleapis.com/v0/b/happysoul-bb5a3.appspot.com/o/shorts%2F%20(1).mp4?alt=media&token=8817c3fb-4885-421f-b386-e39933b4e22c',
  ];

  @override
  initState() {
    super.initState();
    getVideos();
  }

  Future<void> getVideos() async {
    await FirebaseFirestore.instance.collection('shorts').get().then((value) {
      for (var element in value.docs) {
        setState(() {
          videos.add(element['src']);
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          decoration: const BoxDecoration(
            color: Colors.black,
          ),
          child: Stack(
            children: [
              //We need swiper for every content
              Swiper(
                itemBuilder: (BuildContext context, int index) {
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
      ),
      floatingActionButton: Visibility(
        visible: FirebaseAuth.instance.currentUser!.email ==
                'dev.bilawalhussain@gmail.com'
            ? true
            : false,
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
    );
  }
}
