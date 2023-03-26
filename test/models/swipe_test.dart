import 'package:flutter_test/flutter_test.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:the_dig_app/models/swipe.dart';
import 'package:mockito/mockito.dart';

class MockQueryDocumentSnapshot extends Mock
    implements QueryDocumentSnapshot<Map<String, dynamic>> {}

void main() {
  group('Swipe', () {
    test('toJson method should convert Swipe object to Map<String, dynamic>',
        () {
      final swipe = Swipe(
        id: 123,
        sourceProfileEmail: 'jane.doe@example.com',
        sourceProfileId: 456,
        sourceProfileFName: 'Jane',
        sourceProfileLName: 'Doe',
        sourceBreed: 'Golden Retriever',
        sourceColor: 'Golden',
        swipeDate: '2022-03-14',
        destinationProfileEmail: 'john.doe@example.com',
        destinationProfileId: 789,
        destinationProfileFName: 'John',
        destinationProfileLName: 'Doe',
        destinationBreed: 'Labrador Retriever',
        destinationColor: 'Black',
        direction: 'right',
        status: 'liked',
      );

      final map = swipe.toJson(swipe);

      expect(map['id'], 123);
      expect(map['sourceProfileEmail'], 'jane.doe@example.com');
      expect(map['sourceProfileId'], 456);
      expect(map['sourceProfileFName'], 'Jane');
      expect(map['sourceProfileLName'], 'Doe');
      expect(map['sourceBreed'], 'Golden Retriever');
      expect(map['sourceColor'], 'Golden');
      expect(map['swipeDate'], '2022-03-14');
      expect(map['destinationProfileEmail'], 'john.doe@example.com');
      expect(map['destinationProfileId'], 789);
      expect(map['destinationProfileFName'], 'John');
      expect(map['destinationProfileLName'], 'Doe');
      expect(map['destinationBreed'], 'Labrador Retriever');
      expect(map['destinationColor'], 'Black');
      expect(map['direction'], 'right');
      expect(map['status'], 'liked');
    });

    test(
        'fromJson method should create Swipe object from QueryDocumentSnapshot',
        () {
      final data = {
        'id': 123,
        'sourceProfileEmail': 'jane.doe@example.com',
        'sourceProfileId': 456,
        'sourceProfileFName': 'Jane',
        'sourceProfileLName': 'Doe',
        'sourceBreed': 'Golden Retriever',
        'sourceColor': 'Golden',
        'swipeDate': '2022-03-14',
        'destinationProfileEmail': 'john.doe@example.com',
        'destinationProfileId': 789,
        'destinationProfileFName': 'John',
        'destinationProfileLName': 'Doe',
        'destinationBreed': 'Labrador Retriever',
        'destinationColor': 'Black',
        'direction': 'right',
        'status': 'liked',
      };
      final doc = MockQueryDocumentSnapshot();
      when(doc['id']).thenReturn(data['id']);
      when(doc['sourceProfileEmail']).thenReturn(data['sourceProfileEmail']);
      when(doc['sourceProfileId']).thenReturn(data['sourceProfileId']);
      when(doc['sourceProfileFName']).thenReturn(data['sourceProfileFName']);
      when(doc['sourceProfileLName']).thenReturn(data['sourceProfileLName']);
      when(doc['sourceBreed']).thenReturn(data['sourceBreed']);
      when(doc['sourceColor']).thenReturn(data['sourceColor']);
      when(doc['swipeDate']).thenReturn(data['swipeDate']);
      when(doc['destinationProfileEmail'])
          .thenReturn(data['destinationProfileEmail']);
      when(doc['destinationProfileLName'])
          .thenReturn(data['destinationProfileLName']);
      when(doc['destinationProfileId'])
          .thenReturn(data['destinationProfileId']);
      when(doc['destinationProfileFName'])
          .thenReturn(data['destinationProfileFName']);
      when(doc['destinationBreed']).thenReturn(data['destinationBreed']);
      when(doc['destinationColor']).thenReturn(data['destinationColor']);
      when(doc['direction']).thenReturn(data['direction']);
      when(doc['status']).thenReturn(data['status']);
      final swipe = Swipe.fromJson(doc);

      expect(swipe.id, equals(data['id']));
      expect(swipe.sourceProfileEmail, equals(data['sourceProfileEmail']));
      expect(swipe.sourceProfileId, equals(data['sourceProfileId']));
      expect(swipe.sourceProfileFName, equals(data['sourceProfileFName']));
      expect(swipe.sourceProfileLName, equals(data['sourceProfileLName']));
      expect(swipe.sourceBreed, equals(data['sourceBreed']));
      expect(swipe.sourceColor, equals(data['sourceColor']));
      expect(swipe.swipeDate, equals(data['swipeDate']));
      expect(swipe.destinationProfileEmail,
          equals(data['destinationProfileEmail']));
      expect(swipe.destinationProfileId, equals(data['destinationProfileId']));
      expect(swipe.destinationProfileFName,
          equals(data['destinationProfileFName']));
      expect(swipe.destinationProfileLName,
          equals(data['destinationProfileLName']));
      expect(swipe.destinationBreed, equals(data['destinationBreed']));
      expect(swipe.destinationColor, equals(data['destinationColor']));
      expect(swipe.direction, equals(data['direction']));
      expect(swipe.status, equals(data['status']));
    });
  });
}
