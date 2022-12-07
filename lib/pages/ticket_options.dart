// ignore_for_file: unnecessary_brace_in_string_interps

import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:train_app/authentication/auth.dart';
import 'package:train_app/models/model_dao.dart';
import 'package:train_app/models/ticket.dart';
import 'package:train_app/models/users.dart';
import 'package:train_app/pages/home.dart';
import 'package:train_app/widgets/dropdown.dart';
import 'package:train_app/widgets/train_seats.dart';
import '../widgets/class_card.dart';
import '../widgets/train_card.dart';
import 'package:go_router/go_router.dart';

// List<String> seats = [];
// final seatsProvider = StateProvider<List<String>>((ref) => seats);

class TicketOptionsPage extends ConsumerStatefulWidget {
  const TicketOptionsPage({super.key});

  @override
  TicketOptionsPageState createState() => TicketOptionsPageState();
}

class TicketOptionsPageState extends ConsumerState<TicketOptionsPage> {
  String? selectedValue = null;
  bool isRoundTrip = false;
  List<Passenger> passengers = [];
  List<String> seatChoosen = [];
  String generateRandomString(int len) {
    var r = Random();
    const chars = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ1234567890';
    return List.generate(len, (index) => chars[r.nextInt(chars.length)]).join();
  }

  @override
  Widget build(BuildContext context) {
    List<String> seatList = ref.watch(seatProvider);
    String price = ref.watch(priceProvider);

    int totalPrice() {
      int priceSum = int.parse(price);
      if (passengers.isEmpty) {
        priceSum = priceSum;
      } else {
        priceSum = priceSum * passengers.length;
      }
      if (isRoundTrip) {
        priceSum += priceSum;
      }

      return priceSum;
    }

    // final List<String> classes = ['Standard', 'Buisiness', 'Executive'];
    int allCost = totalPrice();

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.white,
        title: const Text(
          'Buy Trip',
          style: TextStyle(
              fontWeight: FontWeight.w600, fontSize: 25, color: Colors.black),
        ),
      ),
      body: Container(
        margin: const EdgeInsets.only(top: 5, right: 5, left: 10),
        height: MediaQuery.of(context).size.height,
        child: ListView(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TrainCard(
                  to: ref.watch(destinationProvider),
                  toCode: ref.watch(toCodeProvider),
                  fromCode: ref.watch(fromCodeProvider),
                  from: ref.watch(sourceProvider),
                  cost: ref.watch(priceProvider),
                  trainName: 'DZ',
                  arrivalTime: ref.watch(arrivalDateProvider),
                  departureTime: ref.watch(departureDateProvider),
                  duration: '',
                ),
                const SizedBox(
                  height: 20,
                ),
                passengers.isEmpty
                    ? Container()
                    : ListView.builder(
                        itemCount: passengers.length,
                        shrinkWrap: true,
                        itemBuilder: ((context, index) {
                          return ListTile(
                            trailing: IconButton(
                                onPressed: () {
                                  setState(() {
                                    passengers.removeAt(index);
                                  });
                                },
                                icon: const Icon(
                                  Icons.delete,
                                  color: Colors.grey,
                                  size: 25,
                                )),
                            dense: true,
                            title: Text(
                                '${passengers[index].firstName.toString()} ${passengers[index].lastName.toString()}'),
                          );
                        })),
                Center(
                  child: TextButton(
                    onPressed: () {
                      TextEditingController _firstNameController =
                          TextEditingController();
                      TextEditingController _lastNameController =
                          TextEditingController();
                      TextEditingController _categoryController =
                          TextEditingController();
                      TextEditingController _securityController =
                          TextEditingController();
                      final _formKey = GlobalKey<FormState>();
                      showModalBottomSheet(
                          isScrollControlled: true,
                          context: context,
                          builder: (context) => Container(
                                height:
                                    MediaQuery.of(context).size.height * 0.7,
                                padding: const EdgeInsets.only(
                                    left: 20, right: 20, top: 30),
                                child: Form(
                                    key: _formKey,
                                    child: Column(
                                      children: [
                                        const Padding(
                                          padding: EdgeInsets.only(bottom: 30),
                                          child: Text(
                                            'Passenger Details',
                                            style: TextStyle(
                                                fontSize: 20,
                                                fontWeight: FontWeight.bold),
                                          ),
                                        ),
                                        TextFormField(
                                          controller: _firstNameController,
                                          validator: (value) => value == null
                                              ? "First Name Required"
                                              : null,
                                          decoration: const InputDecoration(
                                              hintText: 'First Name'),
                                        ),
                                        const SizedBox(
                                          height: 10,
                                        ),
                                        TextFormField(
                                          validator: (value) => value == null
                                              ? "Last Name Required"
                                              : null,
                                          controller: _lastNameController,
                                          decoration: const InputDecoration(
                                              hintText: 'Last Name'),
                                        ),
                                        const SizedBox(
                                          height: 10,
                                        ),
                                        CategoryDropDownMenuField(
                                          selectedValue: selectedValue,
                                        ),
                                        const SizedBox(
                                          height: 10,
                                        ),
                                        const SizedBox(
                                          height: 10,
                                        ),
                                        TextButton(
                                            onPressed: () {
                                              if (_formKey.currentState!
                                                  .validate()) {
                                                Passenger passenger = Passenger(
                                                  firstName:
                                                      _firstNameController.text
                                                          .trim(),
                                                  lastName: _lastNameController
                                                      .text
                                                      .trim(),
                                                  // socialNumber: int.parse(
                                                  //     _securityController.text
                                                  //         .trim()),
                                                  isAdult: true,
                                                  isChild: false,
                                                );
                                                setState(() {
                                                  passengers.add(passenger);
                                                  Navigator.pop(context);
                                                });
                                              }
                                            },
                                            child: Container(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 25,
                                                      vertical: 12),
                                              decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(8),
                                                  border: Border.all(
                                                      color: Colors.green,
                                                      width: 1.2)),
                                              child: const Text('Continue',
                                                  style:
                                                      TextStyle(fontSize: 15)),
                                            ))
                                      ],
                                    )),
                              ));
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 70, vertical: 10),
                      decoration: BoxDecoration(
                          border: Border.all(color: Colors.green, width: 0.7)),
                      child: const Text(
                        'Add Passenger',
                        style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w700,
                            color: Colors.black),
                      ),
                    ),
                  ),
                ),
                // const SizedBox(height: 20),
                // SizedBox(
                //   width: MediaQuery.of(context).size.width,
                //   height: 250,
                //   child: ListView.builder(
                //       scrollDirection: Axis.horizontal,
                //       itemCount: classes.length,
                //       itemBuilder: (context, index) {
                //         return Container(
                //           margin: const EdgeInsets.only(right: 20),
                //           child: ClassCard(
                //               onTap: () {},
                //               className: classes[index],
                //               cost: '\$ 0.00',
                //               classBenefits: const [
                //                 'Power plugs',
                //                 'Extral legroom',
                //                 'Free Meal',
                //                 'Non Exchangeable'
                //               ],
                //               iconList: const [
                //                 Icons.plumbing,
                //                 Icons.chair,
                //                 Icons.food_bank,
                //                 Icons.compress_sharp
                //               ]),
                //         );
                //       }),
                // ),
                const SizedBox(
                  height: 20,
                ),
                const Text(
                  'Seats',
                  style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                      color: Colors.black),
                ),

                // const SizedBox(height: 10),

                seatList.isEmpty
                    ? Container()
                    : ListView.builder(
                        shrinkWrap: true,
                        itemCount: seatList.length,
                        itemBuilder: (context, index) {
                          return Text(seatList[index]);
                        }),
                Padding(
                  padding: const EdgeInsets.only(right: 8.0),
                  child: Card(
                    child: ListTile(
                      onTap: () {
                        context.push('/seats');
                      },
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10)),
                      contentPadding: const EdgeInsets.all(5),
                      // tileColor: Color.fromARGB(255, 243, 238, 238),
                      leading: const Icon(
                        Icons.chair_sharp,
                        size: 20,
                        color: Colors.green,
                      ),
                      title: const Text(
                        'Add Seat Preference',
                        style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w500,
                            color: Colors.black),
                      ),
                    ),
                  ),
                ),
                //Seats
              ],
            ),
            const SizedBox(
              height: 15,
            ),
            SwitchListTile(
                activeColor: Colors.green,
                inactiveThumbColor: Colors.grey,
                title: const Text(
                  'Round Trip',
                  style: TextStyle(fontWeight: FontWeight.w500, fontSize: 18),
                ),
                value: isRoundTrip,
                onChanged: (bool newVal) {
                  setState(() {
                    isRoundTrip = newVal;
                  });
                })
          ],
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        elevation: 5.0,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'Trip Cost',
                    style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w200,
                        color: Colors.black.withOpacity(0.4)),
                  ),
                  Text(
                    '\$ ${allCost}',
                    style: const TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.w700,
                        color: Colors.black),
                  ),
                ],
              ),
              TextButton(
                  onPressed: () {
                    final String tripID = ref.read(tripIDProvider);
                    final String? owner =
                        ref.read(authenticationProvider).currentUser?.uid;
                    // final String ticketID = generateRandomString(10);
                    ref.read(ticketIDProvider.notifier).state =
                        generateRandomString(10);

                    List<String> ticketPassengers = passengers
                        .map((passenger) =>
                            '${passenger.firstName} ${passenger.lastName}')
                        .toList();

                    Ticket ticket = Ticket(
                        owner: owner.toString(),
                        ticketID: ref.watch(ticketIDProvider),
                        seats: seatList,
                        passengers: ticketPassengers,
                        totalPrice: allCost,
                        status: 'valid');
                    ref
                        .read(daoProvider)
                        .storeTicketDetails(tripID, ticket)
                        .then((value) {
                      context.push('/thanks');
                      ref.watch(seatProvider.notifier).emptySeats();
                      passengers = [];
                    });
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 30, vertical: 15),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.green,
                    ),
                    child: const Text(
                      'Buy Trip',
                      style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w200,
                          color: Colors.white),
                    ),
                  ))
            ],
          ),
        ),
      ),
    );
  }
}

class AddPassengers extends StatefulWidget {
  const AddPassengers({super.key});

  @override
  State<AddPassengers> createState() => _AddPassengersState();
}

class _AddPassengersState extends State<AddPassengers> {
  List<Passenger> passengers = [];
  @override
  Widget build(BuildContext context) {
    return Container();
  }
}

class SeatsNotifier extends StateNotifier<List<String>> {
  SeatsNotifier() : super([]);

  void addSeats(seat) {
    state = [...state];
    state.add(seat);
  }

  void removeSeats(index) {
    state = [...state];
    state.removeAt(index);
  }

  void emptySeats() {
    state = [];
  }
}

final seatProvider = StateNotifierProvider<SeatsNotifier, List<String>>(
    (ref) => SeatsNotifier());

final ticketIDProvider = StateProvider<String>((ref) => '');
