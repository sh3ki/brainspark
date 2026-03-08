import 'package:flutter_test/flutter_test.dart';
import 'package:brainspark/main.dart';

void main() {
  testWidgets('BrainSpark smoke test', (WidgetTester tester) async {
    await tester.pumpWidget(const BrainSparkApp());
    expect(find.byType(BrainSparkApp), findsOneWidget);
  });
}
