import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gradient_app_bar/flutter_gradient_app_bar.dart';
import 'package:happy_soul/constants.dart';
import 'package:happy_soul/screens/chatting_screen.dart';
import 'package:happy_soul/screens/login_screen.dart';
import 'psychiatrist_data/psychiatrist_screen.dart';

class EmailVerification extends StatefulWidget {
  static const String routeName = '/email_verification';

  const EmailVerification({super.key});

  @override
  State<EmailVerification> createState() => _EmailVerificationState();
}

class _EmailVerificationState extends State<EmailVerification> {
  bool isEmailVerified = false;
  Timer? timer;
  bool isEmailSent = true;

  @override
  void initState() {
    super.initState();

    isEmailVerified = FirebaseAuth.instance.currentUser!.emailVerified;

    print("Email is verified: $isEmailVerified");

    if (!isEmailVerified) {
      try {
        FirebaseAuth.instance.currentUser!.sendEmailVerification();
      } catch (e) {
        print("An error occurred while trying to send email verification");
        print(e);
      }

      timer = Timer.periodic(const Duration(seconds: 5), (timer) async {
        await FirebaseAuth.instance.currentUser!.reload();
        var user = FirebaseAuth.instance.currentUser;
        if (user!.emailVerified) {
          timer.cancel();

          // Using mounted to check if the widget is still in the tree before navigating
          if (!mounted) return;

          Navigator.pushReplacementNamed(context, ChattingScreen.id);
        }
      });
    } else {
      // Using a delayed call to allow the widget to be built before navigating
      WidgetsBinding.instance.addPostFrameCallback((_) {

        if (!mounted) return;

        Navigator.pushReplacementNamed(context, ChattingScreen.id);
      });
    }
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: GradientAppBar(
        title: const Text('Email Verification'),
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [kPrimaryColor, kSecondaryColor],
        ),
      ),
      body: Center(
        child: Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [kPrimaryColor, kSecondaryColor], // Gradient background
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              const Text(
                'Please verify your email address',
                style: TextStyle(color: Colors.white),
              ),
              ElevatedButton(
                onPressed: resendEmailVerification,
                style: ElevatedButton.styleFrom(
                  backgroundColor: kFontColor,
                  foregroundColor: Colors.white,
                ),
                child: const Text('Resend Email Verification'),
              ),
              ElevatedButton(
                onPressed: () {
                  FirebaseAuth.instance.signOut();
                  Navigator.pushReplacementNamed(context, LoginScreen.id);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: kFontColor,
                  foregroundColor: Colors.white,
                ),
                child: const Text("Cancel"),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> resendEmailVerification() async {
    try {
      await FirebaseAuth.instance.currentUser!.sendEmailVerification();

      setState(() {
        isEmailSent = false;
      });
      await Future.delayed(const Duration(seconds: 5));
      setState(() {
        isEmailSent = true;
      });
    } catch (e) {
      print("An error occurred while trying to send email verification");
      print(e);
    }
  }
}
