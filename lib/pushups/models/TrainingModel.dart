import 'package:cloud_firestore/cloud_firestore.dart';

class TrainingModel {
  Timestamp _date;
  String _uid;
  String _scope;

  TrainingModel(this._scope, this._date, this._uid);
}

class TestTraining extends TrainingModel {
  int _result;

  TestTraining(String scope, Timestamp date, String uid, this._result)
      : super(scope, date, uid);

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

  @override
  String toString() {
    return 'SCOPE $_scope DATE: ${_date.toDate()} DAY: $_day RESULT: $_result';
  }
}
