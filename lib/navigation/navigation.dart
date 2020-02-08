import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:muskul/authentication/AuthenticationScreen.dart';
import 'package:muskul/navigation/NavigationScreen.dart';
import 'package:muskul/pushups/screens/AddScreen.dart';
import 'package:muskul/pushups/screens/ListScreen.dart';

void toNavigation(BuildContext context) {
  Navigator.pushReplacement(
      context, MaterialPageRoute(builder: (context) => NavigationScreen()));
}

void toAuthentication(BuildContext context) {
  Navigator.pushReplacement(
      context, MaterialPageRoute(builder: (context) => AuthenticationScreen()));
}

void toList(BuildContext context) {
  Navigator.push(
      context, MaterialPageRoute(builder: (context) => ListScreen()));
}

toAdd(BuildContext context) {
  Navigator.push(context, MaterialPageRoute(builder: (context) => AddScreen()));
}
