import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:commons/commons.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:rh_mef/constantes.dart';
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
  String errorMsgFP = '';
  String errorMsgCGRAE = '';
  String value = "";
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

  Future<DocumentSnapshot> geterrorMsgFP() async {
    DocumentSnapshot documentSnapshot = await FirebaseFirestore.instance
        .collection('Documents')
        .doc(auth.currentUser.uid)
        .get();
    return documentSnapshot;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            // Navigator.pushReplacement(
            //     context, MaterialPageRoute(builder: (context) => MyApp()));

            Navigator.pop(context);
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
        child:
            // FutureBuilder<DocumentSnapshot>(
            //     future: geterrorMsgFP(),
            //     builder: (context, snapshot) {
            //       if (snapshot == null ||
            //           snapshot.data == null ||
            //           snapshot.data.data() == null) {
            //         return Center(
            //           child: CircularProgressIndicator(),
            //         );
            //       }
            //       // String data = snapshot.data.data()['docs'];
            //       final List<dynamic> listdinamic = snapshot.data.data()['docs'];
            //       final List<String> listDatas = listdinamic.cast<String>();
            //
            //       listDatas.forEach((element) {
            //         if (element.contains('404')) {
            //           List<String> listErrors = element.split(':');
            //           // errorMsgFP = listErrors[1];
            //         }
            //       });
            StreamBuilder<DocumentSnapshot>(
                stream: FirebaseFirestore.instance
                    .collection("Retreate")
                    .doc('${auth.currentUser.uid}')
                    .snapshots(),
                builder: (context, snapshot) {
                  // geterrorMsgFP();
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                  if (snapshot.data == null ||
                      snapshot == null ||
                      snapshot.data.data() == null) {
                    return Center(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Card(
                          child: ListTile(
                            title: Text(
                              'AUCUNE PROCCEDURE DE RETRAITE N\'A ETE ENTAMMEE',
                              style: TextStyle(
                                  fontStyle: FontStyle.normal, fontSize: 25),
                              textAlign: TextAlign.center,
                            ),
                            // subtitle: Text(
                            //     "Veuillez contacter le service social de la DRH/MEF pour entammer une proccedure de retraire"),
                          ),
                        ),
                      ),
                    );
                  } else if (snapshot.hasData) {
                    //checking for colors
                    List<MaterialColor> listColors = [];
                    // if (snapshot.data.data()['steps'] != null) {
                    final List<dynamic> listStepsR =
                        snapshot.data.data()['listSteps'];
                    List<String> listStepsSR = listStepsR.cast<String>();
                    List<StepRetreatProcess> listStepRetreat =
                        Constants.listStepsRetreate;

                    listStepsSR.forEach((element) {
                      int index = listStepsSR.indexOf(element);
                      if (element.toString().contains('404')) {
                        List<String> templist = element.split(',');
                        value = templist[0];
                        errorMsgFP = templist[1];
                        listStepRetreat[index].description = templist[1];
                        listColors.add(
                            colorForRetreateList(element.split(',').first));
                      } else {
                        listColors.add(colorForRetreateList(element));
                      }
                      listStepRetreat[1].updated =
                          new DateFormat('EEE, MMM d, ' 'yy')
                              .format(snapshot.data.data()['updated'].toDate());
                      // listColors.add(colorForRetreateList(element));
                    });

                    return Container(
                      padding: EdgeInsets.only(top: 30, left: 10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Expanded(
                            child: ListView.builder(
                                itemCount: Constants.listStepsRetreate.length,
                                itemBuilder: (context, index) {
                                  // if (index ==
                                  //     Constants.listStepsRetreate.length)
                                  //   return timelineLastRow(
                                  //       Constants
                                  //           .listStepsRetreate[index].title,
                                  //       Constants.listStepsRetreate[index]
                                  //           .description,
                                  //       listColors[index],
                                  //       listColors[index]);
                                  return timelineRow(
                                      title: Constants
                                          .listStepsRetreate[index].title,
                                      subTile:
                                          listStepRetreat[index].description,
                                      colors: listColors[index],
                                      textColors: listColors[index],
                                      updated: listStepRetreat[index].updated);
                                  // Divider(
                                }),
                          ),
                          Divider(
                            height: 3,
                          ),
                          Row(
                            children: [
                              Expanded(
                                child: Container(
                                  height: 70,
                                  child: Column(
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: TextButton(
                                          onPressed: () {
                                            Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        DocumentSelected(
                                                          listDocuments: Constants
                                                              .documentSubmit,
                                                          title:
                                                              'Liste des documents a fournir.',
                                                        )));
                                          },
                                          style: TextButton.styleFrom(
                                            primary: Colors.white,
                                            backgroundColor: Colors.orange,
                                          ),
                                          child: Text(
                                            "Cliquez pour voir la liste des documents à fournir",
                                            textAlign: TextAlign.center,
                                          ),
                                        ),
                                      ),

                                      // timelineRow(
                                      //     "Constitution des documents a la DRH/MEF",
                                      //     "Veuillez soumettre es documents, nécessaire pour la constitution de votre dossier\nCliquez ici",
                                      //     listColors[0],
                                      //     listColors[0]),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    );
                    // }
                    // print(snapshot.data.data());
                    // print('Snapshot seems to be null');
                    // //snapshot.data is null
                    // return Center(
                    //   child: Card(),
                    // );
                  } else {
                    return Center(
                      child: Text('No Data'),
                    );
                  }
                }),
        // }),
      ),
    );
    // );
  }

  Widget documentFP(String title, List<String> listDocuments) {
    return Container();
  }

  Widget timelineRow(
      {String title,
      String subTile,
      MaterialColor colors,
      MaterialColor textColors,
      String updated}) {
    if (colors == Colors.grey || updated == null || updated == 'null') {
      updated = "";
    }
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
                width: 25,
                height: 25,
                decoration: new BoxDecoration(
                  color: colors,
                  shape: BoxShape.circle,
                ),
                child: Text(""),
              ),
              Container(
                width: 3,
                height: 110,
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
                  "$subTile \n $updated",
                  style: TextStyle(color: Colors.black, fontSize: 14),
                  textAlign: TextAlign.center,
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
