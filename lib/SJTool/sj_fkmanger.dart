import 'dart:convert';
import 'dart:developer';
import 'package:flutter/services.dart';
import 'package:flutter_tba_info/flutter_tba_info.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:scratchjoy/SJTool/sj_extension_help.dart';

class SJFKManger {
  static final SJFKManger _instance = SJFKManger._internal();

  factory SJFKManger() {
    return _instance;
  }

  SJFKManger._internal();

  // SJFkModel fkModel = SJFkModel();

  Future<void> initFKJson() async {
    // 'fkModel=$fkModel'.log();
    // if (fkModel.behavior.ad_daily_show == 0) {
    //   String jsonString = await rootBundle.loadString("risk_control122".jsons());
    //   'risk_control=$jsonString'.log();
    //   Map<String, dynamic> jsonMap = json.decode(jsonString);
    //   fkModel = SJFkModel.fromJson(jsonMap);
    // }
    // "scractchjoy fk json = ${fkModel.behavior.ad_daily_show}".log();
  }


  Future<void> initFK() async {
    sp_checkRoot();
    sp_checkVpn();
    sp_checkSim();
    sp_checkSimulator();
    sp_checkDeveloper();
    sp_checkStore();
    sp_checkIP();
    sp_checkNum();
  }

  // 是否需要打开风控
  Future<bool> sp_checkAllStatus() async {
    final prefs = await SharedPreferences.getInstance();
    // behavior
    bool behavior = await sp_checkUser();
    'behavior=$behavior'.log();
    // number
    bool number = prefs.getBool('sp_fk_number_status') ?? false;
    'number=$number'.log();
    // device
    bool device = prefs.getBool('sp_fk_decvice_status') ?? false;
    'device=$device'.log();
    if (behavior || number || device){
      return true;
    }
    return false;
  }

  // 获取用户异常行为状态
  Future<bool> sp_checkUser() async {
    // 开关未打开
    // if(fkModel.ui.behavior == 0){
    //   return false;
    // }
    // final prefs = await SharedPreferences.getInstance();
    // 'SPLocalProvider.instance.sp_fk_ad_short_show2 = ${SJLocalProvider.instance.sp_fk_ad_short_show}'.log();
    // // 两次rv间隔时间小于30s，3次以上
    // if(prefs.getBool('sp_fk_ad_short_show') == true){
    //   return true;
    // }
    // // RV 从播放到收到关闭回调时间小于20s，3次以上
    // if(prefs.getBool('sp_fk_ad_short_close') == true){
    //   return true;
    // }
    // // //现金金额达到提现门槛,视频数少于3次
    // if((prefs.getInt('sp_ad_all_number') ?? 0) < fkModel.behavior.wrong_deem_ad_less && (prefs.getInt('sp_dolas_old_number') ?? 0) >= SPNumberhelper().numberEntity.card_range.first){
    //   // sj_event_fire('risk_chance', {'risk_from' : 'wrong_deem_ad_less'});
    //   return true;
    // }
    // // 用户观看90次RV(不包含插屏)，未到提现门槛
    // if((prefs.getInt('sp_ad_reawrd_all_number') ?? 0) >= fkModel.behavior.wrong_deem_ad_more && (prefs.getInt('sp_dolas_old_number') ?? 0) < SPNumberhelper().numberEntity.card_range.first){
    //   // sj_event_fire('risk_chance', {'risk_from' : 'wrong_deem_ad_more'});
    //   return true;
    // }
    return false;
  }

 // 数字联盟
  sp_checkNum()async{
    // var numberUnitID = await ScratchJoyFK.instance.sp_getNumberUnitID();
    // var url = Uri.parse('https://sg-ddi.shuzilm.cn/q');
    // try {
    //   var response = await http.post(
    //     url,
    //     headers: eventHeader,
    //     body: jsonEncode({"protocol":2,"pkg":await FlutterTbaInfo.instance.getBundleId(),"did":numberUnitID}),
    //   );
    //   print("upload event [Number] success ${response.body}");
    //
    //   try{
    //     //{"protocol":2,"ver":"1.0.1","err":0,"device_type":0,"normal_times":0,
    //     // "duplicate_times":0,"update_times":1,"recall_times":0}
    //     var json = jsonDecode(response.body);
    //     if(json["err"] == 0 && json["device_type"] != 0 && fkModel.ui.number == 1){
    //       sp_event_fire('risk_chance', {'risk_from' : 'number'});
    //       SPLocalProvider.instance.updatesp_fk_number_status(true);
    //     }else{
    //       SPLocalProvider.instance.updatesp_fk_number_status(false);
    //     }
    //   }catch(e){
    //     SPLocalProvider.instance.updatesp_fk_number_status(false);
    //   }
    //
    // } catch (e) {
    //   SPLocalProvider.instance.updatesp_fk_number_status(false);
    //   "upload event [Number] faild".log();
    // }

  }

  Map<String, String> eventHeader = {
    'Content-Type': 'application/json',
  };

  // 设备 Ip
  sp_checkIP()async{

    // var url = Uri.parse('https://ip-prod.scratchplayland.com/api/dqwdwqw');
    // try {
    //   var response = await http.post(
    //     url,
    //     headers: eventHeader,
    //     body: jsonEncode({
    //       "adog" : await FlutterTbaInfo.instance.getAndroidId(),
    //     }),
    //   );
    //   print("upload event [IP] success ${response.body}");
    //   //{"code":200,"msg":"Success","data":{"bbear":false}}
    //   var result = BoomUniqueStringUtil.decrypt(response.body, 18);
    //   print("upload event [IP] success ${result}");
    //   try{
    //     var bbear = jsonDecode(result)["data"]["bbear"];
    //     if(bbear && fkModel.device.contains('ip')){
    //       sp_event_fire('risk_chance', {'risk_from' : 'ip'});
    //       SPLocalProvider.instance.updatesp_fk_ip_status(true);
    //     }
    //   }catch(e){
    //     SPLocalProvider.instance.updatesp_fk_ip_status(false);
    //   }
    //
    // } catch (e) {
    //   SPLocalProvider.instance.updatesp_fk_ip_status(false);
    //   "upload event [IP] faild".log();
    // }
  }

  sp_add_tabsession_custom() async {

    bool root = await sp_checkRoot();
    bool vpn = await sp_checkVpn();
    bool sim = await sp_checkSim();
    bool simulator = await sp_checkSimulator();
    bool developer = await sp_checkDeveloper();
    bool googleplay = await sp_checkStore();
    Map<String, dynamic> customer = {
      'root' : root ? 1 : 0,
      'vpn' : vpn ? 1 : 0,
      'sim' : sim ? 0 : 1,
      'simulator' : simulator ? 1 : 0,
      'developer' : developer ? 1 : 0,
      'googleplay' : googleplay ? 0 : 1,
    };
    // sj_event_fire('session_custom', customer);

  }

  Future<bool> sp_checkRoot() async {
    // var result = await ScratchPlayLandFK.instance.sp_root();
    // if(fkModel.ui.device == 0){
    //   return false;
    // }
    // if(result && fkModel.device.contains('root')){
    //   sp_event_fire('risk_chance', {'risk_from' : 'root'});
    //   SPLocalProvider.instance.updatesp_fk_decvice_status(true);
    //   return true;
    // }
    return false;
  }

  Future<bool> sp_checkVpn() async {
    // var result = await ScratchPlayLandFK.instance.sp_vpn();
    // if(fkModel.ui.device == 0){
    //   return false;
    // }
    // if(result && fkModel.device.contains('vpn')){
    //   sp_event_fire('risk_chance', {'risk_from' : 'vpn'});
    //   SPLocalProvider.instance.updatesp_fk_decvice_status(true);
    //   return true;
    // }
    return false;
  }

  Future<bool> sp_checkSim() async {
    // var result = await ScratchPlayLandFK.instance.sp_sim();
    // if(fkModel.ui.device == 0){
    //   return false;
    // }
    // if(!result && fkModel.device.contains('sim')){
    //   sp_event_fire('risk_chance', {'risk_from' : 'sim'});
    //   SPLocalProvider.instance.updatesp_fk_decvice_status(true);
    //   return true;
    // }
    return false;
  }

  Future<bool> sp_checkSimulator() async {
    // var result = await ScratchPlayLandFK.instance.sp_simulator();
    // if(fkModel.ui.device == 0){
    //   return false;
    // }
    // if(result && fkModel.device.contains('simulator')){
    //   sp_event_fire('risk_chance', {'risk_from' : 'simulator'});
    //   SPLocalProvider.instance.updatesp_fk_decvice_status(true);
    //   return true;
    // }
    return false;
  }

  Future<bool> sp_checkDeveloper() async {
    // var result = await ScratchPlayLandFK.instance.sp_developer();
    // if(fkModel.ui.device == 0){
    //   return false;
    // }
    // if(result && fkModel.device.contains('developer')){
    //   sp_event_fire('risk_chance', {'risk_from' : 'developer'});
    //   SPLocalProvider.instance.updatesp_fk_decvice_status(true);
    //   return true;
    // }
    return false;
  }

  Future<bool> sp_checkStore() async {
    // var result = await ScratchPlayLandFK.instance.sp_store();
    // if(fkModel.ui.device == 0){
    //   return false;
    // }
    // if(!result && fkModel.device.contains('googleplay')){
    //   sp_event_fire('risk_chance', {'risk_from' : 'googleplay'});
    //   SPLocalProvider.instance.updatesp_fk_decvice_status(true);
    //   return true;
    // }
    return false;
  }
}