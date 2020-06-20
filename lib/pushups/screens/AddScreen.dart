import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:wakelock/wakelock.dart';
import 'package:muskul/pushups/models/PushupsModel.dart';
import 'package:muskul/pushups/models/TrainingModel.dart';
import 'package:muskul/navigation/navigation.dart' as navigation;

class AddScreen extends StatefulWidget {
  PushupsModel pushupsModel;
  TrainingModel currentTraining;
  bool finished = false;

  AddScreen(this.pushupsModel) {
    this.currentTraining =
        pushupsModel.getNextTraining(pushupsModel.getLastTraining());
  }

  @override
  State<StatefulWidget> createState() {
    return _AddScreenState();
  }
}

class _AddScreenState extends State<AddScreen> {

 @override
  void dispose() {
    Wakelock.disable();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Wakelock.enable();

    return Scaffold(
      body: Center(
        child: Column(
          children: <Widget>[
            Spacer(),
            Text(widget.currentTraining.toString()),
            ...(widget.currentTraining is TestTraining
                ? _displayTestTraining()
                : _displayRegularTraining()),
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

  Map<int, int> _getScheduleSerieForTraining(RegularTraining training) {
    return widget.pushupsModel.schedule
        .findTrainingScheduledSeries(training)
        .series;
  }

  List<Widget> _displayTestTraining() {
    var training = (widget.currentTraining as TestTraining);
    return [
      Row(children: <Widget>[
        Spacer(),
        RaisedButton(
          child: Text('-'),
          onPressed: () => setState(() {
            --training.result;
          }),
        ),
        Text(training.result.toString()),
        RaisedButton(
          child: Text('+'),
          onPressed: () => setState(() {
            ++training.result;
          }),
        ),
        Spacer(),
      ]),
      RaisedButton(child: Text('Save'), onPressed: () => _saveTraining(context))
    ];
  }

  List<Widget> _displayRegularTraining() {
    var series = _getScheduleSerieForTraining(widget.currentTraining);
    var training = (widget.currentTraining as RegularTraining);

    return [
      Text(series.toString()),
      ..._displayRegularTrainingForm(),
      if (training.result.length < series.length)
        RaisedButton(
          child: Text(training.result.length > 0 ? 'Next' : 'Start'),
          onPressed: () {
            setState(() {
              if (training.result.length != 0 &&
                  training.result.last < series[training.result.length]) {
                _saveTraining(context);
                Wakelock.disable();
              } else {
                training.result.add(series[training.result.length + 1]);
              }
            });
          },
        ),
      if (training.result.length == series.length)
        RaisedButton(
            child: Text('Save'),
            onPressed: () {
              _saveTraining(context); 
              Wakelock.disable();
            })
    ];
  }

  List<Widget> _displayRegularTrainingForm() {
    List<Widget> entries = [];
    var training = (widget.currentTraining as RegularTraining);
    var series = _getScheduleSerieForTraining(training);

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

  void _saveTraining(BuildContext context) {
    print(widget.currentTraining);

    widget.pushupsModel.saveTraining(widget.currentTraining).then((result) {
      print('SUCCESS ${result.toString()}');
      navigation.toList(context);
    }).catchError((error) {
      print('ERROR ${error.toString()}');
    });
  }
}
