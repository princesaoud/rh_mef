import 'dart:convert';
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:rh_mef/constantes.dart';
import 'package:rh_mef/models/actualites_type.dart';
import 'package:rh_mef/models/mDemandeActe.dart';
import 'package:twilio_flutter/twilio_flutter.dart';
import 'package:uuid/uuid.dart';

// class CustomFirebaseMangement {}
String userKey = "";

Future<void> userSetup(String designation, String number, String email,
    String complaintType, String observation) async {
  CollectionReference acteDemand =
      FirebaseFirestore.instance.collection('acteDemand');
  // FirebaseAuth auth = FirebaseAuth.instance;
  // String uid = auth.currentUser.uid.toString();
  acteDemand.add({
    'designation': designation,
    'number': number,
    'email': email,
    'complaintType': complaintType,
    'observation': observation,
  });
  return;
}

Future<void> demandeActeSetup(DemandeActe _demandeacte) async {
  firebaseCloudMessaging_Listeners();
  var uuid = Uuid();
  int numeroDemande = Random().nextInt(10000);
  CollectionReference acteDemand =
      FirebaseFirestore.instance.collection('ActeDemand');
  // FirebaseAuth auth = FirebaseAuth.instance;
  // String uid = auth.currentUser.uid.toString();
  String docId = uuid.v4();
  FirebaseMessaging().getToken().then((token) async {
    acteDemand.doc(docId).set({
      'key': docId,
      'deviceId': token,
      'matricule': _demandeacte.matricule,
      'nom': _demandeacte.nom,
      'telephone': _demandeacte.telephone,
      'email': _demandeacte.email,
      'datePriseService': _demandeacte.datePriseService,
      'emploi': _demandeacte.emploi,
      'natureActe': _demandeacte.natureActe,
      'pieceJointe': _demandeacte.pieceJointe,
      'motif': _demandeacte.motif,
      'statuts': _demandeacte.statuts,
      'numeroDemande': numeroDemande,
      'updated': DateTime.now(),
      'isNotification': true,
    });
    // bool pushNotification = await callOnFcmApiSendPushNotifications(token);
  });

  return;
}

void firebaseCloudMessaging_Listeners() {
  FirebaseMessaging().getToken().then((token) {
    print("token of the device is : $token");
  });
}

Future<void> newsSetup(Actualites actualites) async {
  CollectionReference newsadd = FirebaseFirestore.instance.collection('News');
  // FirebaseAuth auth = FirebaseAuth.instance;
  // String uid = auth.currentUser.uid.toString();
  newsadd.add({
    'Title': actualites.title,
    'Description': actualites.subtitle,
    'Author': actualites.author,
    'DatePosted': actualites.published_date,
    'Link': actualites.link,
    'ImageUrl': actualites.imageAsset,
  });
  return;
}

// sendLocalNotification() {}

Future<bool> callOnFcmApiSendPushNotifications(
    String userToken, String description) async {
  final postUrl = 'https://fcm.googleapis.com/fcm/send';
  final data = {
    "registration_ids": userToken,
    "collapse_key": "type_a",
    "notification": {
      "title": 'DRH-MEF',
      "body": '$description',
    }
  };

  final headers = {
    'content-type': 'application/json',
    'Authorization': Constants.firebaseTokenAPIFCM // 'key=YOUR_SERVER_KEY'
  };

  final response = await http.post(postUrl,
      body: json.encode(data),
      encoding: Encoding.getByName('utf-8'),
      headers: headers);

  if (response.statusCode == 200) {
    // on success do sth
    print('test ok push CFM');
    return true;
  } else {
    print(' CFM error');
    // on failure do sth
    return false;
  }
}

Widget statusCode(int status, int numeroDemande) {
  String tempResult = "";
  switch (status) {
    case 0:
      tempResult = "Votre demande est en cours de validation";
      return Card(
        child: ListTile(
          leading: Icon(Icons.pending_actions_rounded),
          title: Text('Numero demande: $numeroDemande'),
          subtitle: Text(
            'Progression: $tempResult',
          ),
        ),
      );
      break;
    case 1:
      tempResult = "Votre demande est validée et est cours de traitement";
      return Card(
        child: ListTile(
          leading: Icon(Icons.autorenew),
          title: Text('Numero demande: $numeroDemande'),
          subtitle: Text(
            'Progression: $tempResult',
          ),
        ),
      );
      break;
    case 2:
      tempResult = "Votre demande a ete rejette";
      return Card(
        child: ListTile(
          leading: Icon(
            Icons.dangerous,
            color: Colors.red,
          ),
          title: Text('Numero demande: $numeroDemande'),
          subtitle: Text(
            'Progression: $tempResult',
          ),
        ),
      );
      break;
    case 3:
      tempResult = "Votre demande est disponible et peut etre retiré";
      return Card(
        child: ListTile(
          leading: Icon(
            Icons.check,
            color: Colors.green,
          ),
          title: Text('Numero demande: $numeroDemande'),
          subtitle: Text(
            'Progression: $tempResult',
          ),
        ),
      );
      break;
    case 4:
      tempResult = "Votre demande a ete retire";
      return Card(
        child: ListTile(
          leading: Icon(
            Icons.download_done_sharp,
            color: Colors.green,
          ),
          title: Text('Numero demande: $numeroDemande'),
          subtitle: Text(
            'Progression: $tempResult',
          ),
        ),
      );
      break;
  }
  // print(tempResult);
  return null;
}

void sendSms(TwilioFlutter twilioFlutter, String number, String message) async {
  twilioFlutter.sendSMS(toNumber: number, messageBody: message);
}
