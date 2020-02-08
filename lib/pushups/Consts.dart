import 'package:intl/intl.dart';

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

  static String getScopeOfTestResult(int result) {
    return [
      SCOPE_0_5,
      SCOPE_6_10,
      SCOPE_11_20,
      SCOPE_21_25,
      SCOPE_26_30,
      SCOPE_31_35,
      SCOPE_36_40,
      SCOPE_41_45,
      SCOPE_46_50,
      SCOPE_51_55,
      SCOPE_56_60,
      SCOPE_60_100
    ].firstWhere((scope) {
      var scopeResults = scope.split("-").map((val) => int.parse(val));

      return result >= scopeResults.first && result <= scopeResults.last;
    });
  }
}
