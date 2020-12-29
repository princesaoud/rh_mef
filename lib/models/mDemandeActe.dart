import 'package:firebase_database/firebase_database.dart';

class DemandeActe {
  String key;
  String matricule = "Entrer le matricule";
  String nom = "Entrer votre nom et prenom";
  String telephone = "Entrer votre numero de telephone";
  String email = "Entrer votre email";
  String datePriseService = "Entrer votre date de prise de service";
  String emploi = "Choisir votre emploi";
  String natureActe = "Choisir la nature de l'acte";
  String pieceJointe = "Ajouter une piece jointe";
  String motif = "Choisir le motif";

  DemandeActe(
      this.key,
      this.matricule,
      this.nom,
      this.telephone,
      this.email,
      this.datePriseService,
      this.emploi,
      this.natureActe,
      this.pieceJointe,
      this.motif);

  DemandeActe.fromSnapshot(DataSnapshot snapshot)
      : key = snapshot.key,
        matricule = snapshot.value["matricule"],
        nom = snapshot.value["nom"],
        telephone = snapshot.value["telephone"],
        email = snapshot.value["email"],
        datePriseService = snapshot.value["datePriseService"],
        emploi = snapshot.value["emploi"],
        natureActe = snapshot.value["natureActe"],
        pieceJointe = snapshot.value["pieceJointe"],
        motif = snapshot.value["motif"];

  @override
  String toString() {
    return 'DemandeActe{key: $key, matricule: $matricule, nom: $nom, telephone: $telephone, email: $email, datePriseService: $datePriseService, emploi: $emploi, natureActe: $natureActe, pieceJointe: $pieceJointe, motif: $motif}';
  }

  toJson() {
    return {
      "matricule": matricule,
      "nom": nom,
      "telephone": telephone,
      "datePriseService": datePriseService,
      "emploi": emploi,
      "natureActe": natureActe,
      "pieceJointe": pieceJointe,
      "motif": motif,
    };
  }
}