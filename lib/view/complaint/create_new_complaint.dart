import 'package:commons/commons.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:rh_mef/app_theme.dart';
import 'package:rh_mef/net/firebase.dart';

import '../../main.dart';

enum NatureTemoignage { plainte, reclamation, suggestion, preoccupation }

class CreateAnewComplaint extends StatefulWidget {
  @override
  _CreateAnewComplaintState createState() => _CreateAnewComplaintState();
}

class _CreateAnewComplaintState extends State<CreateAnewComplaint> {
  NatureTemoignage _character = NatureTemoignage.plainte;
  final myControllerDesignation = TextEditingController();
  final myControllerNumber = TextEditingController();
  final myControllerEmail = TextEditingController();
  final myControllerObservation = TextEditingController();
  FirebaseAuth auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: const Text(
          "Faire une temoignage",
          style: TextStyle(color: AppTheme.nearlyBlack),
        ),
        centerTitle: true,
        backgroundColor: AppTheme.nearlyWhite,
        actions: [
          IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: Icon(
              Icons.close,
              color: AppTheme.grey,
            ),
          ),
        ],
      ),
      body: ListView(
        children: <Widget>[
          const Divider(
            height: 1.0,
          ),
          ListTile(
            onTap: () {
              setState(() {
                _character = NatureTemoignage.plainte;
              });
            },
            title: const Text('Plaintes'),
            leading: Radio(
              value: NatureTemoignage.plainte,
              groupValue: _character,
              onChanged: (NatureTemoignage value) {
                setState(() {
                  _character = value;
                });
              },
            ),
          ),
          ListTile(
            onTap: () {
              setState(() {
                _character = NatureTemoignage.reclamation;
              });
            },
            title: const Text('Réclamations'),
            leading: Radio(
              value: NatureTemoignage.reclamation,
              groupValue: _character,
              onChanged: (NatureTemoignage value) {
                setState(() {
                  _character = value;
                });
              },
            ),
          ),
          ListTile(
            onTap: () {
              setState(() {
                _character = NatureTemoignage.suggestion;
              });
            },
            title: const Text('Suggestions'),
            leading: Radio(
              value: NatureTemoignage.suggestion,
              groupValue: _character,
              onChanged: (NatureTemoignage value) {
                setState(() {
                  _character = value;
                });
              },
            ),
          ),
          ListTile(
            onTap: () {
              setState(() {
                _character = NatureTemoignage.preoccupation;
              });
            },
            title: const Text('Préoccupations'),
            leading: Radio(
              value: NatureTemoignage.preoccupation,
              groupValue: _character,
              onChanged: (NatureTemoignage value) {
                setState(() {
                  _character = value;
                });
              },
            ),
          ),
          new ListTile(
            leading: const Icon(Icons.location_pin),
            title: new TextField(
              controller: myControllerDesignation,
              decoration: new InputDecoration(
                hintText: "Ville",
              ),
            ),
          ),
          const Divider(
            height: 2.0,
          ),
          ListTile(
            title: TextFormField(
              controller: myControllerObservation,
              maxLines: 3,
              minLines: 2,
              textInputAction: TextInputAction.done,
              decoration: InputDecoration(labelText: 'Observation'),
            ),
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
                String designation = myControllerDesignation.text.isNotEmpty
                    ? myControllerDesignation.text
                    : 'N/A';
                String number = myControllerNumber.text.isNotEmpty
                    ? myControllerNumber.text
                    : 'N/A';
                String email = myControllerEmail.text.isNotEmpty
                    ? myControllerEmail.text
                    : 'N/A';
                String complaintType = _character
                    .toString()
                    .substring(_character.toString().indexOf('.') + 1);
                String observation = myControllerObservation.text;
                if (observation.isEmpty) {
                  print('Observation need to be fill');
                  warningDialog(
                      context, "Attention veuillez écrire votre observation");
                } else {
                  await complaintSetup(
                          observation: observation,
                          complaintType: complaintType,
                          userId: auth.currentUser.uid)
                      .then((value) {
                    successDialog(
                        context, "Votre demande a été envoyé avec succes");
                    myControllerDesignation.text = "";
                    myControllerNumber.text = "";
                    myControllerEmail.text = "";
                    myControllerObservation.text = "";
                    _character = NatureTemoignage.plainte;
                  });
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => LoginContent()),
                  );
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
