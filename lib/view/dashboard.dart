import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:rh_mef/custom_drawer/drawer_user_controller.dart';
import 'package:rh_mef/custom_drawer/home_drawer.dart';
import 'package:rh_mef/view/authservice/profiledetails.dart';
import 'package:rh_mef/view/complaint/complaint.dart';
import 'package:rh_mef/view/demandeacte/demande_dactes.dart';
import 'package:rh_mef/view/retraite/retraiteProcedure.dart';

import '../app_theme.dart';

class Dashboard extends StatefulWidget {
  @override
  _DashboardState createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  Widget screenView;
  DrawerIndex drawerIndex;
  final FirebaseAuth auth = FirebaseAuth.instance;

  @override
  void initState() {
    drawerIndex = DrawerIndex.Acceuil;
    screenView = DashboardContent();
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
          screenView = DashboardContent();
        });
      } else if (drawerIndex == DrawerIndex.Retraite) {
        setState(() {
          screenView = RetraiteProccedure();
        });
      } else if (drawerIndex == DrawerIndex.Demande) {
        setState(() {
          screenView = DemandeActes();
        });
      } else if (drawerIndex == DrawerIndex.Temoigngage) {
        setState(() {
          screenView = Complaint();
        });
      } else if (drawerIndex == DrawerIndex.Profile) {
        screenView = ProfileDetails();
      } else {
        //do in your way......
      }
    }
  }
}

class DashboardContent extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(backgroundColor: Colors.white, body: homeContent());
  }

  Widget homeContent() {
    return SafeArea(
        child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.all(12.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              // IconButton(
              //   icon: Icon(
              //     Icons.menu,
              //     color: Colors.black,
              //     size: 52.0,
              //   ),
              //   onPressed: () {},
              // ),
              SizedBox(
                width: 100,
              ),
              Image.asset(
                "assets/images/logo.png",
                width: 52.0,
              )
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(18.0),
          child: Text(
            "Bienvenu, Doctor code \nChoisissez une option",
            style: TextStyle(
                color: Colors.black,
                fontSize: 28.0,
                fontWeight: FontWeight.bold),
            textAlign: TextAlign.start,
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(12.0),
          child: Center(
            child: Wrap(
              spacing: 20,
              runSpacing: 20.0,
              children: <Widget>[
                SizedBox(
                  width: 160.0,
                  height: 160.0,
                  child: Card(
                    color: Colors.grey[300],
                    elevation: 2.0,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.0)),
                    child: Center(
                        child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        children: <Widget>[
                          Image.asset(
                            "assets/images/todo.png",
                            width: 64.0,
                          ),
                          SizedBox(
                            height: 10.0,
                          ),
                          Text(
                            "Temoignage",
                            style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                                fontSize: 20.0),
                          ),
                          SizedBox(
                            height: 5.0,
                          ),
                          // Text(
                          //   "2 Items",
                          //   style: TextStyle(
                          //       color: Colors.black,
                          //       fontWeight: FontWeight.w100),
                          // )
                        ],
                      ),
                    )),
                  ),
                ),
                SizedBox(
                  width: 160.0,
                  height: 160.0,
                  child: Card(
                    color: Colors.grey[300],
                    elevation: 2.0,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.0)),
                    child: Center(
                        child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        children: <Widget>[
                          Image.asset(
                            "assets/images/note.png",
                            width: 64.0,
                          ),
                          SizedBox(
                            height: 10.0,
                          ),
                          Text(
                            "Demande d'acte",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                              fontSize: 20.0,
                            ),
                          ),
                          SizedBox(
                            height: 5.0,
                          ),
                          // Text(
                          //   "Gérer vos demandes d'actes",
                          //   style: TextStyle(
                          //       color: Colors.black,
                          //       fontWeight: FontWeight.w100),
                          // )
                        ],
                      ),
                    )),
                  ),
                ),
                SizedBox(
                  width: 160.0,
                  height: 160.0,
                  child: Card(
                    color: Colors.grey[300],
                    elevation: 2.0,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.0)),
                    child: Center(
                        child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        children: <Widget>[
                          Image.asset(
                            "assets/images/calendar.png",
                            width: 64.0,
                            color: Colors.white,
                          ),
                          SizedBox(
                            height: 10.0,
                          ),
                          Text(
                            "Retraite",
                            style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                                fontSize: 20.0),
                          ),
                          SizedBox(
                            height: 5.0,
                          ),
                          // Text(
                          //   "4 Items",
                          //   style: TextStyle(
                          //       color: Colors.black,
                          //       fontWeight: FontWeight.w100),
                          // )
                        ],
                      ),
                    )),
                  ),
                ),
                SizedBox(
                  width: 160.0,
                  height: 160.0,
                  child: Card(
                    color: Colors.grey[300],
                    elevation: 2.0,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.0)),
                    child: Center(
                        child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        children: <Widget>[
                          Image.asset(
                            "assets/images/settings.png",
                            width: 64.0,
                          ),
                          SizedBox(
                            height: 10.0,
                          ),
                          Text(
                            "Profile",
                            style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                                fontSize: 20.0),
                          ),
                          SizedBox(
                            height: 5.0,
                          ),
                          // Text(
                          //   "6 Items",
                          //   style: TextStyle(
                          //       color: Colors.black,
                          //       fontWeight: FontWeight.w100),
                          // )
                        ],
                      ),
                    )),
                  ),
                ),
              ],
            ),
          ),
        )
      ],
    ));
  }
}
