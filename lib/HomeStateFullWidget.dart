import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:rh_mef/net/DatabaseManager.dart';

class HomeStateFull extends StatefulWidget {
  @override
  _HomeStateFullState createState() => _HomeStateFullState();
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
              child: Image(
                image: AssetImage('assets/images/embleme.png'),
              ),
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

class _HomeStateFullState extends State<HomeStateFull> {
  // ignore: non_constant_identifier_names
  List list_actualites;
  @override
  Widget build(BuildContext context) {
    if (list_actualites.length == 0)
      return Container();
    else
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
                    title: list_actualites[index]['Title'],
                    subtitle: list_actualites[index]['Description'],
                    author: list_actualites[index]['Author'],
                    publishDate: list_actualites[index]['DatePosted'],
                  ),
                ],
              ),
            ),
          );
        },
      );
  }

  fetchData() async {
    dynamic data = await DatabaseManager().getNewsList();
    if (data == null) {
      print("Unable to retrieve the data");
    } else {
      setState(() {
        print("get the data");
        list_actualites = data;
      });
    }
  }

  void initState() {
    super.initState();
    Firebase.initializeApp().whenComplete(() {
      fetchData();
    });
  }
}
