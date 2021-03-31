import 'package:chats_repository/chats_repository.dart';
import 'package:flutter/material.dart';
import 'package:p2p_chat/authentication/authentication.dart';
import 'package:p2p_chat/peer/peer.dart';
import 'package:peer_repository/peer_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:user_repository/user_repository.dart';

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
      child: RepositoryProvider(
        create: (context) => _chatsRepository,
        child: ChatView(
          endUsername: _endUsername,
          initialMessagesListSize: _chatsRepository.getChatMessages(_endUsername).length,
        ),
      ),
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

  User user;

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

    final bloc = BlocProvider.of<AuthenticationBloc>(context);
    final user = (bloc.state as AuthenticatedState).user;

    return Scaffold(
      backgroundColor: Colors.blue[500],
      appBar: AppBar(
        title: Text(widget.endUsername),
      ),
      body: SafeArea(
        child: Column(
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
                child: Container(
                  color: Colors.white,
                  child: AnimatedList(
                    key: _animatedMessageListKey,
                    initialItemCount: widget.initialMessagesListSize,
                    itemBuilder: (context, index, animation) {
                      final chatMessage = context
                          .read<ChatsRepository>()
                          .getChatMessageAt(widget.endUsername, index);
                      final isMyMessage = user.username == chatMessage.messageOwner;
                      print("${user.username} | ${chatMessage.messageOwner}");
                      return ChatMessageCell(isMyMessage: isMyMessage, chatMessage: chatMessage);
                    },
                  ),
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
                      context.read<PeerBloc>().add(DataChannelEventOccurred(SendTextMessage(
                          _textMessageController.text, widget.endUsername, user.username)));
                      _textMessageController.clear();
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ChatMessageCell extends StatelessWidget {
  ChatMessageCell({
    Key key,
    @required this.isMyMessage,
    @required this.chatMessage,
  }) : super(key: key);

  final bool isMyMessage;
  final ChatMessage chatMessage;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(8),
      child: Container(
        child: Column(
          crossAxisAlignment: this.isMyMessage ? CrossAxisAlignment.end : CrossAxisAlignment.start,
          children: [
            ConstrainedBox(
              constraints: BoxConstraints(
                minWidth: 150,
                maxWidth: MediaQuery.of(context).size.width * 0.85,
                minHeight: 35,
              ),
              child: Container(
                padding: const EdgeInsets.all(4.0),
                decoration: BoxDecoration(
                  color: this.isMyMessage ? Colors.blue[600] : Colors.grey[600],
                  borderRadius: BorderRadius.all(Radius.circular(8)),
                ),
                child: Text(
                  chatMessage.message.toString(),
                  style: TextStyle(color: Colors.white70),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
