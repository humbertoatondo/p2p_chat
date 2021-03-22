import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:peer_repository/peer_repository.dart';

part 'peer_event.dart';
part 'peer_state.dart';

class PeerBloc extends Bloc<PeerEvent, PeerState> {
  final PeerRepository _peerRepository;

  StreamSubscription<DataChannelEvent> _dataChannelEventSubscription;

  PeerBloc({
    @required PeerRepository peerRepository,
  })  : assert(peerRepository != null),
        _peerRepository = peerRepository,
        super(PeersInitial()) {
    _dataChannelEventSubscription = _peerRepository.event.listen((event) {
      this.add(DataChannelEventOccurred(event));
    });
  }

  @override
  Stream<PeerState> mapEventToState(
    PeerEvent event,
  ) async* {
    if (event is DataChannelEventOccurred) {
      final dataChannelEvent = event.dataChannelEvent;
      if (dataChannelEvent is ReceiveTextMessage) {
        // TODO: Create chat repository.
        // TODO: Add the received message to chat repository.
      } else if (dataChannelEvent is SendTextMessage) {
        // Receiver
        // Message
        // TODO: Create function in peer repository to send message
      }
    }
  }

  @override
  Future<void> close() {
    _dataChannelEventSubscription.cancel();
    _peerRepository.dispose();
    return super.close();
  }
}
