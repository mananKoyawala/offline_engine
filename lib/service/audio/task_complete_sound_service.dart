import 'package:audioplayers/audioplayers.dart';
import 'package:offline_engine/core/global_getters.dart';

class TaskCompleteSoundService {
  TaskCompleteSoundService._();

  static final AudioPlayer _player = AudioPlayer();

  static Future<void> playSelectedSound() async {
    final selectedSound = prefsInstance.getTaskCompleteSound();
    final normalizedPath = selectedSound.startsWith('assets/')
        ? selectedSound.substring('assets/'.length)
        : selectedSound;

    try {
      await _player.stop();
      await _player.play(AssetSource(normalizedPath));
    } catch (_) {
      // Sound playback should never block the task flow.
    }
  }
}
