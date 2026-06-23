import 'dart:math';

/// Utility for deterministic random number generation
/// Uses seeds for reproducible results (e.g., daily card)
class RandomUtils {
  RandomUtils._();

  /// Generate a seeded random number in range [min, max]
  static int seededInt(int seed, int min, int max) {
    final random = Random(seed);
    return min + random.nextInt(max - min + 1);
  }

  /// Generate a seeded boolean
  static bool seededBool(int seed) {
    final random = Random(seed);
    return random.nextBool();
  }

  /// Generate a seeded list of unique indices
  static List<int> seededUniqueIndices(int seed, int count, int max) {
    final random = Random(seed);
    final indices = <int>{};
    while (indices.length < count) {
      indices.add(random.nextInt(max));
    }
    return indices.toList();
  }

  /// Shuffle a list deterministically using a seed
  static List<T> seededShuffle<T>(List<T> items, int seed) {
    final random = Random(seed);
    final shuffled = List<T>.from(items);
    shuffled.shuffle(random);
    return shuffled;
  }
}
