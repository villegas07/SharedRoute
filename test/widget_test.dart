import 'package:flutter_test/flutter_test.dart';

import 'package:sharedroute/injection_container.dart';
import 'package:sharedroute/main.dart';
import 'package:sharedroute/features/auth/presentation/viewmodels/auth_viewmodel.dart';

void main() {
  testWidgets('SharedRoute app smoke test', (WidgetTester tester) async {
    await setupDependencies();
    final authViewModel = sl<AuthViewModel>();
    await tester.pumpWidget(SharedRouteApp(authViewModel: authViewModel));

    expect(find.text('SharedRoute'), findsOneWidget);
  });
}
