import 'package:flutter_test/flutter_test.dart';
import 'package:cosmic/app/app.dart';

void main() {
  testWidgets('Dashboard smoke test – renders without error',
      (WidgetTester tester) async {
    await tester.pumpWidget(const CosmicApp());
    await tester.pump();
    expect(find.text('LUNARALIGN'), findsOneWidget);
  });
}
