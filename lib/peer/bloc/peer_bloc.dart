import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:chats_repository/chats_repository.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:peer_repository/peer_repository.dart';

part 'peer_event.dart';
part 'peer_state.dart';

class PeerBloc extends Bloc<PeerEvent, PeerState> {
  final PeerRepository _peerRepository;
  final ChatsRepository _chatsRepository;

  StreamSubscription<DataChannelEvent> _dataChannelEventSubscription;

  PeerBloc({
    @required PeerRepository peerRepository,
    @required ChatsRepository chatsRepository,
  })  : assert(peerRepository != null),
        assert(chatsRepository != null),
        _peerRepository = peerRepository,
        _chatsRepository = chatsRepository,
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
        // Add the received message to chat repository.
        _chatsRepository.addMessage(
            dataChannelEvent.sender, dataChannelEvent.sender, dataChannelEvent.message);
      } else if (dataChannelEvent is SendTextMessage) {
        // Send message to corresponding peer.
        _peerRepository.sendMessage(dataChannelEvent.receiver, dataChannelEvent.message);
        // Add message to the current chat.
        _chatsRepository.addMessage(dataChannelEvent.messageOwner, dataChannelEvent.receiver,
            dataChannelEvent.getEncodedMessage());
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
