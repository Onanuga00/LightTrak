import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:train_app/authentication/auth.dart';
import 'package:train_app/models/location.dart';
import 'package:train_app/models/model_dao.dart';
import 'package:go_router/go_router.dart';
import 'package:train_app/widgets/train_card.dart';
import 'package:train_app/models/itinerary.dart';

class Home extends StatelessWidget {
  const Home({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // leadingWidth: ,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            Text(
              "DzeTrain",
              style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                  fontSize: 20),
            ),
            SizedBox(
              height: 5,
            ),
            Text(
              "Book your next train",
              style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w200,
                  fontSize: 13),
            ),
          ],
        ),
        actions: const [
          Padding(
            padding: EdgeInsets.only(right: 8.0),
            child: UserCircleAvatar(),
          )
        ],
        elevation: 0.0,
        backgroundColor: const Color(0xff03314b),
      ),
      body: Stack(
        alignment: AlignmentDirectional.center,
        children: [
          Column(
            children: [
              Expanded(
                  flex: 1,
                  child: Container(
                    color: const Color(0xff03314B),
                    padding: const EdgeInsets.only(right: 20, left: 30),
                    child: Column(
                      children: [
                        const SizedBox(
                          height: 30,
                        ),
                        Consumer(builder: (context, ref, child) {
                          //user name from DB create account
                          // String userName;
                          final String userId =
                              ref.watch(authenticationProvider).currentUserID;
                          Future<String?> userName =
                              ref.watch(daoProvider).getUserById(userId);
                          //User Name from google
                          final String? userNameG = ref
                              .watch(authStateProvider)
                              .value
                              ?.displayName
                              .toString()
                              .split(" ")[0];

                          return Row(
                            children: [
                              const Text('Where to today,',
                                  style: TextStyle(
                                      color: Colors.grey,
                                      fontWeight: FontWeight.w400,
                                      fontSize: 18)),
                              const SizedBox(
                                width: 5,
                              ),
                              FutureBuilder<String?>(
                                  future: userName,
                                  builder: ((context, snapshot) {
                                    //Choosing username from google or from DB
                                    String? name = userNameG == "null"
                                        ? snapshot.data.toString()
                                        : userNameG;
                                    return Text(name.toString(),
                                        style: const TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.w500,
                                            fontSize: 25));
                                  })),
                            ],
                          );
                        })
                      ],
                    ),
                  )),
              Expanded(
                  flex: 1,
                  child: Container(
                    color: const Color(0xff03314B),
                  )),
              Expanded(
                  flex: 2,
                  child: Container(
                    color: Colors.grey.withOpacity(0.3),
                  ))
            ],
          ),
          Positioned(
              top: MediaQuery.of(context).size.height * 0.2,
              child: Container(
                width: MediaQuery.of(context).size.width * 0.85,
                height: 450,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: Colors.white),
                child: const Center(
                  child: SingleChildScrollView(
                    reverse: true,
                    child: SearchTrainForm(),
                  ),
                ),
              ))
        ],
      ),
    );
  }
}

class SearchTrainForm extends ConsumerStatefulWidget {
  const SearchTrainForm({
    Key? key,
  }) : super(key: key);

  @override
  SearchTrainFormState createState() => SearchTrainFormState();
}

class SearchTrainFormState extends ConsumerState<SearchTrainForm> {
  final TextEditingController fromController = TextEditingController();
  final TextEditingController toController = TextEditingController();
  final TextEditingController dateInputController = TextEditingController();
  @override
  void initState() {
    // DateTime dateNow = DateTime.now();
    // dateInputController.text =
    //     "${dateNow.year}-${dateNow.month}-${dateNow.day}";
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    // dateInputController.dispose();
    // fromController.dispose();
    // toController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // final TextEditingController searchBoxController = ref.watch(providerSearchBoxFieldController);
    return Form(
        key: GlobalKey<FormState>(),
        child: Column(
          children: [
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 15.0, vertical: 8),
              child: MyTextFormField(
                  readOnly: true,
                  controller: fromController,
                  label: 'From',
                  prefixIcon: Icons.home_outlined,
                  onTap: () {
                    ref.read(daoProvider).getLocations().then((value) {
                      buildShowModalBottomSheet(context, value, fromController,
                          provider: sourceProvider);
                    });
                    ref
                        .read(sourceProvider.notifier)
                        .update((state) => fromController.text);
                  }),
            ),
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 15.0, vertical: 8),
              child: MyTextFormField(
                  readOnly: true,
                  controller: toController,
                  label: 'To',
                  prefixIcon: Icons.train_rounded,
                  onTap: () {
                    ref.read(daoProvider).getLocations().then((value) {
                      buildShowModalBottomSheet(context, value, toController,
                          provider: destinationProvider);
                      // ref
                      //     .read(destinationProvider.notifier)
                      //     .update((state) => value);
                    });
                  }),
            ),
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 15.0, vertical: 8),
              child: MyTextFormField(
                controller: dateInputController,
                readOnly: true,
                prefixIcon: Icons.calendar_month_rounded,
                label: 'Date',
                onTap: () async {
                  DateTime? pickedDate = await showDatePicker(
                      context: context,
                      initialDate: DateTime.now(),
                      firstDate: DateTime.now(),
                      lastDate: DateTime(2040));
                  if (pickedDate != null) {
                    setState(() {
                      dateInputController.text =
                          "${pickedDate.year}-${pickedDate.month}-${pickedDate.day}";
                    });
                    ref
                        .read(dateProvider.notifier)
                        .update((state) => dateFormater(pickedDate));
                  }
                },
              ),
            ),
            const SizedBox(
              height: 40,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15.0),
              child: TextButton(
                child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 15),
                    width: double.infinity,
                    decoration: const BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                        color: Color(0xff1cbf8e)),
                    child: const Center(
                        child: Text(
                      'Search Train',
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold),
                    ))),
                onPressed: () {
                  context.push('/search');
                },
              ),
            ),
          ],
        ));
  }

  //This method is show a bottom sheet to choose location
  Future<dynamic> buildShowModalBottomSheet(BuildContext context,
      List<Location> value, TextEditingController controller,
      {StateProvider<String>? provider}) {
    return showModalBottomSheet(
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
        context: context,
        // isScrollControlled: true,
        builder: (context) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 10),
              // TODO search form field to be put here to dynamically search for locations. Also put an x icon to pop bottom sheet.

              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                // height: MediaQuery.of(context).size.height*0.95,
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: List.generate(value.length, (index) {
                      String city = value[index].name.toString();
                      return TextButton(
                        child: Text(city,
                            style: const TextStyle(
                                fontSize: 18, color: Colors.black)),
                        onPressed: () {
                          setState(() {
                            controller.text = city;
                            ref
                                .read(provider!.notifier)
                                .update((state) => controller.text);
                            Navigator.of(context).pop();
                          });
                        },
                      );
                    })),
              ),
            ],
          );
        });
  }
}

class MyTextFormField extends StatelessWidget {
  const MyTextFormField(
      {Key? key,
      this.prefixIcon,
      required this.label,
      required this.controller,
      this.onTap,
      this.initialValue,
      required this.readOnly,
      this.validator})
      : super(key: key);
  final IconData? prefixIcon;
  final String label;
  final TextEditingController controller;
  final void Function()? onTap;
  final String? initialValue;
  final bool readOnly;
  final String? Function(String?)? validator;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      validator: validator,
      readOnly: readOnly,
      controller: controller,
      onTap: onTap,
      initialValue: initialValue,
      decoration: InputDecoration(
        prefixIcon: Icon(prefixIcon),
        label: Text(label),
      ),
    );
  }
}

class UserCircleAvatar extends ConsumerWidget {
  const UserCircleAvatar({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    const String defaultUrl =
        "https://cdn.pixabay.com/photo/2017/08/16/11/38/tree-2647471__340.png";
    final String? url = ref.watch(authStateProvider).value?.photoURL;
    return CircleAvatar(
      backgroundColor: Colors.white.withOpacity(0.7),
      radius: 20,
      child: CircleAvatar(
        backgroundImage:
            NetworkImage(url != null ? url.toString() : defaultUrl),
        radius: 19,
      ),
    );
  }
}

class SearchTripPage extends ConsumerWidget {
  const SearchTripPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final source = ref.watch(sourceProvider);
    final destination = ref.watch(destinationProvider);
    final date = ref.watch(dateProvider);
    // final List<Itinerary> trips = [];

    //Reading the list of trips available for the chosen destination and date

    final tripSnapshot =
        ref.watch(daoProvider).findTrips(source, destination, date);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Search Trip",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.black,
              fontSize: 30,
            )),
        backgroundColor: Colors.white,
      ),
      body: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        height: MediaQuery.of(context).size.height,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Expanded(
              child: StreamBuilder<List<Itinerary>>(
                stream: tripSnapshot,
                builder: ((context, snapshot) {
                  // if (snapshot.data!.isEmpty) {
                  //   return const Center(
                  //       child: Text(
                  //     'No Available trips today. Sorry!',
                  //     style: TextStyle(color: Colors.black),
                  //   ));
                  // }
                  return (snapshot.connectionState == ConnectionState.waiting)
                      ? const Center(
                          child: CircularProgressIndicator(),
                        )
                      : ListView.builder(
                          // physics: const NeverScrollableScrollPhysics(),
                          // shrinkWrap: true,
                          itemCount: snapshot.data?.length,
                          itemBuilder: ((context, index) {
                            List<Itinerary> trip = snapshot.data!;

                            return GestureDetector(
                              onTap: () {
                                //updating the various providers to be used in other pages
                                ref.read(sourceProvider.notifier).update(
                                      (state) => trip[index].source,
                                    );
                                ref.read(destinationProvider.notifier).update(
                                      (state) => trip[index].destination,
                                    );
                                ref.read(priceProvider.notifier).update(
                                      (state) => trip[index].price.toString(),
                                    );
                                ref.read(arrivalDateProvider.notifier).update(
                                      (state) => trip[index].arrivalDate,
                                    );
                                ref.read(arrivalDateProvider.notifier).update(
                                      (state) => trip[index].arrivalDate,
                                    );
                                ref.read(departureDateProvider.notifier).update(
                                      (state) => trip[index].departureDate,
                                    );
                                ref.read(toCodeProvider.notifier).update(
                                      (state) => trip[index]
                                          .destinationCode
                                          .toString(),
                                    );
                                ref.read(fromCodeProvider.notifier).update(
                                      (state) =>
                                          trip[index].sourceCode.toString(),
                                    );

                                context.push('/options');
                              },
                              child: TrainCard(
                                  to: trip[index].destination,
                                  from: trip[index].source,
                                  cost: trip[index].price.toString(),
                                  trainName: 'DZ',
                                  arrivalTime: trip[index].arrivalDate,
                                  departureTime: trip[index].departureDate,
                                  duration: '5hr',
                                  toCode:
                                      trip[index].destinationCode.toString(),
                                  fromCode: trip[index].sourceCode.toString()),
                            );
                          }),
                        );
                }),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

final dateProvider = StateProvider<String>((ref) =>
    "${DateTime.now().year}-${DateTime.now().month}-${DateTime.now().day}");
final sourceProvider = StateProvider<String>((ref) => '');
final destinationProvider = StateProvider<String>((ref) => '');
final priceProvider = StateProvider<String>((ref) => '');
final arrivalDateProvider = StateProvider<String>((ref) => '');
final departureDateProvider = StateProvider<String>((ref) => '');
final durationProvider = StateProvider<String>((ref) => '');
final toCodeProvider = StateProvider<String>((ref) => '');
final fromCodeProvider = StateProvider<String>((ref) => '');

String dateFormater(DateTime date) {
  return "${date.year}-${date.month}-${date.day}";
}
