import 'package:cloud_firestore/cloud_firestore.dart';

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
