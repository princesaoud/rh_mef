import 'package:firebase_database/firebase_database.dart';

class M_complaint {
  String key;
  String designation;
  String number;
  String email;
  String complaintType;
  String observation;

  M_complaint(this.key, this.designation, this.number, this.email,
      this.complaintType, this.observation);

  M_complaint.fromSnapshot(DataSnapshot snapshot)
      : key = snapshot.key,
        designation = snapshot.value["designation"],
        number = snapshot.value["number"],
        email = snapshot.value["email"],
        complaintType = snapshot.value["complaintType"],
        observation = snapshot.value["observation"];

  toJson() {
    return {
      "designation": designation,
      "number": number,
      "email": email,
      "complaintType": complaintType,
      "observation": observation,
    };
  }
}
