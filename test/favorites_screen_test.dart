import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'package:z_sports_booking/features/favorites/presentation/favorites_screen.dart';

void main() {
  testWidgets('FavoritesScreen pumps and shows card', (tester) async {
    FlutterError.onError = (FlutterErrorDetails details) {
      FlutterError.dumpErrorToConsole(details);
    };

    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(body: FavoritesScreen()),
      ),
    );
    await tester.pumpAndSettle();
    
    expect(find.byType(FavoritesScreen), findsOneWidget);
    expect(find.text('ملعب الملوك'), findsOneWidget); // Card title
    expect(find.text('احجز الآن'), findsOneWidget); // Card button
  });
}
