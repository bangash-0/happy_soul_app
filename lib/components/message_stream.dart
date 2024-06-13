
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'message_bubble.dart';

class MessagesStream extends StatelessWidget {
  final _fireStore = FirebaseFirestore.instance;
  final String email ;

  MessagesStream({super.key, required this.email});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: _fireStore.collection('chat').snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Center(
            child: CircularProgressIndicator(
              backgroundColor: Colors.lightBlueAccent,
            ),
          );
        }
        final messages = snapshot.data?.docs.reversed;
        List<MessageBubble> messageBubbles = [];
        for (var message in messages!) {
          final messageText = message['text_by_user'];
          final messageSender = message['sender'];

          final messageWidget = MessageBubble(
            text: messageText,
            sender: messageSender,
            isMe: messageSender == email,
          );
          messageBubbles.add(messageWidget);
        }
        return Expanded(
          child: ListView(
            reverse: true,
            padding:
            const EdgeInsets.symmetric(horizontal: 10.0, vertical: 20.0),
            children: messageBubbles,
          ),
        );
      },
    );
  }
}