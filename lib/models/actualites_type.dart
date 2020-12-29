import 'package:firebase_database/firebase_database.dart';

class Actualites {
  String key;
  String title;
  String subtitle;
  String author;
  String published_date;
  String imageAsset;
  String link;

  Actualites(this.key, this.title, this.subtitle, this.author,
      this.published_date, this.imageAsset, this.link);

  Actualites.fromSnapshot(DataSnapshot snapshot)
      : key = snapshot.key,
        title = snapshot.value["title"],
        subtitle = snapshot.value["subtitle"],
        author = snapshot.value["author"],
        published_date = snapshot.value["published_date"],
        link = snapshot.value["link"],
        imageAsset = snapshot.value["imageAsset"];

  toJson() {
    return {
      "title": title,
      "subtitle": subtitle,
      "author": author,
      "published_date": published_date,
      "imageAsset": imageAsset,
      "link": link,
    };
  }
}
