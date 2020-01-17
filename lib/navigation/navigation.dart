import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'NavigationScreen.dart';
import '../authentication/AuthenticationScreen.dart';
import '../pushups/ListScreen.dart';

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
