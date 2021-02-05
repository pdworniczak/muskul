import 'package:flutter/material.dart';
import 'package:muskul/pushups/models/PushupsModel.dart';
import 'package:muskul/service/store.dart';
import 'package:provider/provider.dart';
import 'authentication/AuthenticationScreen.dart';

import 'package:firebase_core/firebase_core.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final _initialization = Future.wait([Firebase.initializeApp(), Store.init()]);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      // Initialize FlutterFire:
      future: _initialization,
      builder: (context, snapshot) {
        // Check for errors
        if (snapshot.hasError) {
          return Text('Problem z uruchomieniem aplikacji',
              textDirection: TextDirection.ltr);
        }

        // Once complete, show your application
        if (snapshot.connectionState == ConnectionState.done) {
          return ChangeNotifierProvider(
            create: (context) {
              PushupsModel pushups = PushupsModel();
              pushups.initSchedule();
              return pushups;
            },
            child: MaterialApp(
              title: 'Muskuł',
              theme: ThemeData(
                primarySwatch: Colors.blue,
              ),
              home: AuthenticationScreen(),
            ),
          );
          ;
        }

        // Otherwise, show something whilst waiting for initialization to complete
        return Text('Wczytywanie', textDirection: TextDirection.ltr);
      },
    );
  }
}
