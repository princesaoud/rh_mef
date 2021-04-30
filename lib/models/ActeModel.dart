import 'package:firebase_database/firebase_database.dart';
import 'package:rh_mef/models/stepsActe.dart';

class ActeModel {
  final String key;
  final int acteCode;
  final String acteName;
  final int acteMotif;
  final List<ListSteps> steps;
  final List<ListSteps> stepsError;

  const ActeModel(
      {this.key,
      this.acteCode,
      this.acteName,
      this.acteMotif,
      this.steps,
      this.stepsError});

  ActeModel.fromSnapshot(DataSnapshot snapshot)
      : key = snapshot.key,
        acteCode = snapshot.value['acteCode'],
        acteName = snapshot.value['acteName'],
        acteMotif = snapshot.value['acteMotif'],
        steps = snapshot.value['steps'],
        stepsError = snapshot.value['stepsError'];

  toJson() {
    return {
      "key": key,
      "acteCode": acteCode,
      "acteName": acteName,
      "acteMotif": acteMotif,
      "steps": steps,
      "stepsError": stepsError
    };
  }

  @override
  String toString() {
    return 'ActeModel{key: $key, acteCode: $acteCode, acteName: $acteName, acteMotif: $acteMotif, steps: $steps, stepsError : $stepsError}';
  }
}
