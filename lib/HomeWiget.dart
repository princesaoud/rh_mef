import 'package:firebase_core/firebase_core.dart';

/// Flutter code sample for ListTile
import 'package:flutter/material.dart';
import 'package:rh_mef/models/actualites_type.dart';
import 'package:rh_mef/net/firebase.dart';

void main() => runApp(HomeWiget());

/// This is the main application widget.
class HomeWiget extends StatelessWidget {
  static const String _title = 'RH Mef online';
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: _title,
      home: Scaffold(
        body: MyStatelessWidget(),
      ),
    );
  }
}

class _ArticleDescription extends StatelessWidget {
  _ArticleDescription({
    Key key,
    this.title,
    this.subtitle,
    this.author,
    this.publishDate,
  }) : super(key: key);

  final String title;
  final String subtitle;
  final String author;
  final String publishDate;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Expanded(
          flex: 1,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                '$title',
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const Padding(padding: EdgeInsets.only(bottom: 2.0)),
              Text(
                '$subtitle',
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontSize: 12.0,
                  color: Colors.black54,
                ),
              ),
            ],
          ),
        ),
        Expanded(
          flex: 1,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[
              Text(
                '$author',
                style: const TextStyle(
                  fontSize: 12.0,
                  color: Colors.black87,
                ),
              ),
              Text(
                '$publishDate',
                style: const TextStyle(
                  fontSize: 12.0,
                  color: Colors.black54,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class CustomListItemTwo extends StatelessWidget {
  CustomListItemTwo({
    Key key,
    this.thumbnail,
    this.title,
    this.subtitle,
    this.author,
    this.publishDate,
  }) : super(key: key);

  final Widget thumbnail;
  final String title;
  final String subtitle;
  final String author;
  final String publishDate;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0),
      child: SizedBox(
        height: 100,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            AspectRatio(
              aspectRatio: 1.0,
              child: thumbnail,
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20.0, 0.0, 2.0, 0.0),
                child: _ArticleDescription(
                  title: title,
                  subtitle: subtitle,
                  author: author,
                  publishDate: publishDate,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}

/// This is the stateless widget that the main application instantiates.
// ignore: must_be_immutable
class MyStatelessWidget extends StatelessWidget {
  MyStatelessWidget({Key key}) : super(key: key);

  // ignore: non_constant_identifier_names
  List<Actualites> list_actualites = [];

  @override
  Widget build(BuildContext context) {
    Future.delayed(Duration(seconds: 6), () async {
      list_actualites = await retriveDataSecondWay();
      // 5s over, navigate to a new page
    });
    print(list_actualites.length);
    return ListView.builder(
      itemCount: list_actualites.length,
      padding: const EdgeInsets.all(10.0),
      itemBuilder: (BuildContext context, int index) {
        return Container(
          child: Card(
            child: Column(
              children: [
                CustomListItemTwo(
                  thumbnail: Container(
                    decoration: const BoxDecoration(color: Colors.orange),
                  ),
                  title: "title ${list_actualites[index].title}",
                  subtitle:
                      'Flutter continues to improve and expand its horizons.'
                      'This text should max out at two lines and clip',
                  author: 'Com',
                  publishDate: 'Dec 28',
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  void initState() {
    // super.initState();
    Firebase.initializeApp().whenComplete(() {
      fetchData();
      print("completed");
    });
  }

  void fetchData() {}
}
