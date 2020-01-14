import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

final FirebaseAuth _auth = FirebaseAuth.instance;

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Muskuł',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: AuthenticationScreen(),
    );
  }
}

class AuthenticationScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _AuthenticationScreenState();
  }
}

class _AuthenticationScreenState extends State<AuthenticationScreen> {
  final _authenticationFormKey = GlobalKey<FormState>();

  String email = "";
  String password = "";

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Container(
        child: Form(
          key: _authenticationFormKey,
          child: Column(
            children: <Widget>[
              Spacer(),
              Text(
                "MUSKUŁ",
              ),
              SizedBox(
                height: 25,
              ),
              Container(
                width: 260,
                child: Column(
                  children: <Widget>[
                    TextFormField(
                      decoration: InputDecoration(labelText: "email"),
                      onSaved: (val) => email = val,
                      validator: (value) =>
                          value.isEmpty ? "Please enter valid email." : null,
                    ),
                    TextFormField(
                        decoration: InputDecoration(
                          labelText: "password",
                        ),
                        obscureText: true,
                        onSaved: (val) => password = val,
                        validator: (value) =>
                            value.isEmpty ? "Please enter password." : null),
                  ],
                ),
              ),
              RaisedButton(
                  child: Text("Log In"),
                  onPressed: () {
                    FormState authenticationFormState =
                        _authenticationFormKey.currentState;
                    authenticationFormState.save();
                    if (authenticationFormState.validate()) {
                      print("email: $email password: $password");

                      _auth
                          .signInWithEmailAndPassword(
                              email: email, password: password)
                          .then((authResult) {
                        Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (context) => NavigationScreen()));
                      });
                    }
                  }),
              Spacer(),
            ],
          ),
        ),
      ),
    );
  }
}

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
              _auth.signOut().then(
                (_) {
                  Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                          builder: (context) => AuthenticationScreen()));
                },
              );
            },
          )
        ],
      ),
      body: Container(
        alignment: AlignmentDirectional.center,
        child: Column(
          children: <Widget>[
            Spacer(),
            RaisedButton(child: Text("Add"), onPressed: () => print('Add')),
            RaisedButton(
              child: Text("List"),
              onPressed: () => Navigator.push(context,
                  MaterialPageRoute(builder: (context) => ListScreen())),
            ),
            Spacer(flex: 2),
          ],
        ),
      ),
    );
  }
}

class ListScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _ListScreenState();
  }
}

class _ListScreenState extends State<ListScreen> {
  var trainings = <DocumentSnapshot>[];

  @override
  void initState() {
    super.initState();
    FirebaseAuth.instance.currentUser().then((user) {
      Firestore.instance
          .collection('pushups')
          .where('uid', isEqualTo: user.uid)
          .snapshots()
          .listen((data) => trainings = data.documents);
      // .forEach((doc) => print("${doc['scope']} ${doc['date']}")));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Material(
        child: Column(
      children: <Widget>[
        Spacer(),
        Text("List"),
        ...trainings
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
