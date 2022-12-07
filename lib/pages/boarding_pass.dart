import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:train_app/models/model_dao.dart';
import 'package:train_app/pages/home.dart';
import 'package:train_app/pages/ticket_options.dart';
import 'package:train_app/widgets/ticket.dart';

import '../models/itinerary.dart';
import '../models/ticket.dart';

class BoardingPassPage extends ConsumerWidget {
  const BoardingPassPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // final tripID = ref.watch(tripIDProvider);
    // final ticketID = ref.watch(ticketIDProvider);

    return Scaffold(
      backgroundColor: const Color(0xff03314B),
      appBar: AppBar(
        backgroundColor: const Color(0xff03314B),
        centerTitle: true,
        elevation: 0.0,
        title: const Text(
          'Boarding Pass',
          style: TextStyle(
              color: Colors.white, fontSize: 25, fontWeight: FontWeight.w600),
        ),
      ),
      body: const Center(
        child: MyTicket(),
      ),
    );
  }
}

class MyTicket extends ConsumerWidget {
  const MyTicket({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ticketAsync = ref.watch(futureTicketProvider);
    return ticketAsync.when(
      error: (err, stack) => Text('Error: $err'),
      loading: () => const CircularProgressIndicator(),
      data: (tickets) => TicketCard(
        agency: ref.watch(trainIDProvider).toUpperCase(),
        location: '',
        source: ref.watch(sourceProvider),
        destination: ref.watch(destinationProvider),
        sourceCode: ref.watch(fromCodeProvider),
        destinationCode: ref.watch(toCodeProvider),
        departureDate: ref.watch(departureDateProvider),
        arrivalDate: ref.watch(arrivalDateProvider),
        departureTime: '',
        arrivalTime: '',
        duration: ref.watch(durationProvider),
        trainCode: ref.watch(trainIDProvider).toUpperCase(),
        ticketClass: tickets.isEmpty ? '' : tickets[0].totalPrice.toString(),
        ticketID: tickets.isEmpty ? '' : tickets[0].ticketID,
        passengers: tickets[0].passengers,
        seats: tickets[0].seats,
      ),
    );
  }
}
