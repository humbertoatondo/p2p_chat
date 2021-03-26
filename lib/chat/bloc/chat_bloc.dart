import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:chats_repository/chats_repository.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

part 'chat_event.dart';
part 'chat_state.dart';

class ChatBloc extends Bloc<ChatEvent, ChatState> {
  final ChatsRepository _chatsRepository;

  StreamSubscription<ChatMessageEvent> _chatMessageEventSubscription;

  ChatBloc({
    @required ChatsRepository chatsRepository,
  })  : assert(chatsRepository != null),
        _chatsRepository = chatsRepository,
        super(IdleChat()) {
    _chatMessageEventSubscription = _chatsRepository.event.listen((event) {
      this.add(ChatMessageEventOccurred(event));
    });
  }

  @override
  Stream<ChatState> mapEventToState(
    ChatEvent event,
  ) async* {
    if (event is ChatMessageEventOccurred) {
      final chatMessageEvent = event.chatMessageEvent;
      if (chatMessageEvent is ChatMessageAdded) {
        yield MessageAddedToChat(chatMessageEvent.previousPosition);
        yield IdleChat();
      }
    }
  }

  @override
  Future<void> close() {
    _chatMessageEventSubscription.cancel();
    _chatsRepository.dispose();
    return super.close();
  }
}
