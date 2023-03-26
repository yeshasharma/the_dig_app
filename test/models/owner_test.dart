import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:the_dig_app/models/owner.dart';

class MockQueryDocumentSnapshot extends Mock implements QueryDocumentSnapshot {}

void main() {
  group('Owner model', () {
    final data = {
      'id': 1,
      'fName': 'John',
      'lName': 'Doe',
      'phone': '1234567890',
      'email': 'test@example.com',
      'city': 'New York',
      'picture': 'http://example.com/picture.jpg',
    };

    test('fromJson should return an Owner object', () {
      final doc = MockQueryDocumentSnapshot();
      when(doc['id']).thenReturn(data['id']);
      when(doc['fName']).thenReturn(data['fName']);
      when(doc['lName']).thenReturn(data['lName']);
      when(doc['phone']).thenReturn(data['phone']);
      when(doc['email']).thenReturn(data['email']);
      when(doc['city']).thenReturn(data['city']);
      when(doc['picture']).thenReturn(data['picture']);

      final owner = Owner.fromJson(doc);
      expect(owner.id, data['id']);
      expect(owner.fName, data['fName']);
      expect(owner.lName, data['lName']);
      expect(owner.phone, data['phone']);
      expect(owner.email, data['email']);
      expect(owner.city, data['city']);
      expect(owner.picture, data['picture']);
    });

    test('toJson should return a Map', () {
      final data = {
        'id': 1,
        'fName': 'John',
        'lName': 'Doe',
        'phone': '555-555-5555',
        'email': 'john.doe@example.com',
        'city': 'New York',
        'picture': 'https://example.com/picture.jpg',
      };
      final owner = Owner(
        id: data['id'] as int,
        fName: data['fName'] as String,
        lName: data['lName'] as String,
        phone: data['phone'] as String,
        email: data['email'] as String,
        city: data['city'] as String,
        picture: data['picture'] as String,
      );
      final json = owner.toJson(owner);
      expect(json['id'], data['id']);
      expect(json['fName'], data['fName']);
      expect(json['lName'], data['lName']);
      expect(json['phone'], data['phone']);
      expect(json['email'], data['email']);
      expect(json['city'], data['city']);
      expect(json['picture'], data['picture']);
    });
  });
}
