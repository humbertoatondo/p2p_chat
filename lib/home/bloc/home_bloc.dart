import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:communication_repository/communication_repository.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

part 'home_event.dart';
part 'home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  final CommunicationRepository _communicationRepository;

  HomeBloc({
    @required CommunicationRepository communicationRepository,
  })  : assert(communicationRepository != null),
        _communicationRepository = communicationRepository,
        super(Idle());

  @override
  Stream<HomeState> mapEventToState(
    HomeEvent event,
  ) async* {
    if (event is SearchInputChanged) {
      if (event.username.isEmpty) {
        yield Idle();
      } else {
        yield SearchingUsers();
        final usernames = await _communicationRepository.searchUsers(event.username);
        yield DisplayingUsers(usernames);
      }
    }
  }
}
