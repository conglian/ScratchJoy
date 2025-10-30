import 'dart:developer';
import 'dart:math';
import 'package:applovin_max/applovin_max.dart';
import 'package:flutter/cupertino.dart';
import 'package:scratchjoy/SJTool/sj_LocalProvider.dart';
import 'package:scratchjoy/SJTool/sj_mp3_player.dart';
import 'package:scratchjoy/SJTool/sj_extension_help.dart';

import '../SJDilaog/SJDialog.dart';

class SJAdAHelper {
  static final SJAdAHelper _instance = SJAdAHelper._internal();

  factory SJAdAHelper() {
    return _instance;
  }

  SJAdAHelper._internal();

  String rewardOne = '0f715bde556a0513';

  String? placeId;

  void Function(bool)? finishIntAd;

  void resetBlock() {
    finishIntAd = null;
  }

  void load() {
    if (rewardOne.length == 0) {
      "scratchJoyad Reward no data".log();
      return;
    }

    AppLovinMAX.setRewardedAdListener(
      RewardedAdListener(
        onAdLoadedCallback: (ad) {
          _saveCurrentAds(ad.adUnitId);
        },
        onAdLoadFailedCallback: (adUnitId, error) {
          _reLoadad(adUnitId, error.message);
        },
        onAdDisplayedCallback: (ad) async {
          if (SJLocalProvider.instance.sj_bg_music) {
            SJMP3Player().pauseBackground();
          }
          "scratchJoyad Reward did display ${ad.adUnitId}".log();
        },
        onAdDisplayFailedCallback: (ad, error) {
          "scratchJoyad Reward did faild to display ${error.message}".log();
          if (this.finishIntAd != null) {
            this.finishIntAd!(false);
          }
        },
        onAdClickedCallback: (ad) {
          "scratchJoyad Reward did click ${ad.adUnitId}".log();
        },
        onAdHiddenCallback: (ad) {
          if (SJLocalProvider.instance.sj_bg_music) {
            SJMP3Player().playBackground();
          }
          "scratchJoyad Reward did hide - ${ad.adUnitId}".log();
          if (this.finishIntAd != null) {
            this.finishIntAd!(true);
          }
          load();
        },
        onAdRevenuePaidCallback: (ad) {
          "scratchJoyad Reward did pay ${ad.revenue} - ${ad.adUnitId}".log();
          "scratchJoyad Int did pay finally ${ad.revenue} - ${ad.adUnitId}".log();
        },
        onAdReceivedRewardCallback: (MaxAd ad, MaxReward reward) {},
      ),
    );

    if ( rewardOne.length != 0) {
      "scratchJoyad Reward Start Load Root ${rewardOne}"
          .log();
      AppLovinMAX.loadRewardedAd(rewardOne);
    }
  }

  void _reLoadad(String identifer, String message) {
    load();
  }

  void _saveCurrentAds(String identifer) {

  }

  Future<void> show(BuildContext content, void Function(bool) hasCache,
      void Function(bool)? finished) async {
    if (finished != null) {
      finishIntAd = finished;
    }

    bool isReady = (await AppLovinMAX.isRewardedAdReady(rewardOne))!;


    if (isReady) {
      AppLovinMAX.showRewardedAd(rewardOne);
      "scratchJoyad Reward request to show pos_id: success root ${rewardOne}"
          .log();
      hasCache(true);
      return;
    }

    "scratchJoyad Reward request to show no cache!}".log();
    SJDialogTool.toast(content, 'Ad loading failed, please try again later~');
    load();
    hasCache(false);
  }

}

extension AdRewardHelperExtension on SJAdAHelper {
  initRewardAdDatasource() {
    load();
  }
}