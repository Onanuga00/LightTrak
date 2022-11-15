import 'package:cloud_firestore/cloud_firestore.dart';

class Location {
  // final String? id;
  final String? name;
  final String? code;

  Location({
    this.code,
    this.name,
    //  this.id,
  });

  factory Location.fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> snapshot,
    SnapshotOptions? options,
  ) {
    final data = snapshot.data();
    return Location(
        // id: data?['id'],
        name: data?['name'],
        code: data?['code']);
  }

  Map<String, dynamic> toFireStore() {
    return {
      // if (id!=null) "id":id,
      if (name != null) "name": name,
      if (code != null) "code": code,
    };
  }
}
