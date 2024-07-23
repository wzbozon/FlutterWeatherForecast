import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:weather_now/main.dart';

void main() {
  testWidgets('MyWidget has a title and message', (tester) async {
    await tester.pumpWidget(const ProviderScope(
      child: App(showOnboarding: false),
    ));
    final titleFinder = find.text('Today');
    expect(titleFinder, findsOneWidget);
  });
}
