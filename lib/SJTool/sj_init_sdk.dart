import 'dart:convert';
import 'package:applovin_max/applovin_max.dart';
import 'package:scratchjoy/SJTool/sj_extension_help.dart';
import 'SJAdAHelp.dart';

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


}


