import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:commons/commons.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:rh_mef/constantes.dart';
import 'package:rh_mef/net/firebase.dart';
import 'package:rh_mef/view/complaint.dart';
import 'package:rh_mef/view/demande_dactes.dart';
import 'package:rh_mef/view/detailsInformation.dart';
import 'package:rh_mef/view/retraiteProcedure.dart';
import 'package:twilio_flutter/twilio_flutter.dart';

Future<dynamic> myBackgroundMessageHandler(Map<String, dynamic> message) async {
  if (message.containsKey('data')) {
    // Handle data message
    final dynamic data = message['data'];

    print('mybackgroundHandler $data');
  }

  if (message.containsKey('notification')) {
    // Handle notification message
    final dynamic notification = message['notification'];
    print('mybackgroundHandler $notification');
  }

  // Or do other work.
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // SharedPreferences prefs = await SharedPreferences.getInstance();
  // if (prefs.getString('login') == null || prefs.getString('login') != '') {
  //   runApp(LoginPage());
  // } else {
  //   // runApp(MyApp());
  // }
  await Firebase.initializeApp();

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
      home: LoginContent(),
    );
  }
}

Future<dynamic> _onBackgroundMessage(Map<String, dynamic> message) async {
  debugPrint('On background message $message');
  return Future<void>.value();
}

class LoginContent extends StatefulWidget {
  @override
  _LoginContentState createState() => _LoginContentState();
}

class _LoginContentState extends State<LoginContent> {
  TextEditingController nameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging();
  final GlobalKey<ScaffoldState> _drawerKey = GlobalKey();
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;
  TwilioFlutter twilioFlutter;

  getStatutsUser() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    final String userdata = sharedPreferences.getString('userdata');
    return userdata;
  }

  @override
  void initState() {
    super.initState();
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
    // showDialog(
    //   context: context,
    //   builder: (context) => AlertDialog(
    //     content: Text("Notification Clicked $payload"),
    //   ),
    // );
  }

  Future _showNotification(String title, String description) async {
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
        1, '$title', '$description', platformChannelSpecifics,
        payload: 'item x');
  }

  void firebaseCloudMessagingListeners() {
    _firebaseMessaging.configure(
      onBackgroundMessage: _onBackgroundMessage,
      onMessage: (Map<String, dynamic> message) async {
        String title = message['notification']['title'];
        print("onMessage: ${title}");

        await _showNotification(message['notification']['title'],
            message['notification']['description']);
      },
      onLaunch: (Map<String, dynamic> message) async {
        print("onLaunch: $message");
        await _showNotification('onResume', 'efg');
      },
      onResume: (Map<String, dynamic> message) async {
        print("onResume: $message");
        await _showNotification('onLaunch', message['data']);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: getStatutsUser(),
        builder: (BuildContext context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.waiting:
              return Center(
                child: Center(child: CircularProgressIndicator()),
              );
            case ConnectionState.done:
              print('connection state : ${snapshot.data}');
              if (snapshot.data != null) {
                return homelogin(context);
              }
              return loginuserview(context);
              break;
            case ConnectionState.none:
              // TODO: Handle this case.
              break;
            case ConnectionState.active:
              // TODO: Handle this case.
              break;
          }
          return Text('');
        });
  }

  Widget loginuserview(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(
          child: Text(
            'Login Page',
            textAlign: TextAlign.center,
          ),
        ),
      ),
      body: Padding(
          padding: EdgeInsets.all(10),
          child: ListView(
            children: <Widget>[
              Container(
                  alignment: Alignment.center,
                  padding: EdgeInsets.all(10),
                  child: Text(
                    'DRH/MEF',
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
                    labelText: 'Matricule',
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
              FlatButton(
                onPressed: () {
                  //forgot password screen
                },
                textColor: Colors.blue,
                child: Text('Mot de passe oublié'),
              ),
              Container(
                  height: 50,
                  padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                  child: TextButton(
                    style: TextButton.styleFrom(
                        primary: Colors.white, backgroundColor: Colors.orange),
                    child: Text('Se Connecter'),
                    onPressed: () async {
                      String matricule = nameController.text;
                      String password = passwordController.text;
                      bool result = await getLoginAgent([matricule, password]);

                      if (result == false) {
                        // print(result);
                        errorDialog(context,
                            'Erreur d\'authentification Matricule ou mot de passe erroné.');
                      } else {
                        Navigator.pushReplacement(context,
                            MaterialPageRoute(builder: (context) => MyApp()));
                      }
                      // print(nameController.text);
                      // print(passwordController.text);
                    },
                  )),
              // Container(
              //     child: Row(
              //   children: <Widget>[
              //     Text('Does not have account?'),
              //     FlatButton(
              //       textColor: Colors.blue,
              //       child: Text(
              //         'S\'inscrire',
              //         style: TextStyle(fontSize: 20),
              //       ),
              //       onPressed: () {
              //         //signup screen
              //       },
              //     )
              //   ],
              //   mainAxisAlignment: MainAxisAlignment.center,
              // ))
            ],
          )),
    );
  }

  Widget homelogin(BuildContext context) {
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
                child: Column(
                  children: [
                    Expanded(
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
                          Divider(
                            thickness: 2,
                          ),
                          ListTile(
                            title: Text(Constants.suggestion),
                            leading: Icon(Icons.message),
                            onTap: () {
                              // Update the state of the app
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => Complaint()),
                              );
                              // Then close the drawer
                              // Navigator.pop(context);
                            },
                          ),
                          Divider(
                            thickness: 2,
                          ),
                          ListTile(
                            title: Text(Constants.dmd_act),
                            leading: Icon(Icons.insert_drive_file),
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
                          Divider(
                            thickness: 2,
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
                          Divider(
                            thickness: 2,
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
                              // _showNotification('abc', 'efg');
                              createNewDemandeActe([
                                'Motif is the motivation',
                                'Nature Acte',
                                'the piece jointe link'
                              ]);
                            },
                          ),
                          Divider(
                            thickness: 2,
                          ),
                        ],
                      ),
                    ),
                    Container(
                        child: TextButton(
                      style: ButtonStyle(
                        backgroundColor:
                            MaterialStateProperty.all<Color>(Colors.red),
                      ),
                      onPressed: () async {
                        SharedPreferences sharedPreferences =
                            await SharedPreferences.getInstance();
                        print('logout button clicked');
                        sharedPreferences.clear();
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => MyApp()),
                        );
                      },
                      child: Row(
                        children: [
                          Icon(
                            Icons.highlight_off,
                            color: Colors.white,
                          ),
                          Expanded(
                            child: Text(
                              "Deconnecter",
                              style: TextStyle(color: Colors.white),
                              textAlign: TextAlign.center,
                            ),
                          )
                        ],
                      ),
                    ))
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
    // showDialog(
    //   context: context,
    //   builder: (context) => AlertDialog(
    //     content: Text("Notification Clicked $payload"),
    //   ),
    // );
  }

  Future _showNotification(String title, String description) async {
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
        1, '$title', '$description', platformChannelSpecifics,
        payload: 'item x');
  }

  void firebaseCloudMessagingListeners() {
    _firebaseMessaging.configure(
      onMessage: (Map<String, dynamic> message) async {
        String title = message['notification']['title'];
        print("onMessage: ${title}");

        await _showNotification(message['notification']['title'],
            message['notification']['description']);
      },
      onBackgroundMessage: myBackgroundMessageHandler,
      onLaunch: (Map<String, dynamic> message) async {
        print("onLaunch: $message");
        await _showNotification('onResume', 'efg');
      },
      onResume: (Map<String, dynamic> message) async {
        print("onResume: $message");
        await _showNotification('onLaunch', message['data']);
      },
    );
  }

  @override
  void didUpdateWidget(covariant MyHomePage oldWidget) {
    // TODO: implement didUpdateWidget
    super.didUpdateWidget(oldWidget);
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
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
                child: Column(
                  children: [
                    Expanded(
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
                          Divider(
                            thickness: 2,
                          ),
                          ListTile(
                            title: Text(Constants.suggestion),
                            leading: Icon(Icons.message),
                            onTap: () {
                              // Update the state of the app
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => Complaint()),
                              );
                              // Then close the drawer
                              // Navigator.pop(context);
                            },
                          ),
                          Divider(
                            thickness: 2,
                          ),
                          ListTile(
                            title: Text(Constants.dmd_act),
                            leading: Icon(Icons.insert_drive_file),
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
                          Divider(
                            thickness: 2,
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
                          Divider(
                            thickness: 2,
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
                              // _showNotification('abc', 'efg');
                            },
                          ),
                          Divider(
                            thickness: 2,
                          ),
                        ],
                      ),
                    ),
                    Container(
                        child: TextButton(
                      style: ButtonStyle(
                        backgroundColor:
                            MaterialStateProperty.all<Color>(Colors.red),
                      ),
                      onPressed: () {
                        print('logout button clicked');
                      },
                      child: Row(
                        children: [
                          Icon(
                            Icons.highlight_off,
                            color: Colors.white,
                          ),
                          Expanded(
                            child: Text(
                              "Deconnecter",
                              style: TextStyle(color: Colors.white),
                              textAlign: TextAlign.center,
                            ),
                          )
                        ],
                      ),
                    ))
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
