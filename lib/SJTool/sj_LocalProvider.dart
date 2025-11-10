import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SJLocalProvider extends ChangeNotifier {
  // 1. 私有构造函数（禁止外部直接创建实例）
  SJLocalProvider._();

  // 2. 静态单例实例
  static final SJLocalProvider _instance = SJLocalProvider._();

  // 3. 提供全局访问点
  static SJLocalProvider get instance => _instance;

  // SJTXModel txEntity = SJTXModel();

  String sj_Scratch_timeKey_0 = '';
  String sj_Scratch_timeKey_1 = '';
  String sj_Scratch_timeKey_2 = '';
  String sj_Scratch_timeKey_3 = '';
  String sj_Scratch_timeKey_4 = '';
  String sj_Scratch_timeKey_5 = '';
  String sj_Scratch_timeKey_6= '';
  String sj_account_id = '';
  String sj_tx_list = "";


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
  bool sj_show_dolas_ani = false;
  bool sj_show_bubble = false;
  bool sj_show_box_guide = false;
  bool sj_cloak_status = false;
  bool sj_fk_number_status = false;
  bool sj_fk_decvice_status = false;
  bool sj_fk_ip_status = false;
  bool sj_fk_ad_short_show = false;
  bool sj_fk_ad_short_close = false;


  int sj_scrach_unlock_index_0 = 0; // 存储的本地值
  int sj_scrach_unlock_index_1 = 0; // 存储的本地值
  int sj_ad_all_number = 0;
  int sj_dolas_number = 0;
  int sj_dolas_old_number = 0;
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
  int sj_scrach_end_number_0 = 0; // 存储的本地值
  int sj_scrach_end_number_1 = 0; // 存储的本地值
  int sj_scrach_end_number_2 = 0; // 存储的本地值
  int sj_scrach_end_number_3 = 0; // 存储的本地值
  int sj_scrach_end_number_4 = 0; // 存储的本地值
  int sj_scrach_end_number_5 = 0; // 存储的本地值
  int sj_scrach_end_number_6 = 0; // 存储的本地值
  int sj_currentNumberIndex = 0;
  int sj_domand_number = 0;


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

  // 3. 初始化：从本地存储加载数据（组件初始化时调用）
  Future<void> init() async {
    final prefs = await SharedPreferences.getInstance();
    // 从本地读取值（key自定义，需与存储时一致）
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
    sj_account_seled_index = prefs.getInt('sj_account_seled_index') ?? 0;
    sj_scrach_unlock_index_0 = prefs.getInt('sj_scrach_unlock_index_0') ?? 0;
    sj_scrach_unlock_index_1 = prefs.getInt('sj_scrach_unlock_index_1') ?? 0;
    sj_ad_short_show_number = prefs.getInt('sj_ad_short_show_number') ?? 0;
    sj_ad_short_close_number = prefs.getInt('sj_ad_short_close_number') ?? 0;
    sj_ad_show_number = prefs.getInt('sj_ad_show_number') ?? 0;
    sj_key_number = prefs.getInt('sj_key_number') ?? 0;
    sj_bg_music = prefs.getBool('sj_bg_music') ?? true;
    sj_sound_music = prefs.getBool('sj_sound_music') ?? true;
    sj_login_status = prefs.getBool('sj_login_status') ?? false;
    sj_cloak_status = prefs.getBool('sj_cloak_status') ?? false;
    sj_fk_number_status = prefs.getBool('sj_fk_number_status') ?? false;
    sj_fk_decvice_status = prefs.getBool('sj_fk_decvice_status') ?? false;
    sj_fk_ad_short_show = prefs.getBool('sj_fk_ad_short_show') ?? false;
    sj_fk_ad_short_close = prefs.getBool('sj_fk_ad_short_close') ?? false;
    sj_fk_ip_status = prefs.getBool('sj_fk_ip_status') ?? false;
    sj_scratch_guide = prefs.getBool('sj_scratch_guide') ?? true;
    sj_old_guide = prefs.getBool('sj_old_guide') ?? true;
    sj_new_guide = prefs.getBool('sj_new_guide') ?? false;
    sj_show_bubble = prefs.getBool('sj_show_bubble') ?? false;
    sj_show_dolas_ani = prefs.getBool('sj_show_dolas_ani') ?? false;
    sj_show_box_guide = prefs.getBool('sj_show_box_guide') ?? false;
    sj_ad_reawrd_all_number = prefs.getInt('sj_ad_reawrd_all_number') ?? 0;
    sj_ad_all_number = prefs.getInt('sj_ad_all_number') ?? 0;
    sj_dolas_number = prefs.getInt('sj_dolas_number') ?? 0;
    sj_dolas_old_number = prefs.getInt('sj_dolas_old_number') ?? 0;
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
    sj_account_id = prefs.getString('sj_account_id') ?? '';
    sj_tx_list =
        prefs.getString("sj_tx_list") ?? "";
    // init tx
    // if (sj_tx_list.isEmpty) {
    //   String jsonTXString = await rootBundle.loadString("sj_tx_list".jsons());
    //   Map<String, dynamic> json_tx = jsonDecode(jsonTXString);
    //   prefs.setString('sj_tx_list',jsonTXString);
    //   txEntity = SPTXModel.fromJson(json_tx);
    // } else {
    //   String jsonTXString = prefs.getString('sj_tx_list') ?? "";
    //   Map<String, dynamic> json_tx = jsonDecode(jsonTXString);
    //   txEntity = SPTXModel.fromJson(json_tx);
    // }
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
    await prefs.setDouble(key, value);
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
    // SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    // txEntity.tx_info[sj_tx_ing_account].tx_list[sj_tx_ing_number].status = status;
    // sharedPreferences.setString('sj_tx_list', jsonEncode(txEntity.toJson()));
    // String jsonTXString = sharedPreferences.getString('sj_tx_list') ?? "";
    // Map<String, dynamic> json_tx = jsonDecode(jsonTXString);
    // txEntity = SPTXModel.fromJson(json_tx);
  }

}