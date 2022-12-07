import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:train_app/models/model_dao.dart';
import 'package:train_app/pages/home.dart';
import 'package:train_app/pages/ticket_options.dart';
import 'package:train_app/widgets/train_card.dart';
import 'package:barcode/barcode.dart';
import 'package:barcode_widget/barcode_widget.dart';

// class Ticket extends StatelessWidget {
//   const Ticket({super.key});

//   @override
//   Widget build(BuildContext context) {
//     const String agency = 'Touristic Express';
//     const String location = 'Yde-Mvan';
//     const String source = 'Yaounde';
//     const String destination = 'Douala';
//     const String sourceCode = 'YDE';
//     const String destinationCode = 'DLA';
//     const String departureDate = '2022-12-28';
//     const String departureTime = '06:15 AM';
//     const String arrivalDate = '2022-12-28';
//     const String arrivalTime = '06:15 AM';
//     const String duration = '3h 45m';
//     const String trainCode = 'LT306';
//     const String ticketClass = 'Buisiness';
//     const String ticketID = 'A098674';
//     const String passengers = '1 Adult';
//     const String seat = 'Wagon:2 / Seat:22';
//     return TicketCard(agency: agency, location: location, source: source, destination: destination, sourceCode: sourceCode, destinationCode: destinationCode, departureDate: departureDate, arrivalDate: arrivalDate, departureTime: departureTime, duration: duration, arrivalTime: arrivalTime, trainCode: trainCode, ticketClass: ticketClass, ticketID: ticketID, passengers: passengers, seat: seat);
//   }
// }

class TicketCard extends ConsumerWidget {
  const TicketCard({
    Key? key,
    required this.agency,
    required this.location,
    required this.source,
    required this.destination,
    required this.sourceCode,
    required this.destinationCode,
    required this.departureDate,
    required this.arrivalDate,
    required this.departureTime,
    required this.duration,
    required this.arrivalTime,
    required this.trainCode,
    required this.ticketClass,
    required this.ticketID,
    required this.passengers,
    required this.seats,
  }) : super(key: key);

  final String agency;
  final String location;
  final String source;
  final String destination;
  final String sourceCode;
  final String destinationCode;
  final String departureDate;
  final String arrivalDate;
  final String departureTime;
  final String duration;
  final String arrivalTime;
  final String trainCode;
  final String ticketClass;
  final String ticketID;
  final List<String>? passengers;
  final List<String>? seats;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    String ticketID = ref.watch(ticketIDProvider);
    String tripID = ref.watch(tripIDProvider);

    return Container(
      width: MediaQuery.of(context).size.width * 0.9,
      height: MediaQuery.of(context).size.height * 0.7,
      // padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
          color: Colors.white, borderRadius: BorderRadius.circular(12)),
      child: Stack(
        alignment: AlignmentDirectional.center,
        children: [
          Container(
            width: MediaQuery.of(context).size.width * 0.9,
            height: MediaQuery.of(context).size.height * 0.7,
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
                color: Colors.white, borderRadius: BorderRadius.circular(12)),
            child: LayoutBuilder(
              builder: (context, constraints) {
                return Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            const CircleAvatar(
                              child: Icon(Icons.train_outlined, size: 25),
                            ),
                            const SizedBox(width: 10),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(agency,
                                    style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: Color(0xff03314B))),
                                const SizedBox(
                                  height: 5,
                                ),
                                Text(location,
                                    style: const TextStyle(
                                        fontWeight: FontWeight.w200,
                                        color: Color(0xff03314B)))
                              ],
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            const Text(
                              'Status: ',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xff03314B)),
                            ),
                            ref.watch(futureTicketByUserProvider).when(
                                error: (err, stack) => Container(),
                                loading: () => Container(),
                                data: (tickets) => const Text(
                                      'valid',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: Colors.green),
                                    ))
                          ],
                        )
                      ],
                    ),
                    const Divider(
                      height: 25,
                    ),
                    Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            source,
                            style: const TextStyle(
                                fontWeight: FontWeight.w200,
                                color: Colors.grey),
                          ),
                          Text(destination,
                              style: const TextStyle(
                                  fontWeight: FontWeight.w200,
                                  color: Colors.grey))
                        ]),
                    const SizedBox(
                      height: 10,
                    ),
                    Stack(
                      alignment: AlignmentDirectional.center,
                      children: [
                        SourceTODestination(
                            fromCode: sourceCode, toCode: destinationCode),
                        Icon(Icons.train, color: Colors.grey.withOpacity(0.6))
                      ],
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            departureDate,
                            style: const TextStyle(
                                fontWeight: FontWeight.w200,
                                color: Colors.grey),
                          ),
                          Text(arrivalDate,
                              style: const TextStyle(
                                  fontWeight: FontWeight.w200,
                                  color: Colors.grey)),
                        ]),
                    const SizedBox(
                      height: 10,
                    ),
                    Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            departureTime,
                            style: const TextStyle(
                                fontWeight: FontWeight.w200,
                                color: Colors.grey),
                          ),
                          Text(duration,
                              style: const TextStyle(
                                  fontWeight: FontWeight.w200,
                                  color: Colors.grey)),
                          Text(arrivalTime,
                              style: const TextStyle(
                                  fontWeight: FontWeight.w200,
                                  color: Colors.grey)),
                        ]),
                    const Divider(
                      height: 25,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              "Train No",
                              style: TextStyle(
                                  fontWeight: FontWeight.w200,
                                  color: Colors.grey),
                            ),
                            Text(
                              trainCode,
                              style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xff03314B)),
                            ),
                          ],
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              "Cost",
                              style: TextStyle(
                                  fontWeight: FontWeight.w200,
                                  color: Colors.grey),
                            ),
                            Text(
                              '\$ $ticketClass',
                              style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xff03314B)),
                            ),
                          ],
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              "Ticket ID",
                              style: TextStyle(
                                  fontWeight: FontWeight.w200,
                                  color: Colors.grey),
                            ),
                            Text(
                              ticketID,
                              style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xff03314B)),
                            ),
                          ],
                        )
                      ],
                    ),
                    const Divider(
                      height: 25,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              "Passengers",
                              style: TextStyle(
                                  fontWeight: FontWeight.w200,
                                  color: Colors.grey),
                            ),
                            Column(
                              children:
                                  List.generate(passengers!.length, (index) {
                                return Text(
                                  passengers![index],
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Color(0xff03314B)),
                                );
                              }),
                            )
                          ],
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            const Text(
                              "Seats",
                              style: TextStyle(
                                  fontWeight: FontWeight.w200,
                                  color: Colors.grey),
                            ),
                            Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: List.generate(seats!.length, (index) {
                                return Text(
                                  seats![index],
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Color(0xff03314B)),
                                );
                              }),
                            )
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 30,
                    ),
                    BarcodeWidget(
                      barcode: Barcode.code128(escapes: true),
                      data: ref.watch(ticketIDProvider),
                      width: 200,
                      height: 70,
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    TextButton(
                      onPressed: () {
                        ref.watch(daoProvider).updateTrainTicketByID(
                            tripID, ticketID, {'status': 'cancelled'});
                        context.go('/cancel');
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 13, vertical: 8),
                        decoration: BoxDecoration(
                            border: Border.all(width: 1.5, color: Colors.pink),
                            borderRadius: BorderRadius.circular(8)),
                        child: const Text(
                          'Cancel Trip',
                          style: TextStyle(fontSize: 14, color: Colors.pink),
                        ),
                      ),
                    )
                  ],
                );
              },
            ),
          ),
          Positioned(
            bottom: 150,
            left: -10.0,
            child: Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: const Color(0xff03314B),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  width: 3,
                  color: const Color(0xff03314B),
                ),
              ),
            ),
          ),
          Positioned(
            bottom: 150,
            right: -12.0,
            child: Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: const Color(0xff03314B),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  width: 3,
                  color: const Color(0xff03314B),
                ),
              ),
            ),
          ),
          Positioned(
            bottom: 5,
            child: TextButton(
              onPressed: () {
                context.go('/home');
              },
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.green, width: 1.2),
                  borderRadius: BorderRadius.circular(8),
                ),
                child:
                    const Text('Return Home', style: TextStyle(fontSize: 12)),
              ),
            ),
          )
          // Positioned(
          //   bottom: 15,
          //   // left: 10,
          //   child: TextButton(
          //     onPressed: () {
          //       ref.watch(daoProvider).updateTrainTicketByID(
          //           tripID, ticketID, {'status': 'cancelled'});
          //       context.go('/cancel');
          //     },
          //     child: Container(
          //       padding:
          //           const EdgeInsets.symmetric(horizontal: 13, vertical: 8),
          //       decoration: BoxDecoration(
          //           border: Border.all(width: 1.5, color: Colors.pink),
          //           borderRadius: BorderRadius.circular(8)),
          //       child: const Text(
          //         'Cancel Trip',
          //         style: TextStyle(fontSize: 14, color: Colors.pink),
          //       ),
          //     ),
          //   ),
          // ),
        ],
      ),
    );
  }
}
