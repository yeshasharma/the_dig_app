import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:the_dig_app/models/contact.dart';

class MockQueryDocumentSnapshot extends Mock
    implements QueryDocumentSnapshot<Map<String, dynamic>> {}

void main() {
  group('Contact model', () {
    final contact = Contact(
      id: 1,
      email: 'test@test.com',
      profileId: 1,
      fName: 'John',
      lName: 'Doe',
      connectionSince: '2022-01-01',
      destinationProfileId: 2,
      destinationFName: 'Jane',
      destinationLName: 'Doe',
      destinationEmail: 'jane@test.com',
      destinationBreed: 'Golden Retriever',
      destinationColor: 'Golden',
    );

    test('toJson method should return a valid JSON map', () {
      final jsonMap = contact.toJson(contact);
      expect(jsonMap, isA<Map<String, dynamic>>());
      expect(jsonMap['id'], equals(contact.id));
      expect(jsonMap['email'], equals(contact.email));
      expect(jsonMap['profileId'], equals(contact.profileId));
      expect(jsonMap['fName'], equals(contact.fName));
      expect(jsonMap['lName'], equals(contact.lName));
      expect(jsonMap['connectionSince'], equals(contact.connectionSince));
      expect(jsonMap['destinationProfileId'],
          equals(contact.destinationProfileId));
      expect(jsonMap['destinationFName'], equals(contact.destinationFName));
      expect(jsonMap['destinationLName'], equals(contact.destinationLName));
      expect(jsonMap['destinationEmail'], equals(contact.destinationEmail));
      expect(jsonMap['destinationBreed'], equals(contact.destinationBreed));
      expect(jsonMap['destinationColor'], equals(contact.destinationColor));
    });
  });
  test('fromJson should return a Contact with the correct values', () {
    final data = {
      'id': 1,
      'email': 'test@example.com',
      'profileId': 123,
      'fName': 'John',
      'lName': 'Doe',
      'connectionSince': '2022-03-15 14:30:00',
      'destinationProfileId': 456,
      'destinationFName': 'Jane',
      'destinationLName': 'Doe',
      'destinationEmail': 'jane@example.com',
      'destinationBreed': 'Golden Retriever',
      'destinationColor': 'Golden'
    };
    final doc = MockQueryDocumentSnapshot();
    when(doc['id']).thenReturn(data['id']);
    when(doc['email']).thenReturn(data['email']);
    when(doc['profileId']).thenReturn(data['profileId']);
    when(doc['fName']).thenReturn(data['fName']);
    when(doc['lName']).thenReturn(data['lName']);
    when(doc['connectionSince']).thenReturn(data['connectionSince']);
    when(doc['destinationProfileId']).thenReturn(data['destinationProfileId']);
    when(doc['destinationFName']).thenReturn(data['destinationFName']);
    when(doc['destinationLName']).thenReturn(data['destinationLName']);
    when(doc['destinationEmail']).thenReturn(data['destinationEmail']);
    when(doc['destinationBreed']).thenReturn(data['destinationBreed']);
    when(doc['destinationColor']).thenReturn(data['destinationColor']);

    final contact = Contact.fromJson(doc);
    expect(contact.id, data['id']);
    expect(contact.email, data['email']);
    expect(contact.profileId, data['profileId']);
    expect(contact.fName, data['fName']);
    expect(contact.lName, data['lName']);
    expect(contact.connectionSince, data['connectionSince']);
    expect(contact.destinationProfileId, data['destinationProfileId']);
    expect(contact.destinationFName, data['destinationFName']);
    expect(contact.destinationLName, data['destinationLName']);
    expect(contact.destinationEmail, data['destinationEmail']);
    expect(contact.destinationBreed, data['destinationBreed']);
    expect(contact.destinationColor, data['destinationColor']);
  });
}
