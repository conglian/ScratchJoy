import 'dart:convert';
import 'dart:math';
import 'package:flutter/services.dart';
import 'package:scratchjoy/SJTool/sj_LocalProvider.dart';
import 'package:scratchjoy/SJTool/sj_extension_help.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../SJModel/SJAdModel.dart';
import '../SJModel/SJint_ad_model.dart';
import '../SJModel/SJprobability_config.dart';
import '../SJModel/SJtask_model.dart';
import '../SJModel/SJbonus_config.dart';
import 'SJAdManager.dart';

class SJNumberHelpers {
  static final SJNumberHelpers _instance = SJNumberHelpers._internal();

  factory SJNumberHelpers() {
    return _instance;
  }

  SJNumberHelpers._internal();

  RootModel? intModel;

  TaskRootModel? taskModel;

  ProbabilityConfig? probabilityConfigModel;

  BonusConfig? bonusConfigModel;

  Future<void> initNumberModel() async {
    await _sjloadintDataFromLocate();
    await _sjloadtaskDataFromLocate();
    await _sjloadprobabilityDataFromLocate();
    await _sjloadwinup_numberDataFromLocate();
  }

  Future<void> _sjloadintDataFromLocate() async {
    if (intModel == null) {
      String jsonString = await rootBundle.loadString("c130_ad_int".jsons());
      Map<String, dynamic> jsonMap = json.decode(jsonString);
      intModel = RootModel.fromJson(jsonMap);
    }
    "ScratchJoy int json = ${intModel}".log();
  }

  Future<void> _sjloadtaskDataFromLocate() async {
    if (taskModel == null) {
      String jsonString = await rootBundle.loadString("c130_withdraw_task".jsons());
      Map<String, dynamic> jsonMap = json.decode(jsonString);
      taskModel = TaskRootModel.fromJson(jsonMap);
    }
    "ScratchJoy task json = ${taskModel}".log();
  }

  Future<void> _sjloadprobabilityDataFromLocate() async {
    if (probabilityConfigModel == null) {
      String jsonString = await rootBundle.loadString("probability_reset".jsons());
      Map<String, dynamic> jsonMap = json.decode(jsonString);
      probabilityConfigModel = ProbabilityConfig.fromJson(jsonMap);
    }
    "ScratchJoy probabilityConfig json = ${probabilityConfigModel}".log();
  }

  Future<void> _sjloadwinup_numberDataFromLocate() async {
    if (bonusConfigModel == null) {
      String jsonString = await rootBundle.loadString("winup_number".jsons());
      Map<String, dynamic> jsonMap = json.decode(jsonString);
      bonusConfigModel = BonusConfig.fromJson(jsonMap);
    }
    "ScratchJoy winup_number json = ${bonusConfigModel}".log();
  }

  // 插屏概率获取
  bool checkProbability() {
    // 找到 value 所在的区间
    double range = 0.0;
    for (var item in intModel!.intAd) {
      if (SJLocalProvider.instance.sj_dolas_number >= item.firstNumber && SJLocalProvider.instance.sj_dolas_number <= item.endNumber) {
        range = item.point;
        break;
      }
    }

    if (range <= 0.0) {
      // 如果不在任何区间，默认返回 true
      return true;
    }

    double point = range.toDouble() ?? 0.0;

    // 随机概率判断
    double rand = Random().nextDouble(); // 0.0 ~ 1.0
    return rand <= point;
  }

}