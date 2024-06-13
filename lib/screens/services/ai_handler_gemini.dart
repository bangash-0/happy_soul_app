// import 'package:chat_gpt_sdk/chat_gpt_sdk.dart';
import 'package:http/http.dart' as http;

import 'package:google_generative_ai/google_generative_ai.dart';


class AIHandlerGemini {

  // set your your gemini ai token from here
  var gemini_api_key = '';

    Future<String?> getResponse(var messages) async {
    try {
      final model = GenerativeModel(model: 'gemini-pro', apiKey: gemini_api_key);


      final response = await model.generateContent(messages);

      return 'Some thing went wrong';
    } catch (e) {
      return 'Bad response';
    }
  }

    Future<String?> talkWithGemini(var messages) async {

      try{

        final model = GenerativeModel(model: 'gemini-pro', apiKey: gemini_api_key);
        String messageText = '';
        for (var message in messages) {
          messageText += message['content'] + '\n';
        }

        final context = Content.text(messageText);

        final response = await model.generateContent([context]);

        return response.text;
      }
      catch(e){
        return 'Bad response';
      }
    }

    Future<String?> getScoreFromGemini(var messages) async {

      try{

        final model = GenerativeModel(model: 'gemini-pro', apiKey: 'AIzaSyAy1f9kWuz5NgCmVc3k9O79HngKGe-iLCY');
        String messageText = '';
        for (var message in messages) {
          print(message);
          messageText += message + '\n';
        }

        final context = Content.text(messageText);
        final response = await model.generateContent([context]);

        print(response.text);
        return response.text;
      }
      catch(e){
        return 'Bad response';
      }
    }

}