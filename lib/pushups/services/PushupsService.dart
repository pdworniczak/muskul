import 'package:muskul/pushups/models/PushupsModel.dart';
import 'package:muskul/pushups/models/ScheduleModel.dart';

class PushupsService {
  PushupsModel _pushups;

  PushupsService(PushupsModel pushups) : _pushups = pushups;

  ScheduleModel _getSchedule() {
    return _pushups.schedule;
  }
}
