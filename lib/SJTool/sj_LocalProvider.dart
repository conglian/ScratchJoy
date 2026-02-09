import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:scratchjoy/SJTool/SJTBAInfoTool.dart';
import 'package:scratchjoy/SJTool/sj_extension_help.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../SJModel/SJTXModel.dart';
import '../main.dart';

class SJLocalProvider extends ChangeNotifier {
  // 1. 私有构造函数（禁止外部直接创建实例）
  SJLocalProvider._();

  // 2. 静态单例实例
  static final SJLocalProvider _instance = SJLocalProvider._();

  // 3. 提供全局访问点
  static SJLocalProvider get instance => _instance;

  SJTXModel txEntity = SJTXModel();

  String sj_Scratch_timeKey_0 = '';
  String sj_Scratch_timeKey_1 = '';
  String sj_Scratch_timeKey_2 = '';
  String sj_Scratch_timeKey_3 = '';
  String sj_Scratch_timeKey_4 = '';
  String sj_Scratch_timeKey_5 = '';
  String sj_Scratch_timeKey_6= '';
  String sj_account_id = '';
  String sj_tx_list = "";
  String sj_ratio_str = "90";


  bool sj_bg_music = true; // 存储的本地值
  bool sj_sound_music = true; // 存储的本地值
  bool sj_login_status = false; // 存储的本地值
  bool sj_scratch_status_0 = true;
  bool sj_scratch_status_1 = true;
  bool sj_scratch_status_2 = true;
  bool sj_scratch_status_3 = true;
  bool sj_scratch_status_4 = true;
  bool sj_scratch_status_5 = true;
  bool sj_scratch_status_6 = true;
  bool sj_scratch_status_7 = true;
  bool sj_scratch_status_8 = true;
  bool sj_scratch_guide = true;
  bool sj_old_guide = true;
  bool sj_new_guide = false;
  bool is_end_Scratch = true;
  bool sj_show_dolas_ani = false;
  bool sj_show_bubble = false;
  bool sj_show_box_guide = false;
  bool sj_cloak_status = false;
  bool sj_fk_number_status = false;
  bool sj_fk_decvice_status = false;
  bool sj_fk_ip_status = false;
  bool sj_fk_ad_short_show = false;
  bool sj_fk_ad_short_close = false;
  bool sj_dolas_800 = false;
  bool sj_dolas_1000 = false;
  bool sj_yunying_3 = false;
  bool sj_yunying_1 = false;
  bool sj_100_timer_star = false;
  bool sj_txing_status = false;
  bool sj_tx_first_status = false;
  bool sj_tx_last_status = false;
  bool sj_show_box_tips = false;
  bool sj_first_box_tips = false;
  bool sj_first_show_cash = false;
  bool sj_open_tx = false;
  bool sj_tx_task2_tips = false;
  bool sj_last_tx_end = false;
  bool sj_show_box = false;
  bool sj_tx_task3_tips = false;
  bool sj_tx_task4_tips = false;
  bool sj_tx_end_status = false;
  bool sj_afSwitch = true;
  bool sj_set_root = false;
  bool sj_af_status = false;
  bool sj_newA_guide = false;
  bool sj_good_review_status = false;

  int sj_scrach_unlock_index_0 = 0; // 存储的本地值
  int sj_scrach_unlock_index_1 = 0; // 存储的本地值
  int sj_ad_all_number = 0;
  double sj_dolas_number = 0.0;
  double sj_dolas_old_number = 0.0;
  int sj_ad_reawrd_all_number = 0;
  int sj_ad_short_show_number = 0;
  int sj_ad_short_close_number = 0;
  int sj_ad_show_index = 0;
  int sj_ad_show_number = 0;
  int sj_key_number = 0;
  int sj_account_seled_index = 0;
  int sj_tx_ing_account = 0;
  int sj_tx_ing_number = 0;
  int sj_tx_task_index = 0;
  int sj_current_ranking = 99;
  int sj_all_ranking = 388;
  int sj_rank_ad_count = 0;
  int sj_tx_card_index = 0;
  int sj_tx_wheel_index = 0;
  int sj_tx_bubble_index = 0;
  int sj_tx_box_index = 0;
  int sj_wheel_number = 0;
  int sj_box_index = 0;
  int sj_card_number = 0;
  int sj_Level_number = 1; // 存储的本地值
  int sj_Level_inedx = 1; // 存储的本地值
  int sj_dice_number = 0;
  int sj_card_a_number = 0;
  int sj_scrach_end_number_0 = 0; // 存储的本地值
  int sj_scrach_end_number_1 = 0; // 存储的本地值
  int sj_scrach_end_number_2 = 0; // 存储的本地值
  int sj_scrach_end_number_3 = 0; // 存储的本地值
  int sj_scrach_end_number_4 = 0; // 存储的本地值
  int sj_scrach_end_number_5 = 0; // 存储的本地值
  int sj_scrach_end_number_6 = 0; // 存储的本地值
  int sj_currentNumberIndex = 0;
  int sj_domand_number = 0;
  int sj_tx_card_first = 0;
  int sj_tx_dice_index = 0;
  // int sj_login_index = 0;
  // int sj_tx_probability_index = 0;
  int sj_scratch_not_award_number = 0;

  String get sj_currentNumberIndexName => 'sj_currentNumberIndex';
  String get sj_dice_numberName => 'sj_dice_number';
  String get sj_domand_numberName => 'sj_domand_number';
  String get sj_scrach_end_number_0Name => 'sj_scrach_end_number_0';
  String get sj_scrach_end_number_1Name => 'sj_scrach_end_number_1';
  String get sj_scrach_end_number_2Name => 'sj_scrach_end_number_2';
  String get sj_scrach_end_number_3Name => 'sj_scrach_end_number_3';
  String get sj_scrach_end_number_4Name => 'sj_scrach_end_number_4';
  String get sj_scrach_end_number_5Name => 'sj_scrach_end_number_5';
  String get sj_scrach_end_number_6Name => 'sj_scrach_end_number_6';
  String get sj_sound_musicName => 'sj_sound_music';
  String get sj_bg_musicName => 'sj_bg_music';
  String get sj_Scratch_timeKey_0Name => 'sj_Scratch_timeKey_0';
  String get sj_Scratch_timeKey_1Name => 'sj_Scratch_timeKey_1';
  String get sj_Scratch_timeKey_2Name => 'sj_Scratch_timeKey_2';
  String get sj_Scratch_timeKey_3Name => 'sj_Scratch_timeKey_3';
  String get sj_Scratch_timeKey_4Name => 'sj_Scratch_timeKey_4';
  String get sj_Scratch_timeKey_5Name => 'sj_Scratch_timeKey_5';
  String get sj_Scratch_timeKey_6Name => 'sj_Scratch_timeKey_6';
  String get sj_Level_numberName => 'sj_Level_number';
  String get sj_Level_inedxName => 'sj_Level_inedx';
  String get sj_fk_number_statusName => 'sj_fk_number_status';
  String get sj_fk_ip_statusName => 'sj_fk_ip_status';
  String get sj_fk_decvice_statusName => 'sj_fk_decvice_status';
  String get sj_ad_show_numberName => 'sj_ad_show_number';
  String get sj_ad_all_numberName => 'sj_ad_all_number';
  String get sj_ad_show_indexName => 'sj_ad_show_index';
  String get sj_ad_reawrd_all_numberName => 'sj_ad_reawrd_all_number';
  String get sj_ad_short_show_numberName => 'sj_ad_short_show_number';
  String get sj_fk_ad_short_showName => 'sj_fk_ad_short_show';
  String get sj_ad_short_close_numberName => 'sj_ad_short_close_number';
  String get sj_fk_ad_short_closeName => 'sj_fk_ad_short_close';
  String get sj_new_guideName => 'sj_new_guide';
  String get sj_ratio_strName => 'sj_ratio_str';
  String get sj_dolas_1000Name => 'sj_dolas_1000';
  String get sj_dolas_800Name => 'sj_dolas_800';
  String get sj_100_timer_starName => 'sj_100_timer_star';
  String get sj_dolas_numberName => 'sj_dolas_number';
  String get sj_card_numberName => 'sj_card_number';
  String get sj_show_dolas_aniName => 'sj_show_dolas_ani';
  String get sj_box_indexName => 'sj_box_index';
  String get sj_txing_statusName => 'sj_txing_status';
  String get sj_tx_ing_numberName => 'sj_tx_ing_number';
  String get sj_account_seled_indexName => 'sj_account_seled_index';
  String get sj_tx_ing_accountName => 'sj_tx_ing_account';
  String get sj_tx_bubble_indexName => 'sj_tx_bubble_index';
  String get sj_tx_card_indexName => 'sj_tx_card_index';
  String get sj_tx_wheel_indexName => 'sj_tx_wheel_index';
  String get sj_tx_box_indexName => 'sj_tx_box_index';
  String get sj_tx_task_indexName => 'sj_tx_task_index';
  String get sj_tx_card_firstName => 'sj_tx_card_first';
  String get sj_account_idName => 'sj_account_id';
  String get sj_tx_dice_indexName => 'sj_tx_dice_index';
  // String get sj_login_indexName => 'sj_login_index';
  // String get sj_tx_probability_indexName => 'sj_tx_probability_index';
  String get sj_tx_first_statusName => 'sj_tx_first_status';
  String get sj_tx_last_statusName => 'sj_tx_last_status';
  String get sj_current_rankingName => 'sj_current_ranking';
  String get sj_all_rankingName => 'sj_all_ranking';
  String get sj_old_guideName => 'sj_old_guide';
  String get sj_scratch_not_award_numberName => 'sj_scratch_not_award_number';
  String get sj_cloak_statusName => 'sj_cloak_status';
  String get sj_show_box_tipsName => 'sj_show_box_tips';
  String get sj_first_box_tipsName => 'sj_first_box_tips';
  String get sj_first_show_cashName => 'sj_first_show_cash';
  String get sj_scratch_guideName => 'sj_scratch_guide';
  String get sj_open_txName => 'sj_open_tx';
  String get sj_tx_task2_tipsName => 'sj_tx_task2_tips';
  String get sj_last_tx_endName => 'sj_last_tx_end';
  String get is_end_ScratchName => 'is_end_Scratch';
  String get sj_yunying_1Name => 'sj_yunying_1';
  String get sj_yunying_3Name => 'sj_yunying_3';
  String get sj_show_boxName => 'sj_show_box';
  String get sj_tx_task3_tipsName => 'sj_tx_task3_tips';
  String get sj_tx_task4_tipsName => 'sj_tx_task4_tips';
  String get sj_tx_end_statusName => 'sj_tx_end_status';
  String get sj_dolas_old_numberName => 'sj_dolas_old_number';
  String get sj_afSwitchName => 'sj_afSwitch';
  String get sj_set_rootName => 'sj_set_root';
  String get sj_login_statusName => 'sj_login_status';
  String get sj_af_statusName => 'sj_af_status';
  String get sj_newA_guideName => 'sj_newA_guide';
  String get sj_good_review_statusName => 'sj_good_review_status';
  String get sj_card_a_numberName => 'sj_card_a_number';


  // 3. 初始化：从本地存储加载数据（组件初始化时调用）
  Future<void> init() async {
    final prefs = await SharedPreferences.getInstance();
    // 从本地读取值（key自定义，需与存储时一致）
    // sj_tx_probability_index = prefs.getInt('sj_tx_probability_index') ?? 0;
    // sj_login_index = prefs.getInt('sj_login_index') ?? 0;
    sj_tx_dice_index = prefs.getInt('sj_tx_dice_index') ?? 0;
    sj_tx_card_first = prefs.getInt('sj_tx_card_first') ?? 0;
    sj_domand_number = prefs.getInt('sj_domand_number') ?? 0;
    sj_dice_number = prefs.getInt('sj_dice_number') ?? 0;
    sj_card_number = prefs.getInt('sj_card_number') ?? 0;
    sj_box_index = prefs.getInt('sj_box_index') ?? 0;
    sj_tx_box_index = prefs.getInt('sj_tx_box_index') ?? 0;
    sj_wheel_number = prefs.getInt('sj_wheel_number') ?? 0;
    sj_tx_card_index = prefs.getInt('sj_tx_card_index') ?? 0;
    sj_tx_wheel_index = prefs.getInt('sj_tx_wheel_index') ?? 0;
    sj_tx_bubble_index = prefs.getInt('sj_tx_bubble_index') ?? 0;
    sj_current_ranking = prefs.getInt('sj_current_ranking') ?? 99;
    sj_all_ranking = prefs.getInt('sj_all_ranking') ?? 388;
    sj_rank_ad_count = prefs.getInt('sj_rank_ad_count') ?? 388;
    sj_tx_task_index = prefs.getInt('sj_tx_task_index') ?? 0;
    sj_tx_ing_account = prefs.getInt('sj_tx_ing_account') ?? 0;
    sj_tx_ing_number = prefs.getInt('sj_tx_ing_number') ?? 0;
    sj_card_a_number = prefs.getInt('sj_card_a_number') ?? 0;
    sj_scratch_not_award_number = prefs.getInt('sj_scratch_not_award_number') ?? 0;
    sj_account_seled_index = prefs.getInt('sj_account_seled_index') ?? 0;
    sj_scrach_unlock_index_0 = prefs.getInt('sj_scrach_unlock_index_0') ?? 0;
    sj_scrach_unlock_index_1 = prefs.getInt('sj_scrach_unlock_index_1') ?? 0;
    sj_ad_short_show_number = prefs.getInt('sj_ad_short_show_number') ?? 0;
    sj_ad_short_close_number = prefs.getInt('sj_ad_short_close_number') ?? 0;
    sj_ad_show_number = prefs.getInt('sj_ad_show_number') ?? 0;
    sj_key_number = prefs.getInt('sj_key_number') ?? 0;
    sj_bg_music = prefs.getBool('sj_bg_music') ?? true;
    sj_sound_music = prefs.getBool('sj_sound_music') ?? true;
    sj_tx_task3_tips = prefs.getBool('sj_tx_task3_tips') ?? false;
    sj_tx_task4_tips = prefs.getBool('sj_tx_task4_tips') ?? false;
    sj_txing_status = prefs.getBool('sj_txing_status') ?? false;
    sj_login_status = prefs.getBool('sj_login_status') ?? false;
    sj_good_review_status = prefs.getBool('sj_good_review_status') ?? false;
    sj_open_tx = prefs.getBool('sj_open_tx') ?? false;
    sj_show_box = prefs.getBool('sj_show_box') ?? false;
    sj_afSwitch = prefs.getBool('sj_afSwitch') ?? true;
    sj_set_root = prefs.getBool('sj_set_root') ?? false;
    sj_af_status = prefs.getBool('sj_af_status') ?? false;
    is_end_Scratch = prefs.getBool('is_end_Scratch') ?? true;
    sj_cloak_status = prefs.getBool('sj_cloak_status') ?? false;
    sj_show_box_tips = prefs.getBool('sj_show_box_tips') ?? false;
    sj_first_box_tips = prefs.getBool('sj_first_box_tips') ?? false;
    sj_fk_number_status = prefs.getBool('sj_fk_number_status') ?? false;
    sj_fk_decvice_status = prefs.getBool('sj_fk_decvice_status') ?? false;
    sj_fk_ad_short_show = prefs.getBool('sj_fk_ad_short_show') ?? false;
    sj_fk_ad_short_close = prefs.getBool('sj_fk_ad_short_close') ?? false;
    sj_fk_ip_status = prefs.getBool('sj_fk_ip_status') ?? false;
    sj_newA_guide = prefs.getBool('sj_newA_guide') ?? false;
    sj_scratch_guide = prefs.getBool('sj_scratch_guide') ?? true;
    sj_old_guide = prefs.getBool('sj_old_guide') ?? true;
    sj_new_guide = prefs.getBool('sj_new_guide') ?? false;
    sj_show_bubble = prefs.getBool('sj_show_bubble') ?? false;
    sj_show_dolas_ani = prefs.getBool('sj_show_dolas_ani') ?? false;
    sj_show_box_guide = prefs.getBool('sj_show_box_guide') ?? false;
    sj_dolas_800 = prefs.getBool('sj_dolas_800') ?? false;
    sj_dolas_1000 = prefs.getBool('sj_dolas_1000') ?? false;
    sj_100_timer_star = prefs.getBool('sj_100_timer_star') ?? false;
    sj_tx_first_status = prefs.getBool('sj_tx_first_status') ?? false;
    sj_tx_last_status = prefs.getBool('sj_tx_last_status') ?? false;
    sj_first_show_cash = prefs.getBool('sj_first_show_cash') ?? false;
    sj_tx_task2_tips = prefs.getBool('sj_tx_task2_tips') ?? false;
    sj_last_tx_end = prefs.getBool('sj_last_tx_end') ?? false;
    sj_yunying_3 = prefs.getBool('sj_yunying_3') ?? false;
    sj_yunying_1 = prefs.getBool('sj_yunying_1') ?? false;
    sj_tx_end_status = prefs.getBool('sj_tx_end_status') ?? false;
    sj_ad_reawrd_all_number = prefs.getInt('sj_ad_reawrd_all_number') ?? 0;
    sj_ad_all_number = prefs.getInt('sj_ad_all_number') ?? 0;
    sj_dolas_number = prefs.getDouble('sj_dolas_number') ?? 0.0;
    sj_dolas_old_number = prefs.getDouble('sj_dolas_old_number') ?? 0.0;
    sj_ad_show_index = prefs.getInt('sj_ad_show_index') ?? 0;
    sj_Level_number = prefs.getInt('sj_Level_number') ?? 1;
    sj_Level_inedx = prefs.getInt('sj_Level_inedx') ?? 1;
    sj_scrach_end_number_0 = prefs.getInt('sj_scrach_end_number_0') ?? 0;
    sj_scrach_end_number_1 = prefs.getInt('sj_scrach_end_number_1') ?? 0;
    sj_scrach_end_number_2 = prefs.getInt('sj_scrach_end_number_2') ?? 0;
    sj_scrach_end_number_3 = prefs.getInt('sj_scrach_end_number_3') ?? 0;
    sj_scrach_end_number_4 = prefs.getInt('sj_scrach_end_number_4') ?? 0;
    sj_scrach_end_number_5 = prefs.getInt('sj_scrach_end_number_5') ?? 0;
    sj_scrach_end_number_6 = prefs.getInt('sj_scrach_end_number_6') ?? 0;
    sj_currentNumberIndex = prefs.getInt('sj_currentNumberIndex') ?? 0;
    sj_scratch_status_0 = prefs.getBool('sj_scratch_status_0') ?? true;
    sj_scratch_status_1 = prefs.getBool('sj_scratch_status_1') ?? true;
    sj_scratch_status_2 = prefs.getBool('sj_scratch_status_2') ?? true;
    sj_scratch_status_3 = prefs.getBool('sj_scratch_status_3') ?? true;
    sj_scratch_status_4 = prefs.getBool('sj_scratch_status_4') ?? true;
    sj_scratch_status_5 = prefs.getBool('sj_scratch_status_5') ?? true;
    sj_scratch_status_6 = prefs.getBool('sj_scratch_status_6') ?? true;
    sj_scratch_status_7 = prefs.getBool('sj_scratch_status_7') ?? true;
    sj_scratch_status_8 = prefs.getBool('sj_scratch_status_8') ?? true;
    sj_Scratch_timeKey_0 = prefs.getString('sj_Scratch_timeKey_0') ?? '';
    sj_Scratch_timeKey_1 = prefs.getString('sj_Scratch_timeKey_1') ?? '';
    sj_Scratch_timeKey_2 = prefs.getString('sj_Scratch_timeKey_2') ?? '';
    sj_Scratch_timeKey_3 = prefs.getString('sj_Scratch_timeKey_3') ?? '';
    sj_Scratch_timeKey_4 = prefs.getString('sj_Scratch_timeKey_4') ?? '';
    sj_Scratch_timeKey_5 = prefs.getString('sj_Scratch_timeKey_5') ?? '';
    sj_Scratch_timeKey_6 = prefs.getString('sj_Scratch_timeKey_6') ?? '';
    sj_ratio_str = prefs.getString('sj_ratio_str') ?? '90';
    sj_account_id = prefs.getString('sj_account_id') ?? '';
    sj_tx_list = prefs.getString("sj_tx_list") ?? "";
    // init tx
    if (sj_tx_list.isEmpty) {
      String jsonTXString = await rootBundle.loadString("sj_tx_list".jsons());
      Map<String, dynamic> json_tx = jsonDecode(jsonTXString);
      prefs.setString('sj_tx_list',jsonTXString);
      txEntity = SJTXModel.fromJson(json_tx);
    } else {
      String jsonTXString = prefs.getString('sj_tx_list') ?? "";
      Map<String, dynamic> json_tx = jsonDecode(jsonTXString);
      txEntity = SJTXModel.fromJson(json_tx);
    }
    notifyListeners(); // 加载完成后通知UI更新
  }

  // 通用bool
  Future<void> updateBool(String key, bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(key, value);
    init();
    notifyListeners();
  }

  // 通用int
  Future<void> updateint(String key, int value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(key, value);
    init();
    notifyListeners();
  }

  // 通用double
  Future<void> updatedouble(String key, double value) async {
    final prefs = await SharedPreferences.getInstance();
    if (key == SJLocalProvider.instance.sj_dolas_numberName && sj_dolas_number <= 0){
      await updateBool(sj_first_show_cashName, true);
    }
    if (key == SJLocalProvider.instance.sj_dolas_numberName && value > 0){
      await updatedouble(sj_dolas_old_numberName, sj_dolas_old_number + value);
    }
    if (key == SJLocalProvider.instance.sj_dolas_numberName){
       value += sj_dolas_number;
    }
    await prefs.setDouble(key, value);
    if (key == SJLocalProvider.instance.sj_dolas_numberName && value > 0){
      trigger.check(SJLocalProvider.instance.sj_dolas_number.toInt(), onTrigger: (level) {
        print("触发 → 达到 $level");
        sj_event_fire('cash_dall', {'money' : level});
      });
      await updateBool(sj_show_dolas_aniName, true);
    }
    if (key == SJLocalProvider.instance.sj_dolas_numberName){
      // SJNoticeHelp().startSJForegroundService();
    }
    init();
    notifyListeners();
  }

  // 通用String
  Future<void> updateString(String key, String value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(key, value);
    init();
    notifyListeners();
  }


  Future<void> updateTXInStatus(int status) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    txEntity.tx_info[sj_tx_ing_account].tx_list[sj_tx_ing_number].status = status;
    sharedPreferences.setString('sj_tx_list', jsonEncode(txEntity.toJson()));
    String jsonTXString = sharedPreferences.getString('sj_tx_list') ?? "";
    Map<String, dynamic> json_tx = jsonDecode(jsonTXString);
    txEntity = SJTXModel.fromJson(json_tx);
  }

}