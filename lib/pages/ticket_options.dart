import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:train_app/pages/home.dart';
import '../widgets/class_card.dart';
import '../widgets/train_card.dart';

class TicketOptionsPage extends StatefulWidget {
  const TicketOptionsPage({super.key});

  @override
  State<TicketOptionsPage> createState() => _TicketOptionsPageState();
}

class _TicketOptionsPageState extends State<TicketOptionsPage> {
  @override
  Widget build(BuildContext context) {
    final List<String> classes = ['Standard', 'Buisiness', 'Executive'];
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.white,
        title: const Text(
          'Ticket Options',
          style: TextStyle(
              fontWeight: FontWeight.w600, fontSize: 18, color: Colors.black),
        ),
      ),
      body: Container(
        margin: const EdgeInsets.only(top: 5, right: 5, left: 10),
        height: MediaQuery.of(context).size.height,
        child: SingleChildScrollView(
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Consumer(builder: (context, ref, child) {
              return TrainCard(
                to: ref.watch(destinationProvider),
                toCode: ref.watch(toCodeProvider),
                fromCode: ref.watch(fromCodeProvider),
                from: ref.watch(sourceProvider),
                cost: ref.watch(priceProvider),
                trainName: 'DZ',
                arrivalTime: ref.watch(arrivalDateProvider),
                departureTime: ref.watch(departureDateProvider),
                duration: '',
              );
            }),
            const SizedBox(
              height: 20,
            ),
            const Text(
              'Select your class',
              style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                  color: Colors.black),
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: MediaQuery.of(context).size.width,
              height: 250,
              child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: classes.length,
                  itemBuilder: (context, index) {
                    return Container(
                      margin: const EdgeInsets.only(right: 20),
                      child: ClassCard(
                          onTap: () {},
                          className: classes[index],
                          cost: '\$ 0.00',
                          classBenefits: const [
                            'Power plugs',
                            'Extral legroom',
                            'Free Meal',
                            'Non Exchangeable'
                          ],
                          iconList: const [
                            Icons.plumbing,
                            Icons.chair,
                            Icons.food_bank,
                            Icons.compress_sharp
                          ]),
                    );
                  }),
            ),
            const SizedBox(
              height: 20,
            ),
            const Text(
              'Seating',
              style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                  color: Colors.black),
            ),
            // const SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.only(right: 8.0),
              child: Card(
                child: ListTile(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)),
                  contentPadding: const EdgeInsets.all(5),
                  // tileColor: Color.fromARGB(255, 243, 238, 238),
                  leading: const Icon(
                    Icons.chair_sharp,
                    size: 40,
                    color: Colors.green,
                  ),
                  title: const Text(
                    'Seat Number',
                    style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                        color: Colors.black),
                  ),
                  subtitle: Text(
                    'Add preferences',
                    style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w200,
                        color: Colors.black.withOpacity(0.4)),
                  ),
                  trailing: const Icon(
                    Icons.arrow_right_alt_rounded,
                    size: 25,
                    color: Colors.grey,
                  ),
                ),
              ),
            )
          ]),
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
                    'Trip total',
                    style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w200,
                        color: Colors.black.withOpacity(0.4)),
                  ),
                  Consumer(builder: (context, ref, child) {
                    String price = ref.watch(priceProvider);
                    return Text(
                      '\$ $price',
                      style: const TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.w700,
                          color: Colors.black),
                    );
                  }),
                ],
              ),
              TextButton(
                  onPressed: () {},
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 30, vertical: 15),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.green,
                    ),
                    child: const Text(
                      'Continue',
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
