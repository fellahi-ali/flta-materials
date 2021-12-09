import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'message.dart';

abstract class Messages {
  Future<Message> send(String message);
  Stream<List<Message>> stream();
}

class FirestoreMessages implements Messages {
  FirestoreMessages({
    this.email = 'test',
  });

  final String email;
  final CollectionReference _collection =
      FirebaseFirestore.instance.collection('messages');

  void add(SnapshotMessage msg) => _collection.add(msg.toJson());

  @override
  Future<Message> send(String message) async {
    final time = DateTime.now();
    try {
      final ref = await _collection.add({
        'text': message,
        'time': time.toString(),
        'email': email,
      });
      print('🎉 New message sent: ${ref.path}');
      final snapshot = await ref.get();
      return SnapshotMessage(snapshot);
    } catch (err) {
      print('🥵 Error sending message, $err');
      throw Exception('Error sending message: $message\n$err');
    }
  }

  @override
  Stream<List<Message>> stream() => _collection.orderBy('time').snapshots().map(
        (snapshot) => snapshot.docs.map((doc) => SnapshotMessage(doc)).toList(),
      );
}
