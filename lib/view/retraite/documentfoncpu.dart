import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:rh_mef/view/retraiteProcedure.dart';

class DocumentSelected extends StatelessWidget {
  final List<String> listDocuments;
  final String title;
  DocumentSelected({this.listDocuments, this.title});
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
      body: Card(
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
                        child: Text(
                          '${listDocuments[index]}',
                          style: TextStyle(fontSize: 20),
                          textAlign: TextAlign.center,
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
                  )
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
