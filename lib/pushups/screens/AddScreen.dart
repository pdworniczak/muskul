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
  TrainingModel _currentTraining;
  int _currentResult = 0;
  int _time = 0;
  Timer _timer;
  bool _isSaving = false;

  AddScreen(this.pushupsModel) {
    this._currentTraining =
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
            _header(widget._currentTraining),
            ...widget._isSaving ||
                    widget.pushupsModel
                        .isTrainingFinished(widget._currentTraining)
                ? [
                    Text(widget.pushupsModel
                            .isTrainingSucessfull(widget._currentTraining)
                        ? 'SUKCES!'
                        : 'Może uda się następnym razem.')
                  ]
                : widget._currentTraining is TestTraining
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
    var training = (widget._currentTraining as TestTraining);
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
      RaisedButton(
          child: Text(widget._isSaving ? 'Zapisywanie...' : 'Zapisz'),
          disabledColor: Colors.grey,
          onPressed: widget._isSaving ? null : () => _saveTraining(context))
    ];
  }

  List<Widget> _displayRegularTraining() {
    var scheduledSeries = _getScheduleSerieForTraining(widget._currentTraining);
    var training = (widget._currentTraining as RegularTraining);

    print(
        '${widget._currentResult} ${training.result.length} ${scheduledSeries.getSerieExpectedResult(1)}');

    var isFirstSeries =
        () => training.result.length == 0 && widget._currentResult == 0;
    var isSerieSuccessful = () =>
        widget._currentResult >=
        scheduledSeries.getSerieExpectedResult(training.result.length);
    var isLastSerie =
        () => training.result.length + 1 == scheduledSeries.series.length;

    return isFirstSeries()
        ? [
            RaisedButton(
              child: Text('Start'),
              onPressed: () {
                setState(() {
                  widget._currentResult =
                      scheduledSeries.getSerieExpectedResult(1);
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
                      training.result.add(widget._currentResult);
                      _saveTraining(context);
                      Wakelock.disable();
                    })
                : (widget._time > 0)
                    ? Padding(
                        child: Text('${widget._time}'),
                        padding: EdgeInsets.all(5),
                      )
                    : RaisedButton(
                        child: Text('Następna'),
                        onPressed: () {
                          setState(() {
                            training.result.add(widget._currentResult);
                            if (isSerieSuccessful()) {
                              widget._currentResult =
                                  scheduledSeries.getSerieExpectedResult(
                                      training.result.length + 1);
                              setState(() {
                                widget._time = WAIT_TIME;
                              });
                              var interval = new Duration(seconds: 1);
                              widget._timer =
                                  new Timer.periodic(interval, (Timer timer) {
                                if (widget._time > 0) {
                                  setState(() {
                                    widget._time -= 1;
                                  });
                                } else {
                                  widget._timer.cancel();
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
    var training = (widget._currentTraining as RegularTraining);
    var scheduledSeries = _getScheduleSerieForTraining(training);

    for (int i = 0; i <= training.result.length; i++) {
      if (i == training.result.length) {
        if (widget._time == 0) {
          entries.add(Column(children: <Widget>[
            Row(children: <Widget>[
              Spacer(),
              Padding(
                padding: EdgeInsets.all(5),
                child: RaisedButton(
                  child: Text('-'),
                  onPressed: () => setState(() {
                    --widget._currentResult;
                  }),
                ),
              ),
              Text(widget._currentResult.toString(),
                  style: TextStyle(
                    color: (widget._currentResult >=
                            scheduledSeries.getSerieExpectedResult(i + 1))
                        ? Colors.green
                        : Colors.red,
                  )),
              Padding(
                padding: EdgeInsets.all(5),
                child: RaisedButton(
                  child: Text('+'),
                  onPressed: () => setState(() {
                    ++widget._currentResult;
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
      widget._isSaving = true;
    });
    widget.pushupsModel.saveTraining(widget._currentTraining).then((result) {
      print('SUCCESS ${result.toString()}');
      widget.pushupsModel.getTrainings().whenComplete(() => setState(() {
            navigation.toHistoryReplace(context);
          }));
    }).catchError((error) {
      print('ERROR ${error.toString()}');
    }).whenComplete(() {
      setState(() {
        widget._isSaving = false;
      });
    });
  }

  Widget _header(TrainingModel training) {
    var series = _getScheduleSerieForTraining(widget._currentTraining);

    List<Widget> header = [];
    if (training is RegularTraining) {
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
