import 'package:flutter_test/flutter_test.dart';
import 'package:z_sports_booking/app.dart';
import 'package:z_sports_booking/features/splash/presentation/splash_screen.dart';

void main() {
  testWidgets('App loads splash screen', (WidgetTester tester) async {
    await tester.pumpWidget(const ZSportsApp());
    await tester.pump();

    expect(find.byType(SplashScreen), findsOneWidget);
  });
}
