import 'dart:async';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:commons/commons.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:image_picker/image_picker.dart';
import 'package:rh_mef/constantes.dart';
import 'package:rh_mef/custom_drawer/drawer_user_controller.dart';
import 'package:rh_mef/custom_drawer/home_drawer.dart';
import 'package:rh_mef/main.dart';
import 'package:rh_mef/models/ActeModel.dart';
import 'package:rh_mef/models/mDemandeActe.dart';
import 'package:rh_mef/models/stepsActe.dart';
import 'package:rh_mef/net/firebase.dart';
import 'package:rh_mef/view/authservice/agent/agentlogin.dart';
import 'package:rh_mef/view/authservice/profiledetails.dart';
import 'package:rh_mef/view/complaint/complaint.dart';
import 'package:rh_mef/view/retraite/retraiteProcedure.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../app_theme.dart';
import 'statutsDeliveryDemande.dart';

/// This is the main application widget.

class DemandeActes extends StatefulWidget {
  @override
  _DemandeActesState createState() => _DemandeActesState();
}

class _DemandeActesState extends State<DemandeActes> {
  Widget screenView;
  DrawerIndex drawerIndex;
  final FirebaseAuth auth = FirebaseAuth.instance;

  @override
  void initState() {
    drawerIndex = DrawerIndex.Demande;
    screenView = DemandeActesContent();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        top: false,
        bottom: false,
        child: Scaffold(
          backgroundColor: AppTheme.nearlyWhite,
          body: DrawerUserController(
            screenIndex: drawerIndex,
            drawerWidth: MediaQuery.of(context).size.width * 0.75,
            onDrawerCall: (DrawerIndex drawerIndexdata) {
              changeIndex(drawerIndexdata);
              // callback from drawer for replace screen as user need with passing DrawerIndex(Enum index)
            },
            screenView: screenView,
            //we replace screen view as we need on navigate starting screens like MyHomePage, HelpScreen, FeedbackScreen, etc...
          ),
        ),
      ),
    );
  }

  void changeIndex(DrawerIndex drawerIndexdata) {
    if (drawerIndex != drawerIndexdata) {
      drawerIndex = drawerIndexdata;
      if (drawerIndex == DrawerIndex.Acceuil) {
        setState(() {
          screenView = AgentLoginContent();
        });
      } else if (drawerIndex == DrawerIndex.Retraite) {
        setState(() {
          screenView = RetraiteProccedure();
        });
      } else if (drawerIndex == DrawerIndex.Demande) {
        setState(() {
          screenView = DemandeActesContent();
        });
      } else if (drawerIndex == DrawerIndex.Temoigngage) {
        setState(() {
          screenView = ComplaintContent();
        });
      } else if (drawerIndex == DrawerIndex.Profile) {
        setState(() {
          screenView = ProfileDetails();
        });
      } else {
        //do in your way......
      }
    }
  }
}

// ignore: camel_case_types
class DemandeActesContent extends StatelessWidget {
  static const String _title = 'Demande d\'acte';
  const DemandeActesContent({Key key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: _title,
      home: Scaffold(
        appBar: AppBar(
          // Here we take the value from the MyHomePage object that was created by
          // the App.build method, and use it to set our appbar title.
          title: const Text(
            "Demande d'acte",
            style: TextStyle(color: Colors.black),
          ),
          centerTitle: true,
          backgroundColor: AppTheme.nearlyWhite,
          // leading: IconButton(
          //   onPressed: () {
          //     // Navigator.pushReplacement(
          //     //     context, MaterialPageRoute(builder: (context) => MyApp()));
          //     Navigator.pop(context);
          //   },
          //   icon: Icon(Icons.arrow_back),
          // ),
        ),
        body: Center(
          child: MyStatefulWidget(),
        ),
      ),
    );
  }
}

/// This is the stateful widget that the main application instantiates.
class MyStatefulWidget extends StatefulWidget {
  MyStatefulWidget({Key key}) : super(key: key);

  @override
  _MyStatefulWidgetState createState() => _MyStatefulWidgetState();
}

/// This is the private State class that goes with MyStatefulWidget.
class _MyStatefulWidgetState extends State<MyStatefulWidget> {
  final myControllerMatricule = TextEditingController();
  final myControllerNom = TextEditingController();
  final myControllerTel = TextEditingController();
  final myControllerEmail = TextEditingController();
  final myControllerSearch = TextEditingController();
  String datePicked = "Click pour date de prise de service (MEF)";
  String pickedEmploi = "Click Pour choisir votre emploi";
  String pickedActes = "Click pour Choisir votre actes";
  String pickedPiecesJointe = "Ajouter une piece jointes";
  String pickedMotif = "Click Pour ajouter une motif";

  String mDeviceToken;
  String matricule;
  FirebaseAuth auth = FirebaseAuth.instance;
  List<ActeModel> listActes = Constants.listsActes;

  //TODO: DECLARE VARIABLE FOR FILE HANDLING SYSTEM

  Future<String> getMatricule() async {
    String getValue = "";
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    getValue = sharedPreferences.getString("matricule");
    // print('getValue = $getValue');
    return getValue;
  }

  Widget build(BuildContext context) {
    //Call value of matricule
    // getMatricule();
    return Container(
        child: Column(
      children: [
        Expanded(
          child: FutureBuilder(
            future: getMatricule(),
            builder: (BuildContext context,
                AsyncSnapshot<String> snapshotMatricule) {
              // print('matricule est: ${snapshotMatricule.data}');
              // print('userId est: ${auth.currentUser.uid}');
              return StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection("ActeDemand")
                    .where("userId", isEqualTo: "${auth.currentUser.uid}")
                    .orderBy('created')
                    .snapshots(),
                builder: (BuildContext context,
                    AsyncSnapshot<QuerySnapshot> snapshot) {
                  //listsSteps variable contains le steps of statutsCode and timeline details
                  if (snapshot.connectionState == ConnectionState.waiting ||
                      snapshot == null) {
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                  if (snapshot.hasData) {
                    print(
                        'the current user on this mobile: ${auth.currentUser.uid}');
                    return ListView.builder(
                        itemCount: snapshot.data.docs.length,
                        itemBuilder: (BuildContext context, int index) {
                          int numeroDemande =
                              snapshot.data.docs[index].data()['acteDemande'];
                          // print(snapshot.data.docs[index].data()['natureActe']);
                          String demandeName =
                              snapshot.data.docs[index].data()['natureActe'];
                          //TODO: work on the where clause
                          print('$numeroDemande');
                          print('$demandeName');
                          return TextButton(
                            onPressed: () async {
                              SharedPreferences sharedprefs =
                                  await SharedPreferences.getInstance();
                              sharedprefs.setInt(
                                  'numeroDemande',
                                  snapshot.data.docs[index]
                                      .data()['acteDemande']);

                              List<ListSteps> listforSteps = [];
                              List<ListSteps> listforStepsError = [];
                              listActes.forEach((element) {
                                // print("listActes forEach: ${element.acteName}");
                                print('demandeName: $demandeName');
                                //
                                // if (demandeName.trim().compareTo(
                                //         "${element.acteName}".trim()) ==
                                //     0) {
                                //   print("Bool said yes");
                                // } else {
                                //   print(
                                //       "Bool said no $demandeName is diff to ${element.acteName}");
                                // }
                                if (demandeName.trim().toLowerCase().compareTo(
                                        "${element.acteName.toLowerCase()}"
                                            .trim()
                                            .toLowerCase()) ==
                                    0) {
                                  // print("acteName: ${element.acteName}");
                                  listforSteps = element.steps;
                                  listforStepsError = element.stepsError;
                                  print(
                                      'demandeActe: ${listforSteps.toString()}');
                                }
                              });
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => StatutsDemande(
                                    listSteps: listforSteps,
                                    listStepsError: listforStepsError,
                                    numeroActe: numeroDemande,
                                  ),
                                ),
                              );
                            },
                            child: statusCode(
                                getStatutsCode(snapshot.data.docs[index]
                                    .data()['statuts']),
                                snapshot.data.docs[index].data()['natureActe']),
                          );
                          // }
                          return Container();
                        });
                  } else {
                    return Container();
                  }
                },
              );
            },
          ),
        ),
        Row(
          children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(40.0),
                child: SizedBox(
                  child: FlatButton(
                    hoverColor: Colors.green,
                    // padding: EdgeInsets.symmetric(vertical: 13, horizontal: 70),
                    color: Colors.lightGreen,
                    onPressed: () async {
                      print('button clicked');
                      SharedPreferences prefs =
                          await SharedPreferences.getInstance();
                      List<String> values = [
                        '${prefs.getInt('id')}',
                        '${prefs.getString('matricule')}',
                        '${prefs.getString('nom')}',
                        '${prefs.getString('tel')}',
                        '${prefs.getString('email')}',
                        '${prefs.getString('priseDeService')}',
                        '${prefs.getString('fonction')}',
                      ];
                      if (values[0] == null ||
                          values[0] == 'null' ||
                          values == null)
                        await FirebaseFirestore.instance
                            .collection('Profile')
                            .doc(auth.currentUser.uid)
                            .get()
                            .then((value) {
                          values.clear();
                          values = [
                            value.data()['id'],
                            value.data()['matricule'],
                            value.data()['nom'],
                            value.data()['tel'],
                            value.data()['email'],
                            value.data()['priseDeService'],
                            value.data()['fonction'],
                          ];
                        });
                      else {
                        warningDialog(context,
                            "Veuillez remplir votre profile avant de faire une demande");
                      }
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  NouvelleDemandeActe(values: values)));
                    },
                    child: Text(
                      "Faire une nouvelle demande",
                      textAlign: TextAlign.center,
                      softWrap: false,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    ));
  }

  @override
  void initState() {
    super.initState();
    FirebaseMessaging.instance.getToken().then((value) {
      mDeviceToken = value;
      print(mDeviceToken);
    });
    // Firebase.initializeApp().whenComplete(() {
    //   print("completed");
    //   setState(() {});
    // });
    myControllerSearch.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    myControllerSearch.removeListener(_onSearchChanged);
    myControllerSearch.dispose();
    super.dispose();
  }

  void _onSearchChanged() {
    print(myControllerSearch.value.text);
  }
}

class NouvelleDemandeActe extends StatefulWidget {
  final List<String> values;
  NouvelleDemandeActe({Key key, this.values}) : super(key: key);

  @override
  _NouvelleDemandeActeState createState() => _NouvelleDemandeActeState();
}

class _NouvelleDemandeActeState extends State<NouvelleDemandeActe> {
  final myControllerMatricule = TextEditingController();
  final myControllerNom = TextEditingController();
  final myControllerTel = TextEditingController();
  final myControllerEmail = TextEditingController();
  final myControllerSearch = TextEditingController();
  File _image;
  // File _image;
  String datePicked = "Click pour date de prise de service (MEF)";
  String pickedEmploi = "Click Pour choisir votre emploi";
  String pickedActes = "";
  String pickedPiecesJointe = "";
  String pickedMotif = "";
  DateTime _dateTime;
  int codeMotif = 1;

  String _currentValueSelected = "Cliquez ici pour faire un choix";
  Widget build(BuildContext context) {
    myControllerMatricule.text = '${widget.values[1]}';
    myControllerNom.text = widget.values[2];
    myControllerTel.text = widget.values[3];
    myControllerEmail.text = widget.values[4];
    datePicked = widget.values[5];
    pickedEmploi = widget.values[6];
    return Scaffold(
      backgroundColor: AppTheme.notWhite.withOpacity(0.5),
      appBar: AppBar(
        leading: Text(""),
        title: Text(
          "Créer nouvelle démande ",
          style: TextStyle(color: AppTheme.grey),
        ),
        backgroundColor: AppTheme.nearlyWhite,
        actions: [
          IconButton(
            icon: Icon(
              Icons.close,
              color: AppTheme.grey,
            ),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ],
      ),
      body: ListView(
        children: <Widget>[
          new ListTile(
            leading: const Icon(Icons.person),
            title: new TextField(
              controller: myControllerMatricule,
              decoration: new InputDecoration(
                hintText: "Entrer le matricule",
              ),
            ),
          ),
          new ListTile(
            leading: const Icon(Icons.person),
            title: new TextFormField(
              readOnly: true,
              controller: myControllerNom,
              decoration: new InputDecoration(
                hintText: "Nom et Prénoms",
              ),
            ),
          ),
          new ListTile(
            leading: const Icon(Icons.phone),
            title: new TextField(
              readOnly: true,
              controller: myControllerTel,
              decoration: new InputDecoration(
                hintText: "Telephone",
              ),
            ),
          ),
          new ListTile(
            leading: const Icon(Icons.email),
            title: new TextField(
              readOnly: true,
              controller: myControllerEmail,
              decoration: new InputDecoration(
                hintText: "Email",
              ),
            ),
          ),
          new ListTile(
            onTap: () {
              _showDatePicker();
            },
            leading: const Icon(Icons.date_range),
            title: Text(datePicked),
          ),
          new ListTile(
            onTap: () {
              _showDropList(1);
            },
            leading: const Icon(Icons.format_align_justify_outlined),
            title: new Text(pickedEmploi),
          ),
          new ListTile(
            onTap: () {
              pickedMotif = "";
              _showDropList(2);
            },
            leading: const Icon(Icons.file_copy),
            title: new Text(pickedActes != ""
                ? pickedActes
                : "Cliquez ici pour choisir votre démande d'acte"),
          ),
          // _showDropList(Constants.list_actes, 2);
          TextButton(
            onPressed: () async {
              // SharedPreferences prefs = await SharedPreferences.getInstance();
              // prefs.setString(
              //     Constants.prefs_imageName, DateTime.now().toString());
              // Navigator.push(
              //   context,
              //   MaterialPageRoute(builder: (context) => SelectFileSys()),
              // );
              _showPicker(context);
            },
            child: Column(
              children: [
                Row(
                  children: [
                    Container(
                      child: Icon(
                        Icons.photo_camera_outlined,
                        color: Colors.grey,
                      ),
                      padding: EdgeInsets.only(left: 10),
                    ),
                    Expanded(
                      child: Container(
                        child: Text(
                          pickedPiecesJointe == ""
                              ? "Choisir votre piece jointe"
                              : pickedPiecesJointe,
                          style: TextStyle(color: Colors.black),
                        ),
                        padding: EdgeInsets.only(left: 30),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          ListTile(
            onTap: () {
              _showDropList(4);
            },
            leading: Icon(Icons.file_copy_rounded),
            title: Text(pickedMotif != ""
                ? pickedMotif
                : 'Spécifier la motif de votre démande'),
            // subtitle: Text(pickedMotif),
          ),
          const Divider(
            height: 2.0,
          ),
          ListTile(
            title: FlatButton(
              color: Colors.orange,
              padding: EdgeInsets.all(10.0),
              child: Text(
                "Valider",
                style: TextStyle(fontSize: 20.0),
              ),
              onPressed: () async {
                SharedPreferences prefs = await SharedPreferences.getInstance();
                String matricule = myControllerMatricule.value.text.isNotEmpty
                    ? myControllerMatricule.value.text
                    : "N/A";
                String nom = myControllerNom.value.text.isNotEmpty
                    ? myControllerNom.value.text
                    : "N/A";
                String tel = myControllerTel.value.text.isNotEmpty
                    ? myControllerTel.value.text
                    : "N/A";
                String email = myControllerEmail.value.text.isNotEmpty
                    ? myControllerEmail.value.text
                    : "N/A";
                String emploi = pickedEmploi;
                String acte = pickedActes;
                // String piece = prefs.getString("imageUrl");
                String piece = pickedPiecesJointe;
                String motif = pickedMotif;
                String dated = datePicked;
                String numeroDemande = DateTime.now().toString();
                DemandeActe _demandeacte = DemandeActe(
                    "",
                    "",
                    matricule,
                    nom,
                    tel,
                    email,
                    dated,
                    emploi,
                    acte,
                    piece,
                    motif,
                    numeroDemande,
                    1,
                    true);

                if (acte == null || acte == "") {
                  warningDialog(
                      context, "Veuillez spécifier votre démande d'acte");
                } else if (motif == null || motif == "") {
                  warningDialog(context,
                      "Veuillez spécifier le motif de votre démande d'acte");
                } else {
                  // demandeActeSetup(_demandeacte);
                  uploadImageToFirebase(context, _image, _demandeacte);
                  print('demande d\'acte envoye');
                  String description =
                      "Une nouvelle demande d'acte est en attente de validation";
                  // String userToken = FirebaseFirestore.instance
                  //     .collection('adminKey')
                  //     .doc('key')
                  //     .toString();
                  successDialog(
                      context, 'Votre demande est envoyé avec succès');
                  // callOnFcmApiSendPushNotifications(userToken, description);
                  Navigator.pushReplacement(context,
                      MaterialPageRoute(builder: (context) => LoginContent()));
                  // print(_demandeacte.toString());
                }
              },
            ),
          ),
        ],
      ),
    );
  }

  // Widget build(BuildContext context) {
  //   myControllerMatricule.text = '${widget.values[1]}';
  //   myControllerNom.text = widget.values[2];
  //   myControllerTel.text = widget.values[3];
  //   myControllerEmail.text = widget.values[4];
  //   datePicked = widget.values[5];
  //   pickedEmploi = widget.values[6];
  //   return Scaffold(
  //     appBar: AppBar(
  //       // Here we take the value from the MyHomePage object that was created by
  //       // the App.build method, and use it to set our appbar title.
  //       title: const Text("Faire une nouvelle demande d'acte"),
  //       centerTitle: true,
  //       backgroundColor: Colors.orangeAccent,
  //       leading: IconButton(
  //         onPressed: () {
  //           Navigator.pushReplacement(context,
  //               MaterialPageRoute(builder: (context) => DemandeActes()));
  //         },
  //         icon: Icon(Icons.close),
  //       ),
  //     ),
  //     body: ListView(
  //       children: <Widget>[
  //         new ListTile(
  //           leading: const Icon(Icons.person),
  //           title: new TextField(
  //             controller: myControllerMatricule,
  //             decoration: new InputDecoration(
  //               hintText: "Entrer le matricule",
  //             ),
  //           ),
  //         ),
  //         new ListTile(
  //           leading: const Icon(Icons.person),
  //           title: new TextFormField(
  //             readOnly: true,
  //             controller: myControllerNom,
  //             decoration: new InputDecoration(
  //               hintText: "Nom et Prénoms",
  //             ),
  //           ),
  //         ),
  //         new ListTile(
  //           leading: const Icon(Icons.phone),
  //           title: new TextField(
  //             readOnly: true,
  //             controller: myControllerTel,
  //             decoration: new InputDecoration(
  //               hintText: "Telephone",
  //             ),
  //           ),
  //         ),
  //         new ListTile(
  //           leading: const Icon(Icons.email),
  //           title: new TextField(
  //             readOnly: true,
  //             controller: myControllerEmail,
  //             decoration: new InputDecoration(
  //               hintText: "Email",
  //             ),
  //           ),
  //         ),
  //         new ListTile(
  //           onTap: () {
  //             _showDatePicker();
  //           },
  //           leading: const Icon(Icons.date_range),
  //           title: Text(datePicked),
  //         ),
  //         new ListTile(
  //           onTap: () {
  //             _showDropList(1);
  //           },
  //           leading: const Icon(Icons.format_align_justify_outlined),
  //           title: new Text(pickedEmploi),
  //         ),
  //         new ListTile(
  //           onTap: () {
  //             pickedMotif = "";
  //             _showDropList(2);
  //           },
  //           leading: const Icon(Icons.file_copy),
  //           title: new Text(pickedActes != ""
  //               ? pickedActes
  //               : "Cliquez ici pour choisir votre démande d'acte"),
  //         ),
  //         // _showDropList(Constants.list_actes, 2);
  //         TextButton(
  //           onPressed: () async {
  //             // SharedPreferences prefs = await SharedPreferences.getInstance();
  //             // prefs.setString(
  //             //     Constants.prefs_imageName, DateTime.now().toString());
  //             // Navigator.push(
  //             //   context,
  //             //   MaterialPageRoute(builder: (context) => SelectFileSys()),
  //             // );
  //             _showPicker(context);
  //           },
  //           child: Column(
  //             children: [
  //               Row(
  //                 children: [
  //                   Container(
  //                     child: Icon(
  //                       Icons.photo_camera_outlined,
  //                       color: Colors.grey,
  //                     ),
  //                     padding: EdgeInsets.only(left: 10),
  //                   ),
  //                   Expanded(
  //                     child: Container(
  //                       child: Text(
  //                         pickedPiecesJointe == ""
  //                             ? "Choisir votre piece jointe"
  //                             : pickedPiecesJointe,
  //                         style: TextStyle(color: Colors.black),
  //                       ),
  //                       padding: EdgeInsets.only(left: 30),
  //                     ),
  //                   ),
  //                 ],
  //               ),
  //             ],
  //           ),
  //         ),
  //         ListTile(
  //           onTap: () {
  //             _showDropList(4);
  //           },
  //           leading: Icon(Icons.file_copy_rounded),
  //           title: Text(pickedMotif != ""
  //               ? pickedMotif
  //               : 'Spécifier la motif de votre démande'),
  //           // subtitle: Text(pickedMotif),
  //         ),
  //         const Divider(
  //           height: 2.0,
  //         ),
  //         ListTile(
  //           title: FlatButton(
  //             color: Colors.orange,
  //             padding: EdgeInsets.all(10.0),
  //             child: Text(
  //               "Valider",
  //               style: TextStyle(fontSize: 20.0),
  //             ),
  //             onPressed: () async {
  //               SharedPreferences prefs = await SharedPreferences.getInstance();
  //               String matricule = myControllerMatricule.value.text.isNotEmpty
  //                   ? myControllerMatricule.value.text
  //                   : "N/A";
  //               String nom = myControllerNom.value.text.isNotEmpty
  //                   ? myControllerNom.value.text
  //                   : "N/A";
  //               String tel = myControllerTel.value.text.isNotEmpty
  //                   ? myControllerTel.value.text
  //                   : "N/A";
  //               String email = myControllerEmail.value.text.isNotEmpty
  //                   ? myControllerEmail.value.text
  //                   : "N/A";
  //               String emploi = pickedEmploi;
  //               String acte = pickedActes;
  //               // String piece = prefs.getString("imageUrl");
  //               String piece = pickedPiecesJointe;
  //               String motif = pickedMotif;
  //               String dated = datePicked;
  //               String numeroDemande = DateTime.now().toString();
  //               DemandeActe _demandeacte = DemandeActe(
  //                   "",
  //                   "",
  //                   matricule,
  //                   nom,
  //                   tel,
  //                   email,
  //                   dated,
  //                   emploi,
  //                   acte,
  //                   piece,
  //                   motif,
  //                   numeroDemande,
  //                   1,
  //                   true);
  //
  //               if (acte == null || acte == "") {
  //                 warningDialog(
  //                     context, "Veuillez spécifier votre démande d'acte");
  //               } else if (motif == null || motif == "") {
  //                 warningDialog(context,
  //                     "Veuillez spécifier le motif de votre démande d'acte");
  //               } else {
  //                 // demandeActeSetup(_demandeacte);
  //                 uploadImageToFirebase(context, _image, _demandeacte);
  //                 print('demande d\'acte envoye');
  //                 String description =
  //                     "Une nouvelle demande d'acte est en attente de validation";
  //                 // String userToken = FirebaseFirestore.instance
  //                 //     .collection('adminKey')
  //                 //     .doc('key')
  //                 //     .toString();
  //                 successDialog(
  //                     context, 'Votre demande est envoyé avec succès');
  //                 // callOnFcmApiSendPushNotifications(userToken, description);
  //                 Navigator.pushReplacement(context,
  //                     MaterialPageRoute(builder: (context) => LoginContent()));
  //                 // print(_demandeacte.toString());
  //               }
  //             },
  //           ),
  //         ),
  //       ],
  //     ),
  //   );
  // }

  formFillList(int type, int code) {
    switch (type) {
      case 1:
        return FirebaseFirestore.instance.collection('Emplois').get();
        break;
      case 2:
        return FirebaseFirestore.instance.collection('DemandeActe').get();
        break;
      case 3:
        // return FirebaseFirestore.instance.collection('Motifs').get();
        break;
    }
  }

  _imgFromCamera() async {
    ImagePicker imagePicker = ImagePicker();

    PickedFile image = await imagePicker.getImage(
        source: ImageSource.camera, imageQuality: 50);

    setState(() {
      print(image.toString());
      _image = File(image.path);
    });
  }

  _imgFromGallery() async {
    ImagePicker imagePicker = ImagePicker();
    PickedFile image = await imagePicker.getImage(
        source: ImageSource.gallery, imageQuality: 50);
    setState(() {
      if (image != null) _image = File(image.path);
    });
  }

  Future uploadImageToFirebase(
      BuildContext context, File _image1, DemandeActe _demandeacte) async {
    String data = "";
    FirebaseStorage storage = FirebaseStorage.instance;
    if (_image1 == null) {
      demandeActeSetup(_demandeacte);
    }
    Reference ref = storage.ref().child("upload/" + DateTime.now().toString());
    UploadTask uploadTask = ref.putFile(_image1);
    uploadTask.then((res) async {
      _demandeacte.pieceJointe = await res.ref.getDownloadURL();
      // data = await res.ref.getDownloadURL();
      demandeActeSetup(_demandeacte);
    });
    print('uploadImageToFirebase $data');
  }

  void _showPicker(context) {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext bc) {
          return SafeArea(
            child: Container(
              child: new Wrap(
                children: <Widget>[
                  new ListTile(
                      leading: new Icon(Icons.photo_library),
                      title: new Text('Phot o Library'),
                      onTap: () {
                        _imgFromGallery();
                        Navigator.of(context).pop();
                      }),
                  new ListTile(
                    leading: new Icon(Icons.photo_camera),
                    title: new Text('Camera'),
                    onTap: () {
                      _imgFromCamera();
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              ),
            ),
          );
        });
  }

  Future<void> _showDropList(int type) async {
    List<String> tempList = [];

    return showDialog<void>(
      context: context,
      barrierDismissible: true, // user must tap button!
      builder: (BuildContext context) {
        return FutureBuilder(
          future: formFillList(type, codeMotif),
          builder:
              (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: CircularProgressIndicator(),
              );
            }
            if (type == 4) {
              tempList.clear();
              switch (codeMotif) {
                case 1:
                  Constants.listMotifs[0].motifsDesc.forEach((element) {
                    print(element);
                    tempList.add(element);
                  });
                  print(tempList);
                  break;
                case 2:
                  Constants.listMotifs[1].motifsDesc.forEach((element) {
                    print(element);
                    tempList.add(element);
                  });
                  print(tempList);

                  break;
                case 3:
                  Constants.listMotifs[2].motifsDesc.forEach((element) {
                    print(element);
                    tempList.add(element);
                  });
                  print(tempList);
                  break;
              }
              print(tempList);
              print('got type 4');
            } else {
              final List<DocumentSnapshot> documents = snapshot.data.docs;
              documents.forEach((element) {
                // print(element.get('acteName'));
                String acteName = element.get('name');
                var splitName = acteName.split(',');
                // print(splitName);
                tempList.addAll(splitName);
              });
            }

            return AlertDialog(
              title: Text(
                'Choisir dans la liste ',
                textAlign: TextAlign.center,
              ),
              elevation: 2,
              content: SingleChildScrollView(
                child: Wrap(
                  alignment: WrapAlignment.end,
                  children: [
                    ListBody(
                      children: [
                        DropdownButton(
                          hint: Text("Cliquez pour faire votre choix"),
                          items: tempList.map((value) {
                            return DropdownMenuItem<String>(
                              onTap: () {
                                _currentValueSelected = "$value";
                                if (type == 1) {
                                  setState(() {
                                    pickedEmploi = "$value";
                                  });
                                } else if (type == 2) {
                                  setState(() {
                                    pickedActes = "$value";
                                    codeMotif = getActeCode(value);
                                    print(codeMotif);
                                  });
                                } else if (type == 4) {
                                  setState(() {
                                    pickedMotif = "$value";
                                  });
                                }
                                // print(_currentValueSelected);
                                Navigator.of(context).pop();
                              },
                              child: Text('${value.toString()}'),
                            );
                          }).toList(),
                          onChanged: (value) {
                            _currentValueSelected = value;
                          },
                          // value: _currentValueSelected),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              actions: <Widget>[
                TextButton(
                  child: Text(""),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ],
            );
          },
        );
      },
    );
  }

  Future<void> _showDatePicker() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(Constants.choisirDate),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Container(
                  height: 200,
                  child: CupertinoDatePicker(
                    mode: CupertinoDatePickerMode.date,
                    maximumDate: DateTime.now(),
                    initialDateTime: DateTime(2000, 1, 1),
                    onDateTimeChanged: (DateTime newDateTime) {
                      // Do something
                      // datePicked = newDateTime.toString();
                      setState(() {
                        _dateTime = newDateTime;
                      });
                      datePicked = DateFormat('dd-MM-yyyy').format(_dateTime);
                    },
                  ),
                ),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text(Constants.valider),
              onPressed: () {
                datePicked = DateFormat('dd-MM-yyyy').format(_dateTime);
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
