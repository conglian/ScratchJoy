import 'dart:convert';
import 'package:adjust_sdk/adjust_ad_revenue.dart';
import 'package:adjust_sdk/adjust_attribution.dart';
// import 'package:anythink_sdk/at_init.dart';
import 'package:applovin_max/applovin_max.dart';
import 'package:facebook_app_events/facebook_app_events.dart';
import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_tba_info/flutter_tba_info.dart';
import 'package:scratchjoy/SJTool/SJTBAInfoTool.dart';
import 'package:scratchjoy/SJTool/sj_LocalProvider.dart';
import 'package:scratchjoy/SJTool/sj_ad_help.dart';
import 'package:scratchjoy/SJTool/sj_ad_manger.dart';
import 'package:scratchjoy/SJTool/sj_extension_help.dart';
import 'package:scratchjoy/SJTool/sj_number_helper.dart';
import 'package:thinkup_sdk/at_init.dart';
import '../SJHome/SJHome.dart';
import '../SJModel/SJAdModel.dart';
import '../SJModel/SJFkModel.dart';
import '../SJModel/SJbonus_config.dart';
import '../SJModel/SJint_ad_model.dart';
import '../SJModel/SJprobability_config.dart';
import '../SJModel/SJtask_model.dart';
import 'SJAdAHelp.dart';
import 'package:adjust_sdk/adjust.dart';
import 'package:adjust_sdk/adjust_config.dart';

import 'SJAdManager.dart';

String decsgerew(String st) => utf8.decode(base64Decode(st));

class SJSDKHelpers {
  static final SJSDKHelpers _instance = SJSDKHelpers._internal();

  factory SJSDKHelpers() {
    return _instance;
  }

  final facebookAppEvents = FacebookAppEvents();

  SJSDKHelpers._internal();

  DateTime sj_max_start = DateTime.now();

  DateTime sj_topon_start = DateTime.now();

  int sj_remoteConfigTryCount = 0;

  Future<void> initSDK() async {
    _initTopon();
    _initAppMAX();
    _sjinitloadFireBase();
  }

  void _initTopon() async {

    WidgetsBinding.instance.addPostFrameCallback((_) {
      // 这里保证在主线程
      sj_topon_start = DateTime.now();
      ATInitManger.initAnyThinkSDK(
          appidStr: 'h69a79baee40f5',
          appidkeyStr: 'aee5e61d1c23cba13e28d1d4bb1b8eb4d').then((value){
        // SJJoyAds().init();
        sj_event_fire('eopjp_ad_initsuc', {
          'ad_platform' : 'topon',
          'ad_init_time' : DateTime.now().difference(sj_topon_start).inMilliseconds
        });
        'topon init Success'.log();
      }).catchError((error){
        'topon init error=$error'.log();
      });
      // 打开SDK的Debug log，强烈建议在测试阶段打开，方便排查问题。
      ATInitManger
          .setLogEnabled(
        logEnabled: true,
      );
    });
  }

  Future<void> _initAppMAX() async {
    // ump设置
    AppLovinMAX.setHasUserConsent(true);
    AppLovinMAX.setDoNotSell(false);

    AppLovinMAX.setCreativeDebuggerEnabled(false);
    AppLovinMAX.setVerboseLogging(false);
    "${decsgerew("TVdKemhuRVB0S3F4TEtSTEFsVnJUeVFmTzJWeFdaV3RWeF9TelRXQ19NZ29aTDdrVEs=")}"
        "${decsgerew("TnQ5dDNNX09nSVoyNG5CWFJYeFZkOW9nUUVwNzYxNlRXZjND")}"
        .log();
    sj_max_start = DateTime.now();
    MaxConfiguration? configuration = await AppLovinMAX.initialize(
      "${decsgerew("TVdKemhuRVB0S3F4TEtSTEFsVnJUeVFmTzJWeFdaV3RWeF9TelRXQ19NZ29aTDdrVEs=")}"
          "${decsgerew("TnQ5dDNNX09nSVoyNG5CWFJYeFZkOW9nUUVwNzYxNlRXZjND")}",
    );
    // AppLovinMAX.showMediationDebugger();
    //
    if (configuration != null) {
      // SJJoyAds().init();
      sj_event_fire('scxji_ad_initsuc', {
        'ad_platform' : 'max',
        'ad_init_time' : DateTime.now().difference(sj_max_start).inMilliseconds
      });
    }
    return;
  }

  initAdjustSDk() async {
    const String appToken1 = 'r0fn8ph82874'; // relsease
    var disId = await FlutterTbaInfo.instance.getDistinctId();
    'disId=$disId'.log();
    Adjust.addGlobalCallbackParameter('customer_user_id', disId);
    final config = AdjustConfig(appToken1, AdjustEnvironment.production);
    config.logLevel = AdjustLogLevel.verbose;
    // 归因信息
    config.attributionCallback = (AdjustAttribution attributionChangedData) {
      print('[Adjust]: Attribution changed!');
      if (attributionChangedData.trackerToken != null) {
        print('[Adjust]: Tracker token: ${attributionChangedData.trackerToken}');
      }
      if (attributionChangedData.trackerName != null) {
        sj_event_fire('adjust_suc', {'adjust_user' : attributionChangedData.trackerName == 'Organic' ? 0 : 1});
        print('[Adjust]: Tracker name: ${attributionChangedData.trackerName}');
        if (attributionChangedData.trackerName != 'Organic'){
          sj_event_fire('organic_to_buy', {});
          _toHome();
        }
      }
      if (attributionChangedData.campaign != null) {
        print('[Adjust]: Campaign: ${attributionChangedData.campaign}');
      }
      if (attributionChangedData.network != null) {
        print('[Adjust]: Network: ${attributionChangedData.network}');
      }
      if (attributionChangedData.creative != null) {
        print('[Adjust]: Creative: ${attributionChangedData.creative}');
      }
      if (attributionChangedData.adgroup != null) {
        print('[Adjust]: Adgroup: ${attributionChangedData.adgroup}');
      }
      if (attributionChangedData.clickLabel != null) {
        print('[Adjust]: Click label: ${attributionChangedData.clickLabel}');
      }
      if (attributionChangedData.fbInstallReferrer != null) {
        print('[Adjust]: facebook install referrer: ${attributionChangedData.fbInstallReferrer}');
      }
      if (attributionChangedData.jsonResponse != null) {
        print('[Adjust]: JSON Response: ${attributionChangedData.jsonResponse}');
      }
    };
    Adjust.initSdk(config);
    sj_event_fire('adjust_req', {});
  }

  Future<void> _toHome() async {
    await SJLocalProvider.instance.updateBool(SJLocalProvider.instance.sj_af_statusName, true);
    '22222222'.log();
    'sj_set_root=${SJLocalProvider.instance.sj_set_root}'.log();
    'sj_cloak_status=${SJLocalProvider.instance.sj_cloak_status}'.log();
    if (SJLocalProvider.instance.sj_set_root == false &&
        SJLocalProvider.instance.sj_cloak_status == true) {
      await SJLocalProvider.instance.updateBool(SJLocalProvider.instance.sj_set_rootName, true);
      await SJLocalProvider.instance.updateBool(SJLocalProvider.instance.sj_login_statusName, true);
      print('organic_to_buy');
      Navigator.pushReplacement(
        homeKey as BuildContext,
        MaterialPageRoute(
          builder: (_) => SJHome(key: homeKey),
        ),
      );
    }

  }

  void _sjinitloadFireBase() async {
    final remoteConfig = FirebaseRemoteConfig.instance;
    await remoteConfig.setConfigSettings(
      RemoteConfigSettings(
        fetchTimeout: const Duration(seconds: 10),
        minimumFetchInterval: const Duration(hours: 1),
      ),
    );
    "app firebase init".log();
    "app firebase loading".log();
    try {
      await remoteConfig.fetchAndActivate();

      // final scratchjoy_fb130 =
      // remoteConfig.getValue("c130scratchjoy_fb").asString();
      // 'c130scratchjoy_fb=$scratchjoy_fb130'.log();
      // // facebook_init
      // if (scratchjoy_fb130 != ''){
      //   Map<String, dynamic> jsonMap = json.decode(scratchjoy_fb130);
      //   SJFacebookAnalytics.init(appId: jsonMap['app_id'], clientToken: jsonMap['client_token'], appName: jsonMap['app_name']);
      // } else {
      //   SJFacebookAnalytics.init(appId: '', clientToken: '', appName: 'C130_GP');
      // }

      final c130_ad_int = remoteConfig.getValue('c130_ad_int').asString();
      if (c130_ad_int != ''){
        try {
          Map<String, dynamic> jsonMap = json.decode(c130_ad_int);
          var fkEntity = RootModel.fromJson(jsonMap);
          SJNumberHelpers().intModel = fkEntity;
          "app firebase remoteconfig c130_ad_int data $jsonMap".log();
        } catch (error) {
          print("app firebase remoteconfig c130_ad_int error ${error}");
        }
      }

      final probability_reset = remoteConfig.getValue('probability_reset').asString();
      if (probability_reset != ''){
        try {
          Map<String, dynamic> jsonMap = json.decode(probability_reset);
          var fkEntity = ProbabilityConfig.fromJson(jsonMap);
          SJNumberHelpers().probabilityConfigModel = fkEntity;
          "app firebase remoteconfig probability_reset data $jsonMap".log();
        } catch (error) {
          print("app firebase remoteconfig probability_reset error ${error}");
        }
      }

      final winup_number = remoteConfig.getValue('winup_number').asString();
      if (winup_number != ''){
        try {
          Map<String, dynamic> jsonMap = json.decode(winup_number);
          var fkEntity = BonusConfig.fromJson(jsonMap);
          SJNumberHelpers().bonusConfigModel = fkEntity;
          "app firebase remoteconfig winup_number data $jsonMap".log();
        } catch (error) {
          print("app firebase remoteconfig winup_number error ${error}");
        }
      }

      final c130_withdraw_task = remoteConfig.getValue('c130_withdraw_task').asString();
      if (c130_withdraw_task != ''){
        try {
          Map<String, dynamic> jsonMap = json.decode(c130_withdraw_task);
          var fkEntity = TaskRootModel.fromJson(jsonMap);
          SJNumberHelpers().taskModel = fkEntity;
          "app firebase remoteconfig c130_withdraw_task data $jsonMap".log();
        } catch (error) {
          print("app firebase remoteconfig c130_withdraw_task error ${error}");
        }
      }

      final c130_withdraw_last_task = remoteConfig.getValue('c130_withdraw_last_task').asString();
      if (c130_withdraw_last_task != ''){
        try {
          Map<String, dynamic> jsonMap = json.decode(c130_withdraw_last_task);
          var fkEntity = TaskRootModel.fromJson(jsonMap);
          SJNumberHelpers().last_taskModel = fkEntity;
          "app firebase remoteconfig c130_withdraw_last_task data $jsonMap".log();
        } catch (error) {
          print("app firebase remoteconfig c130_withdraw_last_task error ${error}");
        }
      }

      final scxji_ad_config = remoteConfig.getValue('scxji_ad_config').asString();
      if (scxji_ad_config != ''){
        try {
          Map<String, dynamic> jsonMap = json.decode(scxji_ad_config);
          var fkEntity = SJAdModel.fromJson(jsonMap);
          SJJoyAds().init(inputAd: fkEntity);
          "app firebase remoteconfig scxji_ad_config data $jsonMap".log();
        } catch (error) {
          // SJJoyAds().init();
          print("app firebase remoteconfig scxji_ad_config error ${error}");
        }
      }

    } catch (e, s) {
      print("RemoteConfig fetch error: $e");
      sj_remoteConfigTryCount += 1;
      if (sj_remoteConfigTryCount <= 160) {
        Future.delayed(Duration(seconds: 1), () {
          _sjinitloadFireBase();
        });
      } else {
        // SJJoyAds().init();
      }
    }
  }

  // 上报收入
  sj_sendAdToSdk(MaxAd max) async {
    try {
      AdjustAdRevenue adjustAdRevenue = AdjustAdRevenue('applovin_max_sdk');
      adjustAdRevenue.setRevenue(max.revenue, 'USD');
      adjustAdRevenue.adRevenueNetwork = max.networkPlacement;
      adjustAdRevenue.adRevenuePlacement = max.placement;
      Adjust.trackAdRevenue(adjustAdRevenue);
      // await SJFacebookAnalytics.logPurchase(max.revenue, 'USD');
      "af logs:: af revenue success ${max.revenue}".log();
    } catch (e) {
      "af logs:: af revenue error $e".log();
    }
  }
  // 上报收入
  sj_sendintTopOnAdToSdk(Map extraMap) async {
    final revenue = extraMap["publisher_revenue"] ?? 0;
    final network = extraMap["network_name"];
    final currency = extraMap["currency"] ?? "";
    try {
      AdjustAdRevenue adjustAdRevenue = AdjustAdRevenue('topon_sdk');
      adjustAdRevenue.setRevenue(revenue, 'USD');
      adjustAdRevenue.adRevenueNetwork = network;
      Adjust.trackAdRevenue(adjustAdRevenue);
      // await SJFacebookAnalytics.logPurchase(revenue, 'USD');
      "af logs:: af revenue success ${revenue}".log();
    } catch (e) {
      "af logs:: af revenue error $e".log();
    }
  }


}

