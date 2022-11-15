import 'package:cloud_firestore/cloud_firestore.dart';

class Itinerary {
  final String? id;
  final String source;
  final String destination;
  final String? trainId;
  final String departureDate;
  final String arrivalDate;
  final int? price;
  final String? sourceCode;
  final String? destinationCode;

  Itinerary(
      {required this.source,
      required this.destination,
      this.id,
      this.trainId,
      required this.departureDate,
      required this.arrivalDate,
      this.price,
      this.sourceCode,
      this.destinationCode});

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
        arrivalDate: data?["arrivalDate"],
        price: data?["price"],
        sourceCode: data?["sourceCode"],
        destinationCode: data?["destinationCode"]);
  }

  // method to write the model to firestore
  Map<String, dynamic> toFireStore() {
    return {
      if (id != null) "id": id,
      "source": source,
      "destination": destination,
      if (trainId != null) "trainId": trainId,
      "departureTime": departureDate,
      "arrivalTime": arrivalDate,
      "price": price,
      if (sourceCode != null) "sourceCode": sourceCode,
      if (destinationCode != null) "destinationCode": destinationCode,
    };
  }
}
