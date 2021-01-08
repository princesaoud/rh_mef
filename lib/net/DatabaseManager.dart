import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseManager {
  final CollectionReference profileList =
      FirebaseFirestore.instance.collection('News').orderBy('DatePosted');

  Future<void> createUserData(
      String name, String gender, int score, String uid) async {
    return await profileList
        .document(uid)
        .setData({'name': name, 'gender': gender, 'score': score});
  }

  Future updateUserList(
      String name, String gender, int score, String uid) async {
    return await profileList
        .doc(uid)
        .updateData({'name': name, 'gender': gender, 'score': score});
  }

  Future getNewsList() async {
    List itemsList = [];

    try {
      await profileList.get().then((querySnapshot) {
        querySnapshot.docs.forEach((element) {
          itemsList.add(element.data());
        });
      });
      print("Get news list");
      return itemsList;
    } catch (e) {
      print(e.toString());
      return null;
    }
  }
}
