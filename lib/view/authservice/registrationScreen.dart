import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:rh_mef/constantes.dart';
import 'package:rh_mef/main.dart';

// class RegistrationScreenFul extends StatefulWidget {
//   @override
//   _RegistrationScreenState createState() => _RegistrationScreenState();
// }
//
// class _RegistrationScreenState extends State<RegistrationScreen> {
//   @override
//   Widget build(BuildContext context) {
//     return Container();
//   }
// }

class RegistrationScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // FirebaseAuth.instance.authStateChanges().listen((User user) {
    //   if (user == null) {
    return Scaffold(
        appBar: AppBar(
          title: Center(
            child: Text(
              'Inscription',
              textAlign: TextAlign.center,
            ),
          ),
          leading: IconButton(
            onPressed: () {
              Navigator.pushReplacement(
                  context, MaterialPageRoute(builder: (context) => MyApp()));
            },
            icon: Icon(Icons.arrow_back),
          ),
        ),
        body: RegistrationContent());
    //   } else {
    //     print('User is signed in!');
    //     Navigator.pushReplacement(
    //         context, MaterialPageRoute(builder: (context) => MyApp()));
    //   }
    // });
    return Container();
  }
}

class RegistrationContent extends StatefulWidget {
  @override
  _RegistrationContentState createState() => _RegistrationContentState();
}

class _RegistrationContentState extends State<RegistrationContent> {
  var nameController = TextEditingController();
  var passwordController = TextEditingController();
  var matriculeController = TextEditingController();
  var designationController = TextEditingController();
  var numeroController = TextEditingController();
  var datePriseServiceController = TextEditingController();
  var fonctionController = TextEditingController();
  var emailController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: EdgeInsets.all(10),
        child: ListView(
          children: <Widget>[
            Container(
                alignment: Alignment.center,
                padding: EdgeInsets.all(10),
                child: Text(
                  'INSCRIPTION',
                  style: TextStyle(
                      color: Colors.orange,
                      fontWeight: FontWeight.w500,
                      fontSize: 30),
                )),
            Container(
              padding: EdgeInsets.all(10),
              child: TextField(
                controller: matriculeController,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Matricule',
                ),
              ),
            ),
            Container(
              padding: EdgeInsets.all(10),
              child: TextField(
                controller: designationController,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Nom et Prénoms',
                ),
              ),
            ),
            Container(
              padding: EdgeInsets.all(10),
              child: TextField(
                keyboardType: TextInputType.number,
                controller: numeroController,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Numéro de téléphone',
                ),
              ),
            ),
            Container(
              padding: EdgeInsets.all(10),
              child: TextField(
                controller: datePriseServiceController,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Date de prise de service',
                ),
              ),
            ),
            Container(
              padding: EdgeInsets.all(10),
              child: TextField(
                controller: fonctionController,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Fonction',
                ),
              ),
            ),
            Container(
              padding: EdgeInsets.all(10),
              child: TextField(
                controller: emailController,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'E-mail',
                ),
              ),
            ),
            Container(
              padding: EdgeInsets.fromLTRB(10, 10, 10, 0),
              child: TextField(
                obscureText: true,
                controller: passwordController,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Mot de passe',
                ),
              ),
            ),
            Container(
              height: 50,
              padding: EdgeInsets.fromLTRB(10, 10, 10, 0),
              child: TextButton(
                onPressed: () async {
                  //create new user
                  try {
                    //TODO: fETCH DATA of matricule to see if its match with the matricule inside the database
                    //Assign accountType according to the matricule
                    String accountType = "public";
                    Constants.listMatricules.forEach((element) {
                      if (element == matriculeController.text) {
                        accountType = "agent";
                      }
                    });
                    registrationWithAccountType(
                      accountType: "$accountType",
                      email: emailController.text.trim(),
                      password: passwordController.text,
                      matricule: matriculeController.text.trim(),
                      nom: designationController.text.trim(),
                      priseService: datePriseServiceController.text.trim(),
                      tel: numeroController.text.trim(),
                      fonction: fonctionController.text.trim(),
                    );
                  } on FirebaseAuthException catch (e) {
                    if (e.code == 'weak-password') {
                      print('The password provided is too weak.');
                      showDialogue("Mot de passe faible");
                    } else if (e.code == 'email-already-in-use') {
                      print('The account already exists for that email.');
                      showDialogue("Mot de passe existe deja");
                    }
                  } catch (e) {
                    print(e);
                    showDialogue(e.toString());
                  }
                  // FirebaseAuth auth = FirebaseAuth.instance;
                  //
                  // FirebaseFirestore.instance
                  //     .collection("Profile")
                  //     .doc(auth.currentUser.uid)
                  //     .set({
                  //   "email": '',
                  //   "matricule": '',
                  //   "nom": '',
                  //   "priseDeService": '',
                  //   "tel": '',
                  //   "fonction": '',
                  //   "userId": '${auth.currentUser.uid}',
                  //   "token": '',
                  // });
                  Navigator.pushReplacement(context,
                      MaterialPageRoute(builder: (context) => MyApp()));
                },
                style: TextButton.styleFrom(
                    primary: Colors.white, backgroundColor: Colors.orange),
                child: Text(
                  'Confirmer',
                  style: TextStyle(fontSize: 16),
                ),
              ),
            ),
          ],
        ));
  }

  registrationWithAccountType({
    String accountType,
    String email,
    String password,
    String matricule,
    String nom,
    String priseService,
    String tel,
    String fonction,
  }) async {
    await FirebaseMessaging.instance.getToken().then((value) async {
      try {
        UserCredential userCredential = await FirebaseAuth.instance
            .createUserWithEmailAndPassword(
                email: "${email}", password: "${password}");
        if (userCredential != null)
          FirebaseFirestore.instance
              .collection("Profile")
              .doc(userCredential.user.uid)
              .set({
            "email": email,
            'accountType': accountType,
            "matricule": matricule,
            "nom": nom,
            "priseDeService": priseService,
            "tel": tel,
            "fonction": fonction,
            "userId": '${userCredential.user.uid}',
            "token": value,
          });
      } on FirebaseAuthException catch (e) {
        if (e.code == 'weak-password') {
          print('The password provided is too weak.');
          showDialogue("Mot de passe faible");
        } else if (e.code == 'email-already-in-use') {
          print('The account already exists for that email.');
          showDialogue("Mot de passe existe deja");
        }
      } catch (e) {
        print(e);
        showDialogue(e.toString());
      }
    });
  }

  showDialogue(String content) {
    return showDialog<void>(
        context: context,
        barrierDismissible: true, // user must tap button!
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Alerte'),
            elevation: 2,
            content: Text("$content"),
            actions: <Widget>[
              TextButton(
                child: Text(""),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        });
  }
}
