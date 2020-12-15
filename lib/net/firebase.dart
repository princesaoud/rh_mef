import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:rh_mef/models/actualites_type.dart';

class CustomFirebaseMangement {}

Future<void> userSetup(String designation, String number, String email,
    String complaintType, String observation) async {
  CollectionReference plaintes =
      FirebaseFirestore.instance.collection('Plaintes');
  // FirebaseAuth auth = FirebaseAuth.instance;
  // String uid = auth.currentUser.uid.toString();
  plaintes.add({
    'designation': designation,
    'number': number,
    'email': email,
    'complaintType': complaintType,
    'observation': observation,
  });
  return;
}

Future<void> retriveData() async {
  print('start collecting data');
  DocumentSnapshot _ds = await FirebaseFirestore.instance
      .collection("News")
      .doc('djyoK75DMrMYXhIMNZI2')
      .get();
  Map mapEventData = _ds.data();
  print(mapEventData);
}

Future<List<Actualites>> retriveDataSecondWay() async {
  final CollectionReference profileList = Firestore.instance.collection("News");
  List itemsList = [];
  List<Actualites> list_actualites = [];
  try {
    await profileList.getDocuments().then((querySnapshot) {
      querySnapshot.documents.forEach((element) {
        Actualites actualites;
        actualites.title = element.data()["Title"];
        actualites.subtitle = element.data()["Description"];
        actualites.published_date = element.data()["DatePosted"];
        list_actualites.add(actualites);
      });
    });
    return list_actualites;
  } catch (e) {
    print(e.toString());
    return null;
  }
}

// Future getUsersList() async {
//   final CollectionReference profileList = Firestore.instance.collection('News');
//   List itemsList = [];
//
//   try {
//     await profileList.getDocuments().then((querySnapshot) {
//       querySnapshot.documents.forEach((element) {
//         itemsList.add(element.data);
//       });
//     });
//     return itemsList;
//   } catch (e) {
//     print(e.toString());
//     return null;
//   }
// }
