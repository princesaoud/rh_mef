// import 'dart:html';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:commons/commons.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:rh_mef/models/stepsActe.dart';

class StatutsDemande extends StatefulWidget {
  final List<ListSteps> listSteps;
  final List<ListSteps> listStepsError;
  final int numeroActe;
  StatutsDemande({this.listSteps, this.listStepsError, this.numeroActe});
  @override
  _StatutsDemandeState createState() => _StatutsDemandeState();
}

class _StatutsDemandeState extends State<StatutsDemande> {
  _StatutsDemandeState();
  List<MaterialColor> statutsColor = [
    Colors.grey,
    Colors.grey,
    Colors.grey,
    Colors.grey
  ];
  List<MaterialColor> textColor = [
    Colors.grey,
    Colors.grey,
    Colors.grey,
    Colors.grey
  ];
  DocumentSnapshot documentSnapshot;
  String errorMessage = '';
  String errorTitle = '';
  FirebaseAuth auth = FirebaseAuth.instance;
  @override
  Widget build(BuildContext context) {
    getNumeroDemande();
    if (documentSnapshot == null) {
      return Scaffold(
        appBar: AppBar(
          title: Text("Chargement..."),
          backgroundColor: Colors.orangeAccent,
        ),
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }
    if (widget.listSteps.length >= 4) {
      print(widget.listSteps.length);
      return Scaffold(
        appBar: AppBar(
          title: Text("Tracking de votre demande "),
          backgroundColor: Colors.orange,
        ),
        body: presenceSoldeTimeLine(),
      );
    } else if (widget.listSteps.length == 0) {
      return Scaffold(
        appBar: AppBar(
          title: Text("Pas normal"),
          backgroundColor: Colors.orange,
        ),
        body: Card(),
      );
    } else {
      // print("le nom ${widget.listSteps.length}");
      return Scaffold(
        appBar: AppBar(
          title: Text("Tracking de votre demande "),
          backgroundColor: Colors.orange,
        ),
        body: orderTimeLine(),
      );
    }
  }

  getNumeroDemande() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    // int value = sharedPreferences.getInt('numeroDemande');
    int choiceCode;
    String value = auth.currentUser.uid;
    QuerySnapshot queryResult = await FirebaseFirestore.instance
        .collection('ActeDemand')
        .where('acteDemande', isEqualTo: widget.numeroActe)
        .get();
    // setState(() {
    //documentSnapshot doc.fist was here
    // });
    documentSnapshot = queryResult.docs[0];
    // setState(() {
    //   documentSnapshot = queryResult.docs[0];
    // });
    var statutsCode = documentSnapshot.data()['statuts'];

    print('statutsCode: $statutsCode');
    print("variable type = ${statutsCode.runtimeType}");
    if (statutsCode.runtimeType == String &&
        statutsCode.toString().contains('404')) {
      List<String> listCode = statutsCode.toString().split(',');
      choiceCode = int.parse(listCode[0]);
      print('its a string value $statutsCode');
      errorMessage = listCode[1];
    } else if (statutsCode.runtimeType == String) {
      choiceCode = int.parse(statutsCode);
    } else if (statutsCode.runtimeType == int) {
      choiceCode = statutsCode;
      print('choice code $choiceCode');
    }
    switch (choiceCode) {
      // case 0:
      //   // print('statuts value is 0');
      //   setState(() {
      //     // statutsColor[0] = Colors.green;
      //   });
      //   break;
      case 1:
        print('statuts value is $choiceCode');
        setState(() {
          for (var i = 0; i < choiceCode; i++) {
            statutsColor[i] = Colors.green;
            textColor[i] = Colors.green;
          }
        });
        break;
      case 2:
        // print('Statuts value is 2');
        setState(() {
          for (var i = 0; i < choiceCode; i++) {
            statutsColor[i] = Colors.green;
            textColor[i] = Colors.green;
          }
        });
        break;
      case 3:
        // print('Statuts value is 3');
        setState(() {
          // print('in the for loop statuts code is : $statutsCode');
          for (var i = 0; i < choiceCode; i++) {
            statutsColor[i] = Colors.green;
            textColor[i] = Colors.green;
          }
        });
        break;
      case 4:
        // print('Statuts value is 3');
        setState(() {
          for (var i = 0; i < choiceCode; i++) {
            statutsColor[i] = Colors.green;
            textColor[i] = Colors.green;
          }
        });
        break;
      case 20:
        // print('Statuts value is 3');
        setState(() {
          for (var i = 0; i < 4; i++) {
            statutsColor[i] = Colors.green;
            textColor[i] = Colors.green;
          }
        });
        break;

      case 404:
        //L'erreur apparait a la deuxieme etape seulement
        setState(() {
          // for (var i = 0; i < 2; i++) {
          //   statutsColor[i] = Colors.red;
          //   textColor[i] = Colors.red;
          // }
          statutsColor[1] = Colors.red;
          textColor[1] = Colors.red;
          statutsColor[0] = Colors.green;
          textColor[0] = Colors.green;
        });
        break;
      // case 5:
      //   // print('Statuts value is 3');
      //   setState(() {
      //     for (var i = 0; i < statutsCode; i++) {
      //       statutsColor[i] = Colors.green;
      //       textColor[i] = Colors.green;
      //     }
      //   });
      //   break;
    }
    // print(documentSnapshot.data()['numeroDemande']);
    return queryResult;
  }

  Widget orderTimeLine() {
    // if (documentSnapshot.data()[''])
    return Container(
      decoration: BoxDecoration(color: Colors.white),
      margin: EdgeInsets.only(
        // bottom: SizeConfig.safeBlockHorizontal * 3,
        bottom: 8,
      ),
      padding: EdgeInsets.only(
        top: 20,
        left: 20,
        // bottom: SizeConfig.safeBlockHorizontal * 3,
      ),
      child: Column(
        children: <Widget>[
          SingleChildScrollView(
            // margin: EdgeInsets.only(top: 30, right: 10, bottom: 30),
            child: SizedBox(
              child: Padding(
                padding: EdgeInsets.all(8),
                child: Row(children: [
                  Expanded(
                    child: Container(
                      child: Card(
                        child: Column(
                          children: [
                            Container(
                              margin: EdgeInsets.only(top: 10),
                              // height: 30,
                              child: Column(
                                children: [
                                  Text(
                                    'Matricule Agent: ${documentSnapshot.data()['matricule']}',
                                    style: TextStyle(fontSize: 15),
                                    textAlign: TextAlign.center,
                                  ),
                                  Text(
                                    'Nature Acte: ${documentSnapshot.data()['natureActe']}',
                                    style: TextStyle(fontSize: 12),
                                    textAlign: TextAlign.center,
                                  ),
                                ],
                              ),
                            ),
                            Divider(),
                            timelineRow(
                                "${widget.listSteps[0].title}",
                                "${widget.listSteps[0].description}",
                                statutsColor[0],
                                textColor[0]),
                            if (errorMessage == '')
                              timelineRow(
                                  "${widget.listSteps[1].title}",
                                  '${widget.listSteps[1].description}',
                                  statutsColor[1],
                                  textColor[1]),
                            if (errorMessage != '')
                              timelineRow(
                                  "${widget.listStepsError[1].title}",
                                  '$errorMessage',
                                  statutsColor[1],
                                  textColor[1]),
                            timelineLastRow(
                                "${widget.listStepsError.last.title}",
                                "${widget.listSteps.last.description}",
                                statutsColor[2],
                                textColor[2]),
                          ],
                        ),
                        elevation: 2,
                      ),
                    ),
                  ),
                ]),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget presenceSoldeTimeLine() {
    // if (documentSnapshot.data()[''])
    return Container(
      decoration: BoxDecoration(color: Colors.white),
      margin: EdgeInsets.only(
        // bottom: SizeConfig.safeBlockHorizontal * 3,
        bottom: 8,
      ),
      padding: EdgeInsets.only(
        top: 20,
        left: 20,
        // bottom: SizeConfig.safeBlockHorizontal * 3,
      ),
      child: Column(
        children: <Widget>[
          SingleChildScrollView(
            // margin: EdgeInsets.only(top: 30, right: 10, bottom: 30),
            child: SizedBox(
              child: Padding(
                padding: EdgeInsets.all(8),
                child: Row(children: [
                  Expanded(
                    child: Container(
                      child: Card(
                        child: Column(
                          children: [
                            Container(
                              margin: EdgeInsets.only(top: 10),
                              // height: 30,
                              child: Column(
                                children: [
                                  Text(
                                    'Matricule Agent: ${documentSnapshot.data()['matricule']}',
                                    style: TextStyle(fontSize: 15),
                                    textAlign: TextAlign.center,
                                  ),
                                  Text(
                                    'Nature Acte: ${documentSnapshot.data()['natureActe']}',
                                    style: TextStyle(fontSize: 12),
                                    textAlign: TextAlign.center,
                                  ),
                                ],
                              ),
                            ),
                            Divider(),
                            timelineRow(
                                "${widget.listSteps[0].title}",
                                "${widget.listSteps[0].description}",
                                statutsColor[0],
                                textColor[0]),
                            if (errorMessage == '')
                              dotlineTimeline(
                                  "${widget.listSteps[1].title}",
                                  '${widget.listSteps[1].description}',
                                  statutsColor[1],
                                  textColor[1]),
                            if (errorMessage != '')
                              dotlineTimeline(
                                  "${widget.listStepsError[1].title}",
                                  'Erreur: ${errorMessage}',
                                  statutsColor[1],
                                  textColor[1]),
                            timelineRow(
                                "${widget.listSteps[2].title}",
                                "${widget.listSteps[2].description}",
                                statutsColor[2],
                                textColor[2]),
                            // timelineRow(
                            //     "${widget.listSteps[3].title}",
                            //     "${widget.listSteps[3].description}",
                            //     statutsColor[3],
                            //     textColor[3]),
                            timelineLastRow(
                                "${widget.listSteps.last.title}",
                                "${widget.listSteps.last.description}",
                                statutsColor.last,
                                textColor[3]),
                          ],
                        ),
                        elevation: 2,
                      ),
                    ),
                  ),
                ]),
              ),
            ),
          ),
        ],
      ),
    );
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
                subtitle: Text(
                  subTile,
                  style: TextStyle(color: colors, fontSize: 15),
                ),
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
