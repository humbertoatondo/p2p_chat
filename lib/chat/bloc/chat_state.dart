part of 'chat_bloc.dart';

abstract class ChatState extends Equatable {
  const ChatState();

  @override
  List<Object> get props => [];
}

class IdleChat extends ChatState {}

class MessageAddedToChat extends ChatState {}
