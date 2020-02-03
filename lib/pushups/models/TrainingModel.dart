import 'package:cloud_firestore/cloud_firestore.dart';

class TrainingModel {
  Timestamp _date;
  String _uid;
  String _scope;

  TrainingModel(this._scope, this._date, this._uid);

  TrainingModel.empty();

  get scope {
    return _scope;
  }
}

class TestTraining extends TrainingModel {
  int _result;

  TestTraining(String scope, Timestamp date, String uid, this._result)
      : super(scope, date, uid);

  TestTraining.fromJson(Map<String, dynamic> trainingJson)
      : super(
            trainingJson['scope'], trainingJson['date'], trainingJson['uid']) {
    _result = trainingJson.containsKey('result')
        ? int.parse(trainingJson['result'])
        : trainingJson['serie']['count'];
  }

  @override
  String toString() {
    return 'SCOPE $_scope DATE: ${_date.toDate()} RESULT: $_result';
  }
}

class RegularTraining extends TrainingModel {
  int _day;
  List<int> _result;

  RegularTraining(
      String scope, Timestamp date, String uid, this._day, this._result)
      : super(scope, date, uid);

  RegularTraining.fromJson(Map<String, dynamic> trainingJson)
      : super(
            trainingJson['scope'], trainingJson['date'], trainingJson['uid']) {
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
