part of 'peer_repository.dart';

abstract class DataChannelEvent extends Equatable {
  const DataChannelEvent();

  @override
  List<Object> get props => [];
}

class ReceiveTextMessage extends DataChannelEvent {
  final String message;
  final String sender;

  const ReceiveTextMessage(this.message, this.sender);

  @override
  List<Object> get props => [message, sender];
}

class SendTextMessage extends DataChannelEvent {
  final String message;
  final String receiver;

  const SendTextMessage(this.message, this.receiver);

  @override
  List<Object> get props => [message, receiver];

  String getEncodedMessage() {
    final encodedMessage = json.encode({
      "timestamp": DateTime.now().millisecondsSinceEpoch,
      "message": message,
    });

    return encodedMessage;
  }
}
