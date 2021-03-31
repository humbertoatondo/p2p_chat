import 'package:chats_repository/chats_repository.dart';
import 'package:communication_repository/communication_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:p2p_chat/authentication/authentication.dart';
import 'package:p2p_chat/chat/bloc/chat_bloc.dart';
import 'package:p2p_chat/communication/communication.dart';
import 'package:p2p_chat/home/bloc/home_bloc.dart';
import 'package:p2p_chat/peer/peer.dart';
import 'package:peer_repository/peer_repository.dart';
import 'package:user_repository/user_repository.dart';
import 'package:p2p_chat/splash/views/splash_page.dart';

part 'search_app_bar.dart';
part 'user_search_view.dart';
part 'chat_list_view.dart';

class HomePage extends StatelessWidget {
  HomePage({
    Key key,
    CommunicationRepository communicationRepository,
    PeerRepository peerRepository,
    ChatsRepository chatsRepository,
    PeerBloc peerBloc,
    ChatBloc chatBloc,
  })  : assert(communicationRepository != null),
        assert(peerRepository != null),
        assert(chatsRepository != null),
        assert(peerBloc != null),
        assert(chatBloc != null),
        _communicationRepository = communicationRepository,
        _peerRepository = peerRepository,
        _chatsRepository = chatsRepository,
        _peerBloc = peerBloc,
        _chatBloc = chatBloc,
        super(key: key);

  final CommunicationRepository _communicationRepository;
  final PeerRepository _peerRepository;
  final ChatsRepository _chatsRepository;
  final PeerBloc _peerBloc;
  final ChatBloc _chatBloc;

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          lazy: false,
          create: (context) => CommunicationBloc(
            communicationRepository: _communicationRepository,
            peerRepository: _peerRepository,
            user: context.read<AuthenticationBloc>().state is AuthenticatedState
                ? (context.read<AuthenticationBloc>().state as AuthenticatedState).user
                : User.empty,
          ),
        ),
        BlocProvider(
          create: (context) => HomeBloc(
            communicationRepository: _communicationRepository,
          ),
        ),
        BlocProvider(
          lazy: false,
          create: (context) => _peerBloc,
        ),
        BlocProvider(
          lazy: false,
          create: (context) => _chatBloc,
        )
      ],
      child: HomeView(
        chatsRepository: _chatsRepository,
      ),
    );
  }
}

class HomeView extends StatefulWidget {
  HomeView({
    Key key,
    @required this.chatsRepository,
  })  : assert(chatsRepository != null),
        super(key: key);

  final chatsRepository;

  @override
  _HomeViewState createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: SearchAppBar(context: context),
      body: SafeArea(
        top: false,
        child: BlocBuilder<HomeBloc, HomeState>(
          builder: (context, state) {
            if (state is Idle) {
              return ChatListView(
                chatsRepository: widget.chatsRepository,
              );
            }
            return UserSearchView();
          },
        ),
      ),
      // body: Center(
      //   child: Column(
      //     mainAxisAlignment: MainAxisAlignment.center,
      //     children: [
      //       Builder(
      //         builder: (context) {
      //           final userId = context.select((AuthenticationBloc bloc) {
      //             if (bloc.state is AuthenticatedState) {
      //               return (bloc.state as AuthenticatedState).user.id;
      //             }
      //           });
      //           return Text('UserID: ');
      //         },
      //       ),
      //       ElevatedButton(
      //         onPressed: () {
      //           context.read<AuthenticationBloc>().add(AuthenticationLogoutRequested());
      //         },
      //         child: const Text('Logout'),
      //       ),
      //       BlocListener<CommunicationBloc, CommunicationState>(
      //         listener: (context, state) {
      //           print(state);
      //         },
      //         child: Container(),
      //       ),
      //       ElevatedButton(
      //         onPressed: () {
      //           context
      //               .read<CommunicationBloc>()
      //               .add(CommunicationEventOccurred(SendData("Test string")));
      //         },
      //         child: Text("Send message"),
      //       )
      //     ],
      // /,
      // )/   ),
      // ),
    );
  }
}
