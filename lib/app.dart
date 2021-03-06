import 'package:authentication_repository/authentication_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:p2p_chat/app_router.dart';
import 'package:p2p_chat/authentication/bloc/authentication_bloc.dart';
import 'package:p2p_chat/home/views/home_page.dart';

import 'package:p2p_chat/login/views/login_page.dart';
import 'package:p2p_chat/splash/views/splash_page.dart';
import 'package:user_repository/user_repository.dart';

class App extends StatelessWidget {
  final AuthenticationRepository authenticationRepository;
  final UserRepository userRepository;

  const App({
    Key key,
    @required this.authenticationRepository,
    @required this.userRepository,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return RepositoryProvider.value(
      value: authenticationRepository,
      child: BlocProvider(
        create: (_) => AuthenticationBloc(
          authenticationRepository: authenticationRepository,
          userRepository: userRepository,
        ),
        child: AppView(),
      ),
    );
  }
}

class AppView extends StatefulWidget {
  @override
  _AppViewState createState() => _AppViewState();
}

class _AppViewState extends State<AppView> {
  final _router = AppRouter();
  final _navigatorKey = GlobalKey<NavigatorState>();

  NavigatorState get _navigator => _navigatorKey.currentState;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorKey: _navigatorKey,
      builder: (context, child) {
        return BlocListener<AuthenticationBloc, AuthenticationState>(
          listener: (context, state) {
            if (state is AuthenticatedState) {
              _navigator.pushNamedAndRemoveUntil(
                "/home",
                (route) => false,
              );
            } else if (state is UnauthenticatedState) {
              _navigator.pushNamedAndRemoveUntil(
                "/login",
                (route) => false,
              );
            }
          },
          child: child,
        );
      },
      initialRoute: "/login",
      onGenerateRoute: _router.generateRoutes,
    );
  }
}
