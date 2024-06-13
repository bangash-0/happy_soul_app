import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gradient_app_bar/flutter_gradient_app_bar.dart';
import 'package:happy_soul/constants.dart';
import 'package:lottie/lottie.dart';
import '../../player/screens/player.dart';
import '../data/mood_data.dart';
import '../data/recommendations.dart';
import '../model/recommendation_model.dart';
import '../widgets/balls_widget.dart';
import 'FormPopUP.dart';

class HarmonyHomeScreen extends StatefulWidget {

  static const id = 'harmony_home_screen';
  const HarmonyHomeScreen({super.key});

  @override
  State<HarmonyHomeScreen> createState() => _HarmonyHomeScreenState();
}

class _HarmonyHomeScreenState extends State<HarmonyHomeScreen> {
  final ValueNotifier<String> _notifier =
      ValueNotifier<String>(MoodData.calm.name);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: GradientAppBar(
        title: const Text("Harmonies"),
        gradient: const LinearGradient(
          colors: [
            // Colors.indigoAccent,
            // Colors.indigo,
            kPrimaryColor,
            kSecondaryColor
          ],
        ),

      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 10),
            SizedBox(
              height: 130,
              child: ValueListenableBuilder<String>(
                  valueListenable: _notifier,
                  builder: (context, value, _) {
                    return ListView.builder(
                      itemCount: MoodData.moods.length,
                      scrollDirection: Axis.horizontal,
                      itemBuilder: (context, index) {
                        var mood = MoodData.moods[index];
                        return GestureDetector(
                          onTap: () {
                            if (value != mood.name) {
                              _notifier.value = mood.name;
                            }
                          },
                          child: Column(
                            children: [
                              AnimatedContainer(
                                curve: Curves.fastEaseInToSlowEaseOut,
                                duration: const Duration(milliseconds: 500),
                                height: 70,
                                width: 70,
                                padding: EdgeInsets.all(
                                    value == mood.name ? 15 : 10),
                                margin: const EdgeInsets.symmetric(
                                    horizontal: 7.5, vertical: 10),
                                decoration: ShapeDecoration(
                                  color: value == mood.name
                                      ? kSecondaryColor
                                      : Theme.of(context)
                                          .colorScheme
                                          .background,
                                  // color: Colors.indigo,
                                  shape: value == mood.name
                                      ? const StarBorder(
                                          pointRounding: .8,
                                          points: 4,
                                          innerRadiusRatio: .75,
                                        )
                                      : const CircleBorder(
                                          eccentricity: 1,
                                          side: BorderSide(
                                            color: kPrimaryColor,
                                            width: 2,
                                          ),
                                        ),
                                  // shape: BoxShape.circle,
                                  // border: Border.all(
                                  //   color: Colors.indigo,
                                  //   width: 2,
                                  // ),
                                ),
                                child: Image.asset(
                                  mood.icon,
                                  color: value == mood.name
                                      ? Colors.white
                                      : kSecondaryColor,
                                ),
                              ),
                              Text(
                                mood.name,
                                style: TextStyle(
                                  color: Colors.indigo,
                                  fontWeight: value == mood.name
                                      ? FontWeight.w900
                                      : FontWeight.normal,
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    );
                  }),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(30),
                child: Stack(
                  children: [
                    Container(
                      height: 250,
                      width: double.infinity,
                      decoration: BoxDecoration(
                          color: Colors.indigo.shade300,
                          border: Border.all(color: Colors.indigo.shade300)),
                    ),
                    Positioned(
                      height: 220,
                      right: -80,
                      bottom: -30,
                      child: Lottie.asset('assets/lottie/yoga.json'),
                    ),
                    Positioned.fill(
                      top: 35,
                      left: 16,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            "Ready to start\nyour first session?",
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 24,
                            ),
                          ),
                          const SizedBox(height: 10),
                          Text(
                            "Meditation 5-10 min",
                            style: TextStyle(
                              color: Colors.white.withOpacity(.8),
                            ),
                          ),
                          const Spacer(),
                          SizedBox(
                            width: 140,
                            child: FilledButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.white,
                                  foregroundColor: Colors.indigo,
                                ),
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) => PlayerScreen(
                                        model: RecommendationsData.mindfulMoments,
                                      ),
                                    ),
                                  );
                                },
                                child: const Text("START")),
                          ),
                          const Spacer(),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
            const Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Text(
                    "Recommended for you",
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.indigo
                    ),
                  ),
                ),
                // TextButton(
                //   onPressed: () {},
                //   child: const Text("View all"),
                // ),
              ],
            ),
            const SizedBox(height: 10),
            SizedBox(
              height: 220,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: RecommendationsData.all.length,
                itemBuilder: (context, index) {
                  RecommendationModel model = RecommendationsData.all[index];
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Balls(model: model),
                  );
                },
              ),
            )
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
                });
          },
          child: const Icon(Icons.add),
        ),
      )
    );
  }
}
