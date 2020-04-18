import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'package:muskul/pushups/models/TrainingModel.dart';
import 'package:muskul/pushups/models/PushupsModel.dart';

class ListScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Material(child: Consumer<PushupsModel>(
      builder: (context, pushups, _) {
        pushups.getTrainings();

        return Column(
          children: [
            Spacer(),
            Text("List"),
            ...pushups.trainings
                .map((TrainingModel document) => Column(
                      children: <Widget>[
                        Row(
                          children: <Widget>[
                            Text(document.date.toDate().toString()),
                          ],
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        ),
                        Row(
                          children: <Widget>[
                            Text(document.scope),
                            ...(document.runtimeType == TestTraining)
                                ? [
                                    Text((document as TestTraining)
                                        .result
                                        .toString())
                                  ]
                                : [
                                    Text((document as RegularTraining)
                                        .day
                                        .toString()),
                                    Text((document as RegularTraining)
                                        .result
                                        .toString()),
                                  ],
                          ],
                        )
                      ],
                    ))
                .toList(),
            Spacer(),
          ],
        );
      },
    ));
  }
}
