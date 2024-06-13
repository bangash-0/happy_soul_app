import 'package:flutter/material.dart';

import 'text_and_voice_field.dart';

class ToggleButton extends StatefulWidget {
  final InputMode _inputMode;
  final VoidCallback _onSendTextMessage;
  final VoidCallback _onSendVoiceMessage;

  final bool _isReplying;
  final bool _isListening;

  ToggleButton(
      {super.key,
      required InputMode inputMode,
      required VoidCallback onSendTextMessage,
      required VoidCallback onSendVoiceMessage,
      required bool isReplying,
      required bool isListening})
      : _inputMode = inputMode,
        _onSendTextMessage = onSendTextMessage,
        _onSendVoiceMessage = onSendVoiceMessage,
        _isReplying = isReplying,
        _isListening = isListening;

  @override
  State<ToggleButton> createState() => _ToggleButtonState();
}

class _ToggleButtonState extends State<ToggleButton> {
  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: Icon(
        widget._inputMode == InputMode.text ? Icons.send : widget._isListening ? Icons.mic : Icons.mic_none_outlined,
        color: Colors.white,
        size: 25,
      ),
      onPressed: () {
        // add send message functionality here
        widget._isReplying
            ? null
            : widget._inputMode == InputMode.text
                ? widget._onSendTextMessage()
                : widget._onSendVoiceMessage();
      },
    );
  }
}
