import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'package:muskul/pushups/models/TrainingModel.dart';
import 'package:muskul/pushups/models/PushupsModel.dart';

class ListScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Material(
      child: Consumer<PushupsModel>(
          builder: (context, pushups, _) => Column(
                children: [
                  Spacer(),
                  Text("List"),
                  ...pushups.trainings
                      .map((TrainingModel document) => Row(
                            children: <Widget>[
                              Text(document.toString()),
                            ],
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          ))
                      .toList(),
                  Spacer(),
                ],
              )),
    );
  }
}
