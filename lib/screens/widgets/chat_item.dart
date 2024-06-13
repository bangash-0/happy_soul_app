import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';

final FlutterTts _flutterTts = FlutterTts();
int? _startWord, _endWord;

class ChatItem extends StatefulWidget {
  final String message;
  final bool isMe;

  const ChatItem({Key? key, required this.message, required this.isMe})
      : super(key: key);

  @override
  State<ChatItem> createState() => _ChatItemState();
}

class _ChatItemState extends State<ChatItem> {
  Map? _currentVoice;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    initTTS();
  }

  void initTTS() {
    _flutterTts.setProgressHandler((text, start, end, word) {
      setState(() {
        _startWord = start;
        _endWord = end;
      });
    });
    _flutterTts.getVoices.then((data) {
      try {
        List<Map> voices = List<Map>.from(data);
        voices = voices.where((voice) => voice["name"].contains("ur")).toList();
        setState(() {
          _currentVoice = voices[2];
          setVoice(_currentVoice!);
        });
      } catch (e) {
        print(e);
      }
    });
  }

  void setVoice(Map voice) async {
    await _flutterTts
        .setVoice({"name": voice["name"], "locale": voice["locale"]});
  }


  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment:
          widget.isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Container(
          constraints: BoxConstraints(
            maxWidth: MediaQuery.of(context).size.width * 0.75,
          ),
          margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
          decoration: BoxDecoration(
            color:
                widget.isMe ? const Color(0xFFD8F2E4) : const Color(0xFFC7EDFE),
            borderRadius: BorderRadius.only(
              topLeft: const Radius.circular(20),
              topRight: const Radius.circular(20),
              bottomLeft: widget.isMe
                  ? const Radius.circular(20)
                  : const Radius.circular(0),
              bottomRight: widget.isMe
                  ? const Radius.circular(0)
                  : const Radius.circular(20),
            ),
          ),
          child: Column(
            children: [
              Text(
                widget.message,
                style: const TextStyle(
                  color: Colors.black,
                  fontSize: 15,
                ),
              ),
            ],
          ),
        ),
        if (!widget.isMe) // Display only if message is not sent by me
          PlayPauseButton(
            message: widget.message,
          ),
      ],
    );
  }
}

class PlayPauseButton extends StatefulWidget {
  final String message;

  const PlayPauseButton({Key? key, required this.message}) : super(key: key);

  @override
  _PlayPauseButtonState createState() => _PlayPauseButtonState();
}

class _PlayPauseButtonState extends State<PlayPauseButton> {
  bool _isPlaying = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    checkCompletion();
  }

  void checkCompletion() {
    _flutterTts.setCompletionHandler(() {
      setState(() {
        _isPlaying = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return IconButton(
      style: ButtonStyle(
        padding: MaterialStateProperty.all<EdgeInsetsGeometry>(
          EdgeInsets.zero,
        ),
        backgroundColor: MaterialStateProperty.all<Color>(Colors.grey[200]!),
      ),
      icon: Icon(
        _isPlaying ? Icons.pause : Icons.play_arrow,
      ),
      onPressed: () {
        setState(() {
          if (_isPlaying) {
            _flutterTts.stop();
          } else {
            _flutterTts.speak(widget.message);
          }
          _isPlaying = !_isPlaying;
        });
      },
    );
  }

}
