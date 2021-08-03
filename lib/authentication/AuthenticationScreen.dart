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
  bool isLoading = false;

  @override
  void initState() {
    if (_pref.getStringList('user') != null &&
        _pref.getStringList('user').length == 2) {
      setState(() {
        isLoading = true;
      });
      login(context, _pref.getStringList('user'));
    }

    super.initState();
  }

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
            child: isLoading
                ? Text("Wczytywanie!")
                : Container(
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
                        ElevatedButton(
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
    )));
  }

  Function handleFormLogin(BuildContext context) {
    return () async {
      FormState authenticationFormState = _authenticationFormKey.currentState;
      authenticationFormState.save();
      if (authenticationFormState.validate()) {
        print("email: $email password: $password");

        login(context, [email, password]);
      }
    };
  }

  login(BuildContext context, List<String> credentials) async {
    print('===> login');
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: credentials[0], password: credentials[1]);
      await Provider.of<PushupsModel>(context, listen: false).getTrainings();
      _pref.setStringList('user', [email, password]);
      navigation.toNavigation(context);
      print('===> logged');
    } on FirebaseAuthException catch (ex) {
      setState(() {
        isError = true;
      });
      Store.getInstance().remove("user");
      print('FirebaseAuthException ${ex.message}');
    }
    setState(() {
      isLoading = false;
    });
  }
}
