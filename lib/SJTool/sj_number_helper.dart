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

  TaskRootModel? last_taskModel;

  TaskRootModel? taskModel;

  ProbabilityConfig? probabilityConfigModel;

  BonusConfig? bonusConfigModel;

  Future<void> initNumberModel() async {
    await _sjloadintDataFromLocate();
    await _sjloadtaskDataFromLocate();
    await _sjloadprobabilityDataFromLocate();
    await _sjloadwinup_numberDataFromLocate();
    await _sjloadlsattaskDataFromLocate();
  }

  Future<void> _sjloadintDataFromLocate() async {
    String jsonString = await rootBundle.loadString("c130_ad_int".jsons());
    Map<String, dynamic> jsonMap = json.decode(jsonString);
    intModel = RootModel.fromJson(jsonMap);
    "ScratchJoy int json = ${intModel}".log();
  }

  Future<void> _sjloadtaskDataFromLocate() async {
      String jsonString = await rootBundle.loadString("c130_withdraw_task".jsons());
      Map<String, dynamic> jsonMap = json.decode(jsonString);
      taskModel = TaskRootModel.fromJson(jsonMap);
    "ScratchJoy task json = ${taskModel}".log();
  }

  Future<void> _sjloadlsattaskDataFromLocate() async {
      String jsonString = await rootBundle.loadString("c130_withdraw_last_task".jsons());
      Map<String, dynamic> jsonMap = json.decode(jsonString);
      last_taskModel = TaskRootModel.fromJson(jsonMap);
    "ScratchJoy task json = ${last_taskModel}".log();
  }

  Future<void> _sjloadprobabilityDataFromLocate() async {
      String jsonString = await rootBundle.loadString("probability_reset".jsons());
      Map<String, dynamic> jsonMap = json.decode(jsonString);
      probabilityConfigModel = ProbabilityConfig.fromJson(jsonMap);
    "ScratchJoy probabilityConfig json = ${probabilityConfigModel}".log();
  }

  Future<void> _sjloadwinup_numberDataFromLocate() async {
      String jsonString = await rootBundle.loadString("winup_number".jsons());
      Map<String, dynamic> jsonMap = json.decode(jsonString);
      bonusConfigModel = BonusConfig.fromJson(jsonMap);
    "ScratchJoy winup_number json = ${bonusConfigModel}".log();
  }

  // 插屏概率获取
  bool checkProbability() {
    // 找到 value 所在的区间
    double range = 0.0;
    for (var item in intModel!.intAd) {
      if (SJLocalProvider.instance.sj_dolas_old_number >= item.firstNumber && SJLocalProvider.instance.sj_dolas_old_number <= item.endNumber) {
        range = item.point;
        break;
      }
    }
    'range=$range'.log();
    if (SJLocalProvider.instance.sj_dolas_old_number >= 1000){
      return true;
    }

    if (range <= 0.0) {
      return false;
    }

    double point = range.toDouble() ?? 0.0;

    // 随机概率判断
    double rand = Random().nextDouble(); // 0.0 ~ 1.0
    return rand <= point;
  }

  /// 获取宝箱气泡奖励值
  double getPrizeWithBoxorBubble() {
    for (var item in bonusConfigModel!.boxReward) {
      int start = item.firstNumber;
      int end = item.endNumber;

      if (SJLocalProvider.instance.sj_dolas_number >= start && SJLocalProvider.instance.sj_dolas_number < end) {
        double min = item.prize!.first;
        double max = item.prize!.last;
        return 0.to2Double(_randomBetween(min, max));
      }
    }

    /// 如果超出所有区间，返回最后一段
    var last = bonusConfigModel!.boxReward.last;
    return 0.to2Double(_randomBetween(
      last.prize!.first,
      last.prize!.last,
    ));
  }

  /// 生成[min, max]之间随机整数（兼容 double）
  int _randomBetween(double min, double max) {
    final r = Random();
    return min.toInt() + r.nextInt(max.toInt() - min.toInt() + 1);
  }

  // 获取骰子显示的数值
  List<int> getDiceValueByBalance() {
    for (var item in bonusConfigModel!.diceNumeric) {
      int start = item.firstNumber;
      int end = item.endNumber;

      if (SJLocalProvider.instance.sj_dolas_number >= start && SJLocalProvider.instance.sj_dolas_number < end) {
        return item.values;
      }
    }

    /// 如果超出所有区间，取最后一个区间
    var last = bonusConfigModel!.diceNumeric.last;
    return last.values;
  }


}