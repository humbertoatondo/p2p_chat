import 'package:chats_repository/chats_repository.dart';
import 'package:communication_repository/communication_repository.dart';
import 'package:flutter/material.dart';
import 'package:p2p_chat/chat/chat.dart';
import 'package:p2p_chat/home/home.dart';
import 'package:p2p_chat/login/login.dart';
import 'package:p2p_chat/peer/peer.dart';
import 'package:peer_repository/peer_repository.dart';

import 'chat/bloc/chat_bloc.dart';

class AppRouter {
  CommunicationRepository _communicationRepository = CommunicationRepository();
  PeerRepository _peerRepository = PeerRepository();
  ChatsRepository _chatsRepository = ChatsRepository();

  PeerBloc _peerBloc;
  ChatBloc _chatBloc;

  Route<dynamic> generateRoutes(RouteSettings settings) {
    final args = settings.arguments;

    if (_peerBloc == null) {
      _peerBloc = PeerBloc(peerRepository: _peerRepository, chatsRepository: _chatsRepository);
    }

    if (_chatBloc == null) {
      _chatBloc = ChatBloc(chatsRepository: _chatsRepository);
    }

    switch (settings.name) {
      case '/login':
        return MaterialPageRoute(
          builder: (context) => LoginPage(),
        );
      case '/home':
        return MaterialPageRoute(
          builder: (context) => HomePage(
            communicationRepository: _communicationRepository,
            peerRepository: _peerRepository,
            chatsRepository: _chatsRepository,
            peerBloc: _peerBloc,
            chatBloc: _chatBloc,
          ),
        );
      case '/chat':
        return MaterialPageRoute(
          builder: (context) => ChatPage(
            endUsername: args,
            chatsRepository: _chatsRepository,
            peerBloc: _peerBloc,
            chatBloc: _chatBloc,
          ),
        );
    }
  }
}
