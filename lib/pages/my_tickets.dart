import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:train_app/authentication/auth.dart';
import 'package:train_app/models/model_dao.dart';

class MyTickets extends StatelessWidget {
  const MyTickets({super.key});

  @override
  Widget build(BuildContext context) {
    // final userID = ref.watch(authenticationProvider).currentUserID;
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          'My Trips',
          style: TextStyle(
              fontSize: 25, fontWeight: FontWeight.bold, color: Colors.black),
        ),
        elevation: 0.0,
        backgroundColor: Colors.white,
      ),
      backgroundColor: Colors.white,
      body: Container(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.height,
          child: const UserTickets()),
    );
  }
}

class UserTickets extends ConsumerWidget {
  const UserTickets({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ticketsAsync = ref.watch(futureTicketByUserProvider);
    return ticketsAsync.when(
        error: (err, stack) => Text('Error: $err'),
        loading: () => const CircularProgressIndicator(),
        data: (tickets) => ListView.builder(
            itemCount: tickets.length,
            itemBuilder: (context, index) {
              return Card(
                child: ListTile(
                  title: Text(
                    tickets[index].ticketID,
                    style: const TextStyle(color: Colors.black),
                  ),
                  trailing: const Icon(
                    Icons.arrow_right_rounded,
                    color: Colors.black,
                    size: 30,
                  ),
                ),
              );
            }));
  }
}
