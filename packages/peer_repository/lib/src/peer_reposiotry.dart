import 'package:flutter_webrtc/flutter_webrtc.dart';
import 'package:peer_repository/src/models/models.dart';
import 'package:sdp_transform/sdp_transform.dart';

class PeerRepository {
  Map<String, PeerData> _peerConnections = Map();

  Future<void> _createPeerConnection(String username) async {
    Map<String, dynamic> configuration = {
      "iceServers": [
        {"url": "stun:stun.l.google.com:19302"},
      ]
    };

    final Map<String, dynamic> offerSdpConstraints = {
      "mandatory": {
        "OfferToReceiveAudio": true,
        "OfferToReceiveVideo": true,
      },
      "optional": [],
    };

    RTCPeerConnection peerConnection =
        await createPeerConnection(configuration, offerSdpConstraints);

    _peerConnections[username] = PeerData(peerConnection);

    peerConnection.onIceCandidate = (candidate) {
      final iceCandidate = IceCandidate(candidate);
      _peerConnections[username].iceCandidates.add(iceCandidate);
      print(iceCandidate);
    };

    peerConnection.createDataChannel("$username channel", RTCDataChannelInit());
  }

  Future<Map<String, dynamic>> createOffer(String username) async {
    // Start a peer connection for this username.
    await _createPeerConnection(username);

    RTCSessionDescription description =
        await _peerConnections[username].peerConnection.createOffer();
    _peerConnections[username].peerConnection.setLocalDescription(description);

    var sessionDescription = parse(description.sdp);
    print(sessionDescription);
    return sessionDescription;
  }
}
