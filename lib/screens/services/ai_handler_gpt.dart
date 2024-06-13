import 'package:chat_gpt_sdk/chat_gpt_sdk.dart';

// set your your open ai token from here
var open_ai_token = '';

class AIHandlerGPT {

  final openAI = OpenAI.instance.build(
      token: open_ai_token,
      baseOption: HttpSetup(receiveTimeout: const Duration(seconds: 20)),
      enableLog: true);


  Future<String?> chatComplete(chats) async {
    openAI.setToken(open_ai_token);

    ///get token
    openAI.token;

    try {
      /*
      for gpt 3.5 use GptTurbo0301ChatModel()
      for gpt 4 use Gpt4ChatModel()
       */
      final request = ChatCompleteText(
          messages: [...chats],
          maxToken: 200, model: Gpt4ChatModel()
      );

      final response = await openAI.onChatCompletion(request: request);
      // for (var element in response!.choices) {
      //   print("data message -> ${element.message?.content}");
      // }
      return response?.choices[0].message?.content.trim();
    }

    catch (e) {
      return 'Bad response';
    }
  }

  Future<String?> getSummery(chats) async {
    openAI.setToken(open_ai_token);

    ///get token
    openAI.token;

    try {
      /*
      for gpt 3.5 use GptTurbo0301ChatModel()
      for gpt 4 use Gpt4ChatModel()
       */

      var bot = {
        "role": "system",
        "content": "Give me very precise summary of the conversation, don't miss any detail",
      };

      chats.add(bot);

      final request = ChatCompleteText(
          messages: [...chats],
          maxToken: 1000, model: GptTurbo0301ChatModel()
      );

      final response = await openAI.onChatCompletion(request: request);
      // for (var element in response!.choices) {
      //   print("data message -> ${element.message?.content}");
      // }

      return response?.choices[0].message?.content.trim();
    }

    catch (e) {
      return 'Bad response';
    }
  }

}


