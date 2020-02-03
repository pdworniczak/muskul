import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:muskul/pushups/Consts.dart';
import 'package:muskul/pushups/models/ScheduleModel.dart';
import 'package:muskul/pushups/models/TrainingModel.dart';

class PushupsModel extends ChangeNotifier {
  ScheduleModel _schedule;
  List<TrainingModel> _trainings = [];

  ScheduleModel get schedule => this._schedule;

  List<TrainingModel> get trainings => _trainings;

  void initSchedule() async {
    if (_schedule == null) {
      String scheduleString =
          await rootBundle.loadString('assets/pushups.json');

      this._schedule = ScheduleModel.fromJson(jsonDecode(scheduleString));
      print('init schedule ${this._schedule}');
      notifyListeners();
    }
  }

  void getTrainings() {
    FirebaseAuth.instance.currentUser().then(
      (user) {
        Firestore.instance
            .collection('pushups')
            .where('uid', isEqualTo: user.uid)
            .snapshots()
            .listen(
          (data) {
            data.documents.forEach((document) {
              if (document['scope'] == Scope.TEST) {
                _trainings.add(TestTraining.fromJson(document.data));
              } else {
                _trainings.add(RegularTraining.fromJson(document.data));
              }
            });
          },
        );
      },
    );
  }

  void logoutUser() {
    _trainings = [];
  }

  bool isTrainingCompleted(TrainingModel training) {
    if (training.scope == Scope.TEST) {
      return true;
    }

    var seriesSchedule = schedule.findTrainingScheduledSeries(training);

    for (int i = 0; i < seriesSchedule.series.length; i++) {
      if ((training as RegularTraining).result[i] <
          seriesSchedule.series[i + 1]) {
        return false;
      }
    }

    return true;
  }
}
