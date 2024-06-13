import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:happy_soul/screens/login_screen.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

import '../components/rounded_button.dart';
import '../constants.dart';

class ResetPaswordScreen extends StatefulWidget {
  static const String id = 'reset_password_screen';
  const ResetPaswordScreen({super.key});

  @override
  State<ResetPaswordScreen> createState() => _ResetPaswordScreenState();
}

class _ResetPaswordScreenState extends State<ResetPaswordScreen> {
  final _auth = FirebaseAuth.instance;
  final _fireStore = FirebaseFirestore.instance;

  bool showSpinner = false;

  late String email;
  late String resetPin;
  late String password;
  late String rePassword;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Container(
        width: double.infinity,
        height: double.infinity,
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
                  const SizedBox(
                    height: 40.0,
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
                    height: 20.0,
                  ),
                  const Text(
                    'Reset',
                    style: TextStyle(
                      fontSize: 30.0,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(
                    height: 48.0,
                  ),
                  buildTextField('Enter your email', (value) => email = value),
                  const SizedBox(height: 8.0),
                  buildTextField('Enter your Reset Pin',
                          (value) => resetPin = value, true),
                  const SizedBox(height: 8.0),
                  buildTextField(
                      'Enter new password', (value) => password = value, true),
                  const SizedBox(height: 8.0),
                  buildTextField(
                      'Confirm password', (value) => rePassword = value, true),
                  const SizedBox(height: 24.0),
                  RoundedButton(
                    color: const Color(0xFF0596FF),
                    title: 'Reset',
                    onPressed: resetPassord,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget buildTextField(String hintText, Function(String) onChanged,
      [bool obscureText = false]) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(32.0),
      ),
      child: TextField(
        textAlign: TextAlign.center,
        obscureText: obscureText,
        onChanged: onChanged,
        decoration: InputDecoration(
          hintText: hintText,
          contentPadding:
          const EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(32.0),
          ),
          enabledBorder: OutlineInputBorder(
            borderSide: const BorderSide(color: Colors.blueAccent, width: 1.0),
            borderRadius: BorderRadius.circular(32.0),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: const BorderSide(color: Colors.blueAccent, width: 2.0),
            borderRadius: BorderRadius.circular(32.0),
          ),
        ),
      ),
    );
  }

  void resetPassord() async {
    setState(() {
      showSpinner = true;
    });

    print('Registering user');
    try {
      if (password != rePassword &&
          password.isNotEmpty &&
          rePassword.isNotEmpty) {
        Fluttertoast.showToast(
          msg: "Password does not match",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0,
        );
        setState(() {
          showSpinner = false;
        });
        return;
      }

      var userEmail = FirebaseAuth.instance.currentUser?.email;
      // Reference to the 'user' collection
      CollectionReference userCollectionRef = _fireStore.collection('users');

        QuerySnapshot querySnapshot = await userCollectionRef.where('email', isEqualTo: userEmail).get();

        // Check if any documents match the query
        if (querySnapshot.docs.isNotEmpty) {
          // Loop through the documents and retrieve the 'reset' column data
          querySnapshot.docs.forEach((doc) {
            // Assuming 'reset' is a field in the document
            dynamic resetPinata = doc['reset_pin'];
            if(resetPinata == resetPin) {
              _auth.currentUser?.updatePassword(password);
            } else {
              Fluttertoast.showToast(
                msg: "Reset Pin does not match",
                toastLength: Toast.LENGTH_SHORT,
                gravity: ToastGravity.CENTER,
                timeInSecForIosWeb: 1,
                backgroundColor: Colors.red,
                textColor: Colors.white,
                fontSize: 16.0,
              );
            }
          });
        } else {
          print('No documents found for email: $email');
        }

      Fluttertoast.showToast(
        msg: "Password Reset Successfully!",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 16.0,
      );

      Navigator.pushNamed(context, LoginScreen.id);

      setState(() {
        showSpinner = false;
      });
    } on FirebaseAuthException catch (e) {
      setState(() {
        showSpinner = false;
      });

      print(e);
      Fluttertoast.showToast(
        msg: "Problem Occured!",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 16.0,
      );
    }
  }

}
