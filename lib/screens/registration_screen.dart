import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:happy_soul/constants.dart';
import 'package:happy_soul/screens/email_verification.dart';
import 'package:happy_soul/screens/login_screen.dart';
import 'package:happy_soul/components/rounded_button.dart';
import 'package:happy_soul/screens/psychiatrist_data/psychiatrist_screen.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:uuid/uuid.dart';

class RegistrationScreen extends StatefulWidget {
  const RegistrationScreen({Key? key}) : super(key: key);

  static get id => 'registration_screen';

  @override
  _RegistrationScreenState createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  final _auth = FirebaseAuth.instance;
  final _fireStore = FirebaseFirestore.instance;
  var uuid = Uuid();

  bool showSpinner = false;

  late String name;
  late String email;
  late String contactNo;
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
                    'Register',
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
                  buildTextField('Enter your Name', (value) => name = value),
                  const SizedBox(height: 8.0),
                  buildTextField('Enter your email', (value) => email = value),
                  const SizedBox(height: 8.0),
                  buildTextField(
                      'Enter your Phone No', (value) => contactNo = value),
                  const SizedBox(height: 8.0),
                  buildTextField('Enter your Reset Pin',
                      (value) => resetPin = value, true),
                  const SizedBox(height: 8.0),
                  buildTextField(
                      'Enter your password', (value) => password = value, true),
                  const SizedBox(height: 8.0),
                  buildTextField(
                      'Confirm password', (value) => rePassword = value, true),
                  const SizedBox(height: 24.0),
                  RoundedButton(
                    color: const Color(0xFF0596FF),
                    title: 'Register',
                    onPressed: registerUser,
                  ),
                  const SizedBox(height: 8.0),
                  buildAlreadyUserRow(context),
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

  Widget buildAlreadyUserRow(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        const Text(
          'Already a user?',
          style: TextStyle(color: Colors.white),
        ),
        TextButton(
          onPressed: () {
            Navigator.pushNamed(context, LoginScreen.id);
          },
          child: const Text(
            'Log In',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }

  void registerUser() async {
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

      await _auth.createUserWithEmailAndPassword(
          email: email, password: password);

      await _fireStore.collection('users').add({
        'name': name,
        'contact_no': contactNo,
        'email': email,
        'country' : 'Pakistan',
        'reset_pin': resetPin,
        'password': password,
        'patient_id': uuid.v4(),
        'fcm_token': '',
      });

        if(email.contains('psychiatrist')) {
          Navigator.pushReplacementNamed(context, PsychiatristScreen.id);
        } else {
          Navigator.pushReplacementNamed(context, EmailVerification.routeName);
        }


      setState(() {
        showSpinner = false;
      });
    } on FirebaseAuthException catch (e) {
      setState(() {
        showSpinner = false;
      });

      print(e);
      Fluttertoast.showToast(
        msg: "",
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
