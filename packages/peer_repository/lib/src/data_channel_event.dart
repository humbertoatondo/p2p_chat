part of 'peer_repository.dart';

abstract class DataChannelEvent extends Equatable {
  const DataChannelEvent();

  @override
  List<Object> get props => [];
}

class ReceiveTextMessage extends DataChannelEvent {
  final String message;

  const ReceiveTextMessage(this.message);

  @override
  List<Object> get props => [message];
}

class SendTextMessage extends DataChannelEvent {
  final String message;

  const SendTextMessage(this.message);

  @override
  List<Object> get props => [message];
}
