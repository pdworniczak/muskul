import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:muskul/pushups/pushups.dart';

import 'scheduleString.dart';

main() {
  test('simple unit test', () {
    var result = 1 + 3;
    expect(result, 4);
  });

  group('Schedule', () {
    test('Schedule.fromJson', () {
      var schedule = Schedule.fromJson(jsonDecode(scheduleString));

      expect(
          schedule
              .getScope(Scope.SCOPE_11_20)
              .getDay(5)
              .getSeries()
              .getSerieExpectedResult(4),
          13);
    });
  });
}
