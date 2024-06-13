import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:happy_soul/constants.dart';
import 'package:happy_soul/screens/psychiatrist_data/psychiatrists_page.dart';

import '../../constants.dart';

class BreathingActivity extends StatefulWidget {
  static const String id = 'breathing_activity';

  const BreathingActivity({Key? key}) : super(key: key);

  @override
  _BreathingActivityState createState() => _BreathingActivityState();
}

class _BreathingActivityState extends State<BreathingActivity>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;
  double _value = 0.5;
  bool start_state = false;
  String buttonText = 'Start';
  String activityText = 'Hold';
  int secondsLeft = 60;
  late Timer _timer;
  int _secondsRemaining = 60;
  bool _isPaused = false;

  bool checker = true;

  String country = 'Pakistan';

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 4), // 4 seconds for each breath
    );
    _animation = Tween<double>(begin: 0.5, end: 1.0).animate(_controller)
      ..addListener(() {
        setState(() {}); // Update the state when animation value changes
      });

    _value = _animation.value;
  }

  void start() {
    _controller.repeat(reverse: true); // Repeat animation in both directions

    _controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        // Reset the timer when it completes
        setState(() {
          secondsLeft = 60;
          buttonText = 'Start';
          start_state = false;
        });
      }
    });

// Start the periodic timer
    _timer = Timer.periodic(Duration(seconds: 1), (Timer timer) {
      if (start_state && secondsLeft > 0) {
        setState(() {
          secondsLeft--;
        });
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    _timer.cancel();
    super.dispose();
  }

  void _startTimer() {
    const oneSec = Duration(seconds: 1);
    _timer = Timer.periodic(
      oneSec,
      (Timer timer) {
        if (!_isPaused) {
          if (_secondsRemaining == 0) {
            _timer.cancel();
            // Timer has completed, you can perform any action here.
            // For example, display a message or navigate to another screen.
          } else {
            setState(() {
              _secondsRemaining--;
            });
          }
        }
      },
    );
  }

  void _pauseTimer() {
    _isPaused = true;
  }

  void _resumeTimer() {
    _isPaused = false;
  }

  double getCurrentValue() {
    // Return a value between 0.5 and 0.9
    return _animation.value;
  }

  void checkAndGo() {
    double currentValue = getCurrentValue();

    if (currentValue > _value) {
      // Value is increasing, trigger login
      activityText = 'OUT';
    } else if (currentValue < _value) {
      // Value is not increasing
      activityText = 'IN';
    }

    // Update previous value
    _value = currentValue;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Stack(
          children: [
            Container(
              width: double.infinity,
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    kPrimaryColor,
                    kSecondaryColor,
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    'Breathing Activity',
                    style: TextStyle(
                        fontSize: 30.0,
                        color: Colors.white,
                        fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 50.0),
                  // Animated circle
                  Container(
                    width: 310.0,
                    height: 310.0,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.white,
                    ),
                    child: AnimatedBuilder(
                      animation: _animation,
                      builder: (context, child) {
                        checkAndGo();

                        return GestureDetector(
                          onTapDown: (_) {
                            // Start the ripple effect animation
                            _controller.forward(from: 0);
                          },
                          onTapUp: (_) {
                            // Reverse the ripple effect animation
                            _controller.reverse();
                          },
                          child: Container(
                            width: 300.0,
                            height: 300.0,
                            child: Stack(
                              alignment: Alignment.center,
                              children: [
                                // Background black circle with larger radius
                                Container(
                                  width: 350 * _animation.value,
                                  height: 350 * _animation.value,
                                  decoration: const BoxDecoration(
                                    shape: BoxShape.circle,
                                    gradient: RadialGradient(
                                      radius: 1,
                                      colors: [
                                        kPrimaryColor,
                                        kSecondaryColor,
                                      ],
                                    ),
                                  ),
                                ),
                                // Inner white circle
                                Container(
                                  width: 220 * _animation.value,
                                  height: 220 * _animation.value,
                                  decoration: const BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: Colors.white,
                                  ),
                                  child: Center(
                                    child: Text(
                                      activityText,
                                      style: const TextStyle(
                                          fontSize: 24, color: Color(0xFF097B74)),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),

                  const SizedBox(height: 50),

                  Text(
                    '0 : $_secondsRemaining',
                    style: const TextStyle(fontSize: 24),
                  ),
                  const SizedBox(height: 20),

                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.teal,
                    ),
                    onPressed: () {
                      setState(() {
                        activityText = 'Hold';

                        if (_secondsRemaining == 0) {
                          _secondsRemaining = 60;
                        }

                        if (checker) {
                          _startTimer();
                          start();
                          checker = false;
                        }
                        if (start_state) {
                          _pauseTimer();
                          _controller.stop();
                          start_state = false;
                          buttonText = 'Start';
                        } else {
                          _resumeTimer();
                          _controller.repeat(reverse: true);
                          start_state = true;

                          buttonText = 'Stop';
                        }
                      });
                    },
                    child: Text(
                      buttonText,
                      style :
                          const TextStyle(fontSize: 16.0, color: Colors.white),
                    ),
                  ),
                  const SizedBox(height: 50),
                  // Button
                  ElevatedButton(
                    onPressed: () async {
                      // Handle button press
                      String? userEmail =
                          FirebaseAuth.instance.currentUser!.email;

                      //   if user exists
                      if (userEmail != null) {
                        // get the user document

                        final snapshot = await FirebaseFirestore.instance
                            .collection('users')
                            .where('email', isEqualTo: userEmail)
                            .get();
                        for (var doc in snapshot.docs) {
                          // update the location field
                          country = doc['country'];
                        }
                      }

                      // Navigator.pushNamed(context, psychiatrist_details.id, arguments: country);

                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => psychiatrist_details(country: country),
                        ),
                      );
                    },

                    child: const Text(
                      'Mind Masters',
                      style:
                          TextStyle(fontSize: 16.0, color: Color(0xFF008000)),
                    ),
                  ),
                ],
              ),
            ),
            Positioned(
              top: 72,
              left: 10,
              child: IconButton(
                color: Colors.white,
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: const Icon(Icons.arrow_back),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
