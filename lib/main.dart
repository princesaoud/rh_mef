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
import 'package:rh_mef/view/retraiteProcedure.dart';
import 'package:twilio_flutter/twilio_flutter.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  //TODO: Background task initialization and setup
  // Workmanager.initialize(
  //     callbackDispatcher, // The top level function, aka callbackDispatcher
  //     isInDebugMode:
  //         true // If enabled it will post a notification whenever the task is running. Handy for debugging tasks
  //     );
  // Workmanager.registerPeriodicTask(
  //   "2",
  //   "simplePeriodicTask",
  //   // When no frequency is provided the default 15 minutes is set.
  //   // Minimum frequency is 15 min. Android will automatically change your frequency to 15 min if you have configured a lower frequency.
  //   frequency: Duration(seconds: 5),
  // );
  await Firebase.initializeApp();
  FirebaseMessaging().getToken().then((token) async {
    await FirebaseFirestore.instance
        .collection("tokens")
        .doc(token)
        .set({'token': token});
  });
  runApp(MyApp());
}

// void callbackDispatcher() {
//   Workmanager.executeTask((task, inputData) {
//     print("Native called background task: "); //simpleTask will be emitted here.
//     return Future.value(true);
//   });
// }

// ignore: must_be_immutable
class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'DRHMEF ONLINE',
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
  TwilioFlutter twilioFlutter;

  @override
  void initState() {
    // WidgetsBinding.instance.addPostFrameCallback(_openDrawer);

    twilioFlutter = TwilioFlutter(
        accountSid: 'AC4cb8ad07e86ad04b7cd18a2737796b3d',
        authToken: '9c1202163f062c18f0b29a2e3a4a7e30',
        twilioNumber: '+14103767481');
    super.initState();

    var androidInitilize =
        new AndroidInitializationSettings('@mipmap/ic_launcher');
    var iOSinitilize = IOSInitializationSettings(
        onDidReceiveLocalNotification: onDidReceiveLocalNotification);
    var initilizationsSettings = new InitializationSettings(
        android: androidInitilize, iOS: iOSinitilize);
    flutterLocalNotificationsPlugin = new FlutterLocalNotificationsPlugin();
    flutterLocalNotificationsPlugin.initialize(initilizationsSettings,
        onSelectNotification: notificationSelected);

    if (Platform.isAndroid) {
      print('android platform');
      firebaseCloudMessagingListeners();
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

  Future _showNotification(
      int id, String channelName, String description) async {
    print(description);
    const AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails(
            'channelId', 'channelName', 'channelDescription',
            importance: Importance.max,
            priority: Priority.high,
            showWhen: false);
    const NotificationDetails platformChannelSpecifics =
        NotificationDetails(android: androidPlatformChannelSpecifics);
    await flutterLocalNotificationsPlugin.show(
        id, 'plain title', '$description', platformChannelSpecifics,
        payload: 'item x');
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  void firebaseCloudMessagingListeners() {
    _firebaseMessaging.configure(
      onMessage: (Map<String, dynamic> message) async {
        print('on message $message');
        _showNotification(1, 'onMessage', 'xyz');
        return;
      },
      onResume: (Map<String, dynamic> message) async {
        print('on resume $message');
        await _showNotification(2, 'onResume', 'efg');
      },
      onLaunch: (Map<String, dynamic> message) async {
        print('on launch $message');
        await _showNotification(3, 'onLaunch', message['data']);
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
                      title: Text(Constants.retraite),
                      leading: Icon(Icons.assistant),
                      onTap: () {
                        // Update the state of the app
                        // ...
                        // Then close the drawer
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (context) => RetraiteProccedure()),
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
                        //   MaterialPageRoute(
                        //       builder: (context) => StatutsDemande()),
                        // );
                        // sendSms();
                        _showNotification(1, 'abc', 'efg');
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
