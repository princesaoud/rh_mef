import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:commons/commons.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:rh_mef/main.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthenticationService {
  final FirebaseAuth _firebaseAuth;
  ProgressDialog pr;
  AuthenticationService(this._firebaseAuth);

  Stream<User> get authStateChanges => _firebaseAuth.authStateChanges();

  Future<void> signOut() async {
    await _firebaseAuth.signOut();
  }

  Future<String> signIn(
      {String email, String password, BuildContext context}) async {
    pr = new ProgressDialog(context,
        type: ProgressDialogType.Normal, isDismissible: true, showLogs: false);
    pr.show();
    try {
      _firebaseAuth
          .signInWithEmailAndPassword(email: email, password: password)
          .whenComplete(() {
        complexeStuff(email: email, context: context);
      });

      return "${_firebaseAuth.currentUser.uid}";
    } on FirebaseAuthException catch (e) {
      pr.hide().then((value) {
        print(value);
        errorDialog(context, "Erreur d'authentification");
      });
      return e.message;
    }
  }

  void complexeStuff({String email, BuildContext context}) {
    FirebaseMessaging.instance.getToken().then((token) async {
      QuerySnapshot data = await FirebaseFirestore.instance
          .collection("ActeDemand")
          .where('email', isEqualTo: email)
          .get();
      String value = "";
      data.docs.forEach((element) {
        value = element.data()['key'];
      });
      print(value);
      if (value != null) {
        var snapshot = FirebaseFirestore.instance
            .collection("ActeDemand")
            .doc(value)
            .snapshots();
        await snapshot.forEach((element) {
          element.reference.update({'deviceId': token});
        });
      }
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
    pr.hide().then((value) {
      print(value);
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => MyApp()));
    });
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
