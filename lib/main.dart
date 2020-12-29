import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:rh_mef/HomeStateFullWidget.dart';
import 'package:rh_mef/adminpanel/actualitesAdminist.dart';
import 'package:rh_mef/constantes.dart';
import 'package:rh_mef/view/complaint.dart';
import 'package:rh_mef/view/demande_dactes.dart';
import 'package:rh_mef/view/detailsInformation.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'RHMEF ONLINE',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.orange,
        // This makes the visual density adapt to the platform that you run
        // the app on. For desktop platforms, the controls will be smaller and
        // closer together (more dense) than on mobile platforms.
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyHomePage(title: 'DRH MEF ONLINE '),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging();
  final GlobalKey<ScaffoldState> _drawerKey = GlobalKey();

  void _openDrawer(_) {
    _drawerKey.currentState.openDrawer();
  }

  int _selectedIndex = 0;
  static const TextStyle optionStyle =
      TextStyle(fontSize: 30, fontWeight: FontWeight.bold);
  static List<Widget> _widgetOptions = <Widget>[
    HomeStateFull(),
    Complaint(),
    Text(
      'Index 2: A Propos',
      style: optionStyle,
    ),
  ];

  @override
  void initState() {
    // WidgetsBinding.instance.addPostFrameCallback(_openDrawer);
    super.initState();
    firebaseCloudMessaging_Listeners();
  }

  void firebaseCloudMessaging_Listeners() {
    // if (Platform.isIOS) iOS_Permission();

    _firebaseMessaging.getToken().then((token) {
      print("token of the device is : $token");
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

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
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
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => Demande_Actes()),
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
                  Navigator.pop(context);
                },
              ),
              ListTile(
                title: Text(Constants.adminText),
                leading: Icon(Icons.settings),
                onTap: () {
                  // Update the state of the app
                  // ...
                  // Then close the drawer
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => ActualitesAdminist()),
                  );
                  // Navigator.pop(context);
                },
              ),
            ],
          ),
        ),
      ),
      //TODO: BottomBar navigation
      // bottomNavigationBar: BottomNavigationBar(
      //   items: const <BottomNavigationBarItem>[
      //     BottomNavigationBarItem(
      //       icon: Icon(Icons.home),
      //       label: 'Home',
      //     ),
      //     BottomNavigationBarItem(
      //       icon: Icon(Icons.message),
      //       label: 'Suggestion',
      //     ),
      //     BottomNavigationBarItem(
      //       icon: Icon(Icons.info),
      //       label: 'A Propos',
      //     ),
      //   ],
      //   currentIndex: _selectedIndex,
      //   selectedItemColor: Colors.amber[800],
      //   onTap: _onItemTapped,
      // ),
      // This trailing comma makes auto-formatting nicer for build methods.
    );
  }

  void selectAction(String value) {
    if (value == Constants.settings) {
      print(value);
    } else if (value == Constants.dmd_act) {
      print(value);
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => Demande_Actes()),
      );
    }
  }
}
