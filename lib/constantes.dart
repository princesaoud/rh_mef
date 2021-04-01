import 'package:rh_mef/models/ActeModel.dart';
import 'package:rh_mef/models/stepsActe.dart';

class Constants {
  static const String settings = "Settings";
  static const String dmd_act = "Demande d'acte";
  static const String accueil = "Actualites";
  static const String suggestion = "Suggestion";
  static const String infos = "Plus d'infos";
  static const String valider = "Valider";
  static const String choisirDate = "Choissez votre date";
  static const String adminText = "Add News Actualites";
  static const String adminDemandeActe = "Manage Demande Acte";
  static const String retraite = "Retraite";
  static const String firebaseTokenAPIFCM =
      "key=AAAA6ubnEOw:APA91bFVG55VZmwhYocOK_jM9gsz1SVcJz7T1KA4gTDL3IbTWVeV1dbcy14RZe0UwULv4mbhA0kr2AlJOfZhkkFcZy-D2b5PNWHeYGYsy4DDPw0g_i4C_WhP8RoGyL9_UN8heEatl-w5";
  static const String prefs_imageName = "imageName";

  static const List<String> choices = <String>[settings, dmd_act];
  static const List<String> list_emplois = <String>[
    "Ingenieur Informatique",
    "Comptable"
  ];

  static const List<String> list_actes = <String>[
    "PRESENCE DE SOLDE",
    "TRAVAIL",
    "PRESENCE",
    "PRESENCE SOLDE"
  ];
  static const List<int> list_actes_code = <int>[001, 002, 003, 004];
  static const List<String> list_motifs = <String>[
    "ADMINISTRATIF",
    "DOSSIER BANCAIRE",
    "DOSSIER DEMANDE DE VISA",
    "DOSSIER DE RETRAITE",
    "DE DOSSIER DE CONCOURS",
  ];

  static List<ActeModel> listsActes = [
    ActeModel(
        acteCode: 001,
        acteName: "Attestation de présence solde",
        acteMotif: 001,
        steps: [
          ListSteps(
              title: "Demande en ligne recu",
              description:
                  "La DRH a reçu votre document avec succès, votre dossier en cours de traitement"),
          ListSteps(
              title: "Votre demande necessite une signature de votre Direction",
              description:
                  "La DRH a traité votre document, veuillez passer le rechercher pour la signature de votre hierachie"),
          ListSteps(
              title:
                  "Attestation de presence de solde reçu après signature de la hiérachie",
              description:
                  "L'Attestation de solde recu par la DRH, en cours de validation"),
          ListSteps(
              title: "Attestation de presence de solde signé",
              description:
                  "Votre demande a ete signe, vous pouvez passer la recupperer a la DRH"),
        ]),
  ];
}
