import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:happy_soul/constants.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:happy_soul/screens/chatting_screen.dart';
import 'package:happy_soul/screens/email_verification.dart';
import 'package:happy_soul/screens/psychiatrist_data/psychiatrist_screen.dart';
import 'package:happy_soul/screens/registration_screen.dart';
import 'package:happy_soul/screens/resetPasswordScreen.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import '../components/rounded_button.dart';
import 'not_used/chat_page.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  static get id => 'login_screen';

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  String email = "";
  String password = "";

  final _auth = FirebaseAuth.instance;
  bool showSpinner = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Container(
        height: MediaQuery.of(context).size.height,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [kPrimaryColor, kSecondaryColor],
          ),
        ),
        child: ModalProgressHUD(
          inAsyncCall: showSpinner,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.1,
                  ),
                  const Text(
                    'Happy Soul',
                    style: TextStyle(
                        fontSize: 45.0,
                        fontWeight: FontWeight.bold,
                        color: Colors.white),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(
                    height: 30.0,
                  ),
                  const Text('Login',
                      style: TextStyle(
                        fontSize: 30.0,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                      textAlign: TextAlign.center),
                  const SizedBox(
                    height: 48.0,
                  ),
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(30.0),
                    ),
                    child: TextField(
                      keyboardType: TextInputType.emailAddress,
                      textAlign: TextAlign.center,
                      onChanged: (value) {
                        //Do something with the user input.
                        email = value;
                      },
                      decoration: kTextFieldDecoration.copyWith(
                        hintText: 'Enter your email',
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 8.0,
                  ),
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(30.0),
                    ),
                    child: TextField(
                      textAlign: TextAlign.center,
                      obscureText: true,
                      onChanged: (value) {
                        //Do something with the user input.
                        password = value;
                      },
                      decoration: kTextFieldDecoration.copyWith(
                        hintText: 'Enter your password.',
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 24.0,
                  ),
                  TextButton(
                    style: TextButton.styleFrom(
                      backgroundColor: const Color(0xFF0596FF),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                    onPressed: () async {
                      //Implement login functionality.
                      setLoader();
                      try {
                        final user = await _auth.signInWithEmailAndPassword(
                            email: email, password: password);
                        final userEmail = await _auth.currentUser!.email;
                        final fCMToken =
                            await FirebaseMessaging.instance.getToken();

                        if (user != null) {
                          await FirebaseFirestore.instance
                              .collection('users')
                              .where('email', isEqualTo: userEmail)
                              .get()
                              .then((value) {
                            for (var element in value.docs) {
                              setState(() {
                                element.reference
                                    .update({'fcm_token': fCMToken});
                              });
                            }
                          });
                          setLoader();
                          if (email.contains('psychiatrist')) {
                            Navigator.pushReplacementNamed(
                                context, PsychiatristScreen.id);
                          } else {
                            Navigator.pushReplacementNamed(
                                context, EmailVerification.routeName);
                          }
                        }
                      } on FirebaseAuthException catch (e) {
                        print(e.code);
                        const TextStyle style = TextStyle(
                          color: Colors.grey,
                        );
                        setLoader();
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              backgroundColor: Colors.white,
                              title: const Text(
                                "User not present",
                                style: style,
                              ),
                              content: const Text(
                                "The provided credentials are not valid. Please check your email and password.",
                                style: style,
                              ),
                              actions: <Widget>[
                                TextButton(
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                  child: const Text("OK"),
                                ),
                              ],
                            );
                          },
                        );
                      }
                    },
                    child: const Text(
                      'Log In',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      const Text(
                        "Forgot your password?",
                        style: TextStyle(
                          color: Colors.white,
                        ),
                      ),
                      TextButton(
                        onPressed: () {
                          //Implement forgot password functionality.
                          Navigator.pushNamed(context, ResetPaswordScreen.id);
                        },
                        child: const Text(
                          "Reset",
                          style: TextStyle(
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      const Text(
                        "Don't have an account?",
                        style: TextStyle(
                          color: Colors.white,
                        ),
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.pushNamed(context, RegistrationScreen.id);
                        },
                        child: const Text(
                          "Register",
                          style: TextStyle(
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void setLoader() {
    setState(() {
      showSpinner = !showSpinner;
    });
  }
}
