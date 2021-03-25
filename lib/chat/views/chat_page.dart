import 'package:chats_repository/chats_repository.dart';
import 'package:flutter/material.dart';
import 'package:p2p_chat/peer/peer.dart';
import 'package:peer_repository/peer_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/chat_bloc.dart';

class ChatPage extends StatelessWidget {
  ChatPage({
    Key key,
    @required String endUsername,
    @required ChatsRepository chatsRepository,
    @required PeerBloc peerBloc,
    @required ChatBloc chatBloc,
  })  : assert(endUsername != null),
        assert(chatsRepository != null),
        assert(peerBloc != null),
        assert(chatBloc != null),
        _endUsername = endUsername,
        _chatsRepository = chatsRepository,
        _peerBloc = peerBloc,
        _chatBloc = chatBloc,
        super(key: key);

  final String _endUsername;
  final ChatsRepository _chatsRepository;
  final PeerBloc _peerBloc;
  final ChatBloc _chatBloc;

  @override
  Widget build(BuildContext context) {
    _chatsRepository.createChatIfAbsent(_endUsername);

    return MultiBlocProvider(
      providers: [
        BlocProvider(
          lazy: false,
          create: (context) => _peerBloc,
        ),
        BlocProvider(
          lazy: false,
          create: (context) => _chatBloc,
        ),
      ],
      child: ChatView(
          endUsername: _endUsername,
          initialMessagesListSize: _chatsRepository.getChatMessages(_endUsername).length),
    );
  }
}

class ChatView extends StatefulWidget {
  ChatView({
    Key key,
    @required String this.endUsername,
    @required int this.initialMessagesListSize,
  })  : assert(endUsername != null),
        assert(initialMessagesListSize != null),
        super(key: key);

  final endUsername;
  final initialMessagesListSize;

  @override
  _ChatViewState createState() => _ChatViewState();
}

class _ChatViewState extends State<ChatView> {
  TextEditingController _textMessageController = TextEditingController();
  final _animatedMessageListKey = GlobalKey<AnimatedListState>();
  int _currentMessageListSize;

  @override
  void initState() {
    super.initState();
  }

  @override
  dispose() {
    _textMessageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _currentMessageListSize = widget.initialMessagesListSize;

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.endUsername),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          BlocListener<ChatBloc, ChatState>(
            listener: (context, state) {
              if (state is MessageAddedToChat) {
                _animatedMessageListKey.currentState.insertItem(_currentMessageListSize);
                _currentMessageListSize++;
              }
            },
            child: Expanded(
              child: AnimatedList(
                key: _animatedMessageListKey,
                initialItemCount: widget.initialMessagesListSize,
                itemBuilder: (context, index, animation) {
                  return ChatMessageCell();
                },
              ),
            ),
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

class ChatMessageCell extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 50,
      decoration: BoxDecoration(
        border: Border.all(width: 2),
        color: Colors.yellow[300],
      ),
    );
  }
}
