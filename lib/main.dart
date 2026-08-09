import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:z_sports_booking/app.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initializeDateFormatting('ar');
  runApp(const ZSportsApp());
}
