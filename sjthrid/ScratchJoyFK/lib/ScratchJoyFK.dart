import 'package:flutter/services.dart';

//TODO:修改所有的函数名
final class ScratchJoyFK {
  static final ScratchJoyFK instance = ScratchJoyFK._internal();

  ScratchJoyFK._internal();

  final _methodChannel = const MethodChannel('ScratchJoyFK');

  //设备是否被Root
  Future<bool> sj_root() async {
    return (await _methodChannel.invokeMethod("root")) == true;
  }

  //是否连接VPN网络
  Future<bool> sj_vpn() async {
    return (await _methodChannel.invokeMethod("vpn")) == true;
  }

  //设备是否有可用的sim卡
  Future<bool> sj_sim() async {
    return (await _methodChannel.invokeMethod("sim")) == true;
  }

  //设备是否为模拟器
  Future<bool> sj_simulator() async {
    return (await _methodChannel.invokeMethod("simulator")) == true;
  }

  //应用是否安装自Google play store
  Future<bool> sj_store() async {
    return (await _methodChannel.invokeMethod("store")) == true;
  }

  //设备是否启用开发者模式
  Future<bool> sj_developer() async {
    return (await _methodChannel.invokeMethod("developer")) == true;
  }

  //安装应用的安装器程序的包名
  Future<String> sj_installer() async {
    return await _methodChannel.invokeMethod("installer");
  }

  //初始化数盟平台
  Future<void> sj_initNumberUnit({required String apiKey}) async {
    await _methodChannel.invokeMethod("initNumberUnit", apiKey);
  }

  //从数盟平台读取数盟可信ID，对应文档请求参数：did
  Future<String> sj_getNumberUnitID({String channel = "", String message = ""}) async {
    return (await _methodChannel.invokeMethod("getNumberUnitID", {
          "channel": channel,
          "message": message,
        })) ??
        "";
  }
}
