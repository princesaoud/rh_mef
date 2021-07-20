class ConstantsForComplaints {
  String temoignagneType = "";
  String motifTemoignagne = "";
  List<ModelComplaintSteps> myComplaint;
  ConstantsForComplaints({this.temoignagneType, this.motifTemoignagne}) {
    myComplaint = [
      ModelComplaintSteps(
          byDefault:
              "Votre $temoignagneType a été transmise au Directeur des Ressources Humaines",
          bySucces:
              "Votre $temoignagneType a été transmise au Directeur des Ressources Humaines",
          byError:
              "Votre $temoignagneType n'a pas été transmise au Directeur des Ressources Humaines",
          subInfoDefault:
              "Votre $temoignagneType est en cours de traitement. Vous serez contacté (e) par un agent",
          subInfoSucces:
              "Votre $temoignagneType est en cours de traitement. Vous serez contacté (e) par un agent",
          subInfoError: ""),
      ModelComplaintSteps(
          byDefault: "Recevabilite de votre $temoignagneType",
          bySucces: "Votre $temoignagneType est déclarée recevable",
          byError: "Votre $temoignagneType est déclarée non-recevable",
          subInfoDefault:
              "Vous serez contacté (e) par un agent en cas de nécéssité",
          subInfoSucces: "Veuillez-vous présenter à la DRH MEF le",
          subInfoError:
              "L'opération n'a pas pu être effectuée pour cause de: $motifTemoignagne"),
      ModelComplaintSteps(
          byDefault: "Issue de votre $temoignagneType ",
          bySucces: "L’issue de votre dossier est la suivante",
          byError: "Fin de la procédure",
          subInfoDefault: "Specifier l'issue de la $temoignagneType",
          subInfoSucces: "Specifier l'issue de la $temoignagneType \n ",
          subInfoError: "La DRH/MEF vous rémercie pour la confiance"),
      ModelComplaintSteps(
          byDefault: "Fin de votre procédure",
          bySucces: "Procédure terminée, la DRH/MEF vous rémercie",
          byError: "",
          subInfoDefault: "",
          subInfoSucces: "La DRH/MEF vous rémercie pour la confiance",
          subInfoError: ""),
    ];
  }
}

class ModelComplaintSteps {
  String byDefault;
  String bySucces;
  String byError;
  String subInfoDefault; //info that show when on default state
  String subInfoSucces; // info that is shown to the user when success state
  String subInfoError;

  ModelComplaintSteps(
      {this.byDefault,
      this.bySucces,
      this.byError,
      this.subInfoDefault,
      this.subInfoSucces,
      this.subInfoError}); //info that is shown to the user when error state

}
