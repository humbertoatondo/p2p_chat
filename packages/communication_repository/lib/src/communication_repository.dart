import 'dart:async';
import 'dart:convert';

import 'package:equatable/equatable.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:http/http.dart' as http;

part 'socket_communication_event.dart';

class CommunicationRepository {
  final _controller = StreamController<SocketCommunicationEvent>();

  WebSocketChannel _channel;

  final String _host = "192.168.1.89";
  final String _port = "3000";

  Stream<SocketCommunicationEvent> get event async* {
    yield* _controller.stream;
  }

  Future<void> startListening(String username) async {
    final String _path = "/connect";
    final url = Uri.parse("ws://$_host:$_port$_path?username=$username");
    _channel = WebSocketChannel.connect(url);

    _channel.stream.listen((data) {
      _controller.add(ReceiveData(data));
    });
  }

  void sendData(dynamic data) {
    _channel.sink.add(data);
  }

  Future<List<String>> searchUsers(String username) async {
    final String _path = "/searchUsers";
    final body = {"username": username};
    final url = Uri.http("$_host:$_port", "$_path", body);
    final response = await http.get(url);

    final responseBody = json.decode(response.body);
    final parsedUsernames =
        (responseBody["usernames"] as List).map((name) => name as String).toList();
    return parsedUsernames;
  }

  void dispose() {
    _channel.sink.close();
    _controller.close();
  }
}
