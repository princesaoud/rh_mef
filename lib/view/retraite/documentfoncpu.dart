import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../constantes.dart';

// ignore: must_be_immutable
class DocumentSelected extends StatelessWidget {
  final List<SubmitModel> listDocuments;
  final String title;

  DocumentSelected({this.listDocuments, this.title});

  final FirebaseAuth auth = FirebaseAuth.instance;
  String errorMessage = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.orangeAccent,
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            // Navigator.pushReplacement(context,
            //     MaterialPageRoute(builder: (context) => RetraiteProccedure()));
            Navigator.pop(context);
          },
          icon: Icon(Icons.close_rounded),
        ),
        title: Text(
          '$title',
          softWrap: true,
          style: TextStyle(fontSize: 15),
          textAlign: TextAlign.center,
        ),
      ),
      body: StreamBuilder<DocumentSnapshot>(
          stream: FirebaseFirestore.instance
              .collection("Documents")
              .doc(auth.currentUser.uid)
              .snapshots(includeMetadataChanges: true),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: CircularProgressIndicator(),
              );
            }
            List<dynamic> receivedData = snapshot.data.data()['docs'];
            List<String> splitData = receivedData.cast<String>();
            print('about to split');
            print(snapshot.data.data());
            List<MaterialColor> listColors = [];
            List<String> listErrorMessage = [];

            splitData.forEach((element) {
              print(element);
              if (element == "10") {
                listColors.add(Colors.green);
                listErrorMessage.add("");
              } else if (element == "0") {
                listErrorMessage.add("");

                listColors.add(Colors.grey);
              } else if (element.contains('404')) {
                List<String> tempList = element.split(':');
                errorMessage = tempList[1];
                listErrorMessage.add(tempList[1]);
                listColors.add(Colors.red);
              }
            });
            return Card(
              child: ListView.builder(
                itemCount: listDocuments.length,
                itemBuilder: (BuildContext context, int index) {
                  return Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            // Text(
                            //   '$index',
                            //   style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                            // ),
                            Expanded(
                              child: ListTile(
                                title: Text(
                                  '${listDocuments[index].descSubmitDoc}',
                                  style: TextStyle(
                                      fontSize: 20, color: listColors[index]),
                                  textAlign: TextAlign.center,
                                ),
                                subtitle: Text(
                                  listErrorMessage[index],
                                  textAlign: TextAlign.center,
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                                leading: Icon(
                                  Icons.check_box,
                                  color: listColors[index],
                                ),
                              ),
                            ),
                            // Icon(
                            //   Icons.radio_button_unchecked,
                            //   color: Colors.blue,
                            // ),
                          ],
                        ),
                        Divider(
                          thickness: 3,
                          color: listColors[index],
                        )
                      ],
                    ),
                  );
                },
              ),
            );
          }),
    );
  }
}
