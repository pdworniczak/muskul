import 'package:flutter/material.dart';
import 'package:muskul/pushups/models/PushupsModel.dart';
import 'package:provider/provider.dart';
import 'authentication/AuthenticationScreen.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
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
  }
}
