import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:communication_repository/communication_repository.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

part 'communication_event.dart';
part 'communication_state.dart';

class CommunicationBloc extends Bloc<CommunicationEvent, CommunicationState> {
  final CommunicationRepository _communicationRepository;

  StreamSubscription<SocketCommunicationEvent> _communicationEventSubscription;

  CommunicationBloc({
    @required CommunicationRepository communicationRepository,
  })  : assert(communicationRepository != null),
        _communicationRepository = communicationRepository,
        super(CommunicationInitial()) {
    _communicationRepository.startListening("USERNAME");
    _communicationEventSubscription = _communicationRepository.event.listen((event) {
      add(CommunicationEventOccurred(event));
    });
  }

  @override
  Stream<CommunicationState> mapEventToState(
    CommunicationEvent event,
  ) async* {
    // TODO: implement mapEventToState
    if (event is CommunicationEventOccurred) {
      print("${event.socketEvent}");
    }
  }
}
