import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:rh_mef/main.dart';
import 'package:rh_mef/view/retraite/documentfoncpu.dart';

class RetraiteProccedure extends StatefulWidget {
  @override
  _RetraiteProccedureState createState() => _RetraiteProccedureState();
}

enum viewValue { home, fp, cgrae }

class _RetraiteProccedureState extends State<RetraiteProccedure> {
  // static var view = '${viewValue.home}';
  static var view = viewValue.home;
  List<String> listDocumentsFP = [
    "L'Extrait de naissance de l'interesse(e) (Original)",
    "Photocopie de la CNI de l'interessé(e)",
    "La première prise de service de l'interessé(e)",
    "La dernière décision d'avancement de l'intéressé(e)",
    "L'arrêté de promotion de l'interessé(e)",
    "Le bulletin de solde des enfants (originaux) pour le cas d'une femme (03 enfants nés pendant le service)",
    "L'état signalétique des services militaires (cas éventuel)"
  ];
  List<String> listDocumentsCgrae = [
    "Une demande de pension de retraite de l'IPS-CGRAE",
    "Un extrait de l'acte de naissance de l'assuré(e) (original)",
    "Un bulletin de solde de la dernière année d'activité (pour les civils) (original)",
    "Photocopie de la pièce d'identité",
    "Relevé d'identité Bancaire (RIB)",
    "Un extrait de l'acte de naissance de chaque enfant (originaux), le cas échéant",
    "La décision d'autorisation de validation des services auxiliaires, le cas echeant (original)",
    "L'attestation de cotisations au titre des services auxiliaires, le cas echeant (original)",
    "L'état signaletique des services militaires, le cas echeant (orignaux)",
    "Un extrait de l'acte de mariage, le cas echeant (original)",
    "Une photocopie du certificat de premiere prise de service ou de la decision d'engagement (pour civils)",
    "Tous les actes de l'avancement, de nomination ou de promotion (pour les civils)"
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Navigator.pushReplacement(
                context, MaterialPageRoute(builder: (context) => MyApp()));
          },
          icon: Icon(Icons.arrow_back),
        ),
        title: Text(
          'Proccedure à suivre',
          style: TextStyle(fontSize: 20),
        ),
      ),
      body: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: Card(
                  child: Container(
                    color: Colors.white30,
                    child: Padding(
                      padding: const EdgeInsets.all(15.0),
                      child: ListTile(
                        onTap: () {
                          Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => DocumentSelected(
                                        listDocuments: listDocumentsFP,
                                        title: 'Fonction Publique',
                                      )));
                        },
                        title: Text(
                          'Fonction Publique',
                          textAlign: TextAlign.left,
                          style: TextStyle(fontSize: 20),
                        ),
                        subtitle: Text(
                            'Cliquer pour obtenir la liste des dossiers a soumettre a la fonction publique '),
                        trailing: Icon(Icons.arrow_forward_ios_outlined),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
          // Row(
          //   children: [
          //     Expanded(
          //       flex: 1,
          //       child: Column(
          //         // mainAxisAlignment: MainAxisAlignment.start,
          //         mainAxisSize: MainAxisSize.min,
          //         crossAxisAlignment: CrossAxisAlignment.center,
          //         children: <Widget>[
          //           Container(
          //             width: 3,
          //             height: 50,
          //             decoration: new BoxDecoration(
          //               color: Colors.black,
          //               shape: BoxShape.rectangle,
          //             ),
          //             child: Text(""),
          //           ),
          //           Container(
          //             width: 18,
          //             height: 18,
          //             decoration: new BoxDecoration(
          //               color: Colors.black,
          //               shape: BoxShape.circle,
          //             ),
          //             child: Text(""),
          //           ),
          //         ],
          //       ),
          //     ),
          //   ],
          // ),
          Card(
            child: Container(
              color: Colors.white30,
              child: Padding(
                padding: const EdgeInsets.all(15.0),
                child: ListTile(
                  onTap: () {
                    Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                            builder: (context) => DocumentSelected(
                                  listDocuments: listDocumentsCgrae,
                                  title: 'CGRAE',
                                )));
                  },
                  title: Text(
                    'CGRAE',
                    textAlign: TextAlign.left,
                    style: TextStyle(fontSize: 20),
                  ),
                  subtitle: Text(
                      'Cliquer pour obtenir la liste des dossiers a soumettre a la CGRAE '),
                  trailing: Icon(
                    Icons.arrow_forward_ios_outlined,
                  ),
                ),
              ),
            ),
          ),
          Row(
            children: [
              Expanded(
                flex: 1,
                child: Column(
                  // mainAxisAlignment: MainAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Container(
                      width: 3,
                      height: 50,
                      decoration: new BoxDecoration(
                        color: Colors.black,
                        shape: BoxShape.rectangle,
                      ),
                      child: Text(""),
                    ),
                    Container(
                      width: 18,
                      height: 18,
                      decoration: new BoxDecoration(
                        color: Colors.black,
                        shape: BoxShape.circle,
                      ),
                      child: Text(""),
                    ),
                  ],
                ),
              ),
            ],
          ),
          Row(
            children: [
              Expanded(
                child: Card(
                  child: Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: ListTile(
                      title: Text(
                        'Statuts',
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 20),
                      ),
                      subtitle: Center(
                        child: Text('Aucune proccedure entammée'),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget documentFP(String title, List<String> listDocuments) {}
}
