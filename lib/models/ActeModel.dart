import 'package:firebase_database/firebase_database.dart';
import 'package:rh_mef/models/stepsActe.dart';

class ActeModel {
  String key;
  int acteCode;
  String acteName;
  int acteMotif;
  List<ListSteps> steps;

  ActeModel(
      {this.key, this.acteCode, this.acteName, this.acteMotif, this.steps});

  ActeModel.fromSnapshot(DataSnapshot snapshot)
      : key = snapshot.key,
        acteCode = snapshot.value['acteCode'],
        acteName = snapshot.value['acteName'],
        acteMotif = snapshot.value['acteMotif'],
        steps = snapshot.value['steps'];

  toJson() {
    return {
      "key": key,
      "acteCode": acteCode,
      "acteName": acteName,
      "acteMotif": acteMotif,
      "steps": steps
    };
  }

  @override
  String toString() {
    return 'ActeModel{key: $key, acteCode: $acteCode, acteName: $acteName, acteMotif: $acteMotif, steps: $steps}';
  }
}
