import 'package:firebase_database/firebase_database.dart';

class ActeModel {
  String key;
  int acteCode;
  String acteName;
  List<String> steps;
  ActeModel(this.key, this.acteCode, this.acteName, this.steps);
  ActeModel.fromSnapshot(DataSnapshot snapshot)
      : key = snapshot.key,
        acteCode = snapshot.value['acteCode'],
        acteName = snapshot.value['acteName'],
        steps = snapshot.value['steps'];

  toJson() {
    return {
      "key": key,
      "acteCode": acteCode,
      "acteName": acteName,
      "steps": steps
    };
  }

  @override
  String toString() {
    // TODO: implement toString
    return "key " +
        key +
        "acteCode : $acteCode " +
        "acteName " +
        acteName +
        "steps " +
        steps.toString();
  }
}
