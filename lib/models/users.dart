import 'package:cloud_firestore/cloud_firestore.dart';

class TrainUser {
  final String id;

  final String email;
  final String? firstName;
  // final String? middleName;
  final String? lastName;
  final String? imageUrl;
  final bool? isAdmin;
  final int? contact;

  TrainUser({
    required this.email,
    this.firstName,
    // this.middleName,
    this.lastName,
    this.imageUrl,
    this.isAdmin,
    this.contact,
    required this.id,
  });

  factory TrainUser.fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> snapshot,
    SnapshotOptions? options,
  ) {
    final data = snapshot.data();
    return TrainUser(
      email: data?['email'],
      id: data?['id'],
      firstName: data?['firstName'],
      // middleName: data?['middleName'],
      lastName: data?['lastName'],
      imageUrl: data?['imageUrl'],
      isAdmin: data?['isAdmin'],
      contact: data?['contact'],
    );
  }

  Map<String, dynamic> toFireStore() {
    return {
      "id": id,
      "email": email,
      if (firstName != null) "firstName": firstName,
      if (lastName != null) "lastName": lastName,
      // if (middleName!=null) "middleName":middleName,
      if (imageUrl != null) "imageUrl": imageUrl,
      "isAdmin": false,
    };
  }
}
