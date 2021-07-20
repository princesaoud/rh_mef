import 'package:rh_mef/models/ActeModel.dart';
import 'package:rh_mef/models/stepsActe.dart';

class StepRetreatProcess {
  final String title;
  String description;
  final bool valid;
  final int id;
  String updated;

  StepRetreatProcess(
      {this.title, this.description, this.valid, this.id, this.updated});
  toSaveFormat() {
    return "$title, $description, $valid, $id, $updated";
  }

  toUseFormat(String value) {
    // List<String> listValue = value.split(',');
    // this.title = listValue[0];
    // this.description = listValue[1];
    // this.valid = bool.fromEnvironment(listValue[2]);
    // this.id = int.parse(listValue[3]);
  }
}

class MotifModel {
  final int motifCode;
  final List<String> motifsDesc;
  MotifModel({this.motifCode, this.motifsDesc});
}

class Constants {
  static const String settings = "Settings";
  static const String dmd_act = "Demande d'acte";
  static const String accueil = "Actualites";
  static const String suggestion = "Plaine/Suggestion";
  static const String infos = "Plus d'infos";
  static const String valider = "Valider";
  static const String choisirDate = "Choissez votre date";
  static const String adminText = "Add News Actualites";
  static const String adminDemandeActe = "Manage Demande Acte";
  static const String retraite = "Rétraite";
  static const String firebaseTokenAPIFCM =
      "key=AAAA6ubnEOw:APA91bFVG55VZmwhYocOK_jM9gsz1SVcJz7T1KA4gTDL3IbTWVeV1dbcy14RZe0UwULv4mbhA0kr2AlJOfZhkkFcZy-D2b5PNWHeYGYsy4DDPw0g_i4C_WhP8RoGyL9_UN8heEatl-w5";
  static const String prefs_imageName = "imageName";

  static const List<String> choices = <String>[settings, dmd_act];
  static const List<String> list_emplois = <String>[
    "Ingenieur Informatique",
    "Comptable"
  ];

  static List<String> listMatricules = [
    '395053W',
    '350185e',
    '464634w',
    '9000',
  ];
  static List<StepRetreatProcess> listStepsRetreate = [
    StepRetreatProcess(
        title:
            "CONSTITUTION DE DOSSIER DE DEMANDE DE LIQUIDATION PENSION ET DE DEMANDE D'ARRETE DE RADIATION",
        description:
            "Veuillez déposer les dossiers au Service Sociale de la DRH/MEF",
        valid: false,
        id: 21),
    StepRetreatProcess(
        title: "DEPOT DE DOSSIER A LA FONCTION PUBLIQUE",
        description:
            "Les dossiers sont en cours de traitement à la fonction publique",
        valid: false,
        id: 22),
    StepRetreatProcess(
        title: "RETRAIT DE L'ARSA+RGS ET DU CCP",
        description: "Initiation de la proccedure de rétrait des dossiers",
        valid: false,
        id: 23),
    StepRetreatProcess(
        title: "TRANSMISSION DE DOSSIER A LA CGRAE.",
        valid: false,
        id: 24,
        description: "Le dossier est en cours de traitement a la CGRAE"),
    StepRetreatProcess(
        title: "FIN DE LA PROCCEDURE",
        description: "Etape de fin de la proccédure de rétraite",
        valid: false,
        id: 25),
  ];

  // static const List<String> list_actes = <String>[
  //   "Attestation de présence solde",
  //   "Attestation de travail",
  //   "Attestation de présence",
  //   "Décision de congé de maternité"
  // ];
  // static const List<String> list_motifs = <String>[
  //   "ADMINISTRATIF",
  //   "DOSSIER BANCAIRE",
  //   "DOSSIER DEMANDE DE VISA",
  //   "DOSSIER DE rétraite",
  //   "DE DOSSIER DE CONCOURS",
  // ];

  static List<MotifModel> listMotifs = [
    MotifModel(motifCode: 1, motifsDesc: [
      "Pour complément de dossiers Administratif ",
      "Pour complément de dossier bancaire ",
      "Pour complément de dossier de demande de visas ",
      "Pour complément de dossier de rétraite",
      "Pour complément de dossier de concours administratif"
    ]),
    MotifModel(motifCode: 2, motifsDesc: [
      "Pour complément de dossiers Administratif ",
      "Pour complément de dossier bancaire"
    ]),
    MotifModel(motifCode: 3, motifsDesc: [
      "Pour constitution de mon dossier de cessation de service pour congé de maternité",
      "Pour complément de dossiers Administratif"
    ])
  ];
  static const List<ActeModel> listsActes = [
    ActeModel(
      acteCode: 001,
      acteName: "ATTESTATION DE PRESENCE DE SOLDE",
      acteMotif: 2,
      steps: [
        ListSteps(
            title: "Votre demande en ligne réçu",
            description:
                "La DRH a réçu votre demande avec succès, votre dossier en cours de traitement"),
        ListSteps(
            title:
                "Attestation de présence de solde prête pour être signée par votre hiérachie",
            description:
                "Veuillez passer à la DRH récupérer votre demande (Non-signé) pour la signature de votre hiérachie"),
        ListSteps(
            title: "Attestation de présence de solde signée par le DRH",
            description:
                "Attestation de présence solde signée par la DRH et peut être retirée"),
        ListSteps(
            title: "Attestation de présence solde retirée",
            description: "Votre demande a été retiré"),
      ],
      stepsError: [
        ListSteps(
            title: "Votre demande a été annulé",
            description:
                "La DRH a réçu votre demande mais ne peux pas proccéder au traitement"),
        ListSteps(
            title:
                "Attestation de présence de solde ne pourra pas être signée par votre hiérachie",
            description:
                "Veuillez passer à la DRH récupérer votre demande (Non-signé) pour la signature de votre hiérachie"),
        ListSteps(
            title: "Attestation de presence de solde non signée par le DRH",
            description:
                "Attestation de solde signée par la DRH et peut être retirée"),
        ListSteps(
            title: "Attestation de presence retirée",
            description: "Votre demande a été retirée"),
      ],
    ),
    ActeModel(
      acteCode: 002,
      acteName: "ATTESTATION DE TRAVAIL",
      acteMotif: 1,
      steps: [
        ListSteps(
            title: "Votre demande en ligne a été validé",
            description:
                "La DRH a réçu votre demande avec succès, votre dossier en cours de traitement"),
        ListSteps(
            title: "Attestation de travail signé",
            description:
                "Votre demande a été signé, vous pouvez passer à la DRH récupérer votre document"),
        ListSteps(
            title: "Attestation de travail retirée",
            description: "Votre demande a été retirée"),
      ],
      stepsError: [
        ListSteps(
            title: "Votre demande en ligne a été invalidé",
            description: "Le traitement de votre demande est arreté"),
        ListSteps(
            title: "Attestation de travail non-signé",
            description:
                "Votre demande n'a pas pu être signé, en raison d'erreur conçernant vos documents"),
        ListSteps(
            title: "Attestation de travail retirée",
            description: "Votre demande a été retiré"),
      ],
    ),
    ActeModel(
      acteCode: 003,
      acteName: "ATTESTATION DE PRESENCE",
      acteMotif: 1,
      steps: [
        ListSteps(
            title: "Votre demande en ligne a été validé",
            description:
                "La DRH a réçu votre demande avec succès, votre dossier en cours de traitement"),
        ListSteps(
            title: "Attestation de présence signé",
            description:
                "Votre demande a été signé, vous pouvez passer la récupérer à la DRH"),
        ListSteps(
            title: "Attestation de présence retirée",
            description: "Votre demande a été retiré"),
      ],
      stepsError: [
        ListSteps(
            title: "Votre demande en ligne a été invalidé",
            description: "Le traitement de votre demande est suspendu"),
        ListSteps(
            title: "Attestation de travail non-signé",
            description:
                "Votre demande ne pas pu être signé, en raison d'erreur conçernant vos documents"),
        ListSteps(
            title: "Attestation de travail retirée",
            description: "Votre demande a été retiré"),
      ],
    ),
    ActeModel(
      acteCode: 004,
      acteName: "DECISION DE CONGE DE MATERNITE",
      acteMotif: 3,
      steps: [
        ListSteps(
            title: "Votre demande en ligne a été validé",
            description:
                "La DRH a réçu votre demande avec succès, votre dossier en cours de traitement"),
        ListSteps(
            title: "Décision de congé de maternité signé",
            description:
                "Votre demande a été signé, vous pouvez passer la récupérer à la DRH"),
        ListSteps(
            title: "Decision de congé de maternité retirée",
            description: "Votre demande a été retiré"),
      ],
      stepsError: [
        ListSteps(
            title: "Votre demande en ligne a été invalidé",
            description: "Le traitement de votre demande est arrêtée"),
        ListSteps(
            title: "Attestation de travail non-signé",
            description:
                "Votre demande ne pas pu être signé, en raison d'erreur conçernant vos documents"),
        ListSteps(
            title: "Attestation de travail retirée",
            description: "Votre demande a été retiré"),
      ],
    ),
  ];

  static List<SubmitModel> documentSubmit = [
    SubmitModel(
        codeSubmitDoc: 11,
        descSubmitDoc:
            "2 Extrait de l\'acte de naissance de l'assure (original)",
        typeSubmitDoc: 'fonction publique',
        checkedSubmitDoc: false),
    SubmitModel(
        codeSubmitDoc: 12,
        descSubmitDoc: "Photocopie de la CNI de l'intérèssé",
        typeSubmitDoc: 'fonction publique',
        checkedSubmitDoc: false),
    SubmitModel(
        codeSubmitDoc: 13,
        descSubmitDoc: "Première prise de service",
        typeSubmitDoc: 'fonction publique',
        checkedSubmitDoc: false),
    SubmitModel(
        codeSubmitDoc: 14,
        descSubmitDoc: "La dernière décision d'avancement de l'intérèssé",
        typeSubmitDoc: 'fonction publique',
        checkedSubmitDoc: false),
    // SubmitModel(
    //     codeSubmitDoc: 15,
    //     descSubmitDoc: "Arretés de promotion de l'intérèssé",
    //     typeSubmitDoc: 'fonction publique',
    //     checkedSubmitDoc: false),
    SubmitModel(
        codeSubmitDoc: 16,
        descSubmitDoc: "L'etat signalétique des services militaires",
        typeSubmitDoc: 'fonction publique',
        checkedSubmitDoc: false),
    SubmitModel(
        codeSubmitDoc: 17,
        descSubmitDoc: "Demande de pension de retraite de l' IPS-CGRAE",
        typeSubmitDoc: 'fonction publique',
        checkedSubmitDoc: false),
    // SubmitModel(
    //     codeSubmitDoc: 18,
    //     descSubmitDoc: "Extrait de l\'acte de naissance de l'assure (original)",
    //     typeSubmitDoc: 'fonction publique',
    //     checkedSubmitDoc: false),
    SubmitModel(
        codeSubmitDoc: 19,
        descSubmitDoc: "Un bulletin de solde de la dernière année d'activitée",
        typeSubmitDoc: 'fonction publique',
        checkedSubmitDoc: false),
    SubmitModel(
        codeSubmitDoc: 20,
        descSubmitDoc: "Photocopie de la pièce d'identitée",
        typeSubmitDoc: 'fonction publique',
        checkedSubmitDoc: false),
    SubmitModel(
        codeSubmitDoc: 21,
        descSubmitDoc: "Rélever d'identitée bancaire",
        typeSubmitDoc: 'fonction publique',
        checkedSubmitDoc: false),
    SubmitModel(
        codeSubmitDoc: 22,
        descSubmitDoc:
            "Un extrait de l'acte de naissance de chaque enfant (mineur)",
        typeSubmitDoc: 'fonction publique',
        checkedSubmitDoc: false),
    SubmitModel(
        codeSubmitDoc: 22,
        descSubmitDoc:
            "Certificat de vie et d'entrétien des enfants (mineur) original",
        typeSubmitDoc: 'fonction publique',
        checkedSubmitDoc: false),
    SubmitModel(
        codeSubmitDoc: 23,
        descSubmitDoc:
            "Décision d\'autorisation de validation des services auxiliaires, le cas échéant (original)",
        typeSubmitDoc: 'fonction publique',
        checkedSubmitDoc: false),
    SubmitModel(
        codeSubmitDoc: 24,
        descSubmitDoc:
            "Attestation de cotisation au titre des services auxiliaires, le cas échéant (original)",
        typeSubmitDoc: 'fonction publique',
        checkedSubmitDoc: false),
    SubmitModel(
        codeSubmitDoc: 25,
        descSubmitDoc:
            "Etat signalétique des services militaires, le cas échéant (original)",
        typeSubmitDoc: 'fonction publique',
        checkedSubmitDoc: false),
    SubmitModel(
        codeSubmitDoc: 26,
        descSubmitDoc:
            "Un extrait de l\'acte de mariage le cas échéant (original)",
        typeSubmitDoc: 'fonction publique',
        checkedSubmitDoc: false),
    SubmitModel(
        codeSubmitDoc: 27,
        descSubmitDoc:
            "Une photocopie du certificat de première prise de service ou de la décision d\'engagement (pour civil)",
        typeSubmitDoc: 'fonction publique',
        checkedSubmitDoc: false),
    SubmitModel(
        codeSubmitDoc: 28,
        descSubmitDoc:
            "Tous les actes de l\'avancement de nomination ou de promotion (pour les civils)",
        typeSubmitDoc: 'fonction publique',
        checkedSubmitDoc: false),
    SubmitModel(
        codeSubmitDoc: 29,
        descSubmitDoc: "Décision d'engagement (agents temporaires)",
        typeSubmitDoc: 'fonction publique',
        checkedSubmitDoc: false)
  ];
}

class SubmitModel {
  int codeSubmitDoc;
  String descSubmitDoc;
  String typeSubmitDoc;
  bool checkedSubmitDoc;

  SubmitModel(
      {this.checkedSubmitDoc,
      this.codeSubmitDoc,
      this.descSubmitDoc,
      this.typeSubmitDoc});

  SubmitModel.emptyValue();

  toSaveFormat() {
    return "$codeSubmitDoc, $descSubmitDoc, $typeSubmitDoc, $checkedSubmitDoc";
  }

  toUseFormat(String value) {
    List<String> listValue = value.split(',');
    this.codeSubmitDoc = int.parse(listValue[0]);
    this.descSubmitDoc = listValue[1];
    this.typeSubmitDoc = listValue[2];
    this.checkedSubmitDoc = bool.fromEnvironment(listValue[3]);
  }
}
