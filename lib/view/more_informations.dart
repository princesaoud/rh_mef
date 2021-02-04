import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class MoreInformations extends StatefulWidget {
  @override
  _MoreInformationsState createState() => _MoreInformationsState();
}

class _MoreInformationsState extends State<MoreInformations> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: const Text("About page"),
        centerTitle: true,
        backgroundColor: Colors.orangeAccent,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(Icons.arrow_back),
        ),
      ),
      body: Corps(),
    );
  }
}

class Corps extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Card(
        child: ListTile(
          contentPadding: EdgeInsets.symmetric(vertical: 5, horizontal: 100),
          title: Text("Developped by iGloGlo"),
        ),
      ),
    );
  }
}
