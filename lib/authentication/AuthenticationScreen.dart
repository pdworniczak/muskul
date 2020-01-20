import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'package:muskul/navigation/navigation.dart' as navigation;
import 'package:muskul/pushups/models/PushupsModel.dart';

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
    var pushupsModel = Provider.of<PushupsModel>(context);

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

                      FirebaseAuth.instance
                          .signInWithEmailAndPassword(
                              email: email, password: password)
                          .then(
                        (result) {
                          pushupsModel.getTrainings();
                          navigation.toNavigation(context);
                        },
                      );
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
