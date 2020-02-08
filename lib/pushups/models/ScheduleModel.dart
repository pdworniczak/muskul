import 'package:muskul/pushups/models/TrainingModel.dart';

class ScheduleModel {
  List<ScheduleScope> _scopes = [];

  ScheduleModel.fromJson(Map<String, dynamic> scheduleJson) {
    scheduleJson.forEach((scope, value) {
      _scopes.add(ScheduleScope.fromJson(scope, value));
    });
  }

  ScheduleScope getScope(String scope) {
    return _scopes.firstWhere((scheduleScope) => scheduleScope._scope == scope);
  }

  ScheduleSerie findTrainingScheduledSeries(RegularTraining training) {
    return this.getScope(training.scope).getDay(training.day).series;
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

  ScheduleDay get lastDay {
    return _days
        .reduce((current, next) => current._day < next._day ? next : current);
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

  int get day {
    return _day;
  }

  ScheduleSerie get series {
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

  Map<int, int> get series {
    return _series;
  }

  int getSerieExpectedResult(int serie) {
    return _series[serie];
  }

  @override
  String toString() {
    return '$_series';
  }
}
