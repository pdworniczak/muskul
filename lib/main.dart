import 'package:flutter/material.dart';

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
                    }
                    // Navigator.pushReplacement(
                    //     context,
                    //     MaterialPageRoute(
                    //         builder: (context) => NavigationScreen()));
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
            onPressed: () => Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                    builder: (context) => AuthenticationScreen())),
          )
        ],
      ),
      body: Container(
        alignment: AlignmentDirectional.center,
        child: Column(
          children: <Widget>[
            Spacer(),
            RaisedButton(
              child: Text("Add"),
              onPressed: () => print("Add"),
            ),
            RaisedButton(
              child: Text("List"),
              onPressed: () => print("List"),
            ),
            Spacer(flex: 2),
          ],
        ),
      ),
    );
  }
}
