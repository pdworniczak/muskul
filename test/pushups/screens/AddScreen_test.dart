import 'package:flutter_test/flutter_test.dart';
import 'package:muskul/pushups/models/PushupsModel.dart';
import 'package:muskul/pushups/screens/AddScreen.dart';

void main() {
  testWidgets("Test Add screen", (WidgetTester tester) async {
    await tester.pumpWidget(AddScreen(new PushupsModel()));
  });
}
