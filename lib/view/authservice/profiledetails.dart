import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:commons/commons.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:rh_mef/app_theme.dart';
import 'package:rh_mef/custom_drawer/drawer_user_controller.dart';
import 'package:rh_mef/custom_drawer/home_drawer.dart';
import 'package:rh_mef/main.dart';
import 'package:rh_mef/models/userDetails.dart';
import 'package:rh_mef/net/firebase.dart';
import 'package:rh_mef/view/authservice/agent/agentlogin.dart';
import 'package:rh_mef/view/complaint/complaint.dart';
import 'package:rh_mef/view/demandeacte/demande_dactes.dart';
import 'package:rh_mef/view/retraite/retraiteProcedure.dart';

class ProfileDetails extends StatefulWidget {
  @override
  _ProfileDetailsState createState() => _ProfileDetailsState();
}

class _ProfileDetailsState extends State<ProfileDetails> {
  Widget screenView;
  DrawerIndex drawerIndex;
  final FirebaseAuth auth = FirebaseAuth.instance;

  @override
  void initState() {
    drawerIndex = DrawerIndex.Profile;
    screenView = ProfileDetailsContent();
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
          screenView = AgentLogin();
        });
      } else if (drawerIndex == DrawerIndex.Retraite) {
        setState(() {
          screenView = RetraiteProccedureContent();
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

class ProfileDetailsContent extends StatelessWidget {
  final DocumentSnapshot values;
  ProfileDetailsContent({Key key, this.values}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (values != null)
      return MaterialApp(
        debugShowCheckedModeBanner: false,
        home: Scaffold(
          appBar: AppBar(
            title: Text(
              'Profile utilisateur',
              style: TextStyle(color: Colors.black),
            ),
            centerTitle: true,
            backgroundColor: Colors.white,
          ),
          body: ProfileDetailsContent(
            values: values,
          ),
        ),
      );
    else
      return MaterialApp(
        debugShowCheckedModeBanner: false,
        home: Scaffold(
            appBar: AppBar(
              title: Text(
                'Profile utilisateur',
                style: TextStyle(color: Colors.black),
              ),
              centerTitle: true,
              backgroundColor: Colors.white,
            ),
            body: ContentProfile()),
      );
  }
}

class ContentProfile extends StatefulWidget {
  @override
  _ContentProfileState createState() => _ContentProfileState();
}

class _ContentProfileState extends State<ContentProfile> {
  final DocumentSnapshot values;
  _ContentProfileState({this.values});
  var myControllerMatricule = TextEditingController();
  var myControllerNom = TextEditingController();
  var myControllerTel = TextEditingController();
  var myControllerEmail = TextEditingController();
  var myControllerCalendar = TextEditingController();
  var myControllerWork = TextEditingController();

  FirebaseAuth auth = FirebaseAuth.instance;
  @override
  Widget build(BuildContext context) {
    // if (widget.values.data() != null) {
    //   myControllerMatricule.text = widget.values.data()['matricule'] != null
    //       ? "${widget.values.data()['matricule']}"
    //       : "";
    //   myControllerNom.text = widget.values.data()['nom'] != null
    //       ? "${widget.values.data()['nom']}"
    //       : "";
    //   myControllerTel.text = widget.values.data()['tel'] != null
    //       ? "${widget.values.data()['tel']}"
    //       : "";
    //   myControllerEmail.text = widget.values.data()['email'] != null
    //       ? "${widget.values.data()['email']}"
    //       : "";
    //   myControllerCalendar.text = widget.values.data()['priseDeService'] != null
    //       ? "${widget.values.data()['priseDeService']}"
    //       : "";
    //   myControllerWork.text = widget.values.data()['fonction'] != null
    //       ? "${widget.values.data()['fonction']}"
    //       : "";
    // }
    return Scaffold(
      // appBar: AppBar(
      //   // Here we take the value from the MyHomePage object that was created by
      //   // the App.build method, and use it to set our appbar title.
      //   title: const Text("Profile utilisateur"),
      //   centerTitle: true,
      //   backgroundColor: Colors.orangeAccent,
      //   leading: IconButton(
      //     onPressed: () {
      //       Navigator.pushReplacement(context,
      //           MaterialPageRoute(builder: (context) => LoginContent()));
      //       // Navigator.pop(context);
      //     },
      //     icon: Icon(Icons.close),
      //   ),
      // ),

      body: FutureBuilder<QuerySnapshot>(
          future: FirebaseFirestore.instance
              .collection("Profile")
              .where("userId", isEqualTo: auth.currentUser.uid)
              .get(),
          builder: (context, snapshot) {
            if (snapshot != null && snapshot.data != null) {
              myControllerMatricule.text =
                  snapshot.data.docs.first.data()['matricule'];
              myControllerNom.text = snapshot.data.docs.first.data()['nom'];
              myControllerEmail.text = snapshot.data.docs.first.data()['email'];
              myControllerTel.text = snapshot.data.docs.first.data()['tel'];
              myControllerWork.text =
                  snapshot.data.docs.first.data()['fonction'];
              myControllerCalendar.text =
                  snapshot.data.docs.first.data()['priseDeService'];

              return ListView(
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
                        SharedPreferences prefs =
                            await SharedPreferences.getInstance();
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
                            matricule: myControllerMatricule.text.trim(),
                            nom: myControllerNom.text.trim(),
                            tel_domicile: myControllerTel.value.text.trim(),
                            email: myControllerEmail.text.trim(),
                            fonction: myControllerWork.text.trim(),
                            prise_service: myControllerCalendar.text.trim());
                        userProfileSetup(
                            userdetails, auth.currentUser.uid.trim());
                        print('demande d\'acte envoye');
                        // String description =
                        //     "Une nouvelle demande d'acte est en attente de validation";
                        //
                        // successDialog(context, 'Votre demande est envoyé avec succès');
                        // callOnFcmApiSendPushNotifications(userToken, description);
                        Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (context) => LoginContent()));
                        // print(_demandeacte.toString());
                      },
                    ),
                  ),
                ],
              );
            } else {
              return Center(
                child: CircularProgressIndicator(),
              );
            }
          }),
    );
  }
}
