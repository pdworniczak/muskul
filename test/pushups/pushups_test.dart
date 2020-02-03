import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:muskul/pushups/Consts.dart';
import 'package:muskul/pushups/models/PushupsModel.dart';
import 'package:muskul/pushups/models/ScheduleModel.dart';
import 'package:muskul/pushups/models/TrainingModel.dart';

import 'scheduleString.dart';

main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  test('simple unit test', () {
    var result = 1 + 3;
    expect(result, 4);
  });

  group('Schedule', () {
    test('Schedule.fromJson', () {
      var schedule = ScheduleModel.fromJson(jsonDecode(scheduleString));

      expect(
          schedule
              .getScope(Scope.SCOPE_11_20)
              .getDay(5)
              .getSeries()
              .getSerieExpectedResult(4),
          13);
    });
  });

  var testTrainingJSON = {
    'date': Timestamp.fromDate(DateTime.now()),
    'uid': 'EvS0jZSzTdet2xK6gcxfVoZ5RMP2',
    'scope': Scope.TEST,
    'serie': {"count": 51}
  };
  var regularTrainingJSON = {
    "date": Timestamp.fromDate(DateTime.now()),
    "uid": "EvS0jZSzTdet2xK6gcxfVoZ5RMP2",
    "scope": Scope.SCOPE_51_55,
    "serie": {1: 30, 2: 39, 3: 33, 4: 0, 5: 0},
    "day": 1
  };
  var regularTrainingCompletedJSON = {
    "date": Timestamp.fromDate(DateTime.now()),
    "uid": "EvS0jZSzTdet2xK6gcxfVoZ5RMP2",
    "scope": Scope.SCOPE_26_30,
    "serie": {1: 30, 2: 39, 3: 33, 4: 33, 5: 41},
    "day": 1
  };

  group('Training', () {
    var pushups = PushupsModel();
    pushups.initSchedule();

    group("create", () {
      test('Test training from json', () {
        var testTraining = TestTraining.fromJson(testTrainingJSON);
      });

      test('regular training from json', () {
        var regTraining = RegularTraining.fromJson(regularTrainingJSON);
        print(regTraining);
      });
    });

    group("completed", () {
      test('test completed', () {
        expect(
            pushups
                .isTrainingCompleted(TestTraining.fromJson(testTrainingJSON)),
            true);
      });

      test('training not completed', () {
        expect(
            pushups.isTrainingCompleted(
                RegularTraining.fromJson(regularTrainingJSON)),
            false);
      });

      test('training completed', () {
        expect(
            pushups.isTrainingCompleted(
                RegularTraining.fromJson(regularTrainingCompletedJSON)),
            true);
      });
    });
  });
}
