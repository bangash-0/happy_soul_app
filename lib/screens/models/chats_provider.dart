import 'package:flutter_riverpod/flutter_riverpod.dart';


import 'chat_model.dart';

class ChatNotifier extends StateNotifier<List<ChatModel>> {
  ChatNotifier(): super([]);

  void add(ChatModel chatModel) {
    state = [...state, chatModel];
  }

  void removeTyping(){
    state = state..removeWhere((element) => element.id == 'typing');

  }
}

final chatProvider = StateNotifierProvider<ChatNotifier, List<ChatModel>>((ref) => ChatNotifier(),);
