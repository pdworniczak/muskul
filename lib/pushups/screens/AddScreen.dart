import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:muskul/pushups/models/PushupsModel.dart';
import 'package:muskul/pushups/models/TrainingModel.dart';

class AddScreen extends StatefulWidget {
  PushupsModel pushupsModel;
  TrainingModel currentTraining;
  Map<int, int> series;

  AddScreen(this.pushupsModel) {
    this.series = _getCurrentTrainingSeries();
    this.currentTraining =
        pushupsModel.getNextTraining(pushupsModel.getLastTraining());
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
    return Scaffold(
      body: Center(
        child: Column(
          children: <Widget>[
            Spacer(),
            Text(widget.currentTraining.toString()),
            ..._displayForm(),
            RaisedButton(
              child: Text('Save'),
              onPressed: () => print('save'),
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

  List<Widget> _displayForm() {
    List<Widget> entries = [];

    _getScheduleSerieForNextTraining().forEach((key, value) => {
          entries.add(Row(
            children: <Widget>[
              RaisedButton(
                child: Text('-'),
                onPressed: () => setState(() {
                  --widget.series[key];
                }),
              ),
              Text(widget.series[key].toString()),
              RaisedButton(
                child: Text('+'),
                onPressed: () => setState(() {
                  ++widget.series[key];
                }),
              ),
              Text(value.toString()),
            ],
          ))
        });
    return entries;
  }
}
