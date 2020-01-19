import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';

import 'navigation.dart' as navigation;
import '../pushups/pushups.dart';

class NavigationScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) {
        Pushups pushups = Pushups();
        pushups.init();
        return pushups;
      },
      child: Scaffold(
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
              Consumer<Pushups>(
                builder: (context, pushups, _) => RaisedButton(
                  child: Text("Add"),
                  onPressed: () => print('ADD ${pushups.schedule}'),
                ),
              ),
              RaisedButton(
                  child: Text("List"),
                  onPressed: () => navigation.toList(context)),
              Spacer(flex: 2),
            ],
          ),
        ),
      ),
    );
  }
}
