import 'package:flutter_test/flutter_test.dart';

import 'package:sharedroute/injection_container.dart';
import 'package:sharedroute/main.dart';

void main() {
  testWidgets('SharedRoute app smoke test', (WidgetTester tester) async {
    setupDependencies();
    await tester.pumpWidget(const SharedRouteApp());

    expect(find.text('SharedRoute'), findsOneWidget);
  });
}
