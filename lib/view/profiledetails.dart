import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:commons/commons.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:rh_mef/main.dart';
import 'package:rh_mef/models/userDetails.dart';
import 'package:rh_mef/net/firebase.dart';

class ProfileDetails extends StatelessWidget {
  final DocumentSnapshot values;
  ProfileDetails({Key key, this.values}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: ProfileDetailsContent(
        values: values,
      ),
    );
  }
}

class ProfileDetailsContent extends StatefulWidget {
  final DocumentSnapshot values;
  ProfileDetailsContent({Key key, this.values}) : super(key: key);

  @override
  _ProfileDetailsContentState createState() => _ProfileDetailsContentState();
}

class _ProfileDetailsContentState extends State<ProfileDetailsContent> {
  var myControllerMatricule = TextEditingController();
  var myControllerNom = TextEditingController();
  var myControllerTel = TextEditingController();
  var myControllerEmail = TextEditingController();
  var myControllerCalendar = TextEditingController();
  var myControllerWork = TextEditingController();

  FirebaseAuth auth = FirebaseAuth.instance;
  @override
  Widget build(BuildContext context) {
    myControllerMatricule.text = "${widget.values.data()['matricule']}";
    myControllerNom.text = "${widget.values.data()['nom']}";
    myControllerTel.text = "${widget.values.data()['tel']}";
    myControllerEmail.text = "${widget.values.data()['email']}";
    myControllerCalendar.text = "${widget.values.data()['priseDeService']}";
    myControllerWork.text = "${widget.values.data()['fonction']}";
    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: const Text("Profile utilisateur"),
        centerTitle: true,
        backgroundColor: Colors.orangeAccent,
        leading: IconButton(
          onPressed: () {
            Navigator.pushReplacement(
                context, MaterialPageRoute(builder: (context) => MyApp()));
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
            leading: const Icon(Icons.calendar_today),
            title: new TextField(
              controller: myControllerCalendar,
              decoration: new InputDecoration(
                hintText: "DatePriseService",
              ),
            ),
          ),
          new ListTile(
            leading: const Icon(Icons.work),
            title: new TextField(
              controller: myControllerWork,
              decoration: new InputDecoration(
                hintText: "Direction",
              ),
            ),
          ),
          // _showDropList(Constants.list_actes, 2);
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
                // String matricule = myControllerMatricule.value.text.isNotEmpty
                //     ? myControllerMatricule.value.text
                //     : "N/A";
                // String nom = myControllerNom.value.text.isNotEmpty
                //     ? myControllerNom.value.text
                //     : "N/A";
                // String tel = myControllerTel.value.text.isNotEmpty
                //     ? myControllerTel.value.text
                //     : "N/A";
                // String email = myControllerEmail.value.text.isNotEmpty
                //     ? myControllerEmail.value.text
                //     : "N/A";
                // String priseService =
                //     myControllerPriseService.value.text.isNotEmpty
                //         ? myControllerEmail.value.text
                //         : "N/A";
                // String emploi = pickedEmploi;
                // String acte = pickedActes;
                // String piece = prefs.getString("imageUrl");
                // String motif = pickedMotif;
                // String dated = datePicked;
                String numeroDemande = DateTime.now().toString();
                UserDetails userdetails = UserDetails(
                    matricule: myControllerMatricule.text,
                    nom: myControllerNom.text,
                    tel_domicile: myControllerTel.value.text,
                    email: myControllerEmail.text,
                    fonction: myControllerWork.text,
                    prise_service: myControllerCalendar.text);
                userProfileSetup(userdetails, auth.currentUser.uid);
                print('demande d\'acte envoye');
                // String description =
                //     "Une nouvelle demande d'acte est en attente de validation";
                //
                // successDialog(context, 'Votre demande est envoyé avec succès');
                // callOnFcmApiSendPushNotifications(userToken, description);
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
}
