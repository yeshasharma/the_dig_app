import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:the_dig_app/models/message.dart';

class MockDocumentSnapshot extends Mock implements DocumentSnapshot {}

void main() {
  group('Message model', () {
    test('toJson should return a Map with the correct values', () {
      final message = Message(
        idFrom: 'user1',
        idTo: 'user2',
        timestamp: '2022-03-15 14:30:00',
        content: 'Hello, world!',
      );

      final json = message.toJson();

      expect(json, {
        'idFrom': 'user1',
        'idTo': 'user2',
        'timestamp': '2022-03-15 14:30:00',
        'content': 'Hello, world!',
      });
    });

    test('fromDocument should return a Message with the correct values', () {
      final doc = MockDocumentSnapshot();
      when(doc.get('idFrom')).thenReturn('user1');
      when(doc.get('idTo')).thenReturn('user2');
      when(doc.get('timestamp')).thenReturn('2022-03-15 14:30:00');
      when(doc.get('content')).thenReturn('Hello, world!');

      final message = Message.fromDocument(doc);

      expect(message.idFrom, 'user1');
      expect(message.idTo, 'user2');
      expect(message.timestamp, '2022-03-15 14:30:00');
      expect(message.content, 'Hello, world!');
    });
  });
}
