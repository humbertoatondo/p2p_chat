import 'dart:async';
import 'dart:collection';

import 'dart:convert';

import 'package:equatable/equatable.dart';

abstract class ChatMessageEvent extends Equatable {
  const ChatMessageEvent();

  @override
  List<Object> get props => [];
}

class ChatMessageAdded extends ChatMessageEvent {
  final String sender;
  final String encodedMessage;

  const ChatMessageAdded(this.sender, this.encodedMessage);

  @override
  List<Object> get props => [sender, encodedMessage];
}

class ChatMessage {
  const ChatMessage(this.timestamp, this.message);

  final DateTime timestamp;
  final dynamic message;
}

class ChatMessages {
  List<ChatMessage> messages = [];
}

class ChatsRepository {
  LinkedHashMap<String, ChatMessages> _chatsMap = LinkedHashMap();

  final _controller = StreamController<ChatMessageEvent>();

  Stream<ChatMessageEvent> get event async* {
    yield* _controller.stream;
  }

  void createChatIfAbsent(String username) {
    _chatsMap.putIfAbsent(username, () => ChatMessages());
  }

  void addMessage(String sender, String encodedMessage) {
    // Obtain values from encoded message.
    var map = json.decode(encodedMessage);
    DateTime timestamp = DateTime.fromMillisecondsSinceEpoch(map["timestamp"]);
    String message = map["message"];

    ChatMessages chatMessages = ChatMessages();
    // If key exists in _chatsMap delete previous key and add it to the end.
    if (_chatsMap.containsKey(sender)) {
      chatMessages = _chatsMap[sender];
      _chatsMap.remove(sender);
    }
    // Create new ChatMessage and add it to its corresponding list in the map.
    ChatMessage newChatMessage = ChatMessage(timestamp, message);
    chatMessages.messages.add(newChatMessage);
    _chatsMap.putIfAbsent(sender, () => chatMessages);

    // Stream message data to the ChatBloc.
    _controller.add(ChatMessageAdded(sender, encodedMessage));
  }

  List<ChatMessage> getChatMessages(String username) {
    return _chatsMap[username].messages;
  }

  void dispose() {
    _controller.close();
  }
}
