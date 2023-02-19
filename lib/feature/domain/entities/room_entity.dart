import 'dart:developer';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter_communication/feature/domain/entities/base_entity.dart';
import 'package:flutter_communication/feature/domain/entities/message_entity.dart';

class RoomEntity extends Entity {
  final MessageEntity recent;
  final String contributor;
  final String owner;
  final ChattingType type;

  const RoomEntity({
    super.id = "",
    super.time,
    this.type = ChattingType.none,
    this.contributor = "",
    this.owner = "",
    this.recent = const MessageEntity(),
  });

  RoomEntity copyWith({
    String? id,
    int? time,
    ChattingType? type,
    MessageEntity? recent,
    String? owner,
    String? contributor,
  }) {
    return RoomEntity(
      id: id ?? this.id,
      time: time ?? this.time,
      type: type ?? this.type,
      recent: recent ?? this.recent,
      owner: owner ?? this.owner,
      contributor: contributor ?? this.contributor,
    );
  }

  factory RoomEntity.from(dynamic data) {
    dynamic id, time;
    dynamic type;
    dynamic recent, owner, contributor;
    try {
      if (data is DataSnapshot) {
        id = data.child('id');
        time = data.child('time');
        type = data.child('type');
        recent = data.child('recent');
        owner = data.child('owner');
        contributor = data.child('contributor');
      } else {
        id = data['id'];
        time = data['time'];
        type = data['type'];
        recent = data['recent'];
        owner = data['owner'];
        contributor = data['contributor'];
      }
    } catch (e) {
      log(e.toString());
    }
    return RoomEntity(
      id: id is String ? id : "",
      time: time is int ? time : 0,
      type: ChattingType.from(type),
      recent: MessageEntity.from(recent),
      owner: owner is String ? owner : "",
      contributor: contributor is String ? contributor : "",
    );
  }

  @override
  Map<String, dynamic> get source {
    return {
      "id": id,
      "time": time,
      "type": type.name,
      "owner": owner,
      "contributor": contributor,
      "recent": recent.source,
    };
  }

  @override
  List<Object?> get props => [
        id,
        time,
        type.name,
        recent.source,
        owner,
        contributor,
      ];
}

enum ChattingType {
  none,
  inbox,
  group;

  factory ChattingType.from(dynamic type) {
    final name = "$type";
    if (name == ChattingType.group.name) {
      return ChattingType.group;
    } else if (name == ChattingType.inbox.name) {
      return ChattingType.inbox;
    } else {
      return ChattingType.none;
    }
  }
}

class RoomKeys {
  static const String recent = "recent";
  static const String contributor = "contributor";
  static const String owner = "owner";
  static const String type = "type";
}
