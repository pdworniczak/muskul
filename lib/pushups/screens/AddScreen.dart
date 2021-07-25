import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:muskul/pushups/models/ScheduleModel.dart';
import 'package:wakelock/wakelock.dart';
import 'package:intl/intl.dart';
import 'package:muskul/pushups/models/PushupsModel.dart';
import 'package:muskul/pushups/models/TrainingModel.dart';
import 'package:muskul/navigation/navigation.dart' as navigation;

const WAIT_TIME = 60;

class AddScreen extends StatefulWidget {
  final PushupsModel pushupsModel;

  AddScreen(this.pushupsModel);

  @override
  State<StatefulWidget> createState() {
    return _AddScreenState(this.pushupsModel);
  }
}

class _AddScreenState extends State<AddScreen> {
  TrainingModel _currentTraining;
  int _currentResult = 0;
  int _time = 0;
  Timer _timer;
  bool _isSaving = false;

  _AddScreenState(PushupsModel pushupsModel) {
    this._currentTraining =
        pushupsModel.getNextTraining(pushupsModel.getLastTraining());
  }

  @override
  void dispose() {
    Wakelock.disable();
    if (this._timer != null) {
      this._timer.cancel();
    }
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
            _header(_currentTraining),
            ..._isSaving ||
                    widget.pushupsModel.isTrainingFinished(_currentTraining)
                ? [
                    Text(widget.pushupsModel
                            .isTrainingSucessfull(_currentTraining)
                        ? 'SUKCES!'
                        : 'Może uda się następnym razem.')
                  ]
                : _currentTraining is TestTraining
                    ? _displayTestTraining()
                    : _displayRegularTraining(),
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
    var training = (_currentTraining as TestTraining);
    return [
      Row(
        children: <Widget>[
          RaisedButton(
            child: Text('-'),
            onPressed: () => setState(() {
              --_currentResult;
            }),
          ),
          Container(
              margin: EdgeInsets.all(10),
              child: Text(
                _currentResult.toString(),
              )),
          RaisedButton(
            child: Text('+'),
            onPressed: () => setState(() {
              ++_currentResult;
            }),
          ),
        ],
        mainAxisAlignment: MainAxisAlignment.center,
      ),
      RaisedButton(
          child: Text(_isSaving ? 'Zapisywanie...' : 'Zapisz'),
          disabledColor: Colors.grey,
          onPressed: _isSaving
              ? null
              : () {
                  training.result = _currentResult;
                  _saveTraining(context);
                })
    ];
  }

  List<Widget> _displayRegularTraining() {
    var scheduledSeries = _getScheduleSerieForTraining(_currentTraining);
    var training = (_currentTraining as RegularTraining);

    print(
        '$_currentResult ${training.result.length} ${scheduledSeries.getSerieExpectedResult(1)}');

    var isFirstSeries =
        () => training.result.length == 0 && _currentResult == 0;
    var isSerieSuccessful = () =>
        _currentResult >=
        scheduledSeries.getSerieExpectedResult(training.result.length);
    var isLastSerie =
        () => training.result.length + 1 == scheduledSeries.series.length;

    return isFirstSeries()
        ? [
            RaisedButton(
              child: Text('Start'),
              onPressed: () {
                setState(() {
                  _currentResult = scheduledSeries.getSerieExpectedResult(1);
                });
              },
            )
          ]
        : [
            ..._displayRegularTrainingForm(),
            isLastSerie()
                ? RaisedButton(
                    child: Text('Zapisz'),
                    onPressed: () {
                      training.result.add(_currentResult);
                      _saveTraining(context);
                      Wakelock.disable();
                    })
                : (_time > 0)
                    ? Padding(
                        child: Text('$_time'),
                        padding: EdgeInsets.all(5),
                      )
                    : RaisedButton(
                        child: Text('Następna'),
                        onPressed: () {
                          setState(() {
                            training.result.add(_currentResult);
                            if (isSerieSuccessful()) {
                              _currentResult =
                                  scheduledSeries.getSerieExpectedResult(
                                      training.result.length + 1);
                              setState(() {
                                _time = WAIT_TIME;
                              });
                              var interval = new Duration(seconds: 1);
                              _timer =
                                  new Timer.periodic(interval, (Timer timer) {
                                if (_time > 0) {
                                  setState(() {
                                    _time -= 1;
                                  });
                                } else {
                                  _timer.cancel();
                                }
                              });
                            } else {
                              _saveTraining(context);
                              Wakelock.disable();
                            }
                          });
                        },
                      ),
          ];
  }

  List<Widget> _displayRegularTrainingForm() {
    List<Widget> entries = [];
    var training = (_currentTraining as RegularTraining);
    var scheduledSeries = _getScheduleSerieForTraining(training);

    for (int i = 0; i <= training.result.length; i++) {
      if (i == training.result.length) {
        if (_time == 0) {
          entries.add(Column(children: <Widget>[
            Row(children: <Widget>[
              Spacer(),
              Padding(
                padding: EdgeInsets.all(5),
                child: RaisedButton(
                  child: Text('-'),
                  onPressed: () => setState(() {
                    --_currentResult;
                  }),
                ),
              ),
              Text(_currentResult.toString(),
                  style: TextStyle(
                    color: (_currentResult >=
                            scheduledSeries.getSerieExpectedResult(i + 1))
                        ? Colors.green
                        : Colors.red,
                  )),
              Padding(
                padding: EdgeInsets.all(5),
                child: RaisedButton(
                  child: Text('+'),
                  onPressed: () => setState(() {
                    ++_currentResult;
                  }),
                ),
              ),
              Spacer()
            ]),
          ]));
        }
      } else {
        entries.add(Text(training.result[i].toString()));
      }
    }

    return entries;
  }

  void _saveTraining(BuildContext context) {
    setState(() {
      _isSaving = true;
    });
    widget.pushupsModel.saveTraining(_currentTraining).then((result) {
      print('SUCCESS ${result.toString()}');
      widget.pushupsModel.getTrainings().whenComplete(() => setState(() {
            navigation.toHistoryReplace(context);
          }));
    }).catchError((error) {
      print('ERROR ${error.toString()}');
    }).whenComplete(() {
      setState(() {
        _isSaving = false;
      });
    });
  }

  Widget _header(TrainingModel training) {
    List<Widget> header = [];
    if (training is RegularTraining) {
      var series = _getScheduleSerieForTraining(_currentTraining);
      header.add(Text("dzień: ${training.day}"));
      header.add(Text("serie: ${series.toString()}"));
    }

    return Column(children: [
      Text(new DateFormat.yMd().format(training.date.toDate())),
      Text(
        training.scope,
        textScaleFactor: 2,
      ),
      Container(
        margin: EdgeInsets.all(20),
        child: Column(
          children: header,
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceAround,
        ),
      )
    ]);
  }
}
