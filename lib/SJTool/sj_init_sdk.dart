import 'dart:convert';
import 'package:adjust_sdk/adjust_ad_revenue.dart';
import 'package:adjust_sdk/adjust_attribution.dart';
import 'package:applovin_max/applovin_max.dart';
import 'package:flutter_tba_info/flutter_tba_info.dart';
import 'package:scratchjoy/SJTool/sj_extension_help.dart';
import 'SJAdAHelp.dart';
import 'package:adjust_sdk/adjust.dart';
import 'package:adjust_sdk/adjust_config.dart';

String decsgerew(String st) => utf8.decode(base64Decode(st));

class SJSDKHelpers {
  static final SJSDKHelpers _instance = SJSDKHelpers._internal();

  factory SJSDKHelpers() {
    return _instance;
  }

  SJSDKHelpers._internal();

  DateTime sj_max_start = DateTime.now();

  DateTime sj_topon_start = DateTime.now();

  int sj_remoteConfigTryCount = 0;

  Future<void> initSDK() async {
    _initAppMAX();
    _initAdjust();
  }


  Future<void> _initAppMAX() async {
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
      SJAdAHelper().initRewardAdDatasource();
      // sj_event_fire('kmrol_ad_initsuc', {
      //   'ad_platform' : 'max',
      //   'ad_init_time' : DateTime.now().difference(sj_max_start).inMilliseconds
      // });
    }
  }

  _initAdjust() async {
    const String appToken = 'gb9h8itt99mo'; // 从 adjust 控制台拿
    var disId = await FlutterTbaInfo.instance.getDistinctId();
    'disId=$disId'.log();
    Adjust.addGlobalCallbackParameter('customer_user_id', disId);
    final config = AdjustConfig(appToken, AdjustEnvironment.production);
    // 归因信息
    config.attributionCallback = (AdjustAttribution attributionChangedData) {
      print('[Adjust]: Attribution changed!');
      if (attributionChangedData.trackerToken != null) {
        print('[Adjust]: Tracker token: ${attributionChangedData.trackerToken}');
      }
      if (attributionChangedData.trackerName != null) {
        print('[Adjust]: Tracker name: ${attributionChangedData.trackerName}');
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

  }

  // 上报收入
  sj_sendAdToSdk(MaxAd max) {
    try {
      AdjustAdRevenue adjustAdRevenue = AdjustAdRevenue('applovin_max_sdk');
      adjustAdRevenue.setRevenue(max.revenue, 'USD');
      adjustAdRevenue.adRevenueNetwork = max.networkPlacement;
      adjustAdRevenue.adRevenuePlacement = max.placement;
      Adjust.trackAdRevenue(adjustAdRevenue);
      "af logs:: af revenue success ${max.revenue}".log();
    } catch (e) {
      "af logs:: af revenue error $e".log();
    }

    // FacebookAppEvents fb = FacebookAppEvents();
    // fb.logPurchase(amount: max.revenue, currency: "USD");
  }
  // 上报收入
  sj_sendintTopOnAdToSdk(Map extraMap) {
    final revenue = extraMap["publisher_revenue"] ?? 0;
    final network = extraMap["network_name"];
    final currency = extraMap["currency"] ?? "";
    try {
      AdjustAdRevenue adjustAdRevenue = AdjustAdRevenue('topon_sdk');
      adjustAdRevenue.setRevenue(revenue, 'USD');
      adjustAdRevenue.adRevenueNetwork = network;
      Adjust.trackAdRevenue(adjustAdRevenue);
      "af logs:: af revenue success ${revenue}".log();
    } catch (e) {
      "af logs:: af revenue error $e".log();
    }
  }


}


