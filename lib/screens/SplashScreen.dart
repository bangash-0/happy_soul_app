import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:happy_soul/constants.dart';
import 'package:happy_soul/screens/chatting_screen.dart';

import 'package:happy_soul/screens/login_screen.dart';

import 'psychiatrist_data/psychiatrist_screen.dart';

class SplashScreen extends StatefulWidget {
  static const String id = 'splash_screen';
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  String? userEmail = FirebaseAuth.instance.currentUser?.email;

  @override
  void initState() {
    super.initState();

    Future.delayed(const Duration(seconds: 3), () {
      if(userEmail != null) {
        if(userEmail!.contains('psychiatrist')) {
          Navigator.pushReplacementNamed(context, PsychiatristScreen.id);
        } else {
          Navigator.pushReplacementNamed(context, ChattingScreen.id);
        }
      } else {
        Navigator.pushReplacementNamed(context, LoginScreen.id);
      }
    });

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Container(
          height: double.infinity,
          width: double.infinity,
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                kPrimaryColor,
                kSecondaryColor
              ],
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              _buildImage('images/banner.png', 200.0),
              const SizedBox(
                height: 20.0,
              ),
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
}