import 'package:audioplayers/audioplayers.dart';

/// Sound utility for playing audio effects
class SoundUtils {
  SoundUtils._();

  static final AudioPlayer _player = AudioPlayer();
  static bool _enabled = true;

  /// Enable or disable sound effects
  static void setEnabled(bool enabled) {
    _enabled = enabled;
  }

  /// Check if sound is enabled
  static bool get isEnabled => _enabled;

  /// Play shuffle sound
  static Future<void> playShuffle() async {
    if (!_enabled) return;
    await _play('sounds/shuffle.wav');
  }

  /// Play flip card sound
  static Future<void> playFlip() async {
    if (!_enabled) return;
    await _play('sounds/flip.wav');
  }

  /// Play fan card sound
  static Future<void> playFan() async {
    if (!_enabled) return;
    await _play('sounds/fan.wav');
  }

  /// Play reveal sound
  static Future<void> playReveal() async {
    if (!_enabled) return;
    await _play('sounds/reveal.wav');
  }

  /// Play a sound from assets
  static Future<void> _play(String path) async {
    try {
      await _player.stop();
      await _player.play(AssetSource(path));
    } catch (e) {
      // Sound file not found - silently ignore
    }
  }

  /// Dispose the player
  static void dispose() {
    _player.dispose();
  }
}
