import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:muskul/pushups/Consts.dart';

class TrainingModel {
  Timestamp _date;
  String _uid;
  String _scope;

  TrainingModel(this._scope, this._date);

  TrainingModel.empty();

  get scope {
    return _scope;
  }

  get date {
    return _date;
  }
}

class TestTraining extends TrainingModel {
  int _result;

  TestTraining(Timestamp date, this._result) : super(Scope.TEST, date);

  TestTraining.emptyResult(Timestamp date) : this(date, 0);

  TestTraining.fromJson(Map<String, dynamic> trainingJson)
      : super(trainingJson['scope'], trainingJson['date']) {
    _uid = trainingJson['uid'];
    _result = trainingJson.containsKey('result')
        ? int.parse(trainingJson['result'])
        : trainingJson['serie']['count'];
  }

  int get result {
    return _result;
  }

  @override
  String toString() {
    return 'SCOPE $_scope DATE: ${_date.toDate()} RESULT: $_result';
  }
}

class RegularTraining extends TrainingModel {
  int _day;
  List<int> _result;

  RegularTraining(String scope, Timestamp date, this._day, this._result)
      : super(scope, date);

  RegularTraining.emptyResult(String scope, Timestamp date, int day)
      : this(scope, date, day, []);

  RegularTraining.fromJson(Map<String, dynamic> trainingJson)
      : super(trainingJson['scope'], trainingJson['date']) {
    _uid = trainingJson['uid'];
    _day = trainingJson['day'];
    _result = trainingJson.containsKey('result')
        ? trainingJson['result']
        : (trainingJson['serie'] as Map<int, int>).values.toList();
  }

  int get day {
    return _day;
  }

  List<int> get result {
    return _result;
  }

  @override
  String toString() {
    return 'SCOPE $_scope DATE: ${_date.toDate()} DAY: $_day RESULT: $_result';
  }
}
