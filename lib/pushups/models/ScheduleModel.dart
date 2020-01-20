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