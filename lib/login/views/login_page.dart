import 'package:authentication_repository/authentication_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';
import 'package:p2p_chat/login/bloc/login_bloc.dart';
import 'package:p2p_chat/login/views/login_form.dart';

class LoginPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(title: const Text('Login')),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.only(left: 12, right: 12),
          child: BlocProvider(
            create: (context) {
              return LoginBloc(
                authenticationRepository: RepositoryProvider.of<AuthenticationRepository>(context),
              );
            },
            child: LoginForm(),
          ),
        ),
      ),
    );
  }
}
