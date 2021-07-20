import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:commons/commons.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:provider/provider.dart';
import 'package:rh_mef/net/authentication_service.dart';
import 'package:rh_mef/view/authservice/agent/agentlogin.dart';
import 'package:rh_mef/view/authservice/passwordreset.dart';
import 'package:rh_mef/view/authservice/public/publiclogin.dart';
import 'package:rh_mef/view/authservice/registrationScreen.dart';
import 'package:twilio_flutter/twilio_flutter.dart';

// Future<dynamic> myBackgroundMessageHandler(Map<String, dynamic> message) async {
//   if (message.containsKey('data')) {
//     // Handle data message
//     final dynamic data = message['data'];
//
//     print('mybackgroundHandler $data');
//   }
//
//   if (message.containsKey('notification')) {
//     // Handle notification message
//     final dynamic notification = message['notification'];
//     print('mybackgroundHandler $notification');
//   }
//
//   // Or do other work.
// }

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  print("onBackgroundMessage: $message");
}

/// Global variables
/// * [GlobalKey<NavigatorState>]
// class GlobalVariable {
//   /// This global key is used in material app for navigation through firebase notifications.
//   /// [navState] usage can be found in [notification_notifier.dart] file.
//   static final GlobalKey<NavigatorState> navState = GlobalKey<NavigatorState>();
// }

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  // ignore: invalid_use_of_visible_for_testing_member
  SharedPreferences.setMockInitialValues({});
  initializeDateFormatting('fr', null).then((_) => runApp(MyApp()));
  // runApp(MyApp());
}

// void callbackDispatcher() {
//   Workmanager.executeTask((task, inputData) {
//     print("Native called background task: "); //simpleTask will be emitted here.
//     return Future.value(true);
//   });
// }
GlobalKey<NavigatorState> navigatorKey =
    GlobalKey(debugLabel: "Main Navigator");

class MyApp extends StatelessWidget {
  // This widget is the root of your application.

  @override
  Widget build(BuildContext context) {
    // return MaterialApp(
    //   debugShowCheckedModeBanner: false,
    //   title: 'DRH/MEF ONLINE',
    //   theme: ThemeData(
    //     primarySwatch: Colors.orange,
    //     visualDensity: VisualDensity.adaptivePlatformDensity,
    //   ),
    //   home: AuthenticationWrapper(),
    // );

    return MultiProvider(
      providers: [
        Provider<AuthenticationService>(
          create: (_) => AuthenticationService(FirebaseAuth.instance),
        ),
        StreamProvider(
          create: (context) =>
              context.read<AuthenticationService>().authStateChanges,
          initialData: null,
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        // navigatorKey: navigatorKey,
        title: 'DRH/MEF ONLINE',
        theme: ThemeData(
          primarySwatch: Colors.orange,
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        home: LoginContent(),
      ),
    );
  }
}

class LoginContent extends StatefulWidget {
  @override
  _LoginContentState createState() => _LoginContentState();
}

class _LoginContentState extends State<LoginContent> {
  TextEditingController nameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  // final GlobalKey<ScaffoldState> _drawerKey = GlobalKey();
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;
  TwilioFlutter twilioFlutter;
  FirebaseAuth auth = FirebaseAuth.instance;
  bool _obscurePassword;

  @override
  void initState() {
    _obscurePassword = true;
    twilioFlutter = TwilioFlutter(
        accountSid: 'AC4cb8ad07e86ad04b7cd18a2737796b3d',
        authToken: '9c1202163f062c18f0b29a2e3a4a7e30',
        twilioNumber: '+14103767481');
    super.initState();

    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
    FirebaseMessaging.onMessage.listen((RemoteMessage message) async {
      await _showNotification('${message.notification.title}',
          '${message.notification.body}', '${message.data['navigation']}');
      print("onMessage: ${message.data['navigation']}");
    });
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) async {
      print("onMessageOpenedApp: $message");
      // Navigator.push(
      //   context,
      //   MaterialPageRoute(
      //     builder: (context) => MyApp(),
      //   ),
      // );
      // navigatorKey.currentState
      //     .push(MaterialPageRoute(builder: (_) => RetraiteProccedure()));
      //
      // if (message.data["screen"] == "/retraite") {
      // Navigator.push(navigatorKey.currentState.context,
      //     MaterialPageRoute(builder: (context) => RetraiteProccedure()));
      // }
      // if (message.data["screen"] == "/demandeacte") {
      //   Navigator.push(navigatorKey.currentState.context,
      //       MaterialPageRoute(builder: (context) => Demande_Actes()));
      // }
    });
    var androidInitilize =
        new AndroidInitializationSettings('@mipmap/ic_launcher');
    var iOSinitilize = IOSInitializationSettings(
        onDidReceiveLocalNotification: onDidReceiveLocalNotification);
    var initilizationsSettings = new InitializationSettings(
        android: androidInitilize, iOS: iOSinitilize);
    flutterLocalNotificationsPlugin = new FlutterLocalNotificationsPlugin();
    flutterLocalNotificationsPlugin.initialize(initilizationsSettings,
        onSelectNotification: notificationSelected);

    // if (Platform.isAndroid) {
    //   print('android platform');
    // }
    // _firebaseMessaging.configure(
    //   onMessage: (Map<String, dynamic> message) async {
    //     print("onMessage: $message");
    //     await _showNotification('${message['notification']['title']}',
    //         '${message['notification']['body']}', message['screen']);
    //     navigatorKey.currentState
    //         .push(MaterialPageRoute(builder: (_) => LoginContent()));
    //   },
    //   onBackgroundMessage: myBackgroundMessageHandler,
    //   onLaunch: (Map<String, dynamic> message) async {
    //     print("onLaunch: $message");
    //   },
    //   onResume: (Map<String, dynamic> message) async {
    //     //   SchedulerBinding.instance.addPostFrameCallback((_) {
    //     //     Navigator.of(GlobalVariable.navState.currentContext)
    //     //         .push(MaterialPageRoute(
    //     //         builder: (context) => Demande_Actes(
    //     //         )));
    //     //   print("onResume: $message");
    //     await _showNotification('${message['notification']['title']}',
    //         '${message['notification']['body']}', message['screen']);
    //   },
    // );
  }

  Future onDidReceiveLocalNotification(
      int id, String title, String body, String payload) async {
    // display a dialog with the notification details, tap ok to go to another page
    // showDialog(
    //   context: context,
    //   builder: (BuildContext context) => CupertinoAlertDialog(
    //     title: Text(title),
    //     content: Text(body),
    //     actions: [
    //       CupertinoDialogAction(
    //         isDefaultAction: true,
    //         child: Text('Ouvrir'),
    //         onPressed: () async {
    //           // Navigator.of(context, rootNavigator: true).pop();
    //           print(title);
    //           await Navigator.push(
    //             context,
    //             MaterialPageRoute(
    //               builder: (context) => RetraiteProccedure(),
    //             ),
    //           );
    //         },
    //       )
    //     ],
    //   ),
    // );
  }

  Future notificationSelected(String payload) async {
    // Navigator.push(
    //   context,
    //   MaterialPageRoute(
    //     builder: (context) => LoginContent(),
    //   ),
    // );
    // showDialog(
    //   context: context,
    //   builder: (context) => AlertDialog(
    //     content: Text("Notification Clicked $payload"),
    //   ),
    // );
    if (payload.isNotEmpty) {
      // Navigator.push(
      //   context,
      //   MaterialPageRoute(
      //     builder: (context) => MyApp(),
      //   ),
      // );
    }

    // Navigator.of(context, rootNavigator: true).pop();
  }

  Future _showNotification(
      String title, String description, String otherData) async {
    print(description);
    int randomInt = Random().nextInt(100);
    const AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails('1234', 'channelName', 'channelDescription',
            importance: Importance.max,
            priority: Priority.high,
            showWhen: false);
    const NotificationDetails platformChannelSpecifics =
        NotificationDetails(android: androidPlatformChannelSpecifics);
    await flutterLocalNotificationsPlugin.show(
        12345, '$title', '$description', platformChannelSpecifics,
        payload: '$otherData');
  }

  void firebaseCloudMessagingListeners() {
    //TODO: COMMENTED FIREBASE MESSAGE.CONFIGURE
    // _firebaseMessaging.configure(
    //   onBackgroundMessage: myBackgroundMessageHandler,
    //   onMessage: (Map<String, dynamic> message) async {
    //     print("onMessage2: $message");
    //     await _showNotification(message['notification']['title'],
    //         message['notification']['body'], '');
    //   },
    //   onLaunch: (Map<String, dynamic> message) async {
    //     print("onLaunch: $message");
    //     await _showNotification('onResume', 'efg', '');
    //   },
    //   onResume: (Map<String, dynamic> message) async {
    //     print("onResume: $message");
    //     await _showNotification('onLaunch', message['data'], '');
    //   },
    // );
  }

  @override
  Widget build(BuildContext context) {
    final firebaseUser = context.watch<User>();

    if (firebaseUser != null) {
      return FutureBuilder<DocumentSnapshot>(
          future: FirebaseFirestore.instance
              .collection('Profile')
              .doc(firebaseUser.uid)
              .get(),
          builder: (context, AsyncSnapshot<DocumentSnapshot> snapshot) {
            if (snapshot == null ||
                snapshot.data == null ||
                snapshot.data.data() == null) return Container();
            if (snapshot.hasData) {
              String data = snapshot.data.data()['accountType'];
              switch (data) {
                case 'agent':
                  return AgentLogin();
                case 'public':
                  return PublicLogin();
                default:
                  return AgentLogin();
              }
              return Container();
            } else
              return Center(
                child: CircularProgressIndicator(),
              );
          });
      return Center(
        child: CircularProgressIndicator(),
      );
    }
    return loginuserview(context);
  }

  Widget loginuserview(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
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
                    labelText: 'Email',
                  ),
                ),
              ),
              Container(
                padding: EdgeInsets.fromLTRB(10, 10, 10, 0),
                child: TextField(
                  obscureText: _obscurePassword,
                  controller: passwordController,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Mot de passe',
                    suffixIcon: IconButton(
                      icon: Icon(Icons.lock),
                      onPressed: () {
                        setState(() {
                          _obscurePassword = !_obscurePassword;
                        });
                      },
                    ),
                  ),
                ),
              ),
              TextButton(
                onPressed: () {
                  //forgot password screen
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => PasswordReset()));
                },
                child: Text('Mot de passe oublié'),
              ),
              TextButton(
                onPressed: () {
                  //create new user
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => RegistrationScreen()));
                },
                child: Text('S\'inscrire'),
              ),
              Container(
                height: 50,
                padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                child: TextButton(
                  style: TextButton.styleFrom(
                      primary: Colors.white, backgroundColor: Colors.orange),
                  child: Text('Se Connecter'),
                  onPressed: () async {
                    String email = nameController.text.toLowerCase().trim();
                    String password = passwordController.text;
                    // bool result = await getLoginAgent([matricule, password]);
                    if (email.isNotEmpty && password.isNotEmpty) {
                      var userId = await context
                          .read<AuthenticationService>()
                          .signIn(
                              email: email,
                              password: password,
                              context: context);
                      print('user login with id: $userId');
                      FirebaseMessaging.instance.getToken().then((value) {
                        print('user login with token: $value');
                        FirebaseFirestore.instance
                            .collection("Profile")
                            .doc('${userId.toString()}')
                            .update({'token': value});
                      });
                    } else {
                      warningDialog(context,
                          "Veuillez remplir les champs email et mot de passe");
                    }
                    // await getLoginAgentFirebaseWay(
                    //     userId: userId, context: context, email: email);
                    //
                    // bool isInternet = await internetChecking();
                    // if (!isInternet) {
                    //   errorDialog(
                    //       context, 'Vous n\'avez de connection internet.');
                    // }
                    // showLoaderDialog(context);

                    // if (result == false) {
                    //   // Navigator.pop(context);
                    //   // print(result);
                    //   errorDialog(context,
                    //       'Erreur d\'authentification Matricule ou mot de passe erroné.');
                    // }

                    // Navigator.pushReplacement(context,
                    //     MaterialPageRoute(builder: (context) => LoginSucces()));
                  },
                ),
              ),
            ],
          )),
    );
  }

  // Widget homelogin(BuildContext context) {
  //   // This method is rerun every time setState is called, for instance as done
  //   // by the _incrementCounter method above.
  //   return Scaffold(
  //     body: FutureBuilder(
  //       future: Firebase.initializeApp(),
  //       builder: (context, snapshot) {
  //         if (snapshot.connectionState == ConnectionState.done) {
  //           return Scaffold(
  //             appBar: AppBar(
  //               // Here we take the value from the MyHomePage object that was created by
  //               // the App.build method, and use it to set our appbar title.
  //               title: const Text('DRH MEF ONLINE'),
  //               centerTitle: true,
  //             ),
  //             body: DetailsInformations(),
  //             drawer: Drawer(
  //               // key: _drawerKey,
  //               child: Container(
  //                 decoration: BoxDecoration(
  //                   color: Colors.orangeAccent,
  //                 ),
  //                 child: Column(
  //                   children: [
  //                     Expanded(
  //                       child: ListView(
  //                         padding: EdgeInsets.zero,
  //                         children: [
  //                           DrawerHeader(
  //                             child: Text(''),
  //                             decoration: BoxDecoration(
  //                               image: DecorationImage(
  //                                   image: AssetImage("assets/images/logo.png"),
  //                                   fit: BoxFit.fill),
  //                               color: Colors.orange,
  //                             ),
  //                           ),
  //                           // Expanded(
  //                           //   child: Center(
  //                           //     child: Text(
  //                           //         'Bienvenu, ${auth.currentUser.displayName}'),
  //                           //   ),
  //                           // ),
  //                           Divider(
  //                             thickness: 3,
  //                           ),
  //                           ListTile(
  //                             title: Text("Profile"),
  //                             leading: Icon(Icons.person),
  //                             onTap: () async {
  //                               // Update the state of the app
  //                               // ...
  //                               // Then close the drawer
  //                               FirebaseFirestore.instance
  //                                   .collection('Profile')
  //                                   .doc(auth.currentUser.uid)
  //                                   .snapshots()
  //                                   .forEach((element) {
  //                                 print(element.data());
  //                                 Navigator.push(
  //                                   context,
  //                                   MaterialPageRoute(
  //                                       builder: (context) =>
  //                                           ProfileDetails(values: element)),
  //                                 );
  //                               });
  //
  //                               // Navigator.pop(context);
  //                             },
  //                           ),
  //                           Divider(
  //                             thickness: 2,
  //                           ),
  //                           //TODO: home for news
  //                           ListTile(
  //                             title: Text(Constants.accueil),
  //                             leading: Icon(Icons.home),
  //                             onTap: () {
  //                               // Update the state of the app
  //                               // ...
  //                               // Then close the drawer
  //                               Navigator.push(
  //                                 context,
  //                                 MaterialPageRoute(
  //                                     builder: (context) => Dashboard()),
  //                               );
  //
  //                               // Navigator.pop(context);
  //                             },
  //                           ),
  //                           Divider(
  //                             thickness: 2,
  //                           ),
  //                           //TODO: Setting up for suggestion field
  //                           // ListTile(
  //                           //   title: Text(Constants.suggestion),
  //                           //   leading: Icon(Icons.message),
  //                           //   onTap: () {
  //                           //     // Update the state of the app
  //                           //     Navigator.push(
  //                           //       context,
  //                           //       MaterialPageRoute(
  //                           //           builder: (context) => Complaint()),
  //                           //     );
  //                           //     // Then close the drawer
  //                           //     // Navigator.pop(context);
  //                           //   },
  //                           // ),
  //                           // Divider(
  //                           //   thickness: 2,
  //                           // ),
  //                           ListTile(
  //                             title: Text(Constants.dmd_act),
  //                             leading: Icon(Icons.insert_drive_file),
  //                             onTap: () {
  //                               // Update the state of the app
  //                               // ...
  //                               // Then close the drawer
  //                               Navigator.push(
  //                                 context,
  //                                 MaterialPageRoute(
  //                                     builder: (context) => Demande_Actes()),
  //                               );
  //                               // Navigator.pop(context);
  //                             },
  //                           ),
  //                           Divider(
  //                             thickness: 2,
  //                           ),
  //
  //                           // TODO: retreat field setting up
  //                           ListTile(
  //                             title: Text(Constants.retraite),
  //                             leading: Icon(Icons.assistant),
  //                             onTap: () {
  //                               // Update the state of the app
  //                               // ...
  //                               // Then close the drawer
  //                               Navigator.push(
  //                                 context,
  //                                 MaterialPageRoute(
  //                                     builder: (context) =>
  //                                         RetraiteProccedure()),
  //                               );
  //                               // Navigator.pop(context);
  //                             },
  //                           ),
  //                           Divider(
  //                             thickness: 2,
  //                           ),
  //                           // ListTile(
  //                           //   title: Text(Constants.infos),
  //                           //   leading: Icon(Icons.info),
  //                           //   onTap: () {
  //                           //     // Update the state of the app
  //                           //     // ...
  //                           //     // Then close the drawer
  //                           //     // Navigator.push(
  //                           //     //   context,
  //                           //     //   MaterialPageRoute(
  //                           //     //       builder: (context) => StatutsDemande()),
  //                           //     // );
  //                           //     // sendSms();
  //                           //     // _showNotification('abc', 'efg');
  //                           //     // createNewDemandeActe([
  //                           //     //   'Motif is the motivation',
  //                           //     //   'Nature Acte',
  //                           //     //   'the piece jointe link'
  //                           //     // ]);
  //                           //   },
  //                           // ),
  //                           // Divider(
  //                           //   thickness: 2,
  //                           // ),
  //                         ],
  //                       ),
  //                     ),
  //                     Container(
  //                         child: TextButton(
  //                       style: ButtonStyle(
  //                         backgroundColor:
  //                             MaterialStateProperty.all<Color>(Colors.red),
  //                       ),
  //                       onPressed: () async {
  //                         SharedPreferences sharedPreferences =
  //                             await SharedPreferences.getInstance();
  //                         print('logout button clicked');
  //                         sharedPreferences.clear();
  //                         context.read<AuthenticationService>().signOut();
  //                         Navigator.push(
  //                           context,
  //                           MaterialPageRoute(
  //                               builder: (context) => LoginContent()),
  //                         );
  //                       },
  //                       child: TextButton(
  //                         onPressed: () async {
  //                           SharedPreferences shared =
  //                               await SharedPreferences.getInstance();
  //                           shared.clear();
  //                           await auth.signOut();
  //                           Navigator.pushReplacement(
  //                             context,
  //                             MaterialPageRoute(
  //                                 builder: (context) => LoginContent()),
  //                           );
  //                         },
  //                         child: Row(
  //                           children: [
  //                             Icon(
  //                               Icons.highlight_off,
  //                               color: Colors.white,
  //                             ),
  //                             Expanded(
  //                               child: Text(
  //                                 "Deconnecter",
  //                                 style: TextStyle(color: Colors.white),
  //                                 textAlign: TextAlign.center,
  //                               ),
  //                             )
  //                           ],
  //                         ),
  //                       ),
  //                     ))
  //                   ],
  //                 ),
  //               ),
  //             ),
  //           );
  //         }
  //         return CircularProgressIndicator();
  //       },
  //     ),
  //   );
  // }

  showLoaderDialog(BuildContext context) {
    AlertDialog alert = AlertDialog(
      content: new Row(
        children: [
          CircularProgressIndicator(),
          Container(
              margin: EdgeInsets.only(left: 7), child: Text("Loading...")),
        ],
      ),
    );
    showDialog(
      barrierDismissible: true,
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }
}
