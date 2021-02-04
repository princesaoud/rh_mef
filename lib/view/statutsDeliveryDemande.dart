// import 'dart:html';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:commons/commons.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

// ignore: must_be_immutable
class StatutsDemande extends StatefulWidget {
  List<String> listSteps = [];
  StatutsDemande(this.listSteps);
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
  DocumentSnapshot documentSnapshot;

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
    return Scaffold(
      appBar: AppBar(
        title: Text("Tracking de votre demande "),
        backgroundColor: Colors.orange,
      ),
      body: orderTimeLine(),
    );
  }

  getNumeroDemande() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    int value = sharedPreferences.getInt('numeroDemande');
    QuerySnapshot queryResult = await FirebaseFirestore.instance
        .collection('ActeDemand')
        .where('numeroDemande', isEqualTo: value)
        .get();
    setState(() {
      documentSnapshot = queryResult.docs.first;
    });
    int statutsCode = documentSnapshot.data()['statuts'];
    // print('$statutsCode');
    switch (statutsCode) {
      case 0:
        // print('statuts value is 0');
        setState(() {
          // statutsColor[0] = Colors.green;
        });
        break;
      case 1:
        // print('statuts value is 1 ');
        setState(() {
          for (var i = 0; i < statutsCode; i++) {
            statutsColor[i] = Colors.green;
          }
        });
        break;
      case 2:
        // print('Statuts value is 2');
        setState(() {
          for (var i = 0; i < statutsCode; i++) {
            statutsColor[i] = Colors.green;
          }
        });
        break;
      case 3:
        // print('Statuts value is 3');
        setState(() {
          for (var i = 0; i < statutsCode; i++) {
            statutsColor[i] = Colors.green;
          }
        });
        break;
      case 4:
        // print('Statuts value is 3');
        setState(() {
          for (var i = 0; i < statutsCode; i++) {
            statutsColor[i] = Colors.green;
          }
        });
        break;
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
          Container(
            margin: EdgeInsets.only(top: 30, right: 10, bottom: 30),
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
                                  'Demande Numero: ${documentSnapshot.data()['numeroDemande']}',
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
                              "${widget.listSteps[0]}", "", statutsColor[0]),
                          timelineRow(
                              "${widget.listSteps[1]}", '', statutsColor[1]),
                          timelineRow(
                              "${widget.listSteps[2]}", "", statutsColor[2]),
                          timelineLastRow(
                              "${widget.listSteps[3]}", "", statutsColor[3]),
                        ],
                      ),
                      elevation: 2,
                    ),
                  ),
                ),
              ]),
            ),
          ),
        ],
      ),
    );
  }

  Widget timelineRow(String title, String subTile, MaterialColor colors) {
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
                height: 50,
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
          flex: 9,
          child: Column(
            // mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text('$title\n $subTile',
                  style: TextStyle(
                      fontFamily: "regular",
                      fontSize: 14,
                      color: Colors.black54)),
            ],
          ),
        ),
      ],
    );
  }

  Widget timelineLastRow(String title, String subTile, MaterialColor colors) {
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
          flex: 9,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text('${title}\n ${subTile}',
                  style: TextStyle(
                      fontFamily: "regular",
                      fontSize: 14,
                      color: Colors.black54)),
            ],
          ),
        ),
      ],
    );
  }
}
