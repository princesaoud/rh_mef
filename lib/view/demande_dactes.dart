import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:rh_mef/constantes.dart';

// void main() => runApp(MyApp());

/// This is the main application widget.
// ignore: camel_case_types
class Demande_Actes extends StatelessWidget {
  static const String _title = 'Flutter Code Sample';

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: _title,
      home: Scaffold(
        appBar: AppBar(
          // Here we take the value from the MyHomePage object that was created by
          // the App.build method, and use it to set our appbar title.
          title: const Text("Demande d'acte"),
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

/// This is the stateful widget that the main application instantiates.
class MyStatefulWidget extends StatefulWidget {
  MyStatefulWidget({Key key}) : super(key: key);

  @override
  _MyStatefulWidgetState createState() => _MyStatefulWidgetState();
}

/// This is the private State class that goes with MyStatefulWidget.
class _MyStatefulWidgetState extends State<MyStatefulWidget> {
  final myControllerDesignation = TextEditingController();
  final myControllerNumber = TextEditingController();
  final myControllerEmail = TextEditingController();
  final myControllerObservation = TextEditingController();
  String _currentValueSelected = "";
  Widget build(BuildContext context) {
    return ListView(
      children: <Widget>[
        new ListTile(
          leading: const Icon(Icons.person),
          title: new TextField(
            decoration: new InputDecoration(
              hintText: "Matricule",
            ),
          ),
        ),
        new ListTile(
          leading: const Icon(Icons.person),
          title: new TextField(
            decoration: new InputDecoration(
              hintText: "Nom et Prénoms",
            ),
          ),
        ),
        new ListTile(
          leading: const Icon(Icons.phone),
          title: new TextField(
            decoration: new InputDecoration(
              hintText: "Telephone",
            ),
          ),
        ),
        new ListTile(
          leading: const Icon(Icons.email),
          title: new TextField(
            decoration: new InputDecoration(
              hintText: "Email",
            ),
          ),
        ),
        new ListTile(
          onTap: () {
            _showMyDialog();
          },
          leading: const Icon(Icons.date_range),
          title: Text("Date de prise de service (MEF)"),
        ),
        new ListTile(
          leading: const Icon(Icons.person_outline_sharp),
          title: new TextField(
            decoration: new InputDecoration(
              hintText: "Emploi DD",
            ),
          ),
        ),
        new ListTile(
          leading: const Icon(Icons.person),
          title: new TextField(
            decoration: new InputDecoration(
              hintText: "Nature de l'acte DD",
            ),
          ),
        ),
        new ListTile(
          leading: const Icon(Icons.photo_camera_outlined),
          title: new TextField(
            decoration: new InputDecoration(
              hintText: "Piece jointe",
            ),
          ),
        ),
        ListTile(
          leading: Icon(Icons.message_rounded),
          title: DropdownButton(
            items: <String>['A', 'B', 'C', 'D'].map((String value) {
              return DropdownMenuItem<String>(
                onTap: () {
                  _currentValueSelected = value;
                  print(_currentValueSelected);
                },
                value: _currentValueSelected,
                child: new Text(value),
              );
            }).toList(),
            onChanged: (value) {
              _currentValueSelected = value;
            },
          ),
        ),
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
            onPressed: () {},
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
    // String Demande_ActesType =
    //     _character.toString().substring(_character.toString().indexOf('.') + 1);
    // String observation = myControllerObservation.text;
    // userSetup(designation, number, email, Demande_ActesType, observation);
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

  Future<void> _showMyDialog() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(Constants.choisirDate),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Container(
                  height: 200,
                  child: CupertinoDatePicker(
                    mode: CupertinoDatePickerMode.date,
                    initialDateTime: DateTime(2012, 1, 1),
                    onDateTimeChanged: (DateTime newDateTime) {
                      // Do something
                      print(newDateTime);
                    },
                  ),
                ),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text(Constants.valider),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
