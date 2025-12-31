import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:scratchjoy/SJTool/sj_extension_help.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../SJModel/SJAdModel.dart';
import 'SJAdManager.dart';

class SJAdHelpers {
  static final SJAdHelpers _instance = SJAdHelpers._internal();

  factory SJAdHelpers() {
    return _instance;
  }

  SJAdHelpers._internal();

  SJAdModel? ad_Entity;

  Future<void> initAd() async {
    await _sjloadAdDataFromLocate();
  }

  Future<void> _sjloadAdDataFromLocate() async {
    //   String jsonString = await rootBundle.loadString("scxji_ad_config".jsons());
    //   Map<String, dynamic> jsonMap = json.decode(jsonString);
    //   ad_Entity = SJAdModel.fromJson(jsonMap);
    // "ScratchJoy ad json = ${ad_Entity}".log();
  }

}