import 'package:firebase_core/firebase_core.dart';
import 'package:train_app/authentication/auth.dart';
import 'package:train_app/models/train.dart';
import 'package:train_app/models/ticket.dart';
import 'package:train_app/pages/home.dart';
import 'package:train_app/pages/ticket_options.dart';

import 'itinerary.dart';
import 'location.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:riverpod/riverpod.dart';
import 'users.dart';

class Dao {
  final db = FirebaseFirestore.instance;
  List<Ticket> tickets = [];
  List<Ticket> ticketsByUser = [];
  List<Ticket> trips = [];
  List<String> ticketIDs = [];

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

  Future<TrainUser> getUser(String id) async {
    final ref = db.collection('users').withConverter(
        fromFirestore: TrainUser.fromFirestore,
        toFirestore: (TrainUser user, _) => user.toFireStore());
    TrainUser trainUser = await ref
        .where('id', isEqualTo: id)
        .get()
        .then((snapshot) => snapshot.docs.first.data());
    return trainUser;
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

  // Add a single train to DB
  Future<void> addTrain(Train train) async {
    final ref = db.collection('trains').withConverter(
        fromFirestore: Train.fromFirestore,
        toFirestore: (Train train, _) => train.toFireStore());
    await ref.add(train).then(
        (value) => print('added data with the following id ${value.id}'),
        onError: (object, trace) => print('error occured'));
  }

//Get trains from the DB to be put in the trip
  Future<List<Train>> getTrains() async {
    final List<Train> trains = [];
    //Use our from and to methods here to convert from and to firebase objects
    final ref = db.collection('locations').withConverter(
        fromFirestore: Train.fromFirestore,
        toFirestore: (Train train, _) => train.toFireStore());

    await ref.get().then((snapshot) {
      for (var train in snapshot.docs) {
        trains.add(train.data());
      }
    });

    return trains;
  }

// Get wagons of a train
  Future<List<Wagon>> getTrainWagons(String trainID) async {
    final List<Wagon> wagons = [];
    //Use our from and to methods here to convert from and to firebase objects
    final trainRef = db
        .collection('trains')
        .withConverter(
            fromFirestore: Train.fromFirestore,
            toFirestore: (Train train, _) => train.toFireStore())
        .where('code', isEqualTo: 'te')
        .get();
    final wagonRef = trainRef.then((value) {
      for (var element in value.docs) {
        db
            .collection('trains')
            .doc(element.id)
            .collection('wagons')
            .withConverter(
                fromFirestore: Wagon.fromFirestore,
                toFirestore: (Wagon wagon, _) => wagon.toFireStore())
            .get()
            .then((subcol) {
          for (var element in subcol.docs) {
            wagons.add(element.data());
            print(element.data().id);
            print(element.data().trainClass);
            print(element.data().noOfSeats);
          }
        });
      }
    });

    return wagons;
  }

//method to store ticket details in the database
  Future<void> storeTicketDetails(String tripID, Ticket ticket) async {
    //Use our from and to methods here to convert from and to firebase objects
    final tripRef = db
        .collection('trips')
        .withConverter(
            fromFirestore: Itinerary.fromFirestore,
            toFirestore: (Itinerary trip, _) => trip.toFireStore())
        .where('id', isEqualTo: tripID)
        .get();
    tripRef.then((value) {
      for (var element in value.docs) {
        db
            .collection('trips')
            .doc(element.id)
            .collection('tickets')
            .withConverter(
                fromFirestore: Ticket.fromFirestore,
                toFirestore: (Ticket ticket, _) => ticket.toFireStore())
            .add(ticket)
            .then((subcol) {
          print('ticket was created successfully');
        });
      }
    });
  }

  //Get ticket IDS for a given trip
  Future<List<String>> getTicketIDs(String tripID) async {
    //Use our from and to methods here to convert from and to firebase objects
    return db
        .collection('trips')
        .withConverter(
            fromFirestore: Itinerary.fromFirestore,
            toFirestore: (Itinerary trip, _) => trip.toFireStore())
        .where('id', isEqualTo: tripID)
        .get()
        .then((value) {
      for (var element in value.docs) {
        db
            .collection('trips')
            .doc(element.id)
            .collection('tickets')
            .withConverter(
                fromFirestore: Ticket.fromFirestore,
                toFirestore: (Ticket ticket, _) => ticket.toFireStore())
            .get()
            .then((subcol) {
          for (var tic in subcol.docs) {
            ticketIDs.add(tic.data().ticketID);
          }
        });
      }

      return ticketIDs;
    });
  }

//get train ticket by ID
  Future<List<Ticket>> getTrainTicketByID(String tripID, ticketID) async {
    //Use our from and to methods here to convert from and to firebase objects
    return db
        .collection('trips')
        .withConverter(
            fromFirestore: Itinerary.fromFirestore,
            toFirestore: (Itinerary trip, _) => trip.toFireStore())
        .where('id', isEqualTo: tripID)
        .get()
        .then((value) {
      for (var element in value.docs) {
        db
            .collection('trips')
            .doc(element.id)
            .collection('tickets')
            .withConverter(
                fromFirestore: Ticket.fromFirestore,
                toFirestore: (Ticket ticket, _) => ticket.toFireStore())
            .where('ticketID', isEqualTo: ticketID)
            .get()
            .then((subcol) {
          for (var tic in subcol.docs) {
            tickets.add(tic.data());
          }
        });
      }

      return tickets;
    });
  }

  // UPDATE TICKET BY ID

  Future<void> updateTrainTicketByID(
      String tripID, ticketID, Map<String, dynamic> data) async {
    //Use our from and to methods here to convert from and to firebase objects
    await db
        .collection('trips')
        .where('id', isEqualTo: tripID)
        .get()
        .then((value) {
      for (var element in value.docs) {
        db
            .collection('trips')
            .doc(element.id)
            .collection('tickets')
            .where('ticketID', isEqualTo: ticketID)
            .get()
            .then((subcol) {
          for (var doc in subcol.docs) {
            db
                .collection('trips')
                .doc(element.id)
                .collection('tickets')
                .doc(doc.id)
                .update(data)
                .then((value) => print('ticket was cancelled'));
          }
        });
      }

      return tickets;
    });
  }

//get train ticket by user
  Future<List<Ticket>> getTrainTicketsByUser(String owner) async {
    //Use our from and to methods here to convert from and to firebase objects
    final trainRef = db
        .collection('trips')
        .withConverter(
            fromFirestore: Itinerary.fromFirestore,
            toFirestore: (Itinerary trip, _) => trip.toFireStore())
        .get();
    trainRef.then((value) {
      for (var element in value.docs) {
        db
            .collection('trips')
            .doc(element.id)
            .collection('tickets')
            .withConverter(
                fromFirestore: Ticket.fromFirestore,
                toFirestore: (Ticket ticket, _) => ticket.toFireStore())
            .where('owner', isEqualTo: owner)
            .get()
            .then((subcol) {
          for (var tic in subcol.docs) {
            ticketsByUser.add(tic.data());
            // print(tic.data().owner);
            // print(tic.data().ticketID);
            // print(element.data().noOfSeats);
          }
        });
      }
    });

    return ticketsByUser;
  }
}

//Provider of the Data Access Object (database) to all pages
final daoProvider = Provider<Dao>((ref) {
  return Dao();
});

final futureTicketProvider = FutureProvider<List<Ticket>>(
  (ref) {
    final dao = ref.watch(daoProvider);
    final tripID = ref.watch(tripIDProvider);
    final ticketID = ref.watch(ticketIDProvider);
    return dao.getTrainTicketByID(tripID, ticketID);
  },
);

final futureTicketByUserProvider = FutureProvider<List<Ticket>>(
  (ref) {
    final dao = ref.watch(daoProvider);
    final userID = ref.watch(authenticationProvider).currentUserID;

    return dao.getTrainTicketsByUser(userID);
  },
);

final futureTicketIDProvider = FutureProvider<List<String>>(
  (ref) {
    final dao = ref.watch(daoProvider);
    final tripID = ref.watch(tripIDProvider);

    return dao.getTicketIDs(tripID);
  },
);

// final washingtonRef = FirebaseFirestore.instance.collection("cites").doc("DC");
// final who = washingtonRef.update({"capital": true}).then(
//     (value) => print("DocumentSnapshot successfully updated!"),
//     onError: (e) => print("Error updating document $e"));
