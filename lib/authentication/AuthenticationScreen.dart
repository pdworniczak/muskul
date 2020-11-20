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
  bool isError = false;
  String errorMessage = "";

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
              Padding(
                padding: EdgeInsets.only(
                    bottom: MediaQuery.of(context).viewInsets.bottom),
                child: Container(
                  width: 260,
                  child: Column(
                    children: <Widget>[
                      TextFormField(
                        decoration: InputDecoration(labelText: "email"),
                        onChanged: (val) {
                          setState(() {
                            isError = false;
                          });
                        },
                        onSaved: (val) => email = val,
                        validator: (value) => value.isEmpty
                            ? "Proszę podać prawidłowy email."
                            : null,
                      ),
                      TextFormField(
                          decoration: InputDecoration(
                            labelText: "hasło",
                          ),
                          obscureText: true,
                          onChanged: (val) {
                            setState(() {
                              isError = false;
                            });
                          },
                          onSaved: (val) => password = val,
                          validator: (value) =>
                              value.isEmpty ? "Proszę podać hasło." : null),
                      RaisedButton(
                          child: Text("Zaloguj"), onPressed: login(context)),
                      Visibility(
                        child: Text(
                          'Błędny login lub hasło',
                          style: TextStyle(
                              fontSize: 14,
                              color: Color.fromRGBO(255, 0, 0, 1)),
                        ),
                        visible: isError,
                      ),
                    ],
                  ),
                ),
              ),
              Spacer(),
            ],
          ),
        ),
      ),
    );
  }

  Function login(BuildContext context) {
    var pushupsModel = Provider.of<PushupsModel>(context);

    return () async {
      FormState authenticationFormState = _authenticationFormKey.currentState;
      authenticationFormState.save();
      if (authenticationFormState.validate()) {
        print("email: $email password: $password");

        try {
          await FirebaseAuth.instance
              .signInWithEmailAndPassword(email: email, password: password);
          await pushupsModel.getTrainings();
          navigation.toNavigation(context);
        } on FirebaseAuthException catch (e) {
          setState(() {
            isError = true;
          });
          print('FirebaseAuthException ${e.message}');
        }
      }
    };
  }
}
