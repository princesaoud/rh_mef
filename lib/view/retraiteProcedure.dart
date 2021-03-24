import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:rh_mef/main.dart';
import 'package:rh_mef/net/firebase.dart';
import 'package:rh_mef/view/retraite/documentfoncpu.dart';

class RetraiteProccedure extends StatefulWidget {
  @override
  _RetraiteProccedureState createState() => _RetraiteProccedureState();
}

enum viewValue { home, fp, cgrae }

class _RetraiteProccedureState extends State<RetraiteProccedure> {
  // static var view = '${viewValue.home}';
  static var view = viewValue.home;
  FirebaseAuth auth = FirebaseAuth.instance;

  List<String> listDocumentsFP = [
    "L'Extrait de naissance de l'interesse(e) (Original)",
    "Photocopie de la CNI de l'interessé(e)",
    "La première prise de service de l'interessé(e)",
    "La dernière décision d'avancement de l'intéressé(e)",
    "L'arrêté de promotion de l'interessé(e)",
    "Le bulletin de solde des enfants (originaux) pour le cas d'une femme (03 enfants nés pendant le service)",
    "L'état signalétique des services militaires (cas éventuel)"
  ];
  List<String> listDocumentsCgrae = [
    "Une demande de pension de retraite de l'IPS-CGRAE",
    "Un extrait de l'acte de naissance de l'assuré(e) (original)",
    "Un bulletin de solde de la dernière année d'activité (pour les civils) (original)",
    "Photocopie de la pièce d'identité",
    "Relevé d'identité Bancaire (RIB)",
    "Un extrait de l'acte de naissance de chaque enfant (originaux), le cas échéant",
    "La décision d'autorisation de validation des services auxiliaires, le cas echeant (original)",
    "L'attestation de cotisations au titre des services auxiliaires, le cas echeant (original)",
    "L'état signaletique des services militaires, le cas echeant (orignaux)",
    "Un extrait de l'acte de mariage, le cas echeant (original)",
    "Une photocopie du certificat de premiere prise de service ou de la decision d'engagement (pour civils)",
    "Tous les actes de l'avancement, de nomination ou de promotion (pour les civils)"
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Navigator.pushReplacement(
                context, MaterialPageRoute(builder: (context) => MyApp()));
          },
          icon: Icon(Icons.arrow_back),
        ),
        title: Text(
          'Etape de la mise en retraite',
          style: TextStyle(fontSize: 20),
        ),
      ),
      body: Card(
        elevation: 2,
        margin: EdgeInsets.all(10),
        child: Padding(
          padding: const EdgeInsets.only(top: 30),
          child: StreamBuilder<DocumentSnapshot>(
              stream: FirebaseFirestore.instance
                  .collection("Retreate")
                  .doc('${auth.currentUser.uid}')
                  .snapshots(),
              builder: (context, snapshot) {
                //checking for colors
                final int value = snapshot.data.data()['steps'];
                List<MaterialColor> listColors = colorForRetreateList(value);
                return ListView(
                  children: <Widget>[
                    //TODO: ADD TITLE
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => DocumentSelected(
                                      listDocuments: listDocumentsFP,
                                    )));
                      },
                      child: Container(
                        child: timelineRow(
                            "Constitution des documents a la DRH/MEF",
                            "Veuillez soumettre es documents, nécessaire pour la constitution de votre dossier\nCliquez pour voir la liste",
                            listColors[0],
                            listColors[0]),
                      ),
                    ),
                    Container(
                      child: timelineRow(
                          "Votre document transmis a la Fonction Publique",
                          "Vos documents, sont en traitement au bureau de la fonction publique",
                          listColors[1],
                          listColors[1]),
                    ),
                    Container(
                        child: dotlineTimeline(
                      "Document de radiation établie",
                      " ",
                      listColors[2],
                      listColors[2],
                    )),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => DocumentSelected(
                                      listDocuments: listDocumentsCgrae,
                                    )));
                      },
                      child: Container(
                        child: timelineRow(
                            "Constitution des documents pour la CGRAE",
                            "Veuillez soumettre les documents, nécessaire pour la constitution de votre de la CGRAE \nCliquez pour voir la liste",
                            listColors[3],
                            listColors[3]),
                      ),
                    ),
                    Container(
                      child: dotlineTimeline(
                          "Document pour de la CGRAE constitué",
                          "",
                          listColors[4],
                          listColors[4]),
                    ),
                    Container(
                      child: timelineRow(
                        "Votre document transmis a la CGRAE",
                        "Vos documents, sont en traitement au bureau de la CGRAE",
                        listColors[5],
                        listColors[5],
                      ),
                    ),
                    Container(
                      child: timelineLastRow(
                        "Proccedure terminée",
                        "",
                        listColors[6],
                        listColors[6],
                      ),
                    ),
                  ],
                );
              }),
        ),
      ),
    );
  }

  Widget documentFP(String title, List<String> listDocuments) {
    return Container();
  }

  Widget timelineRow(String title, String subTile, MaterialColor colors,
      MaterialColor textColors) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: <Widget>[
        Expanded(
          flex: 1,
          child: Column(
            // mainAxisAlignment: MainAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Container(
                width: 18,
                height: 18,
                decoration: new BoxDecoration(
                  color: colors,
                  shape: BoxShape.circle,
                ),
                child: Text(""),
              ),
              Container(
                width: 3,
                height: 70,
                decoration: new BoxDecoration(
                  color: colors,
                  shape: BoxShape.rectangle,
                ),
                child: Text(""),
              ),
            ],
          ),
        ),
        Expanded(
          flex: 7,
          child: Column(
            // mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              ListTile(
                title: Text(
                  title,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: colors,
                  ),
                  textAlign: TextAlign.center,
                ),
                subtitle: Text(
                  subTile,
                  style: TextStyle(color: colors),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget dotlineTimeline(String title, String subTile, MaterialColor colors,
      MaterialColor textColors) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: <Widget>[
        Expanded(
          flex: 1,
          child: Column(
            // mainAxisAlignment: MainAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Container(
                width: 18,
                height: 18,
                decoration: new BoxDecoration(
                  color: colors,
                  shape: BoxShape.circle,
                ),
                child: Text(""),
              ),
              Container(
                width: 7,
                height: 7,
                decoration: new BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                ),
                child: Text(""),
              ),
              Container(
                width: 7,
                height: 7,
                decoration: new BoxDecoration(
                  color: colors,
                  shape: BoxShape.circle,
                ),
                child: Text(""),
              ),
              Container(
                width: 7,
                height: 7,
                decoration: new BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                ),
                child: Text(""),
              ),
              Container(
                width: 7,
                height: 7,
                decoration: new BoxDecoration(
                  color: colors,
                  shape: BoxShape.circle,
                ),
                child: Text(""),
              ),
              Container(
                width: 7,
                height: 7,
                decoration: new BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                ),
                child: Text(""),
              ),
              Container(
                width: 7,
                height: 7,
                decoration: new BoxDecoration(
                  color: colors,
                  shape: BoxShape.circle,
                ),
                child: Text(""),
              ),
              Container(
                width: 7,
                height: 7,
                decoration: new BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                ),
                child: Text(""),
              ),
              Container(
                width: 7,
                height: 7,
                decoration: new BoxDecoration(
                  color: colors,
                  shape: BoxShape.circle,
                ),
                child: Text(""),
              ),
              Container(
                width: 7,
                height: 7,
                decoration: new BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                ),
                child: Text(""),
              ),
              Container(
                width: 7,
                height: 7,
                decoration: new BoxDecoration(
                  color: colors,
                  shape: BoxShape.circle,
                ),
                child: Text(""),
              ),
              Container(
                width: 5,
                height: 5,
                decoration: new BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                ),
                child: Text(""),
              ),
            ],
          ),
        ),
        Expanded(
          flex: 7,
          child: Column(
            // mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              ListTile(
                title: Text(
                  title,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: textColors,
                  ),
                ),
                subtitle: Text(subTile),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget timelineLastRow(String title, String subTile, MaterialColor colors,
      MaterialColor textColors) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: <Widget>[
        Expanded(
          flex: 1,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Container(
                width: 18,
                height: 18,
                decoration: new BoxDecoration(
                  color: colors,
                  shape: BoxShape.circle,
                ),
                child: Text(""),
              ),
              Container(
                width: 3,
                height: 55,
                decoration: new BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.rectangle,
                ),
                child: Text(""),
              ),
              // Container(
              //   width: 3,
              //   height: 20,
              //   decoration: new BoxDecoration(
              //     color: colors,
              //     shape: BoxShape.rectangle,
              //   ),
              //   child: Text(""),
              // ),
            ],
          ),
        ),
        Expanded(
          flex: 7,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              ListTile(
                title: Text(
                  title,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: textColors,
                  ),
                ),
                subtitle: Text(subTile),
              )
            ],
          ),
        ),
      ],
    );
  }
}
