part of 'chat_bloc.dart';

abstract class ChatEvent extends Equatable {
  const ChatEvent();

  @override
  List<Object> get props => [];
}

class ChatMessageEventOccurred extends ChatEvent {
  final ChatMessageEvent chatMessageEvent;

  const ChatMessageEventOccurred(this.chatMessageEvent);

  @override
  List<Object> get props => [chatMessageEvent];
}
