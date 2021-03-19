part of 'communication_repository.dart';

abstract class SocketCommunicationEvent extends Equatable {
  const SocketCommunicationEvent();

  @override
  List<Object> get props => [];
}

class ReceiveData extends SocketCommunicationEvent {
  final dynamic data;

  const ReceiveData(this.data);

  @override
  List<Object> get props => [data];
}

class SendData extends SocketCommunicationEvent {
  final dynamic data;

  const SendData(this.data);

  @override
  List<Object> get props => [data];
}
