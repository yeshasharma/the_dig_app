import 'package:cloud_firestore/cloud_firestore.dart';

class Owner {
  int id;
  String fName;
  String lName;
  String phone;
  String email;
  String city;
  String picture;
  Owner({
    required this.id,
    required this.fName,
    required this.lName,
    required this.phone,
    required this.email,
    required this.city,
    required this.picture,
  });

  toJson(Owner owner) {
    return {
      "id": owner.id,
      "fName": owner.fName,
      "lName": owner.lName,
      "phone": owner.phone,
      "email": owner.email,
      "city": owner.city,
      "picture": owner.picture,
    };
  }

  static Owner fromJson(QueryDocumentSnapshot data) {
    return Owner(
        id: data['id'],
        fName: data['fName'],
        lName: data['lName'],
        phone: data['phone'],
        email: data['email'],
        city: data['city'],
        picture: data['picture']);
  }
}
