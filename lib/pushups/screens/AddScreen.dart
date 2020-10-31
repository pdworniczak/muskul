import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:muskul/pushups/models/ScheduleModel.dart';
import 'package:wakelock/wakelock.dart';
import 'package:intl/intl.dart';
import 'package:muskul/pushups/models/PushupsModel.dart';
import 'package:muskul/pushups/models/TrainingModel.dart';
import 'package:muskul/navigation/navigation.dart' as navigation;

class AddScreen extends StatefulWidget {
  final PushupsModel pushupsModel;
  TrainingModel currentTraining;

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
      appBar: AppBar(
        title: Text('Dodaj'),
      ),
      body: Center(
        child: Column(
          children: <Widget>[
            Spacer(),
            _header(widget.currentTraining),
            ...(widget.currentTraining is TestTraining
                ? _displayTestTraining()
                : _displayRegularTraining()),
            Spacer(),
          ],
        ),
      ),
    );
  }

  ScheduleSerie _getScheduleSerieForTraining(RegularTraining training) {
    return widget.pushupsModel.schedule.findTrainingScheduledSeries(training);
  }

  List<Widget> _displayTestTraining() {
    var training = (widget.currentTraining as TestTraining);
    return [
      Row(
        children: <Widget>[
          RaisedButton(
            child: Text('-'),
            onPressed: () => setState(() {
              --training.result;
            }),
          ),
          Container(
              margin: EdgeInsets.all(10),
              child: Text(
                training.result.toString(),
              )),
          RaisedButton(
            child: Text('+'),
            onPressed: () => setState(() {
              ++training.result;
            }),
          ),
        ],
        mainAxisAlignment: MainAxisAlignment.center,
      ),
      RaisedButton(child: Text('Save'), onPressed: () => _saveTraining(context))
    ];
  }

  List<Widget> _displayRegularTraining() {
    var scheduledSeries = _getScheduleSerieForTraining(widget.currentTraining);
    var training = (widget.currentTraining as RegularTraining);

    return [
      ..._displayRegularTrainingForm(),
      if (training.result.length < scheduledSeries.series.length)
        RaisedButton(
          child: Text(training.result.length > 0 ? 'Next' : 'Start'),
          onPressed: () {
            setState(() {
              if (training.result.length != 0 &&
                  training.result.last <
                      scheduledSeries
                          .getSerieExpectedResult(training.result.length)) {
                _saveTraining(context);
                Wakelock.disable();
              } else {
                training.result.add(scheduledSeries
                    .getSerieExpectedResult(training.result.length + 1));
              }
            });
          },
        ),
      if (training.result.length == scheduledSeries.series.length)
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
    var scheduledSeries = _getScheduleSerieForTraining(training);

    for (int i = 0; i < training.result.length; i++) {
      if (i == training.result.length - 1) {
        entries.add(Column(children: <Widget>[
          Text(scheduledSeries.getSerieExpectedResult(i + 1).toString()),
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

  Widget _header(TrainingModel training) {
    var series = _getScheduleSerieForTraining(widget.currentTraining);

    List<Widget> header = [
      Text(new DateFormat.yMd().format(training.date.toDate())),
    ];
    if (training is RegularTraining) {
      header.add(Text("dzień: ${training.day}"));
      header.add(Text("serie: ${series.toString()}"));
    }

    return Column(children: [
      Text(
        training.scope,
        textScaleFactor: 2,
      ),
      Container(
        margin: EdgeInsets.all(20),
        child: Row(
          children: header,
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceAround,
        ),
      )
    ]);
  }
}
