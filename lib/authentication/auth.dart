import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:train_app/widgets/show_dialogue.dart';

class Authentication {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  Stream<User?> get authStateChange => _auth.authStateChanges();
  User? get currentUser => _auth.currentUser;
  String get currentUserID => _auth.currentUser!.uid;

  Future<void> createUserWithEmailAndPassword(
      String email, String password, BuildContext ctx) async {
    try {
      await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
    } on FirebaseAuthException catch (e) {
      await ShowDialogue().alert(ctx, e.code);
    }
  }

  Future<void> signInWithEmailAndPassword(
      String email, String password, BuildContext ctx) async {
    try {
      await _auth.signInWithEmailAndPassword(email: email, password: password);
    } on FirebaseAuthException catch (e) {
      await ShowDialogue().alert(ctx, e.code);
    }
  }

  Future<void> googleSignIn(BuildContext ctx) async {
    try {
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
      //authenticate the user
      final GoogleSignInAuthentication? googleAuth =
          await googleUser?.authentication;

      //Create a new credential
      final AuthCredential credential = GoogleAuthProvider.credential(
        idToken: googleAuth?.idToken,
        accessToken: googleAuth?.accessToken,
      );
      await _auth.signInWithCredential(credential);
    } on FirebaseAuthException catch (e) {
      await ShowDialogue().alert(ctx, e.code);
    }
  }

  Future<void> signOut() async {
    await FirebaseAuth.instance.signOut();
    await GoogleSignIn().signOut();
  }
}

final authenticationProvider =
    Provider<Authentication>((ref) => Authentication());
final authStateProvider = StreamProvider<User?>(
    (ref) => ref.watch(authenticationProvider).authStateChange);

final loginStatusProvider = Provider<bool>((ref) {
  User? user = ref.watch(authStateProvider).value;
  if (user != null) {
    return true;
  } else {
    return false;
  }
});
