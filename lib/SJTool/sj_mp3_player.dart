import 'package:audioplayers/audioplayers.dart';
import 'package:scratchjoy/SJTool/sj_extension_help.dart';

class SJMP3Player {

  static final SJMP3Player _instance = SJMP3Player._internal();

  factory SJMP3Player() {
    return _instance;
  }

  SJMP3Player._internal();

  final AudioPlayer backgroundPlayer = AudioPlayer();
  final AudioPlayer effectPlayer = AudioPlayer();
  final AudioPlayer effect2Player = AudioPlayer();
  final AudioPlayer effect3Player = AudioPlayer();

  // 播放背景音频
  Future<void> playBackground() async {
    String path = "sj_bg1".mp3files();
    // await backgroundPlayer.setReleaseMode(ReleaseMode.loop);
    // await backgroundPlayer.play(AssetSource(path));
  }

  // 暂停背景音频
  Future<void> pauseBackground() async {
    await backgroundPlayer.pause();
  }

  // 恢复背景音频
  Future<void> resumeBackground() async {
    await backgroundPlayer.resume();
  }

  // 播放特效音频
  Future<void> playEffect() async {
    String path = "sj_guaka1".mp3files();
    // await effectPlayer.setReleaseMode(ReleaseMode.loop);
    // await effectPlayer.play(AssetSource(path));
  }

  // 暂停特效音频
  Future<void> pauseEffect() async {
    await effectPlayer.pause();
  }

  // 恢复特效音频
  Future<void> resumeEffect() async {
    await effectPlayer.resume();
  }

  // 播放特效音频
  Future<void> playEffect2() async {
    String path = "sj_guaka2".mp3files();
    // await effect2Player.setReleaseMode(ReleaseMode.loop);
    // await effect2Player.play(AssetSource(path));
  }

  // 暂停特效音频
  Future<void> pauseEffect2() async {
    await effect2Player.pause();
  }

  // 恢复特效音频
  Future<void> resumeEffect2() async {
    await effect2Player.resume();
  }

  // 播放特效音频
  Future<void> playEffect3() async {
    String path = "sj_jinbi1".mp3files();
    // await effect3Player.setReleaseMode(ReleaseMode.loop);
    // await effect3Player.play(AssetSource(path));
  }

  // 暂停特效音频
  Future<void> pauseEffect3() async {
    await effect3Player.pause();
  }

  // 恢复特效音频
  Future<void> resumeEffect3() async {
    await effect3Player.resume();
  }

  // 释放资源
  Future<void> dispose() async {
    await backgroundPlayer.dispose();
    await effectPlayer.dispose();
    await effect2Player.dispose();
    await effect3Player.dispose();
  }
}    