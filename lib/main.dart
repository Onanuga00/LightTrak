import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:train_app/router.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:google_fonts/google_fonts.dart';

void main() async {
  //Initialising firebase for each platform
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  // runApp is the inbuilt method that calls the root app of our project.
  //Provider scope is some magic from Riverpod (state management package) that permits
  // that the state of our app can be accessed by other widgets down the tree.
  runApp(const ProviderScope(child: TrainApp()));
}

class TrainApp extends ConsumerWidget {
  const TrainApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(routerProvider);
    return MaterialApp.router(
      routeInformationParser: router.routeInformationParser,
      routerDelegate: router.routerDelegate,
      routeInformationProvider: router.routeInformationProvider,
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
          // This is the theme of your application.

          primarySwatch: Colors.blueGrey,
          textTheme:
              GoogleFonts.varelaRoundTextTheme(Theme.of(context).textTheme),
          inputDecorationTheme: InputDecorationTheme(
            isDense: true,
            fillColor: Colors.grey[200],
            filled: true,
            //Just defining how I want the borders of text input fields to look like across all of the app.

            enabledBorder: OutlineInputBorder(
                borderSide: const BorderSide(color: Colors.white, width: 2.0),
                borderRadius: BorderRadius.circular(12)),
            disabledBorder: OutlineInputBorder(
              borderSide:
                  const BorderSide(width: 2.0, color: Color(0xff03314B)),
              borderRadius: BorderRadius.circular(12),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: const BorderSide(color: Colors.green),
              borderRadius: BorderRadius.circular(12),
            ),
          )),
    );
  }
}
