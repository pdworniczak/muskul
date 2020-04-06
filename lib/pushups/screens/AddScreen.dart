import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:muskul/pushups/models/PushupsModel.dart';
import 'package:muskul/pushups/models/TrainingModel.dart';

class AddScreen extends StatefulWidget {
  PushupsModel pushupsModel;
  TrainingModel currentTraining;

  AddScreen(this.pushupsModel) {
    this.currentTraining =
        pushupsModel.getNextTraining(pushupsModel.getLastTraining());

    if (this.currentTraining is RegularTraining) {
      (this.currentTraining as RegularTraining).result.add(0);
    }
  }

  @override
  State<StatefulWidget> createState() {
    return _AddScreenState();
  }

  Map<int, int> _getCurrentTrainingSeries() {
    final lastTraining =
        pushupsModel.getNextTraining(pushupsModel.getLastTraining());

    return Map.from(
        pushupsModel.schedule.findTrainingScheduledSeries(lastTraining).series);
  }
}

class _AddScreenState extends State<AddScreen> {
  @override
  Widget build(BuildContext context) {
    var series = _getScheduleSerieForNextTraining();
    var training = (widget.currentTraining as RegularTraining);

    return Scaffold(
      body: Center(
        child: Column(
          children: <Widget>[
            Spacer(),
            Text(widget.currentTraining.toString()),
            ..._displayRegularTrainingForm(),
            if (training.result.length < series.length)
              RaisedButton(
                child: Text('Next'),
                onPressed: () => setState(() {
                  training.result.add(0);
                }),
              ),
            RaisedButton(
              child: Text('Save'),
              onPressed: () => print(widget.currentTraining),
            ),
            Spacer(),
          ],
        ),
      ),
    );
  }

  TrainingModel _getNextTraining() {
    return widget.pushupsModel
        .getNextTraining(widget.pushupsModel.getLastTraining());
  }

  Map<int, int> _getScheduleSerieForNextTraining() {
    return widget.pushupsModel.schedule
        .findTrainingScheduledSeries(_getNextTraining())
        .series;
  }

  List<Widget> _displayRegularTrainingForm() {
    List<Widget> entries = [];
    var training = (widget.currentTraining as RegularTraining);
    var series = _getScheduleSerieForNextTraining();

    for (int i = 0; i < training.result.length; i++) {
      if (i == training.result.length - 1) {
        entries.add(Column(children: <Widget>[
          Text(series[i + 1].toString()),
          Row(children: <Widget>[
            Spacer(),
            RaisedButton(
              child: Text('-'),
              onPressed: () => setState(() {
                --training.result[i];
              }),
            ),
            Text(training.result[i].toString()),
            RaisedButton(
              child: Text('+'),
              onPressed: () => setState(() {
                ++training.result[i];
              }),
            ),
            Spacer()
          ]),
        ]));
      } else {
        entries.add(Text(training.result[i].toString()));
      }
    }

    return entries;
  }
}
