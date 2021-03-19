part of 'communication_bloc.dart';

abstract class CommunicationEvent extends Equatable {
  const CommunicationEvent();

  @override
  List<Object> get props => [];
}

class CommunicationEventOccurred extends CommunicationEvent {
  final SocketCommunicationEvent socketEvent;

  const CommunicationEventOccurred(this.socketEvent);

  @override
  List<Object> get props => [socketEvent];
}
