// Hive "process restart" simulation. We open a box in a temp dir, write
// data (mirroring the shape of our record entities), close the box, then
// re-open from the same temp directory — that round-trip is the closest
// in-process analogue to closing the app and re-launching. We assert the
// serialized map survives intact (keys, values, types).
//
// This runs in the default fast suite (no widget pumping, no real app boot).

import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:hive/hive.dart';
import 'package:mystica_tarot/features/tarot/domain/entities/reading.dart';

void main() {
  late Directory tempDir;

  // Box names this test file uses; tracked explicitly because hive 2.x
  // does not expose a public box-names API.
  const boxNames = [
    'reading_records',
    'reading_recs_2',
    'empty_box_for_restart',
    'daily_cards',
  ];

  setUpAll(() async {
    tempDir = Directory.systemTemp.createTempSync('hive_restart_test_');
    Hive.init(tempDir.path);
  });

  tearDownAll(() async {
    // Windows-safe teardown order: close each box first (releases file
    // handles) then Hive.close() (drains registry) then deleteFromDisk
    // (removes on-disk files) then finally remove the temp dir. Matches
    // the same Windows race-avoidance pattern from the widget-test fix.
    for (final name in boxNames) {
      if (Hive.isBoxOpen(name)) {
        await Hive.box<Map>(name).close();
      }
    }
    await Hive.close();
    await Hive.deleteFromDisk();
    if (tempDir.existsSync()) {
      tempDir.deleteSync(recursive: true);
    }
  });

  group('Hive restart — Map record round-trip', () {
    test('first session: write, close', () async {
      final box = await Hive.openBox<Map>('reading_records');
      await box.put('rec1', {
        'id': 'rec-001',
        'timestamp': DateTime.utc(2026, 6, 23, 10, 0).toIso8601String(),
        'type': 'tarot',
        'spreadId': 'three',
        'cards': [
          {'cardIndex': 0, 'isReversed': false, 'position': 0},
          {'cardIndex': 1, 'isReversed': true, 'position': 1},
        ],
        'userInput': 'birthday:1990',
        'notes': 'first session',
      });
      await box.close();
    });

    test('second session (simulating restart): box reopens with same data', () async {
      final box = await Hive.openBox<Map>('reading_records');
      expect(box.isOpen, isTrue);
      final stored = box.get('rec1');
      expect(stored, isNotNull);
      expect(stored!['id'], 'rec-001');
      expect(stored['type'], 'tarot');
      expect(stored['userInput'], 'birthday:1990');
      expect(stored['cards'], isA<List>());
      final cards = stored['cards'] as List;
      expect(cards.length, 2);
      expect((cards[0] as Map)['cardIndex'], 0);
      expect((cards[1] as Map)['isReversed'], true);
    });

    test('second session can write a new record alongside the old', () async {
      final box = await Hive.openBox<Map>('reading_records');
      await box.put('rec2', {
        'id': 'rec-002',
        'timestamp': DateTime.utc(2026, 6, 24, 9, 0).toIso8601String(),
        'type': 'astrology',
        'cards': <Map>[],
        'userInput': null,
        'notes': null,
      });
      expect(box.length, 2);
      final rec2 = box.get('rec2');
      expect(rec2!['id'], 'rec-002');
      expect(rec2['type'], 'astrology');
    });

    test('closed-then-reopened boxes survive in boxNames', () async {
      await Hive.box<Map>('reading_records').close();
      final box = await Hive.openBox<Map>('reading_records');
      expect(box.length, 2);
      expect(box.keys, containsAll(['rec1', 'rec2']));
    });
  });

  group('ReadingRecord serialization survives Hive boundary', () {
    test('toJson → store → fromJson round-trips after restart', () async {
      final original = ReadingRecord(
        id: 'rec-HR-001',
        timestamp: DateTime.utc(2026, 6, 23, 12, 0),
        type: DivinationType.tarot,
        spreadId: 'three',
        cards: const [
          CardResult(cardIndex: 7, isReversed: true, position: 0),
          CardResult(cardIndex: 12, isReversed: false, position: 1),
        ],
        userInput: 'hello',
        notes: 'hive round-trip test',
      );

      // Session 1: serialize, close.
      var box = await Hive.openBox<Map>('reading_recs_2');
      await box.put(original.id, original.toJson());
      await box.close();

      // Session 2: reopen and deserialize. ReadingRecord.fromJson now
      // accepts `dynamic` so callers don't have to cast; production
      // normalizes the Hive-restored dynamic-keyed nested map graph
      // internally via `normalizeJsonMap` (lib/core/util/json_normalize.dart).
      box = await Hive.openBox<Map>('reading_recs_2');
      final raw = box.get(original.id)!;
      final restored = ReadingRecord.fromJson(raw);
      expect(restored, equals(original));
      expect(restored.hashCode, original.hashCode);
    });

    test('restart with empty box returns empty', () async {
      final box = await Hive.openBox<Map>('empty_box_for_restart');
      expect(box.isEmpty, isTrue);
      expect(box.length, 0);
    });
  });

  group('DailyCardRecord serialization survives Hive boundary', () {
    test('round-trip a daily card record across close + reopen', () async {
      final box = await Hive.openBox<Map>('daily_cards');
      await box.put('2026-06-23', {
        'date': '2026-06-23',
        'cardType': 'tarot',
        'cardIndex': 21,
        'isReversed': false,
        'readingText': 'The World — completion.',
        'timestamp': DateTime.utc(2026, 6, 23, 9, 0).toIso8601String(),
      });
      await box.close();

      final reopened = await Hive.openBox<Map>('daily_cards');
      final raw = reopened.get('2026-06-23')!;
      expect(raw['cardType'], 'tarot');
      expect(raw['cardIndex'], 21);
      expect(raw['readingText'], contains('World'));
    });
  });
}
