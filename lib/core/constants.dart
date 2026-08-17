class AppAudio {
  static const String tunk = 'assets/audio/tunk.wav';
  static const String fahhh = 'assets/audio/fahhh.mp3';
  static const String gunShot = 'assets/audio/gun_shot.mp3';
  static const String errorSound = 'assets/audio/error_sound.mp3';
  static const String duckToy = 'assets/audio/duck_toy.mp3';
  static const String aayein = 'assets/audio/aayein.mp3';
  static const String dingSound = 'assets/audio/ding_sound.mp3';
  static const String thunder = 'assets/audio/thunder.mp3';
  static const String chaloo = 'assets/audio/chaloo.mp3';
  static const String cid = 'assets/audio/cid.mp3';

  static const String defaultTaskCompleteSound = tunk;

  static const List<AppAudioOption> taskCompleteSounds = [
    AppAudioOption(label: 'Tunk', assetPath: tunk),
    AppAudioOption(label: 'Fahhh', assetPath: fahhh),
    AppAudioOption(label: 'Gun Shot', assetPath: gunShot),
    AppAudioOption(label: 'Error Sound', assetPath: errorSound),
    AppAudioOption(label: 'Duck Toy', assetPath: duckToy),
    AppAudioOption(label: 'Aayein', assetPath: aayein),
    AppAudioOption(label: 'Ding Sound', assetPath: dingSound),
    AppAudioOption(label: 'Thunder', assetPath: thunder),
    AppAudioOption(label: 'Chaloo', assetPath: chaloo),
    AppAudioOption(label: 'CID', assetPath: cid),
  ];
}

class AppAudioOption {
  final String label;
  final String assetPath;

  const AppAudioOption({required this.label, required this.assetPath});
}
