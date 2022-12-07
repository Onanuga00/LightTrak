import 'package:cloud_firestore/cloud_firestore.dart';

class Ticket {
  final String owner;
  final String ticketID;
  final int totalPrice;
  final String? ticketClass;
  final String? status;
  final List<String>? passengers;
  final List<String>? seats;

  Ticket({
    required this.owner,
    required this.ticketID,
    required this.totalPrice,
    this.status,
    this.ticketClass,
    this.passengers,
    this.seats,
  });

  factory Ticket.fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> snapshot,
    SnapshotOptions? options,
  ) {
    final data = snapshot.data();
    return Ticket(
      owner: data?['owner'],
      ticketID: data?['ticketID'],
      totalPrice: data?['totalPrice'],
      ticketClass: data?['ticketClass'],
      status: data?['status'],
      passengers: data?['passengers'] is Iterable
          ? List.from(data?['passengers'])
          : null,
      seats: data?['seats'] is Iterable ? List.from(data?['seats']) : null,
    );
  }

  Map<String, dynamic> toFireStore() {
    return {
      if (passengers != null) "passengers": passengers,
      if (seats != null) "seats": seats,
      if (ticketClass != null) "ticketClass": ticketClass,
      if (status != null) "status": status,
      "ticketID": ticketID,
      "owner": owner,
      "totalPrice": totalPrice,
    };
  }
}
