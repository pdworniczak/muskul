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
              .series
              .getSerieExpectedResult(4),
          11);
      expect(
          schedule
              .getScope(Scope.SCOPE_11_20)
              .getDay(2)
              .series
              .getSerieExpectedResult(4),
          8);
    });
  });

  var trainingSerie = {
    "testTrainingJSON": {
      'date': Timestamp.fromDate(DateTime.now()),
      'uid': 'EvS0jZSzTdet2xK6gcxfVoZ5RMP2',
      'scope': Scope.TEST,
      'serie': {"count": 51}
    },
    "regularTrainingJSON": {
      "date": Timestamp.fromDate(DateTime.now()),
      "uid": "EvS0jZSzTdet2xK6gcxfVoZ5RMP2",
      "scope": Scope.SCOPE_51_55,
      "serie": {1: 30, 2: 39, 3: 33, 4: 0, 5: 0},
      "day": 1
    },
    "regularTrainingCompletedJSON": {
      "date": Timestamp.fromDate(DateTime.now()),
      "uid": "EvS0jZSzTdet2xK6gcxfVoZ5RMP2",
      "scope": Scope.SCOPE_26_30,
      "serie": {1: 30, 2: 39, 3: 33, 4: 33, 5: 41},
      "day": 1
    }
  };

  var trainingResult = {
    "testTrainingJSON": {
      'date': Timestamp.fromDate(DateTime.now()),
      'uid': 'EvS0jZSzTdet2xK6gcxfVoZ5RMP2',
      'scope': Scope.TEST,
      'result': 51
    },
    "regularTrainingJSON": {
      "date": Timestamp.fromDate(DateTime.now()),
      "uid": "EvS0jZSzTdet2xK6gcxfVoZ5RMP2",
      "scope": Scope.SCOPE_51_55,
      "result": [30, 39, 33, 0, 0],
      "day": 1
    },
    "regularTrainingCompletedJSON": {
      "date": Timestamp.fromDate(DateTime.now()),
      "uid": "EvS0jZSzTdet2xK6gcxfVoZ5RMP2",
      "scope": Scope.SCOPE_26_30,
      "result": [30, 39, 33, 33, 41],
      "day": 1
    }
  };

  group('Training', () {
    var pushups = PushupsModel();
    pushups.initSchedule();

    group("create", () {
      group("serie", () {
        test('Test training from json', () {
          var testTraining =
              TestTraining.fromJson(trainingSerie['testTrainingJSON']);
          expect(testTraining.scope, Scope.TEST);
          expect(testTraining.result, 51);
        });

        test('regular training from json', () {
          var regTraining =
              RegularTraining.fromJson(trainingSerie['regularTrainingJSON']);
          expect(regTraining.day, 1);
          expect(regTraining.scope, Scope.SCOPE_51_55);
          expect(regTraining.result, [30, 39, 33, 0, 0]);
        });

        test('regular training completed from json', () {
          var regTraining = RegularTraining.fromJson(
              trainingSerie['regularTrainingCompletedJSON']);
          expect(regTraining.day, 1);
          expect(regTraining.scope, Scope.SCOPE_26_30);
          expect(regTraining.result, [30, 39, 33, 33, 41]);
        });
      });

      group("result", () {
        test('Test training from json', () {
          var testTraining =
              TestTraining.fromJson(trainingResult['testTrainingJSON']);
          expect(testTraining.scope, Scope.TEST);
          expect(testTraining.result, 51);
        });

        test('regular training from json', () {
          var regTraining =
              RegularTraining.fromJson(trainingResult['regularTrainingJSON']);
          expect(regTraining.day, 1);
          expect(regTraining.scope, Scope.SCOPE_51_55);
          expect(regTraining.result, [30, 39, 33, 0, 0]);
        });

        test('regular training completed from json', () {
          var regTraining = RegularTraining.fromJson(
              trainingResult['regularTrainingCompletedJSON']);
          expect(regTraining.day, 1);
          expect(regTraining.scope, Scope.SCOPE_26_30);
          expect(regTraining.result, [30, 39, 33, 33, 41]);
        });
      });
    });

    group("completed", () {
      test('test completed', () {
        expect(
            pushups.isTrainingSucessfull(
                TestTraining.fromJson(trainingSerie['testTrainingJSON'])),
            true);
      });

      test('training not completed', () {
        expect(
            pushups.isTrainingSucessfull(
                RegularTraining.fromJson(trainingSerie['regularTrainingJSON'])),
            false);
      });

      test('training completed', () {
        expect(
            pushups.isTrainingSucessfull(RegularTraining.fromJson(
                trainingSerie['regularTrainingCompletedJSON'])),
            true);
      });
    });

    group("next", () {
      var date = Timestamp.fromDate(DateTime.now());
      test("test", () {
        var training = TestTraining(date, 16);
        var nextTraining = pushups.getNextTraining(training);

        expect(
            nextTraining.toString(),
            RegularTraining.emptyResult(Scope.SCOPE_11_20, nextTraining.date, 1)
                .toString());
      });

      test("fail", () {
        var training = RegularTraining(Scope.SCOPE_11_20, date, 3, [0]);
        var nextTraining = pushups.getNextTraining(training);

        expect(
            nextTraining.toString(),
            RegularTraining.emptyResult(Scope.SCOPE_11_20, nextTraining.date, 1)
                .toString());
      });

      test("success", () {
        var training =
            RegularTraining(Scope.SCOPE_11_20, date, 3, [11, 13, 9, 9, 13]);
        var nextTraining = pushups.getNextTraining(training);

        expect(
            nextTraining.toString(),
            RegularTraining.emptyResult(Scope.SCOPE_11_20, nextTraining.date, 1)
                .toString());
      });

      test("success last", () {
        var training =
            RegularTraining(Scope.SCOPE_11_20, date, 6, [14, 16, 13, 13, 19]);
        var nextTraining = pushups.getNextTraining(training);

        expect(nextTraining.toString(),
            TestTraining.emptyResult(nextTraining.date).toString());
      });
    });
  });
}
