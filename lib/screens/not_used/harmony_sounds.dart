import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gradient_app_bar/flutter_gradient_app_bar.dart';
import '../../constants.dart';

class HarmonySounds extends StatefulWidget {
  static const String id = 'harmony_sounds';

  const HarmonySounds({Key? key}) : super(key: key);

  @override
  State<HarmonySounds> createState() => _HarmonySoundsState();
}

class _HarmonySoundsState extends State<HarmonySounds> {
  var elements = soundElements;
  final player = AudioCache();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: GradientAppBar(
        title: const Text('Harmony Sounds'),
        gradient: const LinearGradient(
          colors: [
            kPrimaryColor,
            kSecondaryColor,
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      body: Container(
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
        child: GridView.count(
          crossAxisCount: 5,
          controller: ScrollController(keepScrollOffset: false),
          shrinkWrap: true,
          childAspectRatio: (1 / 1.3),
          scrollDirection: Axis.vertical,
          children: List.generate(
            elements.length,
                (index) {
              return ShowSoundIcon(elements[index]);
            },
          ),
        ),
      ),
    );
  }

  Widget ShowSoundIcon(var element) {
    String img = element['icon'];
    var audio = element['audio'];

    return TextButton(
      onPressed: () {
        // Play audio when button is pressed

      },
      style: ButtonStyle(
        backgroundColor: MaterialStateProperty.all(Colors.transparent),
        padding: MaterialStateProperty.all(const EdgeInsets.all(0)),
        textStyle: MaterialStateProperty.all(
          const TextStyle(
            color: Colors.white,
          ),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: Colors.transparent,
          ),
          child: Column(
            children: <Widget>[
              Expanded(
                child: Image.asset(
                  "images/sound_images/$img",
                  fit: BoxFit.cover,
                ),
              ),
              Padding(
                padding: EdgeInsets.all(5.0),
                child: Text(
                  element['title'],
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

}
