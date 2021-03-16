import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:rh_mef/main.dart';

class RegistrationScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    FirebaseAuth.instance.authStateChanges().listen((User user) {
      if (user == null) {
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
                  Navigator.pushReplacement(context,
                      MaterialPageRoute(builder: (context) => MyApp()));
                },
                icon: Icon(Icons.arrow_back),
              ),
            ),
            body: RegistrationContent());
      } else {
        print('User is signed in!');
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => MyApp()));
      }
    });
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
                controller: nameController,
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
                    UserCredential userCredential = await FirebaseAuth.instance
                        .createUserWithEmailAndPassword(
                            email: "${nameController.text}",
                            password: "${passwordController.text}");
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
                  }
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
