import 'package:flutter_webrtc/flutter_webrtc.dart';
import 'package:peer_repository/src/models/ice_candidate.dart';

class PeerData {
  PeerData(this.peerConnection);

  RTCPeerConnection peerConnection;
  RTCDataChannel dataChannel;
  List<IceCandidate> iceCandidates = [];
}
