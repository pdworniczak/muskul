import 'package:shared_preferences/shared_preferences.dart';

class Store {
  static SharedPreferences _perf;

  static init() async {
    _perf = await SharedPreferences.getInstance();
    return _perf;
  }

  static SharedPreferences getInstance() {
    return _perf;
  }
}
