import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:commons/commons.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:rh_mef/app_theme.dart';
import 'package:rh_mef/view/complaint/complaint.dart';
import 'package:rh_mef/view/complaint/constantesForComplaints.dart';

class TimelineComplaint extends StatefulWidget {
  final int complaintId;
  final String complaintType;
  TimelineComplaint({this.complaintId, this.complaintType});
  @override
  _TimelineComplaintState createState() => _TimelineComplaintState();
}

class _TimelineComplaintState extends State<TimelineComplaint> {
  final FirebaseAuth auth = FirebaseAuth.instance;
  @override
  Widget build(BuildContext context) {
    List<MaterialColor> listColors = [
      for (var i = 0; i < ConstantsForComplaints().myComplaint.length; i++)
        Colors.grey
    ];
    print(' timeline value of complaint id ${widget.complaintId}');
    print(' timeline value of complaint id ${widget.complaintType}');
    initializeDateFormatting('fr');
    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(
          "Suivi de votre ${widget.complaintType}",
          style: TextStyle(color: AppTheme.grey),
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
      body: SafeArea(
        child: StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance
                .collection('Complaint')
                .where('id', isEqualTo: widget.complaintId)
                .snapshots(),
            builder: (context, snapshot) {
              if (snapshot.data == null ||
                  snapshot == null ||
                  snapshot.data.docs == null) {
                return Center(
                    child: Container(
                  child: Text("Aucune informations disponible"),
                ));
              }
              ConstantsForComplaints constantsForComplaints =
                  ConstantsForComplaints(
                      temoignagneType: widget.complaintType,
                      motifTemoignagne:
                          snapshot.data.docs.first.data()['error']);
              if (snapshot.hasData) {
                if (snapshot.data.docs.first.data()['steps'] == 404) {
                  List<MaterialColor> listColors = [
                    Colors.green,
                    Colors.red,
                    Colors.red,
                  ];
                  return Column(
                    children: [
                      Expanded(
                        child: timelineComplaintError(
                            constantsForComplaints.myComplaint,
                            listColors,
                            snapshot.data.docs.first.data()['error'],
                            snapshot.data.docs.first.data()['steps']),
                      ),
                      // getNewComplaintView(snapshot.data.docs.first, context)
                    ],
                  );
                } else {
                  print(snapshot.data.docs.first.data()['steps']);
                  int stopSteps = snapshot.data.docs.first.data()['steps'];
                  // print(listColors.length);
                  print(stopSteps);
                  String issue = snapshot.data.docs.first.data()['issue'];
                  // print(issue);
                  String recevabiliteDate =
                      DateFormat('EEE, MMM d, ' 'yy', 'fr').format(snapshot
                          .data.docs.first
                          .data()['recevabilite']
                          .toDate());
                  for (var i = 0; i < stopSteps; i++) {
                    listColors[i] = Colors.green;
                  }
                  // ConstantsForComplaints().myComplaint.forEach((element) {});
                  return Column(
                    children: [
                      Expanded(
                        child: listOfComplaintSteps(
                            constantsForComplaints.myComplaint,
                            listColors,
                            issue,
                            recevabiliteDate,
                            stopSteps),
                      ),
                    ],
                  );
                }
                return Container();
              } else
                return Container();
            }),
      ),
    );
  }

  Widget getNewComplaintView(DocumentSnapshot snapshot, BuildContext context) {
    return TextButton(
      child: Text('Refaire un nouveau témoignage'),
      onPressed: () {
        FirebaseFirestore.instance
            .collection('Complaint')
            .doc(snapshot.data()['userId'])
            .delete();
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => Complaint()),
        );
      },
    );
  }

  String getComplaintTitle(
      ModelComplaintSteps complaintSteps, MaterialColor colors) {
    if (colors == Colors.green) return complaintSteps.bySucces;
    if (colors == Colors.grey) return complaintSteps.byDefault;
    if (colors == Colors.red) return complaintSteps.byError;
    return complaintSteps.byError;
  }

  String getComplaintSubTitle(
      ModelComplaintSteps complaintSteps,
      MaterialColor colors,
      int index,
      String issue,
      String dateRecevable,
      int stopSteps) {
    if (index == 1 && colors == Colors.green) {
      return 'Veuillez-vous présenter à la DRH MEF le $dateRecevable';
    } else if (index == 2 && colors == Colors.green) {
      return "L’issue de votre dossier est la suivante $issue";
    } else if (index == 1 && colors == Colors.red) {
      return complaintSteps.subInfoError;
    } else if (index == 2 && colors == Colors.red) {
      return complaintSteps.subInfoError;
    } else if (index == 3 && colors == Colors.green) {
      return complaintSteps.subInfoSucces;
    }

    // if (colors == Colors.green) return complaintSteps.subInfoSucces;
    // if (colors == Colors.grey) return complaintSteps.subInfoSucces;
    return "";
  }

  Widget timelineComplaintError(List<ModelComplaintSteps> listComplaint,
      List<MaterialColor> listColor, String issue, int stopSteps) {
    String result = "";
    return ListView(
      padding: EdgeInsets.all(20),
      children: [
        for (var i = 0; i < listComplaint.length - 1; i++)
          timelineRow(
            title: '${getComplaintTitle(listComplaint[i], listColor[i])}',
            subTile:
                '${getComplaintSubTitle(listComplaint[i], listColor[i], i, issue, "", stopSteps)}',
            colors: listColor[i],
            textColors: listColor[i],
          ),
      ],
    );
  }

  Widget listOfComplaintSteps(
      List<ModelComplaintSteps> listComplaint,
      List<MaterialColor> listColor,
      String issue,
      String recevabiliteDate,
      int stopSteps) {
    String result = "";
    return ListView(
      padding: EdgeInsets.all(20),
      children: [
        for (var i = 0; i < listComplaint.length; i++)
          timelineRow(
            title: '${getComplaintTitle(listComplaint[i], listColor[i])}',
            subTile:
                '${getComplaintSubTitle(listComplaint[i], listColor[i], i, issue, recevabiliteDate, stopSteps)}',
            colors: listColor[i],
            textColors: listColor[i],
          ),
        // timelineRow(
        //   title:
        //       'Votre plainte/réclamation est en cours de traitement. Vous serez contacté (e) par un agent',
        //   subTile: '',
        //   colors: Colors.green,
        //   textColors: Colors.green,
        // ),
        // timelineRow(
        //   title: 'Votre plainte/réclamation est déclarée recevable',
        //   subTile: '',
        //   colors: Colors.green,
        //   textColors: Colors.green,
        // ),
        // timelineRow(
        //   title:
        //       'Veuillez-vous présenter à la DRH MEF le ………2021 à …………….heures',
        //   subTile: '',
        //   colors: Colors.green,
        //   textColors: Colors.green,
        // ),
        // timelineRow(
        //   title: 'L’issue de votre dossier est la suivante…..',
        //   subTile: '',
        //   colors: Colors.green,
        //   textColors: Colors.green,
        // ),
        // timelineRow(
        //   title: 'Procédure terminée',
        //   subTile: 'la DRH/MEF vous remercie',
        //   colors: Colors.green,
        //   textColors: Colors.green,
        // ),
      ],
    );
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
                  style: TextStyle(color: textColors, fontSize: 14),
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
