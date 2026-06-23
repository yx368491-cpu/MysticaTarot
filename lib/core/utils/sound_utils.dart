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
    await _play('sounds/shuffle.mp3');
  }

  /// Play flip card sound
  static Future<void> playFlip() async {
    if (!_enabled) return;
    await _play('sounds/flip.mp3');
  }

  /// Play fan card sound
  static Future<void> playFan() async {
    if (!_enabled) return;
    await _play('sounds/fan.mp3');
  }

  /// Play reveal sound
  static Future<void> playReveal() async {
    if (!_enabled) return;
    await _play('sounds/reveal.mp3');
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
