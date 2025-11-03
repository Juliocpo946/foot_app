import 'package:flutter_test/flutter_test.dart';
import 'package:foot_app/app/my_app.dart';
import 'package:foot_app/core/application/app_state.dart';
import 'package:foot_app/core/router/app_router.dart';
import 'package:provider/provider.dart';

void main() {
  testWidgets('App initialization test', (WidgetTester tester) async {
    final appState = AppState();
    final appRouter = AppRouter(appState: appState);

    await tester.pumpWidget(
      ChangeNotifierProvider.value(
        value: appState,
        child: MyApp(router: appRouter),
      ),
    );

    expect(find.byType(MyApp), findsOneWidget);
  });
}