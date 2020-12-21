import 'package:commons/commons.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:rh_mef/net/firebase.dart';

// void main() => runApp(MyApp());

/// This is the main application widget.
class Complaint extends StatelessWidget {
  static const String _title = 'Flutter Code Sample';

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          // Here we take the value from the MyHomePage object that was created by
          // the App.build method, and use it to set our appbar title.
          title: const Text("Faire une plainte ou suggestion"),
          centerTitle: true,
          backgroundColor: Colors.orangeAccent,
          leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: Icon(Icons.arrow_back),
          ),
        ),
        body: Center(
          child: MyStatefulWidget(),
        ),
      ),
    );
  }
}

enum SingingCharacter { plainte, suggestion }

/// This is the stateful widget that the main application instantiates.
class MyStatefulWidget extends StatefulWidget {
  MyStatefulWidget({Key key}) : super(key: key);

  @override
  _MyStatefulWidgetState createState() => _MyStatefulWidgetState();
}

/// This is the private State class that goes with MyStatefulWidget.
class _MyStatefulWidgetState extends State<MyStatefulWidget> {
  SingingCharacter _character = SingingCharacter.plainte;
  final myControllerDesignation = TextEditingController();
  final myControllerNumber = TextEditingController();
  final myControllerEmail = TextEditingController();
  final myControllerObservation = TextEditingController();

  Widget build(BuildContext context) {
    return ListView(
      children: <Widget>[
        new ListTile(
          leading: const Icon(Icons.person),
          title: new TextField(
            controller: myControllerDesignation,
            decoration: new InputDecoration(
              hintText: "Designation",
            ),
          ),
        ),
        new ListTile(
          leading: const Icon(Icons.phone),
          title: new TextField(
            controller: myControllerNumber,
            decoration: new InputDecoration(
              hintText: "Contact",
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
        const Divider(
          height: 1.0,
        ),
        ListTile(
          title: const Text('Plainte'),
          leading: Radio(
            value: SingingCharacter.plainte,
            groupValue: _character,
            onChanged: (SingingCharacter value) {
              setState(() {
                _character = value;
              });
            },
          ),
        ),
        ListTile(
          title: const Text('Suggestion'),
          leading: Radio(
            value: SingingCharacter.suggestion,
            groupValue: _character,
            onChanged: (SingingCharacter value) {
              setState(() {
                _character = value;
              });
            },
          ),
        ),
        const Divider(
          height: 2.0,
        ),
        ListTile(
          title: TextFormField(
            controller: myControllerObservation,
            maxLines: 3,
            minLines: 2,
            textInputAction: TextInputAction.done,
            decoration: InputDecoration(labelText: 'Observation'),
          ),
        ),
        ListTile(
          title: FlatButton(
            color: Colors.orange,
            padding: EdgeInsets.all(10.0),
            child: Text(
              "Valider",
              style: TextStyle(fontSize: 20.0),
            ),
            onPressed: () {
              String designation = myControllerDesignation.text.isNotEmpty
                  ? myControllerDesignation.text
                  : 'N/A';
              String number = myControllerNumber.text.isNotEmpty
                  ? myControllerNumber.text
                  : 'N/A';
              String email = myControllerEmail.text.isNotEmpty
                  ? myControllerEmail.text
                  : 'N/A';
              String complaintType = _character
                  .toString()
                  .substring(_character.toString().indexOf('.') + 1);
              String observation = myControllerObservation.text;
              if (observation.isEmpty) {
                print('Observation need to be fill');
                warningDialog(
                    context, "Attention veuillez ecrire votre observation");
              } else {
                userSetup(
                        designation, number, email, complaintType, observation)
                    .then((value) {
                  successDialog(
                      context, "Votre demande a été envoyé avec succes");
                  myControllerDesignation.text = "";
                  myControllerNumber.text = "";
                  myControllerEmail.text = "";
                  myControllerObservation.text = "";
                  _character = SingingCharacter.plainte;
                });
              }
            },
          ),
        ),
      ],
    );
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
