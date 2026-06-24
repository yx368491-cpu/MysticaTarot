import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../domain/entities/reading.dart';

/// Provider for managing reading history via Hive
class ReadingHistoryProvider extends ChangeNotifier {
  late Box _historyBox;
  List<ReadingRecord> _records = [];
  bool _isLoaded = false;

  static const int _maxRecords = 500;

  List<ReadingRecord> get records => List.unmodifiable(_records);
  bool get isLoaded => _isLoaded;
  int get count => _records.length;

  /// Initialize and load history from Hive
  Future<void> init() async {
    _historyBox = Hive.box('reading_history');
    _loadFromHive();
    _isLoaded = true;
    notifyListeners();
  }

  void _loadFromHive() {
    final data = _historyBox.get('records') as List<dynamic>? ?? [];
    _records = data
        .map((e) => ReadingRecord.fromJson(e))
        .toList()
      ..sort((a, b) => b.timestamp.compareTo(a.timestamp));
  }

  void _saveToHive() {
    _historyBox.put(
      'records',
      _records.map((r) => r.toJson()).toList(),
    );
  }

  /// Add a new reading record
  Future<void> addRecord(ReadingRecord record) async {
    _records.insert(0, record);
    // Enforce max records limit
    if (_records.length > _maxRecords) {
      _records = _records.sublist(0, _maxRecords);
    }
    _saveToHive();
    notifyListeners();
  }

  /// Delete a specific record
  Future<void> deleteRecord(String id) async {
    _records.removeWhere((r) => r.id == id);
    _saveToHive();
    notifyListeners();
  }

  /// Clear all history
  Future<void> clearAll() async {
    _records.clear();
    _saveToHive();
    notifyListeners();
  }

  /// Get a record by index
  ReadingRecord? getRecord(int index) {
    if (index < 0 || index >= _records.length) return null;
    return _records[index];
  }

  /// Get records for a specific month/year
  List<ReadingRecord> getRecordsForMonth(int year, int month) {
    return _records.where((r) =>
        r.timestamp.year == year && r.timestamp.month == month
    ).toList();
  }
}
