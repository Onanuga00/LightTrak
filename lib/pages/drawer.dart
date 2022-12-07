import 'package:flutter/material.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:train_app/pages/home_page.dart';
import 'package:train_app/pages/ticket_options.dart';

import '../models/model_dao.dart';

class MyDrawer extends StatelessWidget {
  const MyDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      // width: 200,
      child: Column(
        children: [
          const SizedBox(
            height: 50,
          ),
          ListTile(
            onTap: () async {
              // await _addTrain(context);
            },
            title: const Text('Add Train'),
          ),
          ListTile(
            onTap: () async {
              // await _addTrip(context);
            },
            title: const Text('Add Trip'),
          ),
          ListTile(
            onTap: () async {
              // await _addLocation(context);
            },
            title: const Text('Add Location'),
          ),
          Consumer(builder: (context, ref, child) {
            return ListTile(
              onTap: () {
                // ref.read(daoProvider).getTrainWagons('te');
              },
              title: const Text('Add class'),
            );
          }),
          ListTile(
            onTap: () {
              context.push('/admintrip');
            },
            title: const Text('Verfy Tickets'),
          )
        ],
      ),
    );
  }
}
