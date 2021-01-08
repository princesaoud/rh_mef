import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:commons/commons.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:rh_mef/constantes.dart';
import 'package:rh_mef/main.dart';
import 'package:rh_mef/models/mDemandeActe.dart';
import 'package:rh_mef/net/firebase.dart';
import 'package:rh_mef/selectFileSystem.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// This is the main application widget.
// ignore: camel_case_types
class Demande_Actes extends StatelessWidget {
  static const String _title = 'Demande d\'acte';
  const Demande_Actes({Key key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: _title,
      home: Scaffold(
        appBar: AppBar(
          // Here we take the value from the MyHomePage object that was created by
          // the App.build method, and use it to set our appbar title.
          title: const Text("Demande d'acte"),
          centerTitle: true,
          backgroundColor: Colors.orangeAccent,
          leading: IconButton(
            onPressed: () {
              Navigator.pushReplacement(
                  context, MaterialPageRoute(builder: (context) => MyApp()));
            },
            icon: Icon(Icons.arrow_back),
          ),
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
  DateTime _dateTime;

  String _currentValueSelected = "...";
  String mDeviceToken;

  //TODO: DECLARE VARIABLE FOR FILE HANDLING SYSTEM

  Widget build(BuildContext context) {
    return Container(
        child: Column(
      children: [
        SizedBox(
          child: FlatButton(
            hoverColor: Colors.green,
            padding: EdgeInsets.symmetric(vertical: 13, horizontal: 70),
            color: Colors.lightGreen,
            onPressed: () {
              Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                      builder: (context) => NouvelleDemandeActe()));
            },
            child: Text("Faire une nouvelle demande"),
          ),
        ),
        Expanded(
          child: StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance
                .collection("ActeDemand")
                // .where("deviceId", isEqualTo: "$")
                .orderBy('updated', descending: true)
                .snapshots(),
            builder:
                (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(
                  child: CircularProgressIndicator(),
                );
              }
              if (snapshot.hasData) {
                return ListView.builder(
                    itemCount: snapshot.data.docs.length,
                    itemBuilder: (BuildContext context, int index) {
                      DocumentSnapshot documentSnapshot =
                          snapshot.data.docs[index];
                      String deviceId = documentSnapshot.data()['deviceId'];
                      if (deviceId.isNotEmpty && deviceId == mDeviceToken) {
                        // print('succces');
                        int numeroDemande =
                            documentSnapshot.data()['numeroDemande'];
                        //TODO: work on the where clause
                        return statusCode(
                            documentSnapshot.data()['statuts'], numeroDemande);
                      }
                      return Container();
                    });
              } else {
                return Container();
              }
            },
          ),
        ),
      ],
    ));
  }

  @override
  void initState() {
    super.initState();
    FirebaseMessaging().getToken().then((value) {
      mDeviceToken = value;
      print(mDeviceToken);
    });
    Firebase.initializeApp().whenComplete(() {
      print("completed");
      setState(() {});
    });
    myControllerSearch.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    myControllerSearch.removeListener(_onSearchChanged);
    myControllerSearch.dispose();
    super.dispose();
  }

  Future<void> _showDropList(List<String> list, int type) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Dropdown'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                DropdownButton(
                  items: list.map((String value) {
                    return DropdownMenuItem<String>(
                      onTap: () {
                        _currentValueSelected = value;
                        if (type == 1) {
                          setState(() {
                            pickedEmploi = value;
                          });
                        } else if (type == 2) {
                          setState(() {
                            pickedActes = value;
                          });
                        } else if (type == 4) {
                          setState(() {
                            pickedMotif = value;
                          });
                        }
                        print(_currentValueSelected);
                        Navigator.of(context).pop();
                      },
                      child: new Text(value),
                    );
                  }).toList(),
                  onChanged: (value) {
                    _currentValueSelected = value;
                  },
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
                datePicked = DateFormat('yyyy-MM-dd').format(_dateTime);
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void _onSearchChanged() {
    print(myControllerSearch.value.text);
  }
}

class NouvelleDemandeActe extends StatefulWidget {
  @override
  _NouvelleDemandeActeState createState() => _NouvelleDemandeActeState();
}

class _NouvelleDemandeActeState extends State<NouvelleDemandeActe> {
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
  DateTime _dateTime;

  String _currentValueSelected = "...";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: const Text("Faire une nouvelle demande d'acte"),
        centerTitle: true,
        backgroundColor: Colors.orangeAccent,
        leading: IconButton(
          onPressed: () {
            Navigator.pushReplacement(context,
                MaterialPageRoute(builder: (context) => Demande_Actes()));
          },
          icon: Icon(Icons.close),
        ),
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
            title: new TextField(
              controller: myControllerNom,
              decoration: new InputDecoration(
                hintText: "Nom et Prénoms",
              ),
            ),
          ),
          new ListTile(
            leading: const Icon(Icons.phone),
            title: new TextField(
              controller: myControllerTel,
              decoration: new InputDecoration(
                hintText: "Telephone",
              ),
            ),
          ),
          new ListTile(
            leading: const Icon(Icons.email),
            title: new TextField(
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
              _showDropList(Constants.list_emplois, 1);
            },
            leading: const Icon(Icons.person_outline_sharp),
            title: new Text(pickedEmploi),
          ),
          new ListTile(
            onTap: () {
              _showDropList(Constants.list_actes, 2);
            },
            leading: const Icon(Icons.person),
            title: Text(pickedActes),
          ),
          new ListTile(
              onTap: () async {
                SharedPreferences prefs = await SharedPreferences.getInstance();
                prefs.setString(
                    Constants.prefs_imageName, DateTime.now().toString());
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => SelectFileSys()),
                );
              },
              leading: const Icon(Icons.photo_camera_outlined),
              title: Text(pickedPiecesJointe)),
          ListTile(
              onTap: () {
                _showDropList(Constants.list_motifs, 4);
              },
              leading: Icon(Icons.message_rounded),
              title: Text(pickedMotif)),
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
                String piece = prefs.getString("imageUrl");
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
                    0);
                demandeActeSetup(_demandeacte);
                print('demande d\'acte envoye');
                String description =
                    "Une nouvelle demande d'acte est en attente de validation";
                String userToken = FirebaseFirestore.instance
                    .collection('adminKey')
                    .doc('key')
                    .toString();
                callOnFcmApiSendPushNotifications(userToken, description);
                Navigator.pushReplacement(
                    context, MaterialPageRoute(builder: (context) => MyApp()));
                // print(_demandeacte.toString());
              },
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _showDropList(List<String> list, int type) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Dropdown'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                DropdownButton(
                  items: list.map((String value) {
                    return DropdownMenuItem<String>(
                      onTap: () {
                        _currentValueSelected = value;
                        if (type == 1) {
                          setState(() {
                            pickedEmploi = value;
                          });
                        } else if (type == 2) {
                          setState(() {
                            pickedActes = value;
                          });
                        } else if (type == 4) {
                          setState(() {
                            pickedMotif = value;
                          });
                        }
                        print(_currentValueSelected);
                        Navigator.of(context).pop();
                      },
                      child: new Text(value),
                    );
                  }).toList(),
                  onChanged: (value) {
                    _currentValueSelected = value;
                  },
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
                datePicked = DateFormat('yyyy-MM-dd').format(_dateTime);
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
