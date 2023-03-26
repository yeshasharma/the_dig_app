import 'package:cloud_firestore/cloud_firestore.dart';

class Contact {
  int id;
  String email;
  int profileId;
  String fName;
  String lName;
  String connectionSince;
  int destinationProfileId;
  String destinationFName;
  String destinationLName;
  String destinationEmail;
  String destinationBreed;
  String destinationColor;

  Contact({
    required this.id,
    required this.email,
    required this.profileId,
    required this.fName,
    required this.lName,
    required this.connectionSince,
    required this.destinationProfileId,
    required this.destinationFName,
    required this.destinationLName,
    required this.destinationEmail,
    required this.destinationBreed,
    required this.destinationColor,
  });

  Map<String, dynamic> toJson(Contact contactObject) => {
        'id': contactObject.id,
        'email': contactObject.email,
        'profileId': contactObject.profileId,
        'fName': contactObject.fName,
        'lName': contactObject.lName,
        'connectionSince': contactObject.connectionSince,
        'destinationProfileId': contactObject.destinationProfileId,
        'destinationFName': contactObject.destinationFName,
        'destinationLName': contactObject.destinationLName,
        'destinationEmail': contactObject.destinationEmail,
        'destinationBreed': contactObject.destinationBreed,
        'destinationColor': contactObject.destinationColor,
      };

  static Contact fromJson(QueryDocumentSnapshot<Map<String, dynamic>> data) {
    return Contact(
        id: data['id'],
        email: data['email'],
        profileId: data['profileId'],
        fName: data['fName'],
        lName: data['lName'],
        connectionSince: data['connectionSince'],
        destinationProfileId: data['destinationProfileId'],
        destinationFName: data['destinationFName'],
        destinationLName: data['destinationLName'],
        destinationEmail: data['destinationEmail'],
        destinationBreed: data['destinationBreed'],
        destinationColor: data['destinationColor']);
  }
}
