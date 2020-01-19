import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class ListScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _ListScreenState();
  }
}

class _ListScreenState extends State<ListScreen> {
  var _trainings = <DocumentSnapshot>[];

  @override
  void initState() {
    print('init');
    super.initState();
    FirebaseAuth.instance.currentUser().then((user) {
      Firestore.instance
          .collection('pushups')
          .where('uid', isEqualTo: user.uid)
          .snapshots()
          .listen((data) {
        setState(() {
          print(data.documents[3].data);
          this._trainings = data.documents;
        });
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Material(
        child: Column(
      children: <Widget>[
        Spacer(),
        Text("List"),
        ..._trainings
            .map((DocumentSnapshot document) => Row(
                  children: <Widget>[
                    Text(document['scope']),
                    Text(document['day'].toString()),
                    Text(document['serie'].toString()),
                  ],
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                ))
            .toList(),
        Spacer(),
      ],
    ));
  }
}