import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter_communication/feature/domain/entities/message_entity.dart';

import '../../../../contents.dart';
import '../../../../core/common/responses/response.dart';
import '../../repositories/database_repository.dart';

class GetsUpdateMessageUseCase {
  final DatabaseRepository<MessageEntity> repository;

  GetsUpdateMessageUseCase({
    required this.repository,
  });

  Future<Response> call<R>({
    required String roomId,
    R? Function(R parent)? source,
  }) async {
    return repository.getUpdates((parent) {
      if (parent is CollectionReference) {
        return parent.doc(roomId).collection(ApiPaths.messages);
      }
      if (parent is DatabaseReference) {
        return parent.child(roomId).child(ApiPaths.messages);
      }
    });
  }
}
