import 'package:chat_gpt_sdk/chat_gpt_sdk.dart';
import 'package:dash_chat_2/dash_chat_2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gradient_app_bar/flutter_gradient_app_bar.dart';
import 'package:happy_soul/constants.dart';
import 'package:happy_soul/screens/activities/breating_activity.dart';
import 'package:happy_soul/screens/happy_chunks.dart';

class ChatPage extends StatefulWidget {
  static const String id = 'chat_page';

  const ChatPage({super.key});

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final _openAI = OpenAI.instance.build(
    token: OPENAI_API_KEY,
    baseOption: HttpSetup(
      receiveTimeout: const Duration(
        seconds: 5,
      ),
    ),
    enableLog: true,
  );
  final ChatUser currentUser = ChatUser(
    id: '1',
    firstName: 'Hussain',
    lastName: 'Ali',
  );

  final gptChatUser = ChatUser(
    id: '2',
    firstName: 'GPT-3',
    lastName: 'AI',
  );

  final List<ChatMessage> _messages = <ChatMessage>[];

  final List<ChatUser> _typingUsers = <ChatUser>[];

  @override
  Widget build(BuildContext context) {
    // save the selected country
    String? selected_country = "";

    IconData msgIcon = Icons.mic; // Initial icon (microphone)
    String currentText = ''; // Initial text

    bool helpMenu = true;

    void _onHelpMenu() {
      helpMenu = !helpMenu;
      print(helpMenu);
    }

    // Show the screen
    return Scaffold(
      appBar: GradientAppBar(
        gradient: const LinearGradient(
          colors: [
            kPrimaryColor,
            kSecondaryColor,
          ],
        ),
        title: const Text(
          'Express your Feelings',
          style: TextStyle(
              color: Colors.white, fontSize: 18.0, fontWeight: FontWeight.bold),
        ),
        actions: [
          // Location Icon
          Padding(
            padding: const EdgeInsets.all(7.0),
            child: Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.5), // Shadow color
                    spreadRadius: 2, // Spread radius
                    blurRadius: 5, // Blur radius
                    offset: const Offset(0, 3), // Offset from the top
                  ),
                ],
              ),
              child: IconButton(
                padding: EdgeInsets.zero,
                iconSize: 30.0,
                icon: const Icon(Icons.location_on, color: Colors.blue),
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: const Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Location',
                              style: TextStyle(color: Colors.black),
                            ),
                            Divider(
                              color: Colors.black, // Adjust color as needed
                              thickness: 1.0, // Adjust thickness as needed
                            ),
                          ],
                        ),
                        content: StatefulBuilder(
                          builder:
                              (BuildContext context, StateSetter setState) {
                            selected_country =
                                'America'; // Default selected country
                            return Column(
                              mainAxisSize: MainAxisSize.min,
                              children: <Widget>[
                                // Radio button for America
                                RadioListTile(
                                  controlAffinity:
                                      ListTileControlAffinity.trailing,
                                  // Align control to the right
                                  dense: true,
                                  // Reduce the height of the tile
                                  title: const Text(
                                    'America',
                                    style: TextStyle(fontSize: 16.0),
                                  ),
                                  // Country name
                                  value: 'America',
                                  groupValue: selected_country,
                                  onChanged: (value) {
                                    setState(() {
                                      selected_country = value;
                                    });
                                    Navigator.pop(context,
                                        selected_country); // Close dialog after selection
                                  },
                                ),
                                // Add more RadioListTile widgets for other countries
                              ],
                            );
                          },
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ),

          // Help Icon
         /* Center(
            child: IconButton(
              padding: EdgeInsets.zero,
              icon: const Row(
                children: [
                  Text(
                    "🤔",
                    style: TextStyle(fontSize: 30),
                  ),
                  Icon(
                    Icons.arrow_drop_down,
                    color: Colors.white,
                  )
                ],
              ),
              onPressed: () {
                // Update UI with the result
                setState(() {
                  _onHelpMenu();
                });
              },
            ),
          ),
          */


          // Profile Icon
          Padding(
            padding: const EdgeInsets.only(
                top: 7.0, bottom: 7.0, right: 7.0, left: 3.0),
            child: Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.5), // Shadow color
                    spreadRadius: 2, // Spread radius
                    blurRadius: 5, // Blur radius
                    offset: const Offset(0, 3), // Offset from the top
                  ),
                ],
              ),
              child: IconButton(
                padding: EdgeInsets.zero,
                // Set padding to zero
                iconSize: 35.0,
                icon: const Icon(Icons.person_outline, color: Colors.red),
                // Set icon color to red
                onPressed: () {},
              ),
            ),
          ),
        ],
      ),
      body: Stack(
        children: [
          Positioned(
            child: Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Color(0xFFE7E7E7),
                    Color(0xFFFAFAFA),
                  ],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
              ),
            ),
          ),
          Positioned(
            top: MediaQuery.of(context).size.height * 0.2,
            left: MediaQuery.of(context).size.width * 0.1,
            child: Opacity(
              opacity: 0.7,
              // Change this value to the desired opacity (0.0 to 1.0)
              child: ClipRRect(
                child: SizedBox.fromSize(
                  size: const Size.fromRadius(150),
                  child: Image.asset('images/banner.png', fit: BoxFit.fitWidth),
                ),
              ),
            ),
          ),
          DashChat(
            messages: _messages,
            typingUsers: _typingUsers,
            messageOptions: const MessageOptions(
              currentUserContainerColor: Color(0xFFD8F2E4),
              currentUserTextColor: Colors.black,
              containerColor: Color(0xFFC7EDFE),
              textColor: Colors.black,
              avatarBuilder: null,
            ),
            onSend: (ChatMessage msg) {
              // Send the message to the API
              getChatResponse(msg);
            },
            currentUser: currentUser,
            inputOptions: InputOptions(
              onTextChange: (String text) {
                // Update current text
                currentText = text;
                print('this is the text $currentText');
                // Check if text is empty
                if (currentText == "") {
                  setState(() {
                    msgIcon = Icons.mic; // Set icon to microphone
                  });
                } else {
                  setState(() {
                    msgIcon = Icons.send; // Set icon to send
                  });
                }
              },
              alwaysShowSend: true,
              sendButtonBuilder: (Function() send) {
                return IconButton(
                  icon: Icon(msgIcon),
                  onPressed: () {
                    // Check if text is not empty before sending
                    if (currentText != '') {
                      send(); // Send the message
                      // Clear text field if needed
                      setState(() {
                        currentText = '';
                        msgIcon = Icons.mic; // Change icon back to microphone
                      });
                    }
                  },
                );
              },
              textInputAction: TextInputAction.send,
            ),

          ),
          Positioned(
            top: 0,
            left: 0,
            child: Visibility(
              visible: helpMenu,
              child: Padding(
                padding: const EdgeInsets.all(6.0),
                child: Container(
                  decoration: BoxDecoration(
                    color: const Color(0xFF3C8682),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.5), // Shadow color
                        spreadRadius: 2, // Spread radius
                        blurRadius: 1, // Blur radius
                        offset: const Offset(0, 3), // Offset from the top
                      ),
                    ],
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  width: 380,
                  height: 60,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      // Happy Chunks Button
                      Container(
                        decoration: BoxDecoration(
                          color: const Color(0xFF3C8682),
                          borderRadius: BorderRadius.circular(50.0),
                          gradient: const LinearGradient(
                            colors: [
                              Color(0xFF7FB9EF),
                              Color(0xFF589BA1),
                            ],
                          ),
                        ),
                        child: ElevatedButton(
                          onPressed: () {
                            // Implement your Happy Chunks functionality here
                            // Navigator.pushNamed(context, HappyChuncksMenu.id);
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.transparent,
                            foregroundColor: Colors.white,
                            shadowColor: Colors.transparent,
                          ),
                          child: const Text(
                            'Happy Chunks',
                            style: TextStyle(
                                fontSize: 16.0, fontWeight: FontWeight.normal),
                          ),
                        ),
                      ),
              
                      // Crisis Support Button
                      Container(
                        decoration: BoxDecoration(
                          color: const Color(0xFF3C8682),
                          borderRadius: BorderRadius.circular(50.0),
                          gradient: const LinearGradient(
                            begin: Alignment.bottomLeft,
                            end: Alignment.topRight,
                            colors: [
                              Color(0xFFab9a9b),
                              Color(0xFFe02d06),
                            ],
                          ),
                        ),
                        child: ElevatedButton(
                          onPressed: () {
                            // Replace with your desired action (e.g., navigation)
                            // Navigator.pushNamed(context, BreathingActivity.id);
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.transparent,
                            foregroundColor: Colors.white,
                            shadowColor: Colors.transparent,
                          ),
                          child: const Text(
                            'Crisis Moment',
                            style: TextStyle(
                                fontSize: 17.0, fontWeight: FontWeight.normal),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> getChatResponse(ChatMessage msg) async {
    // Call the API to get the response
    setState(() {
      _messages.insert(0, msg);
      _typingUsers.add(gptChatUser);
    });

    List<Map<String, dynamic>> messagesHistory = _messages.reversed.map((msg) {
      return {
        'role': msg.user == currentUser ? Role.user : Role.assistant,
        'content': msg.text,
      };
    }).toList();

    try {
      // final request = ChatCompleteText(
      //     model: GptTurbo0301ChatModel(),
      //     messages: messagesHistory,
      //     maxToken: 200);

      // final response = await _openAI.onChatCompletion(request: request);

      // for (var element in response!.choices) {
      //   if (element.message != null) {
      //     setState(
      //           () {
      //         _messages.insert(
      //             0,
      //             ChatMessage(
      //               user: gptChatUser,
      //               createdAt: DateTime.now(),
      //               text: element.message!.content,
      //             ));
      //       },
      //     );
      //   }
      // }

      setState(
        () {
          _messages.insert(
            0,
            ChatMessage(
              user: gptChatUser,
              createdAt: DateTime.now(),
              text: "From gpt",
            ),
          );
        },
      );

      setState(
        () {
          _typingUsers.remove(gptChatUser);
        },
      );
    } catch (e) {
      print(e);
    }
  }

}
