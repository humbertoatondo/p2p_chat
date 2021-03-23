import 'package:flutter/material.dart';
import 'package:p2p_chat/peer/peer.dart';
import 'package:peer_repository/peer_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ChatPage extends StatelessWidget {
  ChatPage({
    Key key,
    @required String endUsername,
    @required PeerRepository peerRepository,
  })  : assert(endUsername != null),
        assert(peerRepository != null),
        _endUsername = endUsername,
        _peerRepository = peerRepository,
        super(key: key);

  final String _endUsername;
  final PeerRepository _peerRepository;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => PeerBloc(
        peerRepository: _peerRepository,
      ),
      child: ChatView(endUsername: _endUsername),
    );
  }
}

class ChatView extends StatefulWidget {
  ChatView({
    Key key,
    @required String this.endUsername,
  })  : assert(endUsername != null),
        super(key: key);

  final endUsername;

  @override
  _ChatViewState createState() => _ChatViewState();
}

class _ChatViewState extends State<ChatView> {
  TextEditingController _textMessageController = TextEditingController();

  @override
  dispose() {
    _textMessageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.endUsername),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: Container(),
          ),
          Container(
            height: 50,
            width: double.infinity,
            color: Colors.blue,
            child: Row(
              children: [
                Expanded(
                  child: Container(
                    margin: EdgeInsets.all(8),
                    child: TextField(
                      controller: _textMessageController,
                      // focusNode: _focusNode,
                      decoration: InputDecoration(
                        hintText: "Message",
                        border: OutlineInputBorder(
                          borderSide: BorderSide.none,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        filled: true,
                        fillColor: Colors.blue[800],
                        contentPadding: EdgeInsets.only(left: 8, right: 8),
                      ),
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.send_rounded),
                  color: Colors.white,
                  onPressed: () {
                    context.read<PeerBloc>().add(DataChannelEventOccurred(
                        SendTextMessage(_textMessageController.text, widget.endUsername)));
                    _textMessageController.clear();
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
