import 'package:flutter_test/flutter_test.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:the_dig_app/models/profile.dart';
import 'package:mockito/mockito.dart';

class MockQueryDocumentSnapshot extends Mock implements QueryDocumentSnapshot {}

void main() {
  group('Profile', () {
    test('toJson should return a valid map of Profile object', () {
      final profile = Profile(
          id: 1,
          token: 'token',
          ownerId: 2,
          ownerfName: 'John',
          ownerlName: 'Doe',
          email: 'johndoe@example.com',
          phone: 1234567890,
          city: 'New York',
          ownerprofilePicture: 'https://example.com/profile.jpg',
          fName: 'Buddy',
          lName: 'Dog',
          profilePicture: 'https://example.com/dog.jpg',
          biography: 'I am a good boy',
          gender: 'male',
          breed: 'Golden Retriever',
          color: 'golden',
          isVaccinated: true,
          registrationDate: '2022-01-01',
          isSterilized: false,
          joiningDate: '2022-01-02',
          size: 'medium',
          socialIndexHumans: 5,
          socialIndexDogs: 7,
          isFoodAggressive: false,
          isNewHumanAggressive: false,
          isNewDogAggressive: true,
          foodName: 'Bone',
          foodLikingIndex: 9,
          activityName: 'fetch',
          activityLikingIndex: 8,
          skillName: 'sit',
          skillProficiency: 'advanced');

      final map = profile.toJson();

      expect(map['id'], equals(1));
      expect(map['token'], equals('token'));
      expect(map['ownerId'], equals(2));
      expect(map['ownerfName'], equals('John'));
      expect(map['ownerlName'], equals('Doe'));
      expect(map['email'], equals('johndoe@example.com'));
      expect(map['phone'], equals(1234567890));
      expect(map['city'], equals('New York'));
      expect(map['ownerprofilePicture'],
          equals('https://example.com/profile.jpg'));
      expect(map['fName'], equals('Buddy'));
      expect(map['lName'], equals('Dog'));
      expect(map['profilePicture'], equals('https://example.com/dog.jpg'));
      expect(map['biography'], equals('I am a good boy'));
      expect(map['gender'], equals('male'));
      expect(map['breed'], equals('Golden Retriever'));
      expect(map['color'], equals('golden'));
      expect(map['isVaccinated'], equals(true));
      expect(map['registrationDate'], equals('2022-01-01'));
      expect(map['isSterilized'], equals(false));
      expect(map['joiningDate'], equals('2022-01-02'));
      expect(map['size'], equals('medium'));
      expect(map['socialIndexHumans'], equals(5));
      expect(map['socialIndexDogs'], equals(7));
      expect(map['isFoodAggressive'], equals(false));
      expect(map['isNewHumanAggressive'], equals(false));
      expect(map['isNewDogAggressive'], equals(true));
      expect(map['foodName'], equals('Bone'));
      expect(profile.foodLikingIndex, equals(9));
      expect(profile.activityName, equals('fetch'));
      expect(profile.activityLikingIndex, equals(8));
      expect(profile.skillName, equals('sit'));
      expect(profile.skillProficiency, equals('advanced'));
    });

    test('fromJson should return a valid Profile object', () {
      final data = {
        'id': 1,
        'ownerId': 2,
        'ownerfName': 'John',
        'ownerlName': 'Doe',
        'email': 'johndoe@example.com',
        'phone': 1234567890,
        'city': 'New York',
        'ownerprofilePicture': 'https://example.com/profile.jpg',
        'fName': 'Buddy',
        'lName': 'Dog',
        'profilePicture': 'https://example.com/dog.jpg',
        'biography': 'I am a good boy',
        'gender': 'male',
        'breed': 'Golden Retriever',
        'color': 'golden',
        'isVaccinated': true,
        'registrationDate': '2022-01-01',
        'isSterilized': false,
        'joiningDate': '2022-01-02',
        'size': 'medium',
        'socialIndexHumans': 5,
        'socialIndexDogs': 7,
        'isFoodAggressive': false,
        'isNewHumanAggressive': false,
        'isNewDogAggressive': true,
        'foodName': 'kibble',
        'foodLikingIndex': 4,
        'activityName': 'fetch',
        'activityLikingIndex': 8,
        'skillName': 'sit',
        'skillProficiency': 'advanced',
      };

      final doc = MockQueryDocumentSnapshot();
      when(doc['id']).thenReturn(data['id']);
      when(doc['token']).thenReturn(data['token']);
      when(doc['ownerId']).thenReturn(data['ownerId']);
      when(doc['ownerfName']).thenReturn(data['ownerfName']);
      when(doc['ownerlName']).thenReturn(data['ownerlName']);
      when(doc['email']).thenReturn(data['email']);
      when(doc['phone']).thenReturn(data['phone']);
      when(doc['city']).thenReturn(data['city']);
      when(doc['ownerprofilePicture']).thenReturn(data['ownerprofilePicture']);
      when(doc['fName']).thenReturn(data['fName']);
      when(doc['lName']).thenReturn(data['lName']);
      when(doc['profilePicture']).thenReturn(data['profilePicture']);
      when(doc['biography']).thenReturn(data['biography']);
      when(doc['gender']).thenReturn(data['gender']);
      when(doc['breed']).thenReturn(data['breed']);
      when(doc['color']).thenReturn(data['color']);
      when(doc['isVaccinated']).thenReturn(data['isVaccinated']);
      when(doc['registrationDate']).thenReturn(data['registrationDate']);
      when(doc['joiningDate']).thenReturn(data['joiningDate']);
      when(doc['isSterilized']).thenReturn(data['isSterilized']);
      when(doc['size']).thenReturn(data['size']);
      when(doc['socialIndexHumans']).thenReturn(data['socialIndexHumans']);
      when(doc['socialIndexDogs']).thenReturn(data['socialIndexDogs']);
      when(doc['isFoodAggressive']).thenReturn(data['isFoodAggressive']);
      when(doc['isNewHumanAggressive'])
          .thenReturn(data['isNewHumanAggressive']);
      when(doc['isNewDogAggressive']).thenReturn(data['isNewDogAggressive']);
      when(doc['foodName']).thenReturn(data['foodName']);
      when(doc['foodLikingIndex']).thenReturn(data['foodLikingIndex']);
      when(doc['activityName']).thenReturn(data['activityName']);
      when(doc['activityLikingIndex']).thenReturn(data['activityLikingIndex']);
      when(doc['skillName']).thenReturn(data['skillName']);
      when(doc['skillProficiency']).thenReturn(data['skillProficiency']);

      final profile = Profile.fromJson(doc);

      expect(profile.id, equals(1));
      expect(profile.ownerId, equals(2));
      expect(profile.ownerfName, equals('John'));
      expect(profile.ownerlName, equals('Doe'));
      expect(profile.email, equals('johndoe@example.com'));
      expect(profile.phone, equals(1234567890));
      expect(profile.city, equals('New York'));
      expect(profile.ownerprofilePicture,
          equals('https://example.com/profile.jpg'));
      expect(profile.fName, equals('Buddy'));
      expect(profile.lName, equals('Dog'));
      expect(profile.profilePicture, equals('https://example.com/dog.jpg'));
      expect(profile.biography, equals('I am a good boy'));
      expect(profile.gender, equals('male'));
      expect(profile.breed, equals('Golden Retriever'));
      expect(profile.color, equals('golden'));
      expect(profile.isVaccinated, isTrue);
      expect(profile.registrationDate, equals('2022-01-01'));
      expect(profile.isSterilized, isFalse);
      expect(profile.joiningDate, equals('2022-01-02'));
      expect(profile.size, equals('medium'));
      expect(profile.socialIndexHumans, equals(5));
      expect(profile.socialIndexDogs, equals(7));
      expect(profile.isFoodAggressive, isFalse);
      expect(profile.isNewHumanAggressive, isFalse);
      expect(profile.isNewDogAggressive, isTrue);
      expect(profile.foodName, equals('kibble'));
      expect(profile.foodLikingIndex, equals(4));
      expect(profile.activityName, equals('fetch'));
      expect(profile.activityLikingIndex, equals(8));
      expect(profile.skillName, equals('sit'));
      expect(profile.skillProficiency, equals('advanced'));
    });
  });
}
