import 'package:cloud_firestore/cloud_firestore.dart';

class Profile {
  int id;
  String? token;
  String ownerfName;
  String ownerlName;
  String email;
  int phone;
  String city;
  String ownerprofilePicture;
  String fName;
  String lName;
  String profilePicture;
  int ownerId;
  String? biography;
  String gender;
  String breed;
  String color;
  bool isVaccinated;
  String registrationDate;
  bool? isSterilized;
  String joiningDate;
  String size;
  int? socialIndexHumans;
  int? socialIndexDogs;
  bool? isFoodAggressive;
  bool? isNewHumanAggressive;
  bool? isNewDogAggressive;
  String? foodName;
  int? foodLikingIndex;
  String? activityName;
  int? activityLikingIndex;
  String? skillName;
  String? skillProficiency;

  Profile({
    required this.id,
    this.token,
    required this.ownerId,
    required this.ownerfName,
    required this.ownerlName,
    required this.email,
    required this.phone,
    required this.city,
    required this.ownerprofilePicture,
    required this.fName,
    required this.lName,
    required this.profilePicture,
    this.biography,
    required this.gender,
    required this.breed,
    required this.color,
    required this.isVaccinated,
    required this.registrationDate,
    this.isSterilized,
    required this.joiningDate,
    required this.size,
    this.socialIndexHumans,
    this.socialIndexDogs,
    this.isFoodAggressive,
    this.isNewHumanAggressive,
    this.isNewDogAggressive,
    this.foodName,
    this.foodLikingIndex,
    this.activityName,
    this.activityLikingIndex,
    this.skillName,
    this.skillProficiency,
  });

  static Profile fromJson(QueryDocumentSnapshot data) {
    return Profile(
      id: data['id'],
      token: data['token'],
      ownerId: data['ownerId'],
      ownerfName: data['ownerfName'],
      ownerlName: data['ownerlName'],
      email: data['email'],
      phone: data['phone'],
      city: data['city'],
      ownerprofilePicture: data['ownerprofilePicture'],
      fName: data['fName'],
      lName: data['lName'],
      profilePicture: data['profilePicture'],
      biography: data['biography'],
      gender: data['gender'],
      breed: data['breed'],
      color: data['color'],
      isVaccinated: data['isVaccinated'],
      registrationDate: data['registrationDate'],
      joiningDate: data['joiningDate'],
      isSterilized: data['isSterilized'],
      size: data['size'],
      socialIndexHumans: data['socialIndexHumans'],
      socialIndexDogs: data['socialIndexDogs'],
      isFoodAggressive: data['isFoodAggressive'],
      isNewHumanAggressive: data['isNewHumanAggressive'],
      isNewDogAggressive: data['isNewDogAggressive'],
      foodName: data['foodName'],
      foodLikingIndex: data['foodLikingIndex'],
      activityName: data['activityName'],
      activityLikingIndex: data['activityLikingIndex'],
      skillName: data['skillName'],
      skillProficiency: data['skillProficiency'],
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'token': token,
        'ownerId': ownerId,
        'ownerfName': ownerfName,
        'ownerlName': ownerlName,
        'email': email,
        'phone': phone,
        'city': city,
        'ownerprofilePicture': ownerprofilePicture,
        'fName': fName,
        'lName': lName,
        'profilePicture': profilePicture,
        'biography': biography,
        'gender': gender,
        'breed': breed,
        'color': color,
        'isVaccinated': isVaccinated,
        'registrationDate': registrationDate,
        'isSterilized': isSterilized,
        'joiningDate': joiningDate,
        'size': size,
        'socialIndexHumans': socialIndexHumans,
        'socialIndexDogs': socialIndexDogs,
        'isFoodAggressive': isFoodAggressive,
        'isNewHumanAggressive': isNewHumanAggressive,
        'isNewDogAggressive': isNewDogAggressive,
        'foodName': foodName,
        'foodLikingIndex': foodLikingIndex,
        'activityName': activityName,
        'activityLikingIndex': activityLikingIndex,
        'skillName': skillName,
        'skillProficiency': skillProficiency,
      };

  // @override
  // String toString() {
  //   return 'Dog{id: $id, fName: $fName, lName: $lName, profilePicture: $profilePicture, ownerId: $ownerId, biography: $biography, gender: $gender}';
  // }
}
