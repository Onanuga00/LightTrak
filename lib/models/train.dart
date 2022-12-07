import 'package:cloud_firestore/cloud_firestore.dart';

class Train {
  final String? id;
  final String? name;
  final String? code;
  final int? noWagons;
  final int? noSeatsPerWagon;
  final List<Map>? seats;

  Train({
    this.code,
    this.name,
    this.id,
    this.noWagons,
    this.noSeatsPerWagon,
    this.seats,
  });

  factory Train.fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> snapshot,
    SnapshotOptions? options,
  ) {
    final data = snapshot.data();
    return Train(
        id: data?['id'],
        name: data?['name'],
        code: data?['code'],
        noWagons: data?['noWagons'],
        noSeatsPerWagon: data?['noSeatsPerWagon'],
        seats: data?['seats'] is Iterable ? List.from(data?['seats']) : null);
  }

  Map<String, dynamic> toFireStore() {
    return {
      if (id != null) "id": id,
      if (name != null) "name": name,
      if (code != null) "code": code,
      if (noWagons != null) "noWagons": noWagons,
      if (noSeatsPerWagon != null) "noSeatsPerWagon": noSeatsPerWagon,
      if (seats != null) "seats": seats,
    };
  }
}

class Wagon {
  final String? id;
  final String? trainClass;
  final int? noOfSeats;

  Wagon({
    this.id,
    this.trainClass,
    this.noOfSeats,
  });

  factory Wagon.fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> snapshot,
    SnapshotOptions? options,
  ) {
    final data = snapshot.data();
    return Wagon(
      id: data?['id'],
      trainClass: data?['trainClass'],
      noOfSeats: data?['noOfSeats'],
    );
  }

  Map<String, dynamic> toFireStore() {
    return {
      if (id != null) "id": id,
      if (trainClass != null) "trainClass": trainClass,
      if (noOfSeats != null) "noOfSeats": noOfSeats,
    };
  }
}
