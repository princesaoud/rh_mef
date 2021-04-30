import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthenticationService {
  final FirebaseAuth _firebaseAuth;

  AuthenticationService(this._firebaseAuth);

  Stream<User> get authStateChanges => _firebaseAuth.authStateChanges();

  Future<void> signOut() async {
    await _firebaseAuth.signOut();
  }

  Future<String> signIn({String email, String password}) async {
    try {
      await _firebaseAuth.signInWithEmailAndPassword(
          email: email, password: password);
      await FirebaseMessaging().getToken().then((token) async {
        QuerySnapshot data = await FirebaseFirestore.instance
            .collection("ActeDemand")
            .where('email', isEqualTo: email)
            .get();
        String value = data.docs.first.data()['key'];
        print(value);
        var snapshot = FirebaseFirestore.instance
            .collection("ActeDemand")
            .doc(value)
            .snapshots();
        await snapshot.forEach((element) {
          element.reference.update({'deviceId': token});
        });

        await FirebaseFirestore.instance
            .collection("Profile")
            .doc('${_firebaseAuth.currentUser.uid}')
            .update({'token': token});
        DocumentSnapshot document = await FirebaseFirestore.instance
            .collection('Profile')
            .doc(_firebaseAuth.currentUser.uid)
            .get();

        SharedPreferences sharedPreferences =
            await SharedPreferences.getInstance();
        sharedPreferences.setString('matricule', document.data()['matricule']);
        sharedPreferences.setString('nom', document.data()['nom']);
        sharedPreferences.setString('tel', document.data()['tel']);
        sharedPreferences.setString('email', document.data()['email']);
        sharedPreferences.setString(
            'priseDeService', document.data()['priseDeService']);
        sharedPreferences.setString('fonction', document.data()['fonction']);
      });
      return "Sign in";
    } on FirebaseAuthException catch (e) {
      return e.message;
    }
  }

  Future<String> signUp({String email, String password}) async {
    try {
      await _firebaseAuth.createUserWithEmailAndPassword(
          email: email, password: password);
      return "New user created";
    } on FirebaseAuthException catch (e) {
      return e.message;
    }
  }
}
