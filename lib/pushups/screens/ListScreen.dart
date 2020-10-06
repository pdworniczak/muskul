import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:muskul/pushups/models/TrainingModel.dart';
import 'package:muskul/pushups/models/PushupsModel.dart';

class ListScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Material(child: Consumer<PushupsModel>(
      builder: (context, pushups, _) {
        pushups.getTrainings();

        return Scaffold(
            appBar: AppBar(
              title: Text('Lista'),
            ),
            body: Container(
              child: ListView(
                children: [
                  ...pushups.trainings.map((TrainingModel training) {
                    if (training.runtimeType == RegularTraining) {
                      return Row(
                        children: <Widget>[
                          Expanded(
                              flex: 3,
                              child: Text(new DateFormat.yMd()
                                  .format(training.date.toDate()))),
                          Expanded(flex: 2, child: Text(training.scope)),
                          Expanded(
                              flex: 1,
                              child: Text((training as RegularTraining)
                                  .day
                                  .toString())),
                          Expanded(
                              flex: 5,
                              child: Text((training as RegularTraining)
                                  .result
                                  .toString())),
                        ],
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      );
                    } else if (training.runtimeType == TestTraining) {
                      return Column(children: [
                        Center(
                          child: Text('TEST'),
                        ),
                        Row(
                          children: [
                            Text(new DateFormat.yMd()
                                .format(training.date.toDate())),
                            Text((training as TestTraining).result.toString()),
                          ],
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                        ),
                      ]);
                    }
                  }).toList(),
                ],
              ),
              padding: EdgeInsets.all(10),
            ));
      },
    ));
  }
}
