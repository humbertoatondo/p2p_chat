part of 'communication_bloc.dart';

abstract class CommunicationEvent extends Equatable {
  const CommunicationEvent();

  @override
  List<Object> get props => [];
}

class SocketEventOccurred extends CommunicationEvent {
  final SocketCommunicationEvent socketEvent;

  const SocketEventOccurred(this.socketEvent);

  @override
  List<Object> get props => [socketEvent];
}

class StartPeerConnectionRequested extends CommunicationEvent {
  final String username;

  const StartPeerConnectionRequested(this.username);

  @override
  List<Object> get props => [username];
}
