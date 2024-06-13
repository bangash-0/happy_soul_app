import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

import 'like_icon.dart';
import 'options_screen.dart';

const String pauseIconPath = 'assets/images/pause_icon.png'; // Replace with your path

class ContentScreen extends StatefulWidget {
  final String? src;

  const ContentScreen({Key? key, this.src}) : super(key: key);

  @override
  _ContentScreenState createState() => _ContentScreenState();
}

class _ContentScreenState extends State<ContentScreen> {
  late VideoPlayerController _videoPlayerController;
  ChewieController? _chewieController;
  bool _liked = false;

  @override
  void initState() {
    super.initState();
    initializePlayer();
  }

  Future initializePlayer() async {
    _videoPlayerController = VideoPlayerController.network(widget.src!);
    await Future.wait([_videoPlayerController.initialize()]);
    _chewieController = ChewieController(
      videoPlayerController: _videoPlayerController,
      autoPlay: true,
      looping: true,
      showControls: false,
      errorBuilder: (context, error) => Center(child: Text(error.toString())),
    );
  }

  @override
  void dispose() {
    _chewieController!.pause();
    _videoPlayerController.dispose();
    _chewieController!.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        _chewieController != null &&
            _chewieController!.videoPlayerController.value.isInitialized
            ? Stack(
          children: [
            GestureDetector(
              onTap: () {
                setState(() {
                  _chewieController!.isPlaying
                      ? _chewieController!.pause()
                      : _chewieController!.play();
                });
              },
              child: Chewie(
                controller: _chewieController!,
              ),
            ),
            _chewieController!.isPlaying ? Container() : const Center(
              child: Opacity(
                opacity: 0.75,
                child: Icon(
                  Icons.play_arrow,
                  size: 100,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        )
            : const Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(),
            SizedBox(height: 10),
            Text('Loading...')
          ],
        ),
        if (_liked)
          Center(
            child: LikeIcon(),
          ),
        // OptionsScreen()
      ],
    );
  }
}
