import 'package:flutter/material.dart';

class MessageBubble extends StatelessWidget {
  final String text;
  final String sender;
  final bool isMe;

  const MessageBubble(
      {super.key,
      required this.text,
      required this.sender,
      required this.isMe});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(6.0),
      child: Column(
        crossAxisAlignment: isMe ?  CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: <Widget>[
          // show user name on top of message
          Text(
            sender,
            style: const TextStyle(
              fontSize: 12.0,
              color: Colors.black54,
            ),
          ),

          // show message in a bubble
          Material(
            elevation: 5.0,
            borderRadius: isMe ?  const BorderRadius.only(
                topLeft: Radius.circular(15.0),
                bottomRight: Radius.circular(15.0),
                bottomLeft: Radius.circular(15.0)) :
                const BorderRadius.only(
                topRight: Radius.circular(15.0),
                bottomRight: Radius.circular(15.0),
                bottomLeft: Radius.circular(15.0)),

            color: isMe ? Colors.lightBlueAccent : Colors.grey.shade200,
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(vertical: 7.0, horizontal: 15.0),
              child: Text(
                text,
                style: TextStyle(
                    color: isMe ? Colors.white : Colors.black, fontSize: 16.0),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
