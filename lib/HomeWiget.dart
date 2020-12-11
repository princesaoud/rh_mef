import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class HomeWiget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MyStatefulWidgetHome();
  }
}

class MyStatefulWidgetHome extends StatefulWidget {
  @override
  _MyStatefulWidgetHomeState createState() => _MyStatefulWidgetHomeState();
}

FirebaseMessaging _firebaseMessaging = FirebaseMessaging();

@override
void initState() {
  // super.initState();
  firebaseCloudMessaging_Listeners();
}

void firebaseCloudMessaging_Listeners() {
  _firebaseMessaging.getToken().then((token) {
    print("Token $token");
  });
}

class _MyStatefulWidgetHomeState extends State<MyStatefulWidgetHome> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Scaffold(
        body: Container(
          padding: EdgeInsets.fromLTRB(10, 10, 10, 0),
          height: 120,
          width: double.maxFinite,
          child: Card(
            child: ListTile(
              leading: FlutterLogo(size: 80.0),
              title: Text('RHMEF NEWS '),
              subtitle:
                  Text('A sufficiently long subtitle warrants three lines.'),
              // trailing: Icon(Icons.more_vert),
              isThreeLine: false,
            ),
          ),
        ),
      ),
    );
  }
}
