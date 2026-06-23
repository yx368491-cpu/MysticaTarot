// Normalize a JSON-like map for use with entity `fromJson` factories.
//
// Hive writes a `Map<String, dynamic>` and reads back the same `Map` instance,
// but Dart's runtime exposes it as a dynamic-keyed map because stored object
// types are erased. A top-level `Map<String, dynamic>.from(map)` only fixes
// the surface-level key cast; nested structures (Maps inside values, Maps
// inside Lists) keep dynamic-keyed types at every depth, and the entity
// factory's `c as Map<String, dynamic>` cast then throws `_Map<dynamic,
// dynamic>` is not a subtype of `Map<String, dynamic>`.
//
// Use this helper at the entry point of every `*Entity.fromJson` factory
// so the input is recursively coerced to a fully String-keyed graph at
// every depth, including Lists of Maps.
//
// Bug-log reference: docs/bug-log.md entry 004.

/// Recursively normalize a JSON-like value (Map or List-or-other) read from
/// sources that may erase Dart's static types (notably Hive, which returns
/// `Map<dynamic, dynamic>` and `List<dynamic>` whose Map elements are also
/// dynamic-keyed). Returns:
///   * a Map with String keys and recursively-normalized values, when raw
///     is a Map;
///   * a List with every element recursively normalized, when raw is a List;
///   * the value as-is for primitives (String / num / bool / null).
/// Throws ArgumentError for anything else (e.g. a Set or custom class).
dynamic normalizeJsonValue(dynamic raw) {
  if (raw == null || raw is String || raw is num || raw is bool) return raw;
  if (raw is Map) return normalizeJsonMap(raw);
  if (raw is List) return raw.map(normalizeJsonValue).toList();
  throw ArgumentError(
    'normalizeJsonValue does not know how to handle ${raw.runtimeType}',
  );
}

Map<String, dynamic> normalizeJsonMap(dynamic raw) {
  if (raw is Map<String, dynamic>) return raw;
  if (raw is Map) {
    // Insertion order is preserved because Dart's default Map literal is
    // LinkedHashMap-backed; this matters for round-trip equality assertions.
    final out = <String, dynamic>{};
    raw.forEach((k, v) => out[k.toString()] = normalizeJsonValue(v));
    return out;
  }
  throw ArgumentError(
    'normalizeJsonMap expected a Map, got ${raw.runtimeType}',
  );
}
