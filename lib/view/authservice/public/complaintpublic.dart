import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:commons/commons.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:rh_mef/app_theme.dart';
import 'package:rh_mef/view/authservice/public/profiledetailspublic.dart';
import 'package:rh_mef/view/authservice/public/public_drawer/drawer_user_controller.dart';
import 'package:rh_mef/view/authservice/public/public_drawer/home_drawer.dart';
import 'package:rh_mef/view/authservice/public/publiclogin.dart';
import 'package:rh_mef/view/complaint/create_new_complaint.dart';
import 'package:rh_mef/view/complaint/timeline_complaint.dart';

// void main() => runApp(MyApp());

/// This is the main application widget.
///

class ComplaintPublic extends StatefulWidget {
  @override
  _ComplaintState createState() => _ComplaintState();
}

class _ComplaintState extends State<ComplaintPublic> {
  Widget screenView;
  DrawerIndex drawerIndex;
  final FirebaseAuth auth = FirebaseAuth.instance;

  @override
  void initState() {
    drawerIndex = DrawerIndex.Temoigngage;
    screenView = ComplaintContentPublic();
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
          body: DrawerUserControllerPublic(
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
          screenView = PublicLogin();
        });
      } else if (drawerIndex == DrawerIndex.Temoigngage) {
        setState(() {
          screenView = ComplaintContentPublic();
        });
      } else if (drawerIndex == DrawerIndex.Profile) {
        setState(() {
          screenView = ProfilePublic();
        });
      } else {
        //do in your way......
      }
    }
  }
}

class ComplaintContentPublic extends StatelessWidget {
  static const String _title = 'Flutter Code Sample';

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          // Here we take the value from the MyHomePage object that was created by
          // the App.build method, and use it to set our appbar title.
          title: const Text(
            "Témoignages",
            style: TextStyle(color: Colors.black),
          ),
          centerTitle: true,
          backgroundColor: Colors.white,
          // leading: IconButton(
          //   onPressed: () {
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

enum NatureTemoignage { plaintes, reclamations, suggestions, preoccupations }

/// This is the stateful widget that the main application instantiates.
class MyStatefulWidget extends StatefulWidget {
  MyStatefulWidget({Key key}) : super(key: key);

  @override
  _MyStatefulWidgetState createState() => _MyStatefulWidgetState();
}

/// This is the private State class that goes with MyStatefulWidget.
class _MyStatefulWidgetState extends State<MyStatefulWidget> {
  NatureTemoignage _character = NatureTemoignage.plaintes;
  final myControllerDesignation = TextEditingController();
  final myControllerNumber = TextEditingController();
  final myControllerEmail = TextEditingController();
  final myControllerObservation = TextEditingController();
  FirebaseAuth auth = FirebaseAuth.instance;
  Widget build(BuildContext context) {
    return FutureBuilder<QuerySnapshot>(
        future: FirebaseFirestore.instance
            .collection('Complaint')
            .where('userId', isEqualTo: auth.currentUser.uid)
            .get(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting)
            return Center(
              child: CircularProgressIndicator(),
            );
          if (snapshot.hasData &&
              snapshot.data != null &&
              snapshot != null &&
              snapshot.data != null) {
            // return TimelineComplaint();
            return Column(
              children: [
                Expanded(
                  child: ListView.builder(
                      itemCount: snapshot.data.docs.length,
                      itemBuilder: (BuildContext context, int index) {
                        return Card(
                          child: ListTile(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => TimelineComplaint(
                                    complaintId:
                                        snapshot.data.docs[index].data()['id'],
                                    complaintType: snapshot.data.docs[index]
                                        .data()['complaintType'],
                                  ),
                                ),
                              );
                            },
                            title: Text(
                              "${snapshot.data.docs[index].data()['complaintType'].toString().toUpperCase()}--> Numero:${snapshot.data.docs[index].data()['id'].toString().toUpperCase()}",
                              textAlign: TextAlign.left,
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            subtitle: Text(
                              DateFormat('dd/MM/yyyy H:mm:ss')
                                  .format(snapshot.data.docs[index]
                                      .data()['created']
                                      .toDate())
                                  .toString(),
                              style: TextStyle(fontSize: 15),
                            ),
                          ),
                        );
                      }),
                ),
                Row(
                  children: [
                    Expanded(
                      child: Container(
                        padding: EdgeInsets.all(10),
                        margin: EdgeInsets.all(15),
                        child: TextButton(
                          style: ButtonStyle(
                              backgroundColor:
                                  MaterialStateProperty.all(Colors.orange)),
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => CreateAnewComplaint()),
                            );
                          },
                          child: Text(
                            'Creer une nouvelle plainte',
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ),
                    ),
                  ],
                )
              ],
            );
          }
          return Container();
          //TODO: LIST OF COMPLAINT AND BUTTON TO CREATE NEW COMPLAINT
        });
  }

  onPressed() {
    // print('button pressed');
    // // NORMAL
    // String designation = myControllerDesignation.text;
    // String number = myControllerNumber.text;
    // String email = myControllerEmail.text;
    // String complaintType =
    //     _character.toString().substring(_character.toString().indexOf('.') + 1);
    // String observation = myControllerObservation.text;
    // userSetup(designation, number, email, complaintType, observation);
    // //TODO: add alert dialog of successfully add data
    // // successDialog(context, "Votre demande a été envoyé avec succes");
  }

  @override
  void initState() {
    super.initState();
    Firebase.initializeApp().whenComplete(() {
      print("completed");
      setState(() {});
    });
  }

  @override
  void dispose() {
    super.dispose();
  }
}
