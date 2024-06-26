import 'package:flutter/material.dart';
import 'package:just_audio_background/just_audio_background.dart';

import 'src/app.dart';

void main() async {
  await JustAudioBackground.init(
    androidNotificationChannelId: 'com.ryanheise.bg_demo.channel.audio',
    androidNotificationChannelName: 'Audio playback',
    androidNotificationIcon: "drawable/ic_player",
    androidNotificationOngoing: true,
  );

  WidgetsFlutterBinding.ensureInitialized();
  runApp(const App());
}
