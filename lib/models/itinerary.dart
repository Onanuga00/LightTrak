import 'package:cloud_firestore/cloud_firestore.dart';

class Itinerary {
  final String? id;
  final String source;
  final String destination;
  final String? trainId;
  final String departureDate;
  final String? departureTime;
  final String arrivalDate;
  final int? price;
  final String? sourceCode;
  final String? destinationCode;
  // final List<List<Map<String, dynamic>>>? trainSeats;

  Itinerary({
    required this.source,
    required this.destination,
    this.id,
    this.trainId,
    required this.departureDate,
    required this.arrivalDate,
    this.price,
    this.departureTime,
    this.sourceCode,
    this.destinationCode,
    // this.trainSeats
  });

  //method to read document snapshot from firestore and transform it directly to the trip model
  factory Itinerary.fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> snapshot,
    SnapshotOptions? options,
  ) {
    final data = snapshot.data();
    return Itinerary(
      id: data?["id"],
      source: data?["source"],
      destination: data?["destination"],
      trainId: data?["trainId"],
      departureDate: data?["departureDate"],
      departureTime: data?["departureTime"],
      arrivalDate: data?["arrivalDate"],
      price: data?["price"],
      sourceCode: data?["sourceCode"],
      destinationCode: data?["destinationCode"],
      // trainSeats: data?["trainSeats"] is Iterable
      //     ? List.from(data?["trainSeats"])
      //     : null,
    );
  }

  // method to write the model to firestore
  Map<String, dynamic> toFireStore() {
    return {
      if (id != null) "id": id,
      if (departureTime != null) "id": departureTime,
      "source": source,
      "destination": destination,
      if (trainId != null) "trainId": trainId,
      "departureTime": departureDate,
      "arrivalTime": arrivalDate,
      "price": price,
      if (sourceCode != null) "sourceCode": sourceCode,
      if (destinationCode != null) "destinationCode": destinationCode,
      // if (trainSeats != null) "trainSeats": trainSeats,
    };
  }
}

//passengers
//firstName, lastName, isAdult, isChild, socialNumber

//tickets
//owner, seats, ticketClass