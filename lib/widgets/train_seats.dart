import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../pages/ticket_options.dart';

int waIndex = 0;
int seIndex = 0;
final wagonIndexProvider = StateProvider<int>((ref) => waIndex);
final seatIndexProvider = StateProvider<int>((ref) => seIndex);

class TrainSeat extends StatefulWidget {
  const TrainSeat({super.key});

  @override
  State<TrainSeat> createState() => _TrainSeatState();
}

class _TrainSeatState extends State<TrainSeat> {
  int wagonIndex = 0;
  int seatIndex = 0;

  var wagon = List.generate(
      6,
      (wagonIndex) => List<Map<String, dynamic>>.generate(30, (seatIndex) {
            return {
              "id": "Wagon:$wagonIndex-Seat:$seatIndex",
              "status": 'available',
              // "isSelected": false,
              // "isAvailable": true,
            };
          }));
  @override
  Widget build(BuildContext context) {
    // final int _noWagons = 6;
    // final int _noSeatsPerWagon = 5;

    // int seatIndex = 0;
    // final wagonIndexProvider = StateProvider<int>((ref) => wagonIndex);
    // final seatIndexProvider = StateProvider<int>((ref) => seatIndex);

    void selectWagon(int selectedWagonIndex) {
      setState(() {
        wagonIndex = selectedWagonIndex;
      });

      // print(wagonIndex);
      // gerbong.refresh();
    }

    void resetSeats() {
      for (var wagon in wagon) {
        for (var seat in wagon) {
          if (seat["status"] != 'filled') {
            seat.update('status', (value) => 'available');
          }
        }
      }
    }

    void selectSeat(int indexSelectedSeat) {
      setState(() {
        if (wagon[wagonIndex][indexSelectedSeat]['status'] == 'available') {
          resetSeats();
          wagon[wagonIndex][indexSelectedSeat]
              .update('status', (value) => 'selected');
          seatIndex = indexSelectedSeat;
        }
        print(wagon[wagonIndex][indexSelectedSeat]);
      });

      // gerbong.refresh();
      // print(wagon);
    }

    Color chooseColor(int index) {
      if (wagon[wagonIndex][index]['status'] == 'selected') {
        return Colors.green.withOpacity(0.6);
      } else if (wagon[wagonIndex][index]['status'] == 'filled') {
        return Colors.grey;
      }
      return Colors.white;
    }

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        centerTitle: true,
        title: const Text(
          "SELECT SEAT",
          style: TextStyle(
              color: Colors.black, fontSize: 20, fontWeight: FontWeight.bold),
        ),
      ),
      body: Container(
        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
        // height: 1000,
        // width: MediaQuery.of(context).size.width,
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Container(
                      height: 18,
                      width: 18,
                      decoration: BoxDecoration(
                          color: const Color(0xff1cbf8e),
                          border: Border.all(color: const Color(0xff1cbf8e)),
                          borderRadius: BorderRadius.circular(3)),
                    ),
                    const SizedBox(width: 8),
                    const Text("Selected",
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: 14,
                            fontWeight: FontWeight.w600))
                  ],
                ),
                Row(
                  children: [
                    Row(
                      children: [
                        Container(
                          height: 18,
                          width: 18,
                          decoration: BoxDecoration(
                              color: Colors.white,
                              border: Border.all(
                                  color: const Color(0xff1cbf8e), width: 2),
                              borderRadius: BorderRadius.circular(3)),
                        ),
                        const SizedBox(width: 8),
                        const Text(
                          "Available",
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: 14,
                              fontWeight: FontWeight.w600),
                        )
                      ],
                    )
                  ],
                ),
                Row(
                  children: [
                    Row(
                      children: [
                        Container(
                          height: 18,
                          width: 18,
                          decoration: BoxDecoration(
                              color: Colors.grey,
                              border: Border.all(color: Colors.grey),
                              borderRadius: BorderRadius.circular(3)),
                        ),
                        const SizedBox(width: 8),
                        const Text("Unvailable",
                            style: TextStyle(
                                color: Colors.black,
                                fontSize: 14,
                                fontWeight: FontWeight.w600))
                      ],
                    )
                  ],
                )
              ],
            ),
            Expanded(
              flex: 4,
              child: Container(
                margin: const EdgeInsets.only(
                  top: 30,
                ),
                padding: const EdgeInsets.all(20),
                color: Colors.white,
                child: Row(
                  children: [
                    Expanded(
                      child: Container(
                        color: Colors.white,
                        child: SingleChildScrollView(
                          child: Column(
                            children: List.generate(
                                wagon.length,
                                (index) =>
                                    Consumer(builder: (context, ref, child) {
                                      return GestureDetector(
                                        //select wagon Index
                                        onTap: () {
                                          ref
                                              .read(wagonIndexProvider.notifier)
                                              .state = index + 1;
                                          selectWagon(index);
                                        },
                                        child: Container(
                                          margin: const EdgeInsets.symmetric(
                                              vertical: 10),
                                          height: 130,
                                          width: 50,
                                          decoration: BoxDecoration(
                                              border: Border.all(
                                                  color: Colors.green,
                                                  width: 2.0),
                                              color: index == wagonIndex
                                                  ? const Color.fromARGB(
                                                      255, 53, 124, 55)
                                                  : Colors.white,
                                              borderRadius:
                                                  BorderRadius.circular(10)),
                                          child: Center(
                                              child: Text(
                                                  "W${(index + 1).toString()}")),
                                        ),
                                      );
                                    })),
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 3,
                      child: GridView.builder(
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 4,
                          mainAxisSpacing: 5.0,
                          crossAxisSpacing: 5.0,
                        ),
                        itemCount: 30,
                        itemBuilder: (context, index) {
                          return Container(
                            // height: 15,
                            // width: 15,
                            decoration: BoxDecoration(
                              color: chooseColor(index),
                              border: Border.all(
                                  color: const Color(0xff1cbf8e), width: 2.5),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Consumer(builder: (context, ref, child) {
                              return IconButton(
                                  onPressed: () {
                                    //seat index
                                    ref.read(seatIndexProvider.notifier).state =
                                        index + 1;
                                    selectSeat(index);
                                  },
                                  icon: const Icon(
                                    Icons.airline_seat_recline_extra_sharp,
                                    color: Colors.blueGrey,
                                  ));
                            }),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    const SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('Your Seat'),
                        Text('Wagon ${wagonIndex + 1} / Seat ${seatIndex + 1}'),
                      ],
                    ),
                    const SizedBox(height: 20),
                    // Row(
                    //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    //   children: const [
                    //     Text('Total Price'),
                    //     Text('\$48.00'),
                    //   ],
                    // ),
                    Consumer(builder: (context, ref, child) {
                      return TextButton(
                        onPressed: () {
                          int userWagon = ref.read(wagonIndexProvider);
                          int userSeat = ref.read(seatIndexProvider);

                          ref
                              .read(seatProvider.notifier)
                              .addSeats('Wagon:$userWagon Seat:$userSeat');
                          setState(() {
                            wagon[wagonIndex][seatIndex]
                                .update('status', (value) => 'filled');
                          });
                          GoRouter.of(context).pop();
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 40, vertical: 12),
                          decoration: BoxDecoration(
                            border: Border.all(
                              width: 2.0,
                              color: const Color(0xff1cbf8e),
                            ),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: const Text("Continue"),
                        ),
                      );
                    })
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
