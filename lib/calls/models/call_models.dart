import 'package:equatable/equatable.dart';

/// Represents the current state of a call
enum CallState {
  idle,
  initiating,
  ringing,
  connecting,
  connected,
  reconnecting,
  ended,
  failed,
  timeout,
  rejected,
}

/// Represents the type of call
enum CallType { audio, video }

/// Represents call events for signaling
enum CallEvent {
  initiated,
  ringing,
  accepted,
  rejected,
  ended,
  timeout,
  cancelled,
}

/// Represents the connection state of a participant
enum ParticipantConnectionState {
  connecting,
  connected,
  reconnecting,
  disconnected,
}

/// Represents a user in a call
class CallUser extends Equatable {
  final String userId;
  final String name;
  final String? avatarUrl;
  final ParticipantConnectionState connectionState;

  const CallUser({
    required this.userId,
    required this.name,
    this.avatarUrl,
    this.connectionState = ParticipantConnectionState.connecting,
  });

  CallUser copyWith({
    String? userId,
    String? name,
    String? avatarUrl,
    ParticipantConnectionState? connectionState,
  }) {
    return CallUser(
      userId: userId ?? this.userId,
      name: name ?? this.name,
      avatarUrl: avatarUrl ?? this.avatarUrl,
      connectionState: connectionState ?? this.connectionState,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'name': name,
      'avatarUrl': avatarUrl,
      'connectionState': connectionState.name,
    };
  }

  factory CallUser.fromJson(Map<String, dynamic> json) {
    return CallUser(
      userId: json['userId'] as String,
      name: json['name'] as String,
      avatarUrl: json['avatarUrl'] as String?,
      connectionState: ParticipantConnectionState.values.firstWhere(
        (e) => e.name == json['connectionState'],
        orElse: () => ParticipantConnectionState.connecting,
      ),
    );
  }

  @override
  List<Object?> get props => [userId, name, avatarUrl, connectionState];
}

/// Represents comprehensive call data
class CallData extends Equatable {
  final String callId;
  final String roomName;
  final CallUser caller;
  final CallUser receiver;
  final CallType callType;
  final CallState status;
  final DateTime createdAt;
  final DateTime? acceptedAt;
  final DateTime? endedAt;
  final int? duration; // in seconds

  const CallData({
    required this.callId,
    required this.roomName,
    required this.caller,
    required this.receiver,
    this.callType = CallType.video,
    this.status = CallState.initiating,
    required this.createdAt,
    this.acceptedAt,
    this.endedAt,
    this.duration,
  });

  CallData copyWith({
    String? callId,
    String? roomName,
    CallUser? caller,
    CallUser? receiver,
    CallType? callType,
    CallState? status,
    DateTime? createdAt,
    DateTime? acceptedAt,
    DateTime? endedAt,
    int? duration,
  }) {
    return CallData(
      callId: callId ?? this.callId,
      roomName: roomName ?? this.roomName,
      caller: caller ?? this.caller,
      receiver: receiver ?? this.receiver,
      callType: callType ?? this.callType,
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
      acceptedAt: acceptedAt ?? this.acceptedAt,
      endedAt: endedAt ?? this.endedAt,
      duration: duration ?? this.duration,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'callId': callId,
      'roomName': roomName,
      'callerId': caller.userId,
      'callerName': caller.name,
      'callerAvatar': caller.avatarUrl,
      'receiverId': receiver.userId,
      'receiverName': receiver.name,
      'receiverAvatar': receiver.avatarUrl,
      'callType': callType.name,
      'status': status.name,
      'createdAt': createdAt.toIso8601String(),
      'acceptedAt': acceptedAt?.toIso8601String(),
      'endedAt': endedAt?.toIso8601String(),
      'duration': duration,
    };
  }

  factory CallData.fromJson(Map<String, dynamic> json) {
    return CallData(
      callId: json['callId'] as String,
      roomName: json['roomName'] as String,
      caller: CallUser(
        userId: json['callerId'] as String,
        name: json['callerName'] as String,
        avatarUrl: json['callerAvatar'] as String?,
      ),
      receiver: CallUser(
        userId: json['receiverId'] as String,
        name: json['receiverName'] as String,
        avatarUrl: json['receiverAvatar'] as String?,
      ),
      callType: CallType.values.firstWhere(
        (e) => e.name == json['callType'],
        orElse: () => CallType.video,
      ),
      status: CallState.values.firstWhere(
        (e) => e.name == json['status'],
        orElse: () => CallState.idle,
      ),
      createdAt: DateTime.parse(json['createdAt'] as String),
      acceptedAt: json['acceptedAt'] != null
          ? DateTime.parse(json['acceptedAt'] as String)
          : null,
      endedAt: json['endedAt'] != null
          ? DateTime.parse(json['endedAt'] as String)
          : null,
      duration: json['duration'] as int?,
    );
  }

  @override
  List<Object?> get props => [
    callId,
    roomName,
    caller,
    receiver,
    callType,
    status,
    createdAt,
    acceptedAt,
    endedAt,
    duration,
  ];
}

/// Represents media track states
class MediaState extends Equatable {
  final bool isAudioEnabled;
  final bool isVideoEnabled;
  final bool isFrontCamera;
  final bool isSpeakerOn;

  const MediaState({
    this.isAudioEnabled = true,
    this.isVideoEnabled = true,
    this.isFrontCamera = true,
    this.isSpeakerOn = true,
  });

  MediaState copyWith({
    bool? isAudioEnabled,
    bool? isVideoEnabled,
    bool? isFrontCamera,
    bool? isSpeakerOn,
  }) {
    return MediaState(
      isAudioEnabled: isAudioEnabled ?? this.isAudioEnabled,
      isVideoEnabled: isVideoEnabled ?? this.isVideoEnabled,
      isFrontCamera: isFrontCamera ?? this.isFrontCamera,
      isSpeakerOn: isSpeakerOn ?? this.isSpeakerOn,
    );
  }

  @override
  List<Object?> get props => [
    isAudioEnabled,
    isVideoEnabled,
    isFrontCamera,
    isSpeakerOn,
  ];
}
