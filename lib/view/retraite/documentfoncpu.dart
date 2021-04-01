import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:rh_mef/view/retraiteProcedure.dart';

class DocumentSelected extends StatelessWidget {
  final List<String> listDocuments;
  final String title;
  DocumentSelected({this.listDocuments, this.title});
  final FirebaseAuth auth = FirebaseAuth.instance;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.orangeAccent,
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Navigator.pushReplacement(context,
                MaterialPageRoute(builder: (context) => RetraiteProccedure()));
          },
          icon: Icon(Icons.close_rounded),
        ),
        title: Text(
          'Pieces a fournir pour la $title',
          softWrap: true,
          style: TextStyle(fontSize: 15),
          textAlign: TextAlign.center,
        ),
      ),
      body: FutureBuilder<DocumentSnapshot>(
          future: FirebaseFirestore.instance
              .collection("Documents")
              .doc(auth.currentUser.uid)
              .get(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: CircularProgressIndicator(),
              );
            }
            print(snapshot.data.data()['$title']);
            var splitData =
                snapshot.data.data()['$title'].toString().split(',');
            List<MaterialColor> listColors = [];
            splitData.forEach((element) {
              if (element == "1") {
                listColors.add(Colors.green);
              } else {
                listColors.add(Colors.grey);
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
                                  '${listDocuments[index]}',
                                  style: TextStyle(
                                      fontSize: 20, color: listColors[index]),
                                  textAlign: TextAlign.center,
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
