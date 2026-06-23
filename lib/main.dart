import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'app.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Hive database
  await Hive.initFlutter();

  // Register adapters (will be added as we create them)
  // await Hive.registerAdapter(TarotCardAdapter());
  // await Hive.registerAdapter(ReadingRecordAdapter());
  // await Hive.registerAdapter(CardResultAdapter());
  // await Hive.registerAdapter(AppSettingsAdapter());

  // Open default boxes
  await Hive.openBox('settings');
  await Hive.openBox('reading_history');
  await Hive.openBox('daily_card');
  await Hive.openBox('favorites');

  runApp(const MysticaTarotApp());
}
