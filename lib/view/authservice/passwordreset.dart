import 'package:commons/commons.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:rh_mef/net/firebase.dart';

import '../../main.dart';

class PasswordReset extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(
          child: Text(
            'Mot de passe oublié',
            textAlign: TextAlign.center,
          ),
        ),
        leading: IconButton(
          onPressed: () {
            // Navigator.pushReplacement(
            //     context, MaterialPageRoute(builder: (context) => MyApp()));
            Navigator.pop(context);
          },
          icon: Icon(Icons.arrow_back),
        ),
      ),
      body: PasswordResetContent(),
    );
  }
}

class PasswordResetContent extends StatefulWidget {
  @override
  _PasswordResetContentState createState() => _PasswordResetContentState();
}

class _PasswordResetContentState extends State<PasswordResetContent> {
  var emailController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            children: [
              Expanded(
                child: Container(
                  padding: EdgeInsets.all(10),
                  child: TextField(
                    controller: emailController,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Email de Reinitialisation',
                    ),
                  ),
                ),
              ),
            ],
          ),
          Row(
            children: [
              Expanded(
                child: Container(
                  height: 70,
                  padding: EdgeInsets.all(10),
                  child: TextButton(
                    style: TextButton.styleFrom(
                        primary: Colors.white, backgroundColor: Colors.orange),
                    onPressed: () {
                      resetPassword(emailController.text.trim());
                      successDialog(context,
                          "E-Mail de reinitialisation envoyé avec succes");
                      // Navigator.pushReplacement(context,
                      //     MaterialPageRoute(builder: (context) => MyApp()));
                      Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (context) => LoginContent()));
                    },
                    child: Text(
                      "Envoyer lien de reinitialisation",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}
