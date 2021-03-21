import 'package:flutter/material.dart';

class ChatPage extends StatelessWidget {
  ChatPage({Key key, String endUsername})
      : assert(endUsername != null),
        _endUsername = endUsername,
        super(key: key);

  final String _endUsername;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_endUsername),
      ),
    );
  }
}

class ChatView extends StatefulWidget {
  @override
  _ChatViewState createState() => _ChatViewState();
}

class _ChatViewState extends State<ChatView> {
  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
