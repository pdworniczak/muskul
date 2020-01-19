import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';

class Pushups extends ChangeNotifier {
  Schedule _schedule;

  void init() async {
    if (_schedule == null) {
      String scheduleString =
          await rootBundle.loadString('assets/pushups.json');

      this._schedule = Schedule.fromJson(jsonDecode(scheduleString));
      print('init schedule ${this._schedule}');
      notifyListeners();
    }
  }

  Schedule get schedule {
    print('get schedule');

    return this._schedule;
  }
}

class Schedule {
  List<ScheduleScope> _scopes = [];

  Schedule.fromJson(Map<String, dynamic> scheduleJson) {
    scheduleJson.forEach((scope, value) {
      _scopes.add(ScheduleScope.fromJson(scope, value));
    });
  }

  ScheduleScope getScope(String scope) {
    return _scopes.firstWhere((scheduleScope) => scheduleScope._scope == scope);
  }

  @override
  String toString() {
    return this._scopes.toString();
  }
}

class ScheduleScope {
  String _scope;
  List<ScheduleDay> _days = [];

  ScheduleScope.fromJson(this._scope, Map<String, dynamic> scopeJson) {
    scopeJson.forEach((day, value) {
      _days.add(ScheduleDay.fromJson(int.parse(day), scopeJson));
    });
  }

  ScheduleDay getDay(int day) {
    return _days.firstWhere((scheduleDay) => scheduleDay._day == day);
  }

  @override
  String toString() {
    return '$_scope: $_days';
  }
}

class ScheduleDay {
  int _day;
  ScheduleSerie _series;

  ScheduleDay.fromJson(this._day, Map<String, dynamic> dayJson) {
    dayJson.forEach((day, value) {
      _series = ScheduleSerie.fromJson(value);
    });
  }

  ScheduleSerie getSeries() {
    return _series;
  }

  @override
  String toString() {
    return '$_day: $_series';
  }
}

class ScheduleSerie {
  Map<int, int> _series = {};

  ScheduleSerie.fromJson(Map<String, dynamic> seriesJson) {
    seriesJson.forEach((no, value) {
      _series[int.parse(no)] = int.parse(value.toString());
    });
  }

  int getSerieExpectedResult(int serie) {
    return _series[serie];
  }

  @override
  String toString() {
    return '$_series';
  }
}

class Training {
  DateTime _date;
  String _uid;
  String _scope;
}

class TestTraining extends Training {
  int _result;
}

class RegularTraining extends Training {
  int _day;
  List<int> _result;
}

class Scope {
  static const TEST = 'TEST';
  static const SCOPE_0_5 = '0-5';
  static const SCOPE_6_10 = '6-10';
  static const SCOPE_11_20 = '11-20';
  static const SCOPE_21_25 = '21-25';
  static const SCOPE_26_30 = '26-30';
  static const SCOPE_31_35 = '31-35';
  static const SCOPE_36_40 = '36-40';
  static const SCOPE_41_45 = '41-45';
  static const SCOPE_46_50 = '46-50';
  static const SCOPE_51_55 = '51-55';
  static const SCOPE_56_60 = '56-60';
  static const SCOPE_60_100 = '60-100';
}
