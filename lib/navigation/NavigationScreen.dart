import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'navigation.dart' as navigation;

class NavigationScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.exit_to_app),
            tooltip: "logout",
            onPressed: () {
              FirebaseAuth.instance
                  .signOut()
                  .then((result) => navigation.toAuthentication(context));
            },
          )
        ],
      ),
      body: Container(
        alignment: AlignmentDirectional.center,
        child: Column(
          children: <Widget>[
            Spacer(),
            RaisedButton(
                child: Text("Add"),
                onPressed: () async {
                  print(await rootBundle.loadString('assets/pushups.json'));
                }),
            RaisedButton(
                child: Text("List"),
                onPressed: () => navigation.toList(context)),
            Spacer(flex: 2),
          ],
        ),
      ),
    );
  }
}
