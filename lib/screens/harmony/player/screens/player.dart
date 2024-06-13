import 'dart:math';

import 'package:audioplayers/audioplayers.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import '../../home/model/recommendation_model.dart';

class PlayerScreen extends StatefulWidget {
  const PlayerScreen({super.key, required this.model});

  @override
  State<PlayerScreen> createState() => _PlayerScreenState();

  final RecommendationModel model;
}

class _PlayerScreenState extends State<PlayerScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _progress;
  final player = AudioPlayer();
  bool _playing = false;

  var playingIcon = const Icon(Icons.play_arrow);

  final music = [];
  var counter = 0;

  var random = 0 ;

  final ValueNotifier<double> _player = ValueNotifier<double>(0);
  bool _isDark = false;

  controllerListener() {
    if (_controller.status == AnimationStatus.forward ||
        _controller.status == AnimationStatus.completed) {
      increasePlayer();
    }
  }

  increasePlayer() async {
    if (_controller.status == AnimationStatus.forward ||
        _controller.status == AnimationStatus.completed) {
      if ((_player.value + .0005) > 1) {
        _player.value = 1;
        _controller.reverse();
      } else {
        _player.value += .00005;
      }

      await Future.delayed(
        const Duration(milliseconds: 100),
      );
      if (_player.value < 1) {
        increasePlayer();
      }
    }
  }

  @override
  void initState() {
    super.initState();

    getMusic();

    _controller = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );

    _progress = Tween<double>(begin: 0, end: 1).animate(_controller)
      ..addListener(() {
        setState(() {});
      });

    _controller.addListener(() {
      controllerListener();
    });
  }

  void getMusic() {
    // get music from firebase
    FirebaseFirestore.instance.collection('music').get().then((value) {
      for (var element in value.docs) {
        setState(() {
          music.add(element['src']);
        });
      }
    });

    // random = Random().nextInt(music.length - 1);
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: _isDark ? Colors.black : Colors.white,
      child: Scaffold(

        backgroundColor: widget.model.color.withOpacity(.1),
        body: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            children: [
              const SizedBox(height: 50),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    highlightColor: widget.model.color.withOpacity(.2),
                    onPressed: () {
                      player.stop();
                      Navigator.pop(context);
                    },
                    icon: Icon(
                      Icons.keyboard_backspace_rounded,
                      color: widget.model.color.shade300,
                    ),
                  ),
                  IconButton(
                    highlightColor: widget.model.color.withOpacity(.2),
                    onPressed: () {
                      setState(() {
                        _isDark = !_isDark;
                      });
                    },
                    icon: Icon(
                      _isDark
                          ? CupertinoIcons.sun_max_fill
                          : CupertinoIcons.moon_stars_fill,
                      color: widget.model.color.shade300,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              SizedBox.square(
                dimension: MediaQuery.sizeOf(context).width - 40,
                child: Stack(
                  children: [
                    Positioned.fill(
                      left: 30,
                      top: 30,
                      bottom: 30,
                      right: 30,
                      child: ValueListenableBuilder(
                          valueListenable: _player,
                          builder: (context, value, _) {
                            return CircularProgressIndicator(
                              color: widget.model.color.shade300,
                              value: value,
                              strokeCap: StrokeCap.round,
                              strokeWidth: 10,
                              backgroundColor:
                                  widget.model.color.withOpacity(.4),
                            );
                          }),
                    ),
                    Align(
                      alignment: Alignment.center,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(1000),
                        child: Container(
                          padding: const EdgeInsets.only(top: 120, left: 20),
                          height: 200,
                          width: 200,
                          color: widget.model.color.shade300,
                          child: Transform.scale(
                            scale: 3,
                            child: Lottie.asset('assets/lottie/yoga.json'),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 10),
              Text(
                widget.model.title,
                style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.w900,
                  color: widget.model.color.shade300,
                ),
              ),

              // author information
              // Text(
              //   widget.model.author,
              //   style: TextStyle(
              //     fontSize: 16,
              //     color: widget.model.color.shade300,
              //   ),
              // ),
              const SizedBox(height: 40),
              Row(
                children: [
                  const Spacer(),
                  IconButton(
                    highlightColor: widget.model.color.withOpacity(.5),
                    onPressed: () {
                      // add previous song functionality
                      player.stop();
                      counter--;
                      if(counter < 0){
                        counter = music.length - 1;
                      }
                      player.play(UrlSource(music[counter]));
                    },
                    icon: Icon(
                      Icons.skip_previous_rounded,
                      size: 50,
                      color: widget.model.color.withOpacity(.5),
                    ),
                  ),
                  const SizedBox(width: 30),
                  IconButton(
                    highlightColor: widget.model.color.withOpacity(.2),
                    onPressed: () async {
                      // add play/pause functionality
                      var random = Random().nextInt(music.length - 1);

                      await player.play(UrlSource(music[random]));

                      if (!_playing) {
                        player.resume();
                        _playing = true;
                      } else {
                        player.pause();
                        _playing = false;
                      }
                      if (_controller.status == AnimationStatus.completed) {
                        _controller.reverse();
                      } else {
                        _controller.forward();
                      }
                      // playSound();
                    },
                    icon: AnimatedIcon(
                      icon: AnimatedIcons.play_pause,
                      progress: _progress,
                      size: 50,
                      color: widget.model.color.shade300,
                    ),
                  ),
                  const SizedBox(width: 30),
                  IconButton(
                    highlightColor: widget.model.color.withOpacity(.5),
                    onPressed: () async {
                      //   add next song functionality
                      player.stop();
                      counter++;

                      if(counter > music.length - 1){
                        counter = 0;
                      }

                      await player.play(UrlSource(music[counter]));
                    },
                    icon: Icon(
                      Icons.skip_next_rounded,
                      size: 50,
                      color: widget.model.color.withOpacity(.5),
                    ),
                  ),
                  const Spacer(),
                ],
              ),
              ValueListenableBuilder(
                valueListenable: _player,
                builder: (context, value, _) {
                  return Slider(
                    thumbColor: widget.model.color.shade300,
                    activeColor: widget.model.color.shade300,
                    inactiveColor: widget.model.color.withOpacity(.4),
                    secondaryActiveColor: widget.model.color.withOpacity(.4),
                    secondaryTrackValue: .8,
                    value: value,
                    onChanged: (_) {
                      _controller.reverse();
                      _player.value = _;
                    },
                  );
                },
              ),
              const SizedBox(height: 30),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Text(
                  // for dynamix data
                  // widget.model.slogan,
                  'Find inner peace and balance in the harmony of the present moment...',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: widget.model.color.shade300,
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    player.stop();
    player.dispose();
  }

}
