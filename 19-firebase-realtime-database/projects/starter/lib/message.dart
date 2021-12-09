import 'package:cloud_firestore/cloud_firestore.dart';

abstract class Message {
  String text();
  DateTime time();
  String email();
  Future<bool> delete();
}

class SnapshotMessage implements Message {
  final DocumentSnapshot _doc;
  final Map<String, dynamic> _json;

  SnapshotMessage(this._doc) : _json = _doc.data() as Map<String, dynamic>;

  factory SnapshotMessage.fromSnapshot(DocumentSnapshot snapshot) {
    //final json = snapshot.data() as Map<String, dynamic>;
    return SnapshotMessage(snapshot);
  }

  @override
  String text() => _json['text'];

  @override
  DateTime time() => DateTime.parse(_json['time']);

  @override
  String email() => _json['email'];

  @override
  Future<bool> delete() async {
    await _doc.reference.delete();
    return true;
  }

  Map<String, dynamic> toJson() => {
        'text': text,
        'time': time.toString(),
        'email': email,
      };
}
