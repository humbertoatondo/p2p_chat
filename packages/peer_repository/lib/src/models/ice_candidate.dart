import 'dart:convert';

import 'package:flutter_webrtc/flutter_webrtc.dart';

class IceCandidate {
  IceCandidate(RTCIceCandidate iceCandidate) {
    this.candidate = iceCandidate.candidate.toString();
    this.sdpMid = iceCandidate.sdpMid.toString();
    this.sdpMlineIndex = iceCandidate.sdpMlineIndex;
  }

  String candidate;
  String sdpMid;
  int sdpMlineIndex;

  @override
  String toString() {
    final candidateObject = {
      "candidate": this.candidate,
      "sdpMid": this.sdpMid,
      "sdpMlineIndex": this.sdpMlineIndex,
    };
    return json.encode(candidateObject);
  }
}
