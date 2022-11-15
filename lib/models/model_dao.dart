import 'package:firebase_core/firebase_core.dart';

import 'itinerary.dart';
import 'location.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:riverpod/riverpod.dart';
import 'users.dart';

class Dao {
  final db = FirebaseFirestore.instance;

  Stream get allCities => db.collection('locations').snapshots();

//function to add a location to the database
  Future<void> addLocation(Location station) async {
    final ref = db.collection('locations').withConverter(
        fromFirestore: Location.fromFirestore,
        toFirestore: (Location location, _) => location.toFireStore());
    await ref.add(station).then(
        (value) => print('added data with the following id ${value.id}'),
        onError: (object, trace) => print('error occured'));
  }

//function to get all locations from the database
  Future<List<Location>> getLocations() async {
    final List<Location> locs = [];
    //Use our from and to methods here to convert from and to firebase objects
    final ref = db.collection('locations').withConverter(
        fromFirestore: Location.fromFirestore,
        toFirestore: (Location location, _) => location.toFireStore());
    await ref.get().then((value) {
      for (var element in value.docs) {
        locs.add(element.data());
      }
    });

    return locs;
  }

//Function to add a newly registered user to database
  Future<void> addUser(TrainUser user) async {
    final ref = db.collection('users').withConverter(
        fromFirestore: TrainUser.fromFirestore,
        toFirestore: (TrainUser user, _) => user.toFireStore());
    await ref.add(user);
  }

//Function to get the name of a local user who registered with email and not google
  Future<String?> getUserById(String id) async {
    final ref = db.collection('users').withConverter(
        fromFirestore: TrainUser.fromFirestore,
        toFirestore: (TrainUser user, _) => user.toFireStore());
    TrainUser trainUser = await ref
        .where('id', isEqualTo: id)
        .get()
        .then((snapshot) => snapshot.docs.first.data());
    return trainUser.firstName;
  }

// Adding a trip in the DB. Admin stuff
  Future<void> addtrip(Itinerary trip) async {
    final ref = db.collection('trips').withConverter(
        fromFirestore: Itinerary.fromFirestore,
        toFirestore: (Itinerary itinerary, _) => itinerary.toFireStore());
    await ref.add(trip);
  }

//Query to search trips from the database per date, per depature location, per destination location
  Stream<List<Itinerary>> findTrips(
      String source, String destination, String date) {
    return FirebaseFirestore.instance
        .collection('trips')
        .withConverter(
            fromFirestore: Itinerary.fromFirestore,
            toFirestore: (Itinerary itinerary, options) =>
                itinerary.toFireStore())
        .where("source", isEqualTo: source)
        .where("destination", isEqualTo: destination)
        .where('departureDate', isEqualTo: date)
        .snapshots()
        .map((snapShot) {
      List<Itinerary> trips = [];
      for (var element in snapShot.docs) {
        trips.add(element.data());
      }
      return trips;
    });
  }
}

//Provider of the Data Access Object (database) to all pages
final daoProvider = Provider<Dao>((ref) {
  return Dao();
});
