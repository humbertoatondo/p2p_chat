import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:communication_repository/communication_repository.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:user_repository/user_repository.dart';

part 'communication_event.dart';
part 'communication_state.dart';

class CommunicationBloc extends Bloc<CommunicationEvent, CommunicationState> {
  final CommunicationRepository _communicationRepository;
  final User _user;

  StreamSubscription<SocketCommunicationEvent> _communicationEventSubscription;

  CommunicationBloc({
    @required CommunicationRepository communicationRepository,
    @required User user,
  })  : assert(communicationRepository != null),
        assert(user != null),
        _communicationRepository = communicationRepository,
        _user = user,
        super(CommunicationInitial()) {
    _communicationRepository.startListening(_user.username);
    _communicationEventSubscription = _communicationRepository.event.listen((event) {
      add(CommunicationEventOccurred(event));
    });
  }

  @override
  Stream<CommunicationState> mapEventToState(
    CommunicationEvent event,
  ) async* {
    if (event is CommunicationEventOccurred) {
      if (event.socketEvent is ReceiveData) {
        final socketEvent = event.socketEvent as ReceiveData;
        print(socketEvent.data);
      } else if (event.socketEvent is SendData) {
        final socketEvent = event.socketEvent as SendData;
        _communicationRepository.sendData(socketEvent.data);
      }
    }
  }

  @override
  Future<void> close() {
    _communicationEventSubscription?.cancel();
    _communicationRepository.dispose();
    return super.close();
  }
}
