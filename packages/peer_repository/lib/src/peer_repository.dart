import 'dart:convert';

import 'package:equatable/equatable.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart';
import 'package:peer_repository/src/models/models.dart';
import 'package:sdp_transform/sdp_transform.dart';

class DataTransferType extends Equatable {
  const DataTransferType._();
  static const String offer = "offer";
  static const String answer = "answer";
  static const String candidates = "candidates";

  @override
  List<Object> get props => [offer, answer, candidates];
}

class PeerRepository {
  Map<String, PeerData> _peerConnections = Map();

  Future<void> _createPeerConnection(String username) async {
    Map<String, dynamic> configuration = {
      "iceServers": [
        {"url": "stun:stun.l.google.com:19302"},
      ]
    };

    RTCPeerConnection peerConnection = await createPeerConnection(configuration);

    peerConnection.onIceCandidate = (candidate) {
      final iceCandidate = IceCandidate(candidate);
      _peerConnections[username].iceCandidates.add(iceCandidate);
    };

    peerConnection.onConnectionState = (state) {
      print("$state");
    };

    _peerConnections[username] = PeerData(peerConnection);
  }

  void _createDataChannel(String username) {
    _peerConnections[username]
        .peerConnection
        .createDataChannel("$username channel", RTCDataChannelInit())
        .then((dataChannel) {
      dataChannel.onDataChannelState = (state) {
        print("$state");
      };

      dataChannel.onMessage = (message) {
        print(message.text);
      };
    });

    _peerConnections[username].peerConnection.onDataChannel = (dataChannel) {
      dataChannel.onMessage = (message) {
        print(message);
      };

      dataChannel.onDataChannelState = (state) {
        print("$state");
      };
    };
  }

  Future<Map<String, dynamic>> createOffer(String sender, String receiver) async {
    // Start a peer connection for this username.
    await _createPeerConnection(receiver);
    // Create a data channel to send and receive messages.
    _createDataChannel(receiver);

    RTCSessionDescription description =
        await _peerConnections[receiver].peerConnection.createOffer();
    _peerConnections[receiver].peerConnection.setLocalDescription(description);

    final sessionDescription = parse(description.sdp);

    final offerObject = {
      "type": DataTransferType.offer,
      "sender": sender,
      "receiver": receiver,
      "sdp": sessionDescription,
    };

    return offerObject;
  }

  Future<Map<String, dynamic>> createAnswer(String sender, String receiver) async {
    RTCSessionDescription description =
        await _peerConnections[receiver].peerConnection.createAnswer();

    _peerConnections[receiver].peerConnection.setLocalDescription(description);

    final sessionDescription = parse(description.sdp);

    final answerObject = {
      "type": DataTransferType.answer,
      "sender": sender,
      "receiver": receiver,
      "sdp": sessionDescription
    };

    return answerObject;
  }

  Future<Map<String, dynamic>> receiveData(String data) async {
    final map = json.decode(data);
    switch (map["type"]) {
      case DataTransferType.offer:
        // Start peer connection is doesn't exist.
        if (!_peerConnections.containsKey(map["sender"])) {
          await _createPeerConnection(map["sender"]);
        }
        // Test data channel
        _peerConnections[map["sender"]].peerConnection.onDataChannel = (dataChannel) {
          dataChannel.onDataChannelState = (state) {
            dataChannel.send(RTCDataChannelMessage("Mensaje de prueba"));
            print("$state");
          };
        };
        // Set remote descripiton
        await _setRemoteDescription(map["sdp"], DataTransferType.offer, map["sender"]);
        // Create answer
        return await createAnswer(map["receiver"], map["sender"]);
        break;
      case DataTransferType.answer:
        // Set remote description
        await _setRemoteDescription(map["sdp"], DataTransferType.answer, map["sender"]);
        // Get ice candidates
        _peerConnections[map["sender"]].peerConnection.onDataChannel = (dataChannel) {
          dataChannel.onMessage = (message) {
            print(message);
          };

          dataChannel.onDataChannelState = (state) {
            print("$state");
          };
        };
        return _getIceCandidates(map["receiver"], map["sender"]);
        break;
      case DataTransferType.candidates:
        await _setRemoteIceCandidates(map["candidates"], map["sender"]);
        break;
      default:
        return {"status": "ok"};
    }
    return {"status": "ok"};
  }

  Future<void> _setRemoteDescription(
      dynamic remoteDescription, String messageType, String sender) async {
    dynamic session = remoteDescription; //json.decode(remoteDescription);
    String sdp = write(session, null);

    RTCSessionDescription description;
    if (messageType == DataTransferType.offer) {
      description = RTCSessionDescription(sdp, DataTransferType.offer);
    } else if (messageType == DataTransferType.answer) {
      description = RTCSessionDescription(sdp, DataTransferType.answer);
    }

    await _peerConnections[sender].peerConnection.setRemoteDescription(description);
  }

  Map<String, dynamic> _getIceCandidates(String sender, String receiver) {
    final candidatesList =
        _peerConnections[receiver].iceCandidates.map((e) => e.toString()).toList();

    final candidatesObject = {
      "type": DataTransferType.candidates,
      "sender": sender,
      "receiver": receiver,
      "candidates": candidatesList,
    };

    return candidatesObject;
  }

  Future<void> _setRemoteIceCandidates(List<dynamic> iceCandidates, String receiver) async {
    iceCandidates.forEach((iceCandidate) async {
      final session = await json.decode(iceCandidate);
      final candidate =
          RTCIceCandidate(session["candidate"], session["sdpMid"], session["sdpMlineIndex"]);
      await _peerConnections[receiver].peerConnection.addCandidate(candidate);
    });
  }
}
