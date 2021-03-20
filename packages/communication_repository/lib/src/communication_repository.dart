import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

part 'socket_communication_event.dart';

class CommunicationRepository {
  final _controller = StreamController<SocketCommunicationEvent>();

  WebSocketChannel? _channel;

  final String _host = "192.168.1.89";
  final String _port = "3000";
  final String _path = "/connect";

  Stream<SocketCommunicationEvent> get event async* {
    yield* _controller.stream;
  }

  Future<void> startListening(String username) async {
    final url = Uri.parse("ws://$_host:$_port$_path?username=$username");
    _channel = WebSocketChannel.connect(url);

    _channel?.stream.listen((data) {
      _controller.add(ReceiveData(data));
    });
  }

  void sendData(dynamic data) {
    _channel?.sink.add(data);
  }

  void dispose() {
    _channel?.sink.close();
    _controller.close();
  }
}
