import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:muskul/pushups/models/PushupsModel.dart';
import 'package:provider/provider.dart';

import 'navigation.dart' as navigation;

class NavigationScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var pushupsModel = Provider.of<PushupsModel>(context);

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.exit_to_app),
            tooltip: "logout",
            onPressed: () {
              FirebaseAuth.instance.signOut().then((result) {
                pushupsModel.logoutUser();
                navigation.toAuthentication(context);
              });
            },
          )
        ],
      ),
      body: Container(
        alignment: AlignmentDirectional.center,
        child: Column(
          children: <Widget>[
            Spacer(),
            Consumer<PushupsModel>(
              builder: (context, pushups, _) => RaisedButton(
                child: Text("Dodaj"),
                onPressed: () => navigation.toAdd(context),
              ),
            ),
            RaisedButton(
                child: Text("Historia"),
                onPressed: () => navigation.toHistory(context)),
            Spacer(flex: 2),
          ],
        ),
      ),
    );
  }
}
