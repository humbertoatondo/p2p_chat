import 'package:web_socket_channel/web_socket_channel.dart';

class CommunicationRepository {
  WebSocketChannel? _channel;

  final String _host = "192.168.1.89";
  final String _port = "3000";
  final String _path = "/connect";

  Future<void> start(String username) async {
    final url = Uri.parse("ws://$_host:$_port$_path?username=$username");
    _channel = WebSocketChannel.connect(url);

    _channel?.stream.listen((message) {});
  }
}
