import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:z_sports_booking/core/localization/language_cubit.dart';
import 'package:z_sports_booking/features/booking/presentation/booking_success_screen.dart';

void main() {
  testWidgets('BookingSuccessScreen renders without crashing', (
    WidgetTester tester,
  ) async {
    FlutterError.onError = (FlutterErrorDetails details) {
      FlutterError.presentError(details);
    };

    await tester.pumpWidget(
      BlocProvider(
        create: (_) => LanguageCubit(),
        child: const MaterialApp(home: BookingSuccessScreen()),
      ),
    );

    await tester.pumpAndSettle();
    expect(find.text('تم تأكيد الحجز بنجاح'), findsOneWidget);
  });
}
