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
                _trainings.add(TestTraining(document['scope'], document['date'],
                    user.uid, document['result']));
              } else {
                _trainings.add(RegularTraining(
                    document['scope'],
                    document['date'],
                    user.uid,
                    document['day'],
                    document['result']));
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
}
