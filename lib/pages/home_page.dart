import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:train_app/authentication/auth.dart';
import 'package:train_app/models/model_dao.dart';
import 'package:train_app/pages/search_page.dart';

import '../models/location.dart';
import 'home.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;
  void _onTap(int currentIndex) {
    setState(() {
      _selectedIndex = currentIndex;
    });
  }

  @override
  Widget build(BuildContext context) {
    // _currentIndex = 0;
    return Scaffold(
      bottomNavigationBar: BottomNavigationBar(
          currentIndex: _selectedIndex,
          onTap: _onTap,
          elevation: 0.0,
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
                icon: Icon(
                  Icons.home_filled,
                  color: Colors.blueGrey,
                ),
                label: 'Home'),
            // BottomNavigationBarItem(
            //     icon: Icon(
            //       Icons.search_outlined,
            //       color: Colors.blueGrey,
            //     ),
            //     label: 'Explore'),
            BottomNavigationBarItem(
                icon: Icon(
                  Icons.airplane_ticket_outlined,
                  color: Colors.blueGrey,
                ),
                label: 'Ticket'),
            BottomNavigationBarItem(
                icon: Icon(
                  Icons.person,
                  color: Colors.blueGrey,
                ),
                label: 'Profile')
          ]),
      body: Center(
          child: IndexedStack(
        index: _selectedIndex,
        children: pages,
      )),
    );
  }
}

List<Widget> pages = [
  const Home(),
  // const Text('Home', style: TextStyle(color: Colors.black),),
  // const Center(child: SearchPage()),
  const Center(child: Text('Ticket')),
  const AdminPage(),
];

class AdminPage extends ConsumerStatefulWidget {
  const AdminPage({super.key});

  @override
  ConsumerState<AdminPage> createState() => _AdminPageState();
}

class _AdminPageState extends ConsumerState<AdminPage> {
  final locationNameController = TextEditingController();
  final locationCodeController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    locationNameController.dispose();
    locationCodeController.dispose();
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: IconButton(
                onPressed: () {
                  ref.read(authenticationProvider).signOut();
                },
                icon: const Icon(
                  Icons.logout_rounded,
                  color: Colors.redAccent,
                  size: 30,
                )),
          )
        ],
        backgroundColor: Colors.white,
        title: const Text(
          'Admin Corner',
          style: TextStyle(
              fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black),
        ),
      ),
      body: Container(
        height: MediaQuery.of(context).size.height,
        padding: const EdgeInsets.all(8),
        decoration: const BoxDecoration(color: Colors.white),
        child: SingleChildScrollView(
          child: Column(
            children: [
              ListTile(
                onTap: () {},
                title: const Text('Add Train'),
              ),
              ListTile(
                onTap: () {},
                title: const Text('Add Trip'),
              ),
              ListTile(
                onTap: () {
                  showModalBottomSheet(
                      context: context,
                      builder: (context) {
                        return Form(
                          key: _formKey,
                          child: SizedBox(
                            width: MediaQuery.of(context).size.width * 0.8,
                            child: Column(
                              children: [
                                const Padding(
                                  padding:
                                      EdgeInsets.only(top: 10.0, bottom: 10),
                                  child: Text(
                                    'Add Location',
                                    style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black),
                                  ),
                                ),
                                const SizedBox(height: 20),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 20.0, vertical: 10),
                                  child: TextFormField(
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return 'Please add a location';
                                      }
                                      return null;
                                    },
                                    controller: locationNameController,
                                    decoration: InputDecoration(
                                      enabledBorder: OutlineInputBorder(
                                          borderSide: const BorderSide(
                                              color: Colors.white),
                                          borderRadius:
                                              BorderRadius.circular(12)),
                                      focusedBorder: OutlineInputBorder(
                                          borderSide: const BorderSide(
                                              color: Colors.deepPurple),
                                          borderRadius:
                                              BorderRadius.circular(12)),
                                      hintText: 'Location Name',
                                      fillColor: Colors.grey[200],
                                      filled: true,
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 20.0, vertical: 10),
                                  child: TextFormField(
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return 'Please add a location';
                                      }
                                      return null;
                                    },
                                    controller: locationCodeController,
                                    decoration: InputDecoration(
                                      enabledBorder: OutlineInputBorder(
                                          borderSide: const BorderSide(
                                              color: Colors.white),
                                          borderRadius:
                                              BorderRadius.circular(12)),
                                      focusedBorder: OutlineInputBorder(
                                          borderSide: const BorderSide(
                                              color: Colors.deepPurple),
                                          borderRadius:
                                              BorderRadius.circular(12)),
                                      hintText: 'Location Code',
                                      fillColor: Colors.grey[200],
                                      filled: true,
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: TextButton(
                                    onPressed: () async {
                                      if (_formKey.currentState!.validate()) {
                                        final station = Location(
                                          code: locationCodeController.text,
                                          name: locationNameController.text,
                                        );
                                        await ref
                                            .read(daoProvider)
                                            .addLocation(station)
                                            .then((value) {
                                          print('done');
                                          setState(() {
                                            locationCodeController.clear();
                                            locationNameController.clear();
                                          });
                                          return;
                                        });
                                      }
                                    },
                                    child: Container(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 20, vertical: 10),
                                        decoration: BoxDecoration(
                                            border: Border.all(
                                                color: Colors.green,
                                                width: 2.5)),
                                        child: const Text(
                                          'Add Station',
                                          style: TextStyle(
                                              color: Colors.black,
                                              fontWeight: FontWeight.bold,
                                              fontSize: 18),
                                        )),
                                  ),
                                )
                              ],
                            ),
                          ),
                        );
                      });
                },
                title: const Text('Add Location'),
              ),
              ListTile(
                onTap: () {},
                title: const Text('Add class'),
              )
            ],
          ),
        ),
      ),
    );
  }
}
