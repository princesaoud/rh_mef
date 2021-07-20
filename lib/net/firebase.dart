import 'dart:convert';
import 'dart:convert' as convert;
import 'dart:io';
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:commons/commons.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:rh_mef/constantes.dart';
import 'package:rh_mef/models/ActeModel.dart';
import 'package:rh_mef/models/actualites_type.dart';
import 'package:rh_mef/models/mDemandeActe.dart';
import 'package:rh_mef/models/userDetails.dart';
import 'package:twilio_flutter/twilio_flutter.dart';
import 'package:uuid/uuid.dart';

// class CustomFirebaseMangement {}
String userKey = "";
Future<bool> internetChecking() async {
  try {
    final result = await InternetAddress.lookup('google.com');
    if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
      print('connected');
      return true;
    }
  } on SocketException catch (_) {
    print('not connected');
    return false;
  }
  return false;
}

Future<void> complaintSetup(
    {String complaintType, String observation, String userId}) async {
  CollectionReference complaintReference =
      FirebaseFirestore.instance.collection('Complaint');
  // FirebaseAuth auth = FirebaseAuth.instance;
  // String uid = auth.currentUser.uid.toString();
  var uuid = Uuid();
  String docId = uuid.v4();

  complaintReference.doc(docId).set({
    'id': Random().nextInt(160000),
    'complaintType': complaintType,
    'observation': observation,
    'userId': userId,
    'steps': 1,
    'created': DateTime.now(),
    'recevabilite': DateTime.now(),
    'error': '',
    'key': docId
  });
  return;
}

//I/flutter (23866): connection state :
// UserDetails{id: 3798, matricule: 385186P,
// nom: AKANGBE ADAMA AJANI, sexe: M,
// nom_pere: AKANGBE KAFAROU, nom_mere: KOUAME AHOU AMELIE,
// tel_domicile: 53055804, tel_bureau: ,
// cellulaire: 09389136, adresse: 11 BP 623 ABIDJAN,
// email: aaajani25@gmail.com, sitmat: null,
// date_nais: 03/03/1983, lieu_nais: M'BAHIAKRO,
// nbre_enf: 1, prise_service: null, type_agent: null,
// grade: null, emloi: null, echelle: null,
// date_emploi: 30/01/2020, fonction: AGENT DE CONCEPTION,
// lib_dg: CABINET DU MINISTRE DE L'ECONOMIE ET DES FINANCES,
// lib_dir: DIRECTION DES RESSOURCES HUMAINES, lib_sr: null,
// lib_sce: SERVICE ETUDES ET DEVELOPPEMENT INFORMATIQUE,
// mut_date_debut: 02/06/2020, code_sp: 634, sous_prefecture: PLATEAU,
// departement: ABIDJAN, region: null, district: null, lieu_pays: null,
// position: null, date_position: null, date_retraite: 03/03/2048,
// date_1ere_ps: 04/02/2013, date_prise_serv_structure: 05/04/2019,
// nat_libelle: IVOIRIENNE, hfonc_reference: N°19101000143057/MEF/DRH DU 12/04/2019, created: 2021-02-09 14:3
Future<void> demandeActeSetup(DemandeActe _demandeacte) async {
  firebaseCloudMessaging_Listeners();
  var uuid = Uuid();
  int acteDemande = Random().nextInt(10000);
  CollectionReference acteDemand =
      FirebaseFirestore.instance.collection('ActeDemand');
  // FirebaseAuth auth = FirebaseAuth.instance;
  // String uid = auth.currentUser.uid.toString();
  String docId = uuid.v4();
  SharedPreferences shar = await SharedPreferences.getInstance();
  String matricule = shar.getString('matricule');
  FirebaseAuth auth = FirebaseAuth.instance;

  FirebaseMessaging.instance.getToken().then((token) async {
    acteDemand.doc(docId).set({
      'key': docId,
      'deviceId': token,
      'matricule': _demandeacte.matricule,
      // 'nom': _demandeacte.nom,
      // 'telephone': _demandeacte.telephone,
      // 'email': _demandeacte.email,
      // 'datePriseService': _demandeacte.datePriseService,
      // 'emploi': _demandeacte.emploi,
      'natureActe': _demandeacte.natureActe,
      'pieceJointe': _demandeacte.pieceJointe,
      'motif': _demandeacte.motif,
      'statuts': _demandeacte.statuts,
      'acteDemande': acteDemande,
      'userId': auth.currentUser.uid,
      'created': DateTime.now(),
    });
    // bool pushNotification = await callOnFcmApiSendPushNotifications(token);
  });

  return;
}

Future<void> userProfileSetup(UserDetails userDetails, String userId) async {
  CollectionReference profileReference =
      FirebaseFirestore.instance.collection('Profile');
  // FirebaseAuth auth = FirebaseAuth.instance;
  // String uid = auth.currentUser.uid.toString();
  FirebaseMessaging.instance.getToken().then((token) async {
    profileReference.doc(userId).update({
      'matricule': userDetails.matricule,
      'nom': userDetails.nom,
      'tel': userDetails.tel_domicile,
      'email': userDetails.email,
      'priseDeService': userDetails.prise_service,
      'fonction': userDetails.fonction,
      'userId': userId,
      'token': token
    });
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    sharedPreferences.setString('matricule', userDetails.matricule);
    sharedPreferences.setString('nom', userDetails.nom);
    sharedPreferences.setString('tel', userDetails.tel_domicile);
    sharedPreferences.setString('email', userDetails.email);
    sharedPreferences.setString('priseDeService', userDetails.prise_service);
    sharedPreferences.setString('fonction', userDetails.fonction);
    // bool pushNotification = await callOnFcmApiSendPushNotifications(token);
    // FirebaseFirestore.instance.collection("Retreate").doc('$userId').set({
    //   'step': 0,
    // });
  });

  return;
}

void firebaseCloudMessaging_Listeners() {
  FirebaseMessaging().getToken().then((token) {
    print("token of the device is : $token");
  });
}

Future<UserDetails> getUserInfo() async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();

  Map<String, dynamic> userMap;
  final UserDetails userStr = json.decode(prefs.getString('userdata'));
  return userStr;
  // if (userStr != null) {
  //   userMap = jsonDecode(userStr) as Map<String, dynamic>;
  // }
  //
  // if (userMap != null) {
  //   final UserDetails user = UserDetails.fromJson(userMap);
  //   print(user);
  //   return user;
  // }
  // return null;
}

Future<void> saveUserInfo(dynamic json) async {
  final UserDetails user = UserDetails.fromJson(json);

  final SharedPreferences prefs = await SharedPreferences.getInstance();
  // bool result = await prefs.setString('userdata', jsonEncode(user));
  prefs.setInt('id', json['id']);
  prefs.setString('ID_inscription', json['ID_inscription']);
  prefs.setString('matricule', json['matricule']);
  prefs.setString('nom', json['nom']);
  prefs.setString('email', json['email']);
  prefs.setString('cellulaire', json['cellulaire']);
  prefs.setString('date_1ere_ps', json['date_1ere_ps']);
  prefs.setString('lib_sce', json['lib_sce']);
  bool result = await prefs.setString('userdata', user.toString());
  // print(result);
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
    String userToken, String description, String screen) async {
  final postUrl = 'https://fcm.googleapis.com/fcm/send';
  final data = {
    "registration_ids": userToken,
    "collapse_key": "type_a",
    "screen": "$screen",
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

Widget statusCode(int status, String acteDemande) {
  String tempResult = "";
  switch (status) {
    case 0:
      tempResult = "Votre demande est en cours de validation";
      // tempResult = "${listSteps[0]}";
      return Card(
        child: ListTile(
          leading: Icon(Icons.pending_actions_rounded),
          title: Text('Acte: $acteDemande'),
          subtitle: Text(
            'Progression: $tempResult \n ',
          ),
        ),
      );
      break;
    case 1:
      tempResult = "Votre demande est validée et est cours de traitement";
      // tempResult = "${listSteps[1]}";
      return Card(
        child: ListTile(
          leading: Icon(Icons.autorenew),
          title: Text('Acte: $acteDemande'),
          subtitle: Text(
            'Progression: $tempResult',
          ),
        ),
      );
      break;
    case 2:
      // tempResult = "Votre demande est disponible et peut etre retiré";
      // tempResult = "${listSteps[2]}";
      tempResult = "Votre demande est validée et est cours de traitement";

      return Card(
        child: ListTile(
          leading: Icon(
            Icons.autorenew_sharp,
            color: Colors.green,
          ),
          title: Text('Acte: $acteDemande'),
          subtitle: Text(
            'Progression: $tempResult',
          ),
        ),
      );
      break;
    case 20:
      // tempResult = "Votre demande a ete retire";
      // tempResult = "${listSteps[3]}";
      tempResult = "Votre demande a été retiré, avec succès";

      return Card(
        child: ListTile(
          leading: Icon(
            Icons.done_all,
            color: Colors.green,
          ),
          title: Text('Acte: $acteDemande'),
          subtitle: Text(
            'Progression: $tempResult',
          ),
        ),
      );
      break;

    case 404:
      tempResult = "Votre demande a rencontré une erreur";
      return Card(
        child: ListTile(
          leading: Icon(
            Icons.dangerous,
            color: Colors.red,
          ),
          title: Text('Acte: $acteDemande'),
          subtitle: Text(
            'Progression: $tempResult',
          ),
        ),
      );
      break;

    default:
      tempResult = "Votre demande est validée et est cours de traitement";

      return Card(
        child: ListTile(
          leading: Icon(
            Icons.autorenew_sharp,
            color: Colors.green,
          ),
          title: Text('Acte : $acteDemande'),
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

createNewDemandeActe(List<String> arguments) async {
  UserDetails userdata = await getUserInfo();
  print(userdata);
  var url =
      'http://192.168.1.6:8000/demandeActe/${arguments[0]}/${arguments[1]}/${arguments[2]}';

  // Await the http get response, then decode the json-formatted response.
  var response = await http.get(url);
  if (response.statusCode == 200) {
    var jsonResponse = convert.jsonDecode(response.body);
    // var itemCount = jsonResponse['totalItems'];
    Map userMap = jsonDecode(response.body);
    print('reponse:body = ${response.body}');
    saveUserInfo(jsonResponse);
    return true;
  } else {
    print('Request failed with status: ${response.statusCode}.');
    return false;
  }
}

getLoginAgentFirebaseWay(
    {var userId, String email, BuildContext context}) async {
  try {
    await FirebaseMessaging.instance.getToken().then((token) async {
      // await actDemande.update({"deviceId": token});
      // print('the token of device: $token');
      // print('the currentUserId of device: ${userCredential.user.uid}');
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

      DocumentSnapshot document = await FirebaseFirestore.instance
          .collection('Profile')
          .doc(userId.toString())
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
    return true;
  } on FirebaseAuthException catch (e) {
    if (e.code == 'user-not-found') {
      print('No user found for that email.');
      errorDialog(
          context, "Votre email ne correspond a aucun compte de nos membres");
      return false;
    } else if (e.code == 'wrong-password') {
      print('Wrong password provided for that user.');
      errorDialog(context, "Mot de passe erroné");
      return false;
    }
  }
}

MaterialColor colorForRetreateList(String value) {
  // for(var i = 0 ; i < value; i ++){
  //   return Icon(Icons.check_box);
  // }
  // List<MaterialColor> listColor = [
  //   Colors.grey,
  //   Colors.grey,
  //   Colors.grey,
  //   Colors.grey,
  //   Colors.grey,
  //   Colors.grey,
  //   Colors.grey,
  // ];
  print('$value');
  switch (value) {
    case '0':
      return Colors.grey;
      break;
    case '1':
      // listColor[0] = Colors.green;
      return Colors.green;
    case '404':
      // for (var i = 0; i < listColor.length; i++) {
      //   listColor[i] = Colors.red;
      // }
      return Colors.red;
      break;
  }
  return Colors.grey;
}

@override
Future<void> resetPassword(String email) async {
  FirebaseAuth auth = FirebaseAuth.instance;
  await auth.sendPasswordResetEmail(email: email);
}

Future<bool> getLoginAgent(List<String> arguments) async {
  // This example uses the Google Books API to search for books about http.
  // https://developers.google.com/books/docs/overview
  // var url = 'https://www.googleapis.com/books/v1/volumes?q={http}';
  var urlInscriptions =
      'http://192.168.1.6:8000/loginAgent/matricule=${arguments[0]}/password=${arguments[1]}';
  var url = 'http://192.168.1.6:8000/agent';
  var connectionUser = FirebaseFirestore.instance
      .collection('loginUser')
      .where('username', isEqualTo: arguments[0])
      .where('password', isEqualTo: arguments[1])
      .snapshots();
  if (connectionUser != null) {
    return true;
  }
  // Await the http get response, then decode the json-formatted response.
  var firstResponse = await http.get(urlInscriptions);
  if (firstResponse.statusCode == 200) {
    print(firstResponse.body);
    var jsonInscriptions = convert.jsonDecode(firstResponse.body);
    if (jsonInscriptions['id'] != false) {
      var response = await http.get(url);
      if (response.statusCode == 200) {
        var jsonResponse = convert.jsonDecode(response.body);
        // var itemCount = jsonResponse['totalItems'];
        Map userMap = jsonDecode(response.body);
        var userdata = UserDetails.fromJson(userMap);
        await saveUserInfo(jsonResponse);
        // print('in net/Firebase/getLoginAgent: $userdata');
        return true;
      } else {
        print('Request failed with status: ${response.statusCode}.');
        return false;
      }
    } else {
      return false;
    }
    return false;
  }
}

getActeCode(String acteName) {
  int value;
  List<ActeModel> listModels = Constants.listsActes;
  listModels.forEach((element) {
    if (element.acteName.trim().compareTo(acteName.trim()) == 0) {
      final int data = element.acteMotif;
      value = data;
    }
  });
  return value;
}

getStatutsCode(var value) {
  int data;
  if (value.runtimeType == int) {
    data = value;
  } else if (value.runtimeType == String) {
    List<String> listValue = value.toString().trim().split(',');
    data = int.parse(listValue[0]);
  }
  return data;
}
