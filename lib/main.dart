import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'app.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  try {
    // Initialize Hive database
    await Hive.initFlutter();

    // Open default boxes
    await Hive.openBox('settings');
    await Hive.openBox('reading_history');
    await Hive.openBox('daily_card');
    await Hive.openBox('favorites');

    runApp(const MysticaTarotApp());
  } catch (e, st) {
    debugPrint('FATAL — init error: $e\n$st');
    runApp(
      MaterialApp(
        debugShowCheckedModeBanner: false,
        home: Scaffold(
          body: Center(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Text(
              '启动失败\n\n$e',
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 16),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
