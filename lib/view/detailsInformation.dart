import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:rh_mef/models/actualites_type.dart';
import 'package:rh_mef/view/demande_dactes.dart';
import 'package:rh_mef/view/profiledetails.dart';
import 'package:rh_mef/view/retraiteProcedure.dart';
import 'package:rh_mef/view/webView.dart';

// const String _kGalleryAssetsPackage = 'flutter_gallery_assets';
// enum CardDemoType {
//   standard,
//   tappable,
//   selectable,
// }

// class TravelDestination {
//   const TravelDestination({
//     this.assetName,
//     this.assetPackage,
//     this.title,
//     this.description,
//     this.city,
//     this.location,
//     this.type = CardDemoType.standard,
//   });
//   final String assetName;
//   final String assetPackage;
//   final String title;
//   final String description;
//   final String city;
//   final String location;
//   final CardDemoType type;
// }

// const List<TravelDestination> destinations = <TravelDestination>[
//   TravelDestination(
//     assetName: 'places/india_thanjavur_market.png',
//     assetPackage: _kGalleryAssetsPackage,
//     title: 'Top 10 Cities to Visit in Tamil Nadu',
//     description: 'Number 10',
//     city: 'Thanjavur',
//     location: 'Thanjavur, Tamil Nadu',
//   ),
//   TravelDestination(
//     assetName: 'places/india_chettinad_silk_maker.png',
//     assetPackage: _kGalleryAssetsPackage,
//     title: 'Artisans of Southern India',
//     description: 'Silk Spinners',
//     city: 'Chettinad',
//     location: 'Sivaganga, Tamil Nadu',
//     type: CardDemoType.tappable,
//   ),
//   TravelDestination(
//     assetName: 'places/india_tanjore_thanjavur_temple.png',
//     assetPackage: _kGalleryAssetsPackage,
//     title: 'Brihadisvara Temple',
//     description: 'Temples',
//     city: 'Thanjavur',
//     location: 'Thanjavur, Tamil Nadu',
//     type: CardDemoType.selectable,
//   ),
// ];

class TravelDestinationItem extends StatelessWidget {
  const TravelDestinationItem({key, this.destination, this.shape})
      : super(key: key);
// This height will allow for all the Card's content to fit comfortably within the card.
  static const double height = 338.0;
  final Actualites destination;
  final ShapeBorder shape;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      bottom: false,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: <Widget>[
            const SectionTitle(title: 'Normal'),
            SizedBox(
              height: height,
              child: Card(
// This ensures that the Card's children are clipped correctly.
                clipBehavior: Clip.antiAlias,
                shape: shape,
                child: TravelDestinationContent(destination: destination),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class TappableTravelDestinationItem extends StatelessWidget {
  const TappableTravelDestinationItem({key, this.destination, this.shape})
      : super(key: key);
// This height will allow for all the Card's content to fit comfortably within the card.
  static const double height = 380.0;
  final Actualites destination;
  final ShapeBorder shape;
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: true,
      bottom: true,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: <Widget>[
            // Center(child: SectionTitle(title: destination.title)),
            SizedBox(
              height: height,
              child: Card(
// This ensures that the Card's children (including the ink splash) are clipped correctly.
                clipBehavior: Clip.antiAlias,
                shape: shape,
                child: InkWell(
                  onTap: () {
                    print('Card was tapped');
                  },
// Generally, material cards use onSurface with 12% opacity for the pressed state.
                  splashColor:
                      Theme.of(context).colorScheme.onSurface.withOpacity(0.12),
// Generally, material cards do not have a highlight overlay.
                  highlightColor: Colors.transparent,
                  child: TravelDestinationContent(destination: destination),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class SectionTitle extends StatelessWidget {
  const SectionTitle({
    key,
    this.title,
  }) : super(key: key);
  final String title;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(4.0, 4.0, 4.0, 12.0),
      child: Align(
        alignment: Alignment.centerLeft,
        child: Text(title, style: Theme.of(context).textTheme.subtitle1),
      ),
    );
  }
}

// void main() async {
//   WidgetsFlutterBinding.ensureInitialized();
//   await Firebase.initializeApp();
//   runApp(DetailsInformations());
// }

class TravelDestinationContent extends StatelessWidget {
  const TravelDestinationContent({key, this.destination}) : super(key: key);
  final Actualites destination;
  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final TextStyle titleStyle =
        theme.textTheme.headline5.copyWith(color: Colors.black);
    final TextStyle descriptionStyle = theme.textTheme.subtitle1;
    final ButtonStyle textButtonStyle =
        TextButton.styleFrom(primary: Colors.amber.shade500);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
// Photo and title.
        SizedBox(
          height: 184.0,
          child: Stack(
            children: <Widget>[
              Positioned.fill(
// In order to have the ink splash appear above the image, you
// must use Ink.image. This allows the image to be painted as part
// of the Material and display ink effects above it. Using a
// standard Image will obscure the ink splash.
//                 child: Ink.image(
//                   //TODO: ADD IMAGENETWORK
//                   image: NetworkImage(destination.imageAsset),
//                   fit: BoxFit.cover,
//                   child: Container(),
//                 ),
                child: destination.imageAsset == null
                    ? Image.network('https://picsum.photos/200/300')
                    : Image.network(
                        destination.imageAsset,
                        fit: BoxFit.fill,
                      ),
              ),

              //TODO: old position of the title on the image
              // Positioned(
              //   bottom: 16.0,
              //   left: 16.0,
              //   right: 16.0,
              //   child: FittedBox(
              //     fit: BoxFit.scaleDown,
              //     alignment: Alignment.centerLeft,
              //     child: Text(
              //       destination.title,
              //       style: titleStyle,
              //     ),
              //   ),
              // ),
            ],
          ),
        ),
// Description and share/explore buttons.

        Padding(
          padding: const EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 0.0),
          child: DefaultTextStyle(
            softWrap: false,
            overflow: TextOverflow.ellipsis,
            style: descriptionStyle,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
// three line description
                //TODO: PADDING REMOVED

//                 Padding(
//                   padding: const EdgeInsets.only(bottom: 8.0),
//                   child: Text(
//                     destination.subtitle,
//                     style: descriptionStyle.copyWith(color: Colors.black54),
//                     softWrap: false,
//                   ),
//                 ),
                Text(
                  destination.title,
                  softWrap: false,
                  style: TextStyle(fontSize: 20),
                ),
                Container(
                  child: Text(
                    destination.subtitle,
                    style: descriptionStyle.copyWith(color: Colors.black54),
                    softWrap: false,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                Text(destination.author),
                Text(destination.published_date),
              ],
            ),
          ),
        ),
        // if (destination.type == CardDemoType.standard)
// share, explore buttons
        ButtonBar(
          alignment: MainAxisAlignment.start,
          children: <Widget>[
            TextButton(
              style: textButtonStyle,
              onPressed: () {
                print('pressed');
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            WebViewExample(destination.link)));
              },
              child: Text('Plus d\'informations',
                  semanticsLabel: 'Share ${destination.title}'),
            ),
            // TextButton(
            //   style: textButtonStyle,
            //   onPressed: () {
            //     print('pressed');
            //   },
            //   child: Text('EXPLORE',
            //       semanticsLabel: 'Explore ${destination.title}'),
            // ),
          ],
        ),
      ],
    );
  }
}

class DetailsInformations extends StatefulWidget {
  // static const String routeName = '/material/cards';
  @override
  _DetailsInformationsState createState() => _DetailsInformationsState();
}

class _DetailsInformationsState extends State<DetailsInformations> {
  ShapeBorder _shape;
  FirebaseAuth auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //TODO: appBar removed
      // appBar: AppBar(
      //   title: const Text('More informations'),
      //   actions: <Widget>[
      //     // MaterialDemoDocumentationButton(DetailsInformations.routeName),
      //     IconButton(
      //       icon: const Icon(
      //         Icons.sentiment_very_satisfied,
      //         semanticLabel: 'update shape',
      //       ),
      //       onPressed: () {
      //         setState(() {
      //           _shape = _shape != null
      //               ? null
      //               : const RoundedRectangleBorder(
      //                   borderRadius: BorderRadius.only(
      //                     topLeft: Radius.circular(16.0),
      //                     topRight: Radius.circular(16.0),
      //                     bottomLeft: Radius.circular(2.0),
      //                     bottomRight: Radius.circular(2.0),
      //                   ),
      //                 );
      //         });
      //       },
      //     ),
      //   ],
      // ),
      body: Scrollbar(
        child: GridView.count(
          primary: false,
          padding: const EdgeInsets.all(20),
          crossAxisSpacing: 10,
          mainAxisSpacing: 10,
          crossAxisCount: 2,
          children: <Widget>[
            Container(
              padding: const EdgeInsets.all(10),
              child: TextButton(
                onPressed: () {
                  FirebaseFirestore.instance
                      .collection('Profile')
                      .doc(auth.currentUser.uid)
                      .snapshots()
                      .forEach((element) {
                    print(element.data());
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              ProfileDetails(values: element)),
                    );
                  });
                },
                child: Column(
                  children: [
                    Card(
                      child: Icon(
                        Icons.person,
                        size: 50,
                        color: Colors.deepOrangeAccent,
                      ),
                    ),
                    Expanded(
                      child: Text(
                        "Profile",
                        style: TextStyle(color: Colors.deepOrangeAccent),
                      ),
                    ),
                  ],
                ),
              ),
              color: Colors.orange[100],
            ),
            Container(
              padding: const EdgeInsets.all(10),
              child: TextButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => Demande_Actes()),
                  );
                },
                child: Column(
                  children: [
                    Card(
                      child: Icon(
                        Icons.file_copy_rounded,
                        size: 50,
                        color: Colors.deepOrangeAccent,
                      ),
                    ),
                    Expanded(
                      child: Text(
                        "Demande Acte",
                        style: TextStyle(color: Colors.deepOrangeAccent),
                      ),
                    ),
                  ],
                ),
              ),
              color: Colors.orange[100],
            ),
            Container(
              padding: const EdgeInsets.all(10),
              child: TextButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => RetraiteProccedure()),
                  );
                },
                child: Column(
                  children: [
                    Card(
                      child: Icon(
                        Icons.assistant_rounded,
                        size: 50,
                        color: Colors.deepOrangeAccent,
                      ),
                    ),
                    Expanded(
                      child: Text(
                        "Retraite",
                        style: TextStyle(color: Colors.deepOrangeAccent),
                      ),
                    ),
                  ],
                ),
              ),
              color: Colors.orange[100],
            ),
          ],
        ),
      ),
    );
  }

  Widget myScrolableNewsDetails() {
    return Scrollbar(
      child: StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance
              .collection('News')
              .orderBy('DatePosted', descending: true)
              .limit(10)
              .snapshots(),
          builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (snapshot.hasError) {
              print("Something went wrong");
              print(snapshot.error);
              return Center(
                child: Text("Something went wrong"),
              );
            }
            if (snapshot.connectionState == ConnectionState.waiting) {
              print("waiting for data");
              return Center(child: CircularProgressIndicator());
            }
            if (snapshot.hasData) {
              return ListView.builder(
                  padding:
                      const EdgeInsets.only(top: 8.0, left: 8.0, right: 8.0),
                  itemCount: snapshot.data.docs.length,
                  itemBuilder: (BuildContext context, int index) {
                    DocumentSnapshot documentSnapshot =
                        snapshot.data.docs[index];

                    Actualites actualites = Actualites(
                        "",
                        documentSnapshot.data()["Title"],
                        documentSnapshot.data()["Description"],
                        documentSnapshot.data()["Author"],
                        documentSnapshot.data()["DatePosted"],
                        documentSnapshot.data()["ImageUrl"],
                        documentSnapshot.data()["Link"]);

                    return Container(
                      child: Column(
                        children: [
                          TappableTravelDestinationItem(
                              destination: actualites, shape: _shape),
                        ],
                      ),
                    );
                  });
            }
            return Center(child: CircularProgressIndicator());
          }),
    );
  }

  @override
  void initState() {
    super.initState();
  }

  Future<DocumentSnapshot> getData() async {
    QuerySnapshot querySnapshot;
    await Firebase.initializeApp();
    print('out of loop get data');
    querySnapshot = await FirebaseFirestore.instance
        .collection("News")
        .orderBy('DatePosted', descending: true)
        .limit(10)
        .get();
    if (querySnapshot != null && querySnapshot.size > 0) {
      print(querySnapshot.toString());
    }
    return null;
  }
}
