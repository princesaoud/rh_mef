import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:rh_mef/constantes.dart';
import 'package:rh_mef/view/complaint.dart';
import 'package:rh_mef/view/demande_dactes.dart';
import 'package:rh_mef/view/detailsInformation.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  // await Firebase.initializeApp();
  print("main method called");
  runApp(MyApp());
}

// ignore: must_be_immutable
class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'RHMEF ONLINE',
      theme: ThemeData(
        primarySwatch: Colors.orange,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyHomePage(title: 'DRH MEF ONLINE '),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);
  final String title;
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging();
  final GlobalKey<ScaffoldState> _drawerKey = GlobalKey();
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;

  @override
  void initState() {
    // WidgetsBinding.instance.addPostFrameCallback(_openDrawer);
    super.initState();

    var androidInitilize = new AndroidInitializationSettings('ic_launcher');
    var iOSinitilize = IOSInitializationSettings(
        onDidReceiveLocalNotification: onDidReceiveLocalNotification);
    var initilizationsSettings = new InitializationSettings(
        android: androidInitilize, iOS: iOSinitilize);
    flutterLocalNotificationsPlugin = new FlutterLocalNotificationsPlugin();
    flutterLocalNotificationsPlugin.initialize(initilizationsSettings,
        onSelectNotification: notificationSelected);

    if (Platform.isAndroid) {
      firebaseCloudMessaging_Listeners();
    }
  }

  Future onDidReceiveLocalNotification(
      int id, String title, String body, String payload) async {
    // display a dialog with the notification details, tap ok to go to another page
    showDialog(
      context: context,
      builder: (BuildContext context) => CupertinoAlertDialog(
        title: Text(title),
        content: Text(body),
        actions: [
          CupertinoDialogAction(
            isDefaultAction: true,
            child: Text('Ok'),
            onPressed: () async {
              Navigator.of(context, rootNavigator: true).pop();
              await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => MyApp(),
                ),
              );
            },
          )
        ],
      ),
    );
  }

  Future notificationSelected(String payload) async {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        content: Text("Notification Clicked $payload"),
      ),
    );
  }

  @override
  void didUpdateWidget(covariant MyHomePage oldWidget) {
    // TODO: implement didUpdateWidget
    super.didUpdateWidget(oldWidget);
  }

  Future _showNotification() async {
    const AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails(
            'your channel id', 'your channel name', 'your channel description',
            importance: Importance.max,
            priority: Priority.high,
            showWhen: false);
    const NotificationDetails platformChannelSpecifics =
        NotificationDetails(android: androidPlatformChannelSpecifics);
    await flutterLocalNotificationsPlugin.show(
        0, 'plain title', 'plain body', platformChannelSpecifics,
        payload: 'item x');
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    print("dispose called");
    FirebaseFirestore.instance
        .collection("ActeDemand")
        .get()
        .then((querySnapshot) => {
              querySnapshot.docs.forEach((element) {
                bool isNotification = element.data()['isNotification'];
                if (isNotification != null && isNotification == true) {
                  print('Notification should be call here');
                  _showNotification();
                }
                print('isNotification $isNotification');
              })
            });
  }

  void firebaseCloudMessaging_Listeners() {
    _firebaseMessaging.getToken().then((token) {
      // print("token of the device is : $token");
    });

    _firebaseMessaging.configure(
      onMessage: (Map<String, dynamic> message) async {
        print('on message $message');
      },
      onResume: (Map<String, dynamic> message) async {
        print('on resume $message');
      },
      onLaunch: (Map<String, dynamic> message) async {
        print('on launch $message');
      },
    );
  }

  // void _onItemTapped(int index) {
  //   setState(() {
  //     _selectedIndex = index;
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return FutureBuilder(
      future: Firebase.initializeApp(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          return Scaffold(
            appBar: AppBar(
              // Here we take the value from the MyHomePage object that was created by
              // the App.build method, and use it to set our appbar title.
              title: const Text('DRH MEF ONLINE'),
              centerTitle: true,
            ),
            body: DetailsInformations(),
            drawer: Drawer(
              key: _drawerKey,
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.orangeAccent,
                ),
                child: ListView(
                  padding: EdgeInsets.zero,
                  children: [
                    DrawerHeader(
                      child: Text(''),
                      decoration: BoxDecoration(
                        image: DecorationImage(
                            image: AssetImage("assets/images/logo.png"),
                            fit: BoxFit.fill),
                        color: Colors.orange,
                      ),
                    ),
                    ListTile(
                      title: Text(Constants.accueil),
                      leading: Icon(Icons.home),
                      onTap: () {
                        // Update the state of the app
                        // ...
                        // Then close the drawer
                        // Navigator.push(
                        //   context,
                        //   MaterialPageRoute(
                        //       builder: (context) => DetailsInformations()),
                        // );

                        Navigator.pop(context);
                      },
                    ),
                    ListTile(
                      title: Text(Constants.suggestion),
                      leading: Icon(Icons.message),
                      onTap: () {
                        // Update the state of the app
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => Complaint()),
                        );
                        // Then close the drawer
                        // Navigator.pop(context);
                      },
                    ),
                    ListTile(
                      title: Text(Constants.dmd_act),
                      leading: Icon(Icons.email),
                      onTap: () {
                        // Update the state of the app
                        // ...
                        // Then close the drawer
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (context) => Demande_Actes()),
                        );
                        // Navigator.pop(context);
                      },
                    ),
                    ListTile(
                      title: Text(Constants.infos),
                      leading: Icon(Icons.info),
                      onTap: () {
                        // Update the state of the app
                        // ...
                        // Then close the drawer
                        // Navigator.push(
                        //   context,
                        //   MaterialPageRoute(builder: (context) => SelectFileSys()),
                        // );
                        _showNotification();
                        Navigator.pop(context);
                      },
                    ),
                  ],
                ),
              ),
            ),
          );
        }
        return CircularProgressIndicator();
      },
    );
  }
}
