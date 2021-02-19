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
}
