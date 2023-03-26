import 'package:cloud_firestore/cloud_firestore.dart';

class Message {
  String idFrom;
  String idTo;
  String timestamp;
  String content;


  Message({
    required this.idFrom,
    required this.idTo,
    required this.timestamp,
    required this.content,

  });

  Map<String, dynamic> toJson() {
    return {
      'idFrom': idFrom,
      'idTo': idTo,
      'timestamp': timestamp,
      'content': content,

    };
  }

  factory Message.fromDocument(DocumentSnapshot doc) {
    String idFrom = doc.get('idFrom');
    String idTo = doc.get('idTo');
    String timestamp = doc.get('timestamp');
    String content = doc.get('content');

    return Message(idFrom: idFrom, idTo: idTo, timestamp: timestamp, content: content);
  }
}