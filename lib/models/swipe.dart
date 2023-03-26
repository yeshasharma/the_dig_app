import 'package:cloud_firestore/cloud_firestore.dart';

class Swipe {
  int id;
  String sourceProfileEmail;
  int sourceProfileId;
  String sourceProfileFName;
  String sourceProfileLName;
  String sourceBreed;
  String sourceColor;
  String swipeDate;
  String destinationProfileEmail;
  int destinationProfileId;
  String destinationProfileFName;
  String destinationProfileLName;
  String destinationBreed;
  String destinationColor;
  String direction;
  String status;

  Swipe({
    required this.id,
    required this.sourceProfileEmail,
    required this.sourceProfileId,
    required this.sourceProfileFName,
    required this.sourceProfileLName,
    required this.sourceBreed,
    required this.sourceColor,
    required this.swipeDate,
    required this.destinationProfileEmail,
    required this.destinationProfileId,
    required this.destinationProfileFName,
    required this.destinationProfileLName,
    required this.destinationBreed,
    required this.destinationColor,
    required this.direction,
    required this.status,
  });

  Map<String, dynamic> toJson(Swipe swipeObject) => {
        'id': swipeObject.id,
        'sourceProfileEmail': swipeObject.sourceProfileEmail,
        'sourceProfileId': swipeObject.sourceProfileId,
        'sourceProfileFName': swipeObject.sourceProfileFName,
        'sourceProfileLName': swipeObject.sourceProfileLName,
        'sourceBreed': swipeObject.sourceBreed,
        'sourceColor': swipeObject.sourceColor,
        'swipeDate': swipeObject.swipeDate,
        'destinationProfileEmail': swipeObject.destinationProfileEmail,
        'destinationProfileId': swipeObject.destinationProfileId,
        'destinationProfileFName': swipeObject.destinationProfileFName,
        'destinationProfileLName': swipeObject.destinationProfileLName,
        'destinationBreed': swipeObject.destinationBreed,
        'destinationColor': swipeObject.destinationColor,
        'direction': swipeObject.direction,
        'status': swipeObject.status,
      };

  static Swipe fromJson(QueryDocumentSnapshot<Map<String, dynamic>> data) {
    return Swipe(
        id: data['id'],
        sourceProfileEmail: data['sourceProfileEmail'],
        sourceProfileId: data['sourceProfileId'],
        sourceProfileFName: data['sourceProfileFName'],
        sourceProfileLName: data['sourceProfileLName'],
        sourceBreed: data['sourceBreed'],
        sourceColor: data['sourceColor'],
        swipeDate: data['swipeDate'],
        destinationProfileEmail: data['destinationProfileEmail'],
        destinationProfileId: data['destinationProfileId'],
        destinationProfileFName: data['destinationProfileFName'],
        destinationProfileLName: data['destinationProfileLName'],
        destinationBreed: data['destinationBreed'],
        destinationColor: data['destinationColor'],
        direction: data['direction'],
        status: data['status']);
  }
}
