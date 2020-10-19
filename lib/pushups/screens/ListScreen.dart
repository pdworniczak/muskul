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
            body: Padding(
              padding: EdgeInsets.all(20),
              child: Table(
                border: TableBorder(horizontalInside: BorderSide(width: 1)),
                columnWidths: {
                  0: IntrinsicColumnWidth(),
                  1: IntrinsicColumnWidth(),
                  2: IntrinsicColumnWidth(),
                  3: FlexColumnWidth(1),
                },
                defaultVerticalAlignment: TableCellVerticalAlignment.middle,
                children: [
                  TableRow(children: [
                    Padding(
                      padding: EdgeInsets.all(5),
                      child: Text('data'),
                    ),
                    Padding(
                      padding: EdgeInsets.all(5),
                      child: Text('zakres'),
                    ),
                    Padding(
                      padding: EdgeInsets.all(5),
                      child: Text('dzień'),
                    ),
                    Padding(padding: EdgeInsets.all(5), child: Text('wynik')),
                  ]),
                  ...pushups.trainings.map((TrainingModel training) {
                    if (training.runtimeType == RegularTraining) {
                      return TableRow(
                        children: <Widget>[
                          Padding(
                            padding: EdgeInsets.all(5),
                            child: Text(new DateFormat.yMd()
                                .format(training.date.toDate())),
                          ),
                          Padding(
                            padding: EdgeInsets.all(5),
                            child: Text(training.scope),
                          ),
                          Padding(
                            padding: EdgeInsets.all(5),
                            child: Text(
                                (training as RegularTraining).day.toString()),
                          ),
                          Padding(
                            padding: EdgeInsets.all(5),
                            child: Text((training as RegularTraining)
                                .result
                                .toString()
                                .replaceAll('[', '')
                                .replaceAll(']', '')),
                          ),
                        ],
                      );
                    } else if (training.runtimeType == TestTraining) {
                      return TableRow(
                        children: [
                          Padding(
                            padding: EdgeInsets.all(5),
                            child: Text(new DateFormat.yMd()
                                .format(training.date.toDate())),
                          ),
                          Padding(
                            padding: EdgeInsets.all(5),
                            child: Text('TEST'),
                          ),
                          Padding(
                            padding: EdgeInsets.all(5),
                            child: Text('-'),
                          ),
                          Padding(
                            padding: EdgeInsets.all(5),
                            child: Text(
                                (training as TestTraining).result.toString()),
                          ),
                        ],
                      );
                    }
                  }).toList(),
                ],
              ),
            ));
      },
    ));
  }
}
