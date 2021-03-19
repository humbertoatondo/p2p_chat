import 'package:communication_repository/communication_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:p2p_chat/authentication/authentication.dart';
import 'package:p2p_chat/communication/bloc/communication_bloc.dart';

class HomePage extends StatelessWidget {
  HomePage({Key key, this.communicationRepository}) : super(key: key);

  final CommunicationRepository communicationRepository;

  static Route route() {
    return MaterialPageRoute<void>(
      builder: (_) => HomePage(
        communicationRepository: CommunicationRepository(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return RepositoryProvider.value(
      value: communicationRepository,
      child: BlocProvider(
        create: (context) => CommunicationBloc(
          communicationRepository: communicationRepository,
        ),
        child: HomeView(),
      ),
    );
  }
}

class HomeView extends StatefulWidget {
  @override
  _HomeViewState createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Builder(
              builder: (context) {
                final userId = context.select((AuthenticationBloc bloc) => bloc.state.user.id);
                return Text('UserID: $userId');
              },
            ),
            ElevatedButton(
              onPressed: () {
                context.read<AuthenticationBloc>().add(AuthenticationLogoutRequested());
              },
              child: const Text('Logout'),
            ),
            BlocListener<CommunicationBloc, CommunicationState>(
              listener: (context, state) {
                print(state);
              },
              child: Container(),
            )
          ],
        ),
      ),
    );
  }
}
