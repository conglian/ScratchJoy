import 'dart:convert';
import 'dart:developer';
import 'package:ScratchJoyFK/ScratchJoyFK.dart';
import 'package:flutter/services.dart';
import 'package:flutter_tba_info/flutter_tba_info.dart';
import 'package:http/http.dart' as http;
import 'package:scratchjoy/SJTool/sj_LocalProvider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:scratchjoy/SJTool/sj_extension_help.dart';
import '../SJModel/SJFkModel.dart';
import 'SJTBAInfoTool.dart';

class SJFKManger {
  static final SJFKManger _instance = SJFKManger._internal();

  factory SJFKManger() {
    return _instance;
  }

  SJFKManger._internal();

  SJFkModel fkModel = SJFkModel();

  Future<void> initFKJson() async {
    'fkModel=$fkModel'.log();
    if (fkModel.behavior.ad_daily_show == 0) {
      String jsonString = await rootBundle.loadString("sj_control130".jsons());
      'risk_control=$jsonString'.log();
      Map<String, dynamic> jsonMap = json.decode(jsonString);
      fkModel = SJFkModel.fromJson(jsonMap);
    }
    "scractchjoy fk json = ${fkModel.behavior.ad_daily_show}".log();
  }


  Future<void> initFK() async {
    sj_checkRoot();
    sj_checkVpn();
    sj_checkSim();
    sj_checkSimulator();
    sj_checkDeveloper();
    sj_checkStore();
    sj_checkIP();
    sj_checkNum();
  }

  // 是否需要打开风控
  Future<bool> sj_checkAllStatus() async {
    final prefs = await SharedPreferences.getInstance();
    String types = 'number';
    // behavior
    bool behavior = await sj_checkUser();
    'behavior=$behavior'.log();
    if (behavior){
      types = 'behavior';
    }
    // number
    bool number = prefs.getBool('sj_fk_number_status') ?? false;
    'number=$number'.log();
    if (number){
      types = 'number';
    }
    // device
    bool device = prefs.getBool('sj_fk_decvice_status') ?? false;
    'device=$device'.log();
    if (device){
      types = 'device';
    }
    if (behavior || number || device){
      sj_event_fire(
        "scxji_fk_head_off",
        {
          "type": types,
        },
      );
      return true;
    }
    return false;
  }

  // 获取用户异常行为状态
  Future<bool> sj_checkUser() async {
    // 开关未打开
    if(fkModel.ui.behavior == 0){
      return false;
    }
    final prefs = await SharedPreferences.getInstance();
    'SJLocalProvider.instance.sj_fk_ad_short_show2 = ${SJLocalProvider.instance.sj_fk_ad_short_show}'.log();
    // 两次rv间隔时间小于30s，3次以上
    if(prefs.getBool('sj_fk_ad_short_show') == true){
      return true;
    }
    // RV 从播放到收到关闭回调时间小于20s，3次以上
    if(prefs.getBool('sj_fk_ad_short_close') == true){
      return true;
    }
    // //现金金额达到提现门槛,视频数少于3次
    if((prefs.getInt('sj_ad_all_number') ?? 0) < fkModel.behavior.wrong_deem_ad_less && (prefs.getInt('sj_dolas_old_number') ?? 0) >= 1000){
      sj_event_fire('risk_chance', {'risk_from' : 'wrong_deem_ad_less'});
      return true;
    }
    // 用户观看90次RV(不包含插屏)，未到提现门槛
    if((prefs.getInt('sj_ad_reawrd_all_number') ?? 0) >= fkModel.behavior.wrong_deem_ad_more && (prefs.getInt('sj_dolas_old_number') ?? 0) < 1000){
      sj_event_fire('risk_chance', {'risk_from' : 'wrong_deem_ad_more'});
      return true;
    }
    return false;
  }

 // 数字联盟
  sj_checkNum()async{
    var numberUnitID = await ScratchJoyFK.instance.sj_getNumberUnitID();
    var url = Uri.parse('https://sg-ddi.shuzilm.cn/q');
    try {
      var response = await http.post(
        url,
        headers: eventHeader,
        body: jsonEncode({"protocol":2,"pkg":await FlutterTbaInfo.instance.getBundleId(),"did":numberUnitID}),
      );
      print("upload event [Number] success ${response.body}");

      try{
        //{"protocol":2,"ver":"1.0.1","err":0,"device_type":0,"normal_times":0,
        // "duplicate_times":0,"update_times":1,"recall_times":0}
        var json = jsonDecode(response.body);
        if(json["err"] == 0 && json["device_type"] != 0 && fkModel.ui.number == 1){
          sj_event_fire('risk_chance', {'risk_from' : 'number'});
          await SJLocalProvider.instance.updateBool(SJLocalProvider.instance.sj_fk_number_statusName,true);
        }else{
          await SJLocalProvider.instance.updateBool(SJLocalProvider.instance.sj_fk_number_statusName,false);
        }
      }catch(e){
        await SJLocalProvider.instance.updateBool(SJLocalProvider.instance.sj_fk_number_statusName,false);
      }

    } catch (e) {
      await SJLocalProvider.instance.updateBool(SJLocalProvider.instance.sj_fk_number_statusName,false);
      "upload event [Number] faild".log();
    }

  }

  Map<String, String> eventHeader = {
    'Content-Type': 'application/json',
  };

  // 设备 Ip
  sj_checkIP()async{

    var url = Uri.parse('https://ip-prod.crazerushscrajoy.com/api/cape');
    try {
      var response = await http.post(
        url,
        headers: eventHeader,
        body: jsonEncode({
          "amouse" : await FlutterTbaInfo.instance.getAndroidId(),
        }),
      );
      print("upload event [IP] success ${response.body}");
      //{"code":200,"msg":"Success","data":{"blion":false}}
      var result = BoomUniqueStringUtil.decrypt(response.body, 26);
      print("upload event [IP] success ${result}");
      try{
        var blion = jsonDecode(result)["data"]["blion"];
        if(blion && fkModel.device.contains('ip') && fkModel.ui.device == 1){
          sj_event_fire('risk_chance', {'risk_from' : 'ip'});
          await SJLocalProvider.instance.updateBool(SJLocalProvider.instance.sj_fk_ip_statusName,true);
        }
      }catch(e){
        await SJLocalProvider.instance.updateBool(SJLocalProvider.instance.sj_fk_ip_statusName,false);
      }

    } catch (e) {
      await SJLocalProvider.instance.updateBool(SJLocalProvider.instance.sj_fk_ip_statusName,false);
      "upload event [IP] faild".log();
    }
  }

  sj_add_tabsession_custom() async {

    bool root = await sj_checkRoot();
    bool vpn = await sj_checkVpn();
    bool sim = await sj_checkSim();
    bool simulator = await sj_checkSimulator();
    bool developer = await sj_checkDeveloper();
    bool googleplay = await sj_checkStore();
    Map<String, dynamic> customer = {
      'root' : root ? 1 : 0,
      'vpn' : vpn ? 1 : 0,
      'sim' : sim ? 1 : 0,
      'simulator' : simulator ? 1 : 0,
      'developer' : developer ? 1 : 0,
      'googleplay' : googleplay ? 1 : 0,
    };
    sj_event_fire('session_custom', customer);

  }

  Future<bool> sj_checkRoot() async {
    var result = await ScratchJoyFK.instance.sj_root();
    if(fkModel.ui.device == 0){
      return false;
    }
    if(result && fkModel.device.contains('root')){
      sj_event_fire('risk_chance', {'risk_from' : 'root'});
      SJLocalProvider.instance.updateBool(SJLocalProvider.instance.sj_fk_decvice_statusName,true);
      return true;
    }
    return false;
  }

  Future<bool> sj_checkVpn() async {
    var result = await ScratchJoyFK.instance.sj_vpn();
    if(fkModel.ui.device == 0){
      return false;
    }
    if(result && fkModel.device.contains('vpn')){
      sj_event_fire('risk_chance', {'risk_from' : 'vpn'});
      SJLocalProvider.instance.updateBool(SJLocalProvider.instance.sj_fk_decvice_statusName,true);
      return true;
    }
    return false;
  }

  Future<bool> sj_checkSim() async {
    var result = await ScratchJoyFK.instance.sj_sim();
    if(fkModel.ui.device == 0){
      return false;
    }
    if(!result && fkModel.device.contains('sim')){
      sj_event_fire('risk_chance', {'risk_from' : 'sim'});
      SJLocalProvider.instance.updateBool(SJLocalProvider.instance.sj_fk_decvice_statusName,true);
      return true;
    }
    return false;
  }

  Future<bool> sj_checkSimulator() async {
    var result = await ScratchJoyFK.instance.sj_simulator();
    if(fkModel.ui.device == 0){
      return false;
    }
    if(result && fkModel.device.contains('simulator')){
      sj_event_fire('risk_chance', {'risk_from' : 'simulator'});
      SJLocalProvider.instance.updateBool(SJLocalProvider.instance.sj_fk_decvice_statusName,true);
      return true;
    }
    return false;
  }

  Future<bool> sj_checkDeveloper() async {
    var result = await ScratchJoyFK.instance.sj_developer();
    if(fkModel.ui.device == 0){
      return false;
    }
    if(result && fkModel.device.contains('developer')){
      sj_event_fire('risk_chance', {'risk_from' : 'developer'});
      SJLocalProvider.instance.updateBool(SJLocalProvider.instance.sj_fk_decvice_statusName,true);
      return true;
    }
    return false;
  }

  Future<bool> sj_checkStore() async {
    var result = await ScratchJoyFK.instance.sj_store();
    if(fkModel.ui.device == 0){
      return false;
    }
    if(!result && fkModel.device.contains('googleplay')){
      sj_event_fire('risk_chance', {'risk_from' : 'googleplay'});
      SJLocalProvider.instance.updateBool(SJLocalProvider.instance.sj_fk_decvice_statusName,true);
      return true;
    }
    return false;
  }
}