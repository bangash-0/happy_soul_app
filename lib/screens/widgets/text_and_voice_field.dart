import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:happy_soul/constants.dart';
import 'package:happy_soul/screens/services/ai_handler_gemini.dart';
import 'package:happy_soul/screens/services/ai_handler_gpt.dart';
import 'package:happy_soul/screens/services/voice_handler.dart';
import 'package:happy_soul/screens/widgets/toggle_btn.dart';
import 'package:uuid/uuid.dart';

import '../happy_chunks.dart';
import '../models/chat_model.dart';
import '../models/chats_provider.dart';

enum InputMode {
  text,
  voice,
}

class TextAndVoiceField extends ConsumerStatefulWidget {
  String? Location;

  TextAndVoiceField({super.key, required this.Location});

  @override
  ConsumerState<TextAndVoiceField> createState() => _TextAndVoiceFieldState();
}

class _TextAndVoiceFieldState extends ConsumerState<TextAndVoiceField> {
  InputMode _inputMode = InputMode.voice;
  final TextEditingController _controller = TextEditingController();
  String? userEmail = FirebaseAuth.instance.currentUser?.email;

  List<Map<String, dynamic>> messagesHistory = [
    {
      "role": "system",
      "content":
          "This empathetic mental health support system offers kind and supportive conversations for users facing mental health challenges. It actively listens, provides encouragement, and suggests helpful resources and coping strategies for concerns like stress, anxiety, depression, and loneliness. Maintaining a respectful, non-judgmental tone, it prioritizes the user's well-being. Implementing features for assessing emotions, tailoring responses, and respecting privacy, it enhances the user experience with mood tracking, goal setting, and progress monitoring. Importantly, it never reveals its true identity as a support system and strives to address the user's situation comprehensively without causing disappointment. Emojis such as 😊, 👍, 🌈, 🌞, 🌸, 🌟, 🤗, 🌼, 🌻, and others are used to convey empathy and support, ensuring a friendly and personal interaction. Concrete, concise answers of 1 to 2 lines are provided, with occasional humorous replies to uplift the user's spirits. The support system asks 'How are you doing today' once at the start of a chat but not thereafter, avoiding repetitiveness and maintaining engagement. Varied expressions are used to convey the concept of recalling information, fostering an engaging conversation flow",
    },
    {
      'role': 'system',
      'content':
          'this chat is going to be in languages (English / Urdu / Pashto / Arabic and other), reply back in language that user asked question in (if user asks in roman then reply in roman else if he asks in native than reply in native, dont use english every where unless needed) also never forget emojis in your replies, they are very important to make user feel that he is talking to a human',
    },
    {
      'role': 'system',
      'content':
          'never say you dont have the answer or you are a bot, always try to answer the question in a way that user feels that he is talking to a human',
    },
    {
      'role': 'system',
      'content':
          'dont say talk to some one else, ask him to talk to you, you are the one who is going to solve his problem',
    },
  ];

  final AIHandlerGemini _gemini = AIHandlerGemini();
  final AIHandlerGPT _openai = AIHandlerGPT();

  final VoiceHandler voiceHandler = VoiceHandler();

  bool _isReplying = false;
  bool _isListening = false;

  int msgCounter = 0;

  @override
  void initState() {
    voiceHandler.initSpeech();
    messagesHistory.add(
      {
        'role': 'system',
        'content':
            'try to answer user according to the country ${widget.Location} he is from, like if he is from pakistan than try to answer him in a way that he feels that he is talking to a pakistani',
      },
    );

    displayData(userEmail!);
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var bot = {
      "role": "system",
      "content":
          "try to solve user problem based on their country ${widget.Location}",
    };
    messagesHistory.add(bot);

    return Padding(
      padding: const EdgeInsets.only(left: 10, right: 10, bottom: 10, top: 5),
      child: Row(
        children: [
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                // color: Colors.white,
                borderRadius: BorderRadius.circular(50),
                border: Border.all(
                  color: Colors.white,
                  width: 2,
                ),
                gradient: const LinearGradient(
                  colors: [kPrimaryColor, kSecondaryColor],
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.7), // Shadow color
                    spreadRadius: 2, // Spread radius
                    blurRadius: 2, // Blur radius
                    offset: const Offset(2, 4), // Shadow offset
                  ),
                ],
              ),
              child: TextField(
                controller: _controller,
                onChanged: (value) {
                  // add typing functionality here
                  value.isEmpty
                      ? setState(() {
                          _inputMode = InputMode.voice;
                        })
                      : setState(() {
                          _inputMode = InputMode.text;
                        });
                },
                style: const TextStyle(color: Colors.white),
                decoration: const InputDecoration(
                  hintText: 'Type a message',
                  hintStyle: TextStyle(
                      color: Colors.white, fontWeight: FontWeight.w400),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(50)),
                    borderSide: BorderSide.none,
                  ),
                  contentPadding: EdgeInsets.symmetric(horizontal: 20),
                ),
              ),
            ),
          ),
          const SizedBox(width: 5),
          Container(
            decoration: BoxDecoration(
              color: const Color(0xFF7DD1BD), // Background color of icon
              shape: BoxShape.circle,
              border: Border.all(
                color: Colors.white,
                width: 2,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.7), // Shadow color
                  spreadRadius: 2, // Spread radius
                  blurRadius: 2, // Blur radius
                  offset: const Offset(2, 4), // Shadow offset
                ),
              ],
            ),
            child: ToggleButton(
              isListening: _isListening,
              isReplying: _isReplying,
              inputMode: _inputMode,
              onSendTextMessage: () {
                sendTextMessage(_controller.text);
              },
              onSendVoiceMessage: sendVoiceMessage,
            ),
          ),
        ],
      ),
    );
  }

  void displayData(String userEmail) {
    final chats = ref.read(chatProvider.notifier);

    FirebaseFirestore.instance
        .collection('chat-$userEmail')
        .orderBy('date_time')
        .get()
        .then((QuerySnapshot querySnapshot) {
      for (var doc in querySnapshot.docs) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;

        // add user message on screen
        chats.add(ChatModel(
          id: const Uuid().v4(),
          message: data['user'],
          isMe: true,
        ));

        // add assistant message on screen
        chats.add(ChatModel(
          id: const Uuid().v4(),
          message: data['assistant'],
          isMe: false,
        ));

        // add user message to chat history
        var user = {
          "role": "user",
          "content": data['user'],
        };

        messagesHistory.add(user);

        // add assistant message to history
        var bot = {
          "role": "assistant",
          "content": data['assistant'],
        };

        messagesHistory.add(bot);
      }
    }).catchError((error) {
      print("Failed to retrieve data: $error");
    });
  }

  Future<void> sendTextMessage(String message) async {
    msgCounter++;
    msgCounter++;
    var oldMsgs = messagesHistory;

    if (msgCounter == 15) {
      // set user sentiment score
      SetUserSentimentScore();

      // get summery of last 15 messages
      oldMsgs.removeRange(0, 6);
      var summery = await _openai.getSummery(oldMsgs);

      CollectionReference usersCollection =
          FirebaseFirestore.instance.collection('summeries-$userEmail');

      Map<String, dynamic> userSummery = {
        'summery': summery,
        'date_time': DateTime.now(),
        // Add more fields as needed
      };

      usersCollection.add(userSummery).then((value) {}).catchError((error) {});

      msgCounter = 0;
    }
    setState(() {
      _isReplying = true;
    });
    // add send text message functionality here
    final chats = ref.read(chatProvider.notifier);
    _controller.clear();

    chats.add(ChatModel(
      id: const Uuid().v4(),
      message: message,
      isMe: true,
    ));

    var user = {
      "role": "user",
      "content": message,
    };

    messagesHistory.add(user);

    // final response = await _openAI.getResponse(jsonDataList);

    _inputMode = InputMode.voice;

    chats.add(const ChatModel(
      id: 'typing',
      isMe: false,
      message: 'Typing...',
    ));

    // gemini working code
    // final response = await _gemini.talkWithGemini(messagesHistory);

    // openai working code

    final response = await _openai.chatComplete(messagesHistory);

    removeTyping();

    if (response != null) {
      chats.add(ChatModel(
        id: const Uuid().v4(),
        isMe: false,
        message: response,
      ));
    }

    var bot = {
      "role": "assistant",
      "content": response,
    };

    messagesHistory.add(bot);

    if (userEmail != null) {
      CollectionReference usersCollection =
          FirebaseFirestore.instance.collection('chat-$userEmail');

      Map<String, dynamic> userData = {
        'user': message,
        'assistant': response,
        'date_time': DateTime.now(),
        // Add more fields as needed
      };

      usersCollection.add(userData).then((value) {
        print("Data added successfully!");
      }).catchError((error) {
        print("Failed to add data: $error");
      });
    }

    setState(() {
      _isReplying = false;
    });
  }

  void removeTyping() {
    final chats = ref.read(chatProvider.notifier);
    chats.removeTyping();
  }

  void setIsListening(bool value) {
    setState(() {
      _isListening = value;
    });
  }

  Future<void> sendVoiceMessage() async {
    // add send voice message functionality here

    if (!voiceHandler.isEnabled) {
      print('Voice not enabled');
      return;
    }
    if (voiceHandler.speechToText.isListening) {
      await voiceHandler.stopListening();
      setIsListening(false);
    } else {
      setIsListening(true);
      final result = await voiceHandler.startListening();
      setIsListening(false);
      sendTextMessage(result);
    }
  }
}
