import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:muskul/service/store.dart';
import 'package:provider/provider.dart';
import 'package:muskul/navigation/navigation.dart' as navigation;
import 'package:muskul/pushups/models/PushupsModel.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
  SharedPreferences _pref = Store.getInstance();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(future: () {
      var credentials = Store.getInstance().getStringList('user');

      if (_pref.getStringList('user') != null &&
          _pref.getStringList('user').length == 2) {
        return login(context, credentials);
      }
      return [];
    }(), builder: (BuildContext context, AsyncSnapshot snapshot) {
      print(
          '${ConnectionState.done} ${snapshot.connectionState} ${snapshot.data}');
      if (snapshot.data == null) {
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
                              child: Text("Zaloguj"),
                              onPressed: handleFormLogin(context)),
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
      return Text("Ładowanie");
    });
  }

  Function handleFormLogin(BuildContext context) {
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
          _pref.setStringList('user', [email, password]);
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

  login(BuildContext context, List<String> credentials) async {
    print('===> login');
    var pushupsModel = Provider.of<PushupsModel>(context);
    await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: credentials[0], password: credentials[1]);
    await pushupsModel.getTrainings();
    navigation.toNavigation(context);

    print('===> logged');
  }
}
