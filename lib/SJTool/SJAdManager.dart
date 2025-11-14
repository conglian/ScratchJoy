import 'package:anythink_sdk/at_interstitial.dart';
import 'package:anythink_sdk/at_interstitial_response.dart';
import 'package:anythink_sdk/at_listener.dart';
import 'package:anythink_sdk/at_rewarded.dart';
import 'package:anythink_sdk/at_rewarded_response.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/cupertino.dart';
import 'package:applovin_max/applovin_max.dart';
import 'package:scratchjoy/SJTool/sj_LocalProvider.dart';
import 'package:scratchjoy/SJTool/sj_ad_help.dart';
import 'package:scratchjoy/SJTool/sj_fkmanger.dart';
import 'package:scratchjoy/SJTool/sj_init_sdk.dart';
import '../SJDilaog/SJDialog.dart';
import '../SJModel/SJAdModel.dart';
import 'SJTBAInfoTool.dart';
import 'package:scratchjoy/SJTool/sj_extension_help.dart';

class SJAdManager {
  static final SJAdManager _instance = SJAdManager._internal();

  factory SJAdManager() {
    return _instance;
  }

  SJAdManager._internal();

  String? placeId;

  List<SJAdModellist> intAds = [];

  List<SJAdModellist> rewardAds = [];
  // 缓存ad 带ecpm
  List<SJAdModellist> intSucAds = [];
  // 缓存ad 带ecpm
  List<SJAdModellist> rewardSucAds = [];

  void Function(bool)? finishIntAd;

  var listenerend = false;
  // 保存上次播放广告时间
  DateTime? _savedTime = DateTime.now();
  // 保存上次播放到关闭广告时间
  DateTime? _savedPlayAndCloseTime;

  bool is_ad_play = false;

  DateTime int_start = DateTime.now();

  DateTime read_start = DateTime.now();

  // 请求所有广告id
  sj_load() async {
    // 展示上限
    if (SJLocalProvider.instance.sj_ad_show_index > SJFKManger().fkModel.behavior.ad_daily_show){
      return;
    }
    // 风控
    if (await SJFKManger().sj_checkAllStatus()){
      return;
    }
    // 添加代理流只能加一次
    if (!listenerend){
      listenerend = true;
      if (SJAdHelpers().ad_Entity!.scxji_int.first.feytgpub == 'max') {
        sp_rewardListener();
        sp_intListener();
      } else {
        wu_interListen();
        wu_rewarderListen();
      }
    }
    // 同时两条线请求
    for (var ad in intAds){
      bool isReady = false;
      for (var ad2 in intSucAds){
        if (ad.hnmkuhdz == ad2.hnmkuhdz){
          isReady = true;
        }
      }
      'int isReady = $isReady'.log();
      if (!isReady){
        sj_event_fire(
          "ad_request",
          { "ad_pos_id": placeId ?? "init_Load",
            'ad_format' : ad.ggtcworw,
            'ad_platform' : ad.feytgpub,
            'ad_code_id' : ad.hnmkuhdz,
          },
        );
        "scratchjoy ad Int Start Load Root ${ad.hnmkuhdz}"
            .log();
        if (SJAdHelpers().ad_Entity!.scxji_int.first.feytgpub == 'max'){
          int_start = DateTime.now();
          AppLovinMAX.loadInterstitial(ad.hnmkuhdz);
        } else {
          int_start = DateTime.now();
          await ATInterstitialManager
              .loadInterstitialAd(placementID: ad.hnmkuhdz, extraMap: {});
        }
      }
    }
    for (var ad in rewardAds){
      bool isReady = false;
      for (var ad2 in rewardSucAds){
        if (ad.hnmkuhdz == ad2.hnmkuhdz){
          isReady = true;
        }
      }
      'reward isReady = $isReady'.log();
      if (!isReady){
        sj_event_fire(
          "ad_request",
          { "ad_pos_id": placeId ?? "init_Load",
            'ad_format' : ad.ggtcworw,
            'ad_platform' : ad.feytgpub,
            'ad_code_id' : ad.hnmkuhdz,
          },
        );
        "scratchjoy ad reawrd Start Load Root ${ad.hnmkuhdz}"
            .log();
        if (SJAdHelpers().ad_Entity!.scxji_rv.first.feytgpub == 'max') {
          read_start = DateTime.now();
          AppLovinMAX.loadRewardedAd(ad.hnmkuhdz);
        } else {
          read_start = DateTime.now();
          await ATRewardedManager.loadRewardedVideo(
              placementID: ad.hnmkuhdz,
              extraMap: {
                ATRewardedManager.kATAdLoadingExtraUserDataKeywordKey(): '',
                ATRewardedManager.kATAdLoadingExtraUserIDKey(): '',
              });
        }
      }
    }
  }
  // 根据比价结果显示广告
  sj_showAd(bool isint, String placeIdentifer, BuildContext context, void Function(bool) hasCache,
      void Function(bool)? finished) async {

    finishIntAd = null;
    placeId = placeIdentifer;
    if (finished != null) {
      finishIntAd = finished;
    }
    // hasCache(true);
    // if (this.finishIntAd != null) {
    //   this.finishIntAd!(true);
    // }
    // return;
    // 展示上限
    if (SJLocalProvider.instance.sj_ad_show_index > SJFKManger().fkModel.behavior.ad_daily_show){
      sj_event_fire('see_you_tommorow', {});
      context.tipShow(SJPopAdLimitDialog());
      hasCache(false);
      return;
    }
    // 风控
    if (await SJFKManger().sj_checkAllStatus()){
      SJDialogTool.toast(context, 'Something went wrong, please try again later.');
      hasCache(false);
      return;
    }
    if (isint){
      sj_event_fire(
        "kmrol_ad_chance",
        {"ad_pos_id": placeId ?? "",
          'ad_format' : 'interstitial',
        },
      );
      // 插屏比价结果
      if (intSucAds.isEmpty){
        sj_event_fire(
          "kmrol_ad_impression_fail",
          {"ad_pos_id": placeId ?? "",
            'ad_format' : 'interstitial'},
        );
        "scratchjoy ad Int request to show pos_id ${placeIdentifer} no cache!}".log();
        showfaildDiolog(context);
        hasCache(false);
        sj_load();
      } else {
        if (SJAdHelpers().ad_Entity!.scxji_int.first.feytgpub == 'max') {
          // 获取最大ecpm Ad
          SJAdModellist shwoAd = getMaxNumber(intSucAds);
          bool isReady = (await AppLovinMAX.isInterstitialReady(shwoAd.hnmkuhdz))!;
          if (isReady){
            "scratchjoy ad Int show pos_id ${placeIdentifer} adUnitId ${shwoAd.hnmkuhdz}".log();
            is_ad_play = true;
            AppLovinMAX.showInterstitial(shwoAd.hnmkuhdz);
            hasCache(true);
          }

        } else {
          SJAdModellist shwoAd = getMaxNumber(intSucAds);
          bool isReady = (await ATInterstitialManager
              .hasInterstitialAdReady(
            placementID: shwoAd.hnmkuhdz,
          ));
          if (isReady){
            Future.delayed(Duration(seconds: 1), () {
              hasCache(true);
            });
            is_ad_play = true;
            await ATInterstitialManager
                .showInterstitialAd(
              placementID: shwoAd.hnmkuhdz,
            );
            "scratchjoy ad Int show pos_id ${placeIdentifer} adUnitId ${shwoAd.hnmkuhdz}".log();
          }
        }
      }
    } else {
      sj_event_fire(
        "kmrol_ad_chance",
        {"ad_pos_id": placeId ?? "",
          'ad_format' : 'reward',
        },
      );
      // 激励比价结果 true 需要和插屏一起比价
      'SBAdAHelpers().adsEntity?.eopjp_switch=${SJAdHelpers().ad_Entity?.scxji_switch}'.log();
      if (SJAdHelpers().ad_Entity?.scxji_switch == true){
        if (rewardSucAds.isEmpty && intSucAds.isEmpty && !isint){
          sj_event_fire(
            "kmrol_ad_impression_fail",
            {"ad_pos_id": placeId ?? "",
              'ad_format' : 'reward'},
          );
          "scratchjoy ad reward request to show pos_id ${placeIdentifer} no cache!}".log();
          showfaildDiolog(context);
          hasCache(false);
          sj_load();
        } else {
          if (rewardSucAds.isNotEmpty && intSucAds.isNotEmpty) {
            SJAdModellist shwoAd1 = getMaxNumber(rewardSucAds);
            SJAdModellist shwoAd2 = getMaxNumber(intSucAds);
            if (shwoAd1.ecpm! > shwoAd2.ecpm!){
              if (SJAdHelpers().ad_Entity!.scxji_int.first.feytgpub == 'max') {
                bool isReady = (await AppLovinMAX.isRewardedAdReady(shwoAd1.hnmkuhdz))!;
                if (isReady){
                  "scratchjoy ad reward show pos_id ${placeIdentifer} adUnitId ${shwoAd1.hnmkuhdz}".log();
                  is_ad_play = true;
                  AppLovinMAX.showRewardedAd(shwoAd1.hnmkuhdz);
                  hasCache(true);
                }
              } else {
                SJAdModellist shwoAd = getMaxNumber(rewardSucAds);
                bool isReady = (await ATRewardedManager
                    .rewardedVideoReady(
                    placementID: shwoAd.hnmkuhdz,)) ?? false;
                if (isReady) {
                  Future.delayed(Duration(seconds: 1), () {
                    hasCache(true);
                  });
                  is_ad_play = true;
                  await ATRewardedManager
                      .showRewardedVideo(
                    placementID: shwoAd.hnmkuhdz,
                  );
                }
              }
            } else {
              if (SJAdHelpers().ad_Entity!.scxji_int.first.feytgpub == 'max') {
                bool isReady = (await AppLovinMAX.isInterstitialReady(shwoAd2.hnmkuhdz))!;
                if (isReady){
                  "scratchjoy ad rewardToInt show pos_id ${placeIdentifer} adUnitId ${shwoAd2.hnmkuhdz}".log();
                  is_ad_play = true;
                  AppLovinMAX.showInterstitial(shwoAd2.hnmkuhdz);
                  hasCache(true);
                }

              } else {
                bool isReady = (await ATRewardedManager
                    .rewardedVideoReady(
                  placementID: shwoAd2.hnmkuhdz,)) ?? false;
                if (isReady) {
                  Future.delayed(Duration(seconds: 1), () {
                    hasCache(true);
                  });
                  is_ad_play = true;
                  await ATRewardedManager
                      .showRewardedVideo(
                    placementID: shwoAd2.hnmkuhdz,
                  );
                }
              }
            }
          } else {
            if (rewardSucAds.isNotEmpty) {
              if (SJAdHelpers().ad_Entity!.scxji_int.first.feytgpub == 'max') {
                // 获取最大ecpm Ad
                SJAdModellist shwoAd = getMaxNumber(rewardSucAds);
                bool isReady = (await AppLovinMAX.isRewardedAdReady(shwoAd.hnmkuhdz))!;
                if (isReady){
                  "scratchjoy ad reward show pos_id ${placeIdentifer} adUnitId ${shwoAd.hnmkuhdz}".log();
                  is_ad_play = true;
                  AppLovinMAX.showRewardedAd(shwoAd.hnmkuhdz);
                  hasCache(true);
                }

              } else {
                SJAdModellist shwoAd = getMaxNumber(rewardSucAds);
                bool isReady = (await ATRewardedManager
                    .rewardedVideoReady(
                  placementID: shwoAd.hnmkuhdz,)) ?? false;
                if (isReady) {
                  Future.delayed(Duration(seconds: 1), () {
                    hasCache(true);
                  });
                  is_ad_play = true;
                  await ATRewardedManager
                      .showRewardedVideo(
                    placementID: shwoAd.hnmkuhdz,
                  );
                }

              }
            } else if (intSucAds.isNotEmpty) {
              if (SJAdHelpers().ad_Entity!.scxji_int.first.feytgpub == 'max') {
                // 获取最大ecpm Ad
                SJAdModellist shwoAd = getMaxNumber(intSucAds);
                bool isReady = (await AppLovinMAX.isInterstitialReady(shwoAd.hnmkuhdz))!;
                if (isReady){
                  "scratchjoy ad Int show pos_id ${placeIdentifer} adUnitId ${shwoAd.hnmkuhdz}".log();
                  is_ad_play = true;
                  AppLovinMAX.showInterstitial(shwoAd.hnmkuhdz);
                  hasCache(true);
                }

              } else {
                SJAdModellist shwoAd = getMaxNumber(intSucAds);
                bool isReady = (await ATInterstitialManager
                    .hasInterstitialAdReady(
                  placementID: shwoAd.hnmkuhdz,
                ));
                if (isReady){
                  Future.delayed(Duration(seconds: 1), () {
                    hasCache(true);
                  });
                  is_ad_play = true;
                  await ATInterstitialManager
                      .showInterstitialAd(
                    placementID: shwoAd.hnmkuhdz,
                  );
                  "scratchjoy ad Int show pos_id ${placeIdentifer} adUnitId ${shwoAd.hnmkuhdz}".log();
                }

              }
            } else {
              sj_event_fire(
                "kmrol_ad_impression_fail",
                {"ad_pos_id": placeId ?? "",
                  'ad_format' : 'reward'},
              );
              "scratchjoy ad reward request to show pos_id ${placeIdentifer} no cache!}".log();
              showfaildDiolog(context);
              hasCache(false);
              sj_load();
            }
          }
        }
      } else {
        // false 不需要和插屏一起比价
        if (rewardSucAds.isEmpty){
          sj_event_fire(
            "kmrol_ad_impression_fail",
            {"ad_pos_id": placeId ?? "",
              'ad_format' : 'reward'},
          );
          "scratchjoy ad reward request to show pos_id ${placeIdentifer} no cache!}".log();
          hasCache(false);
          showfaildDiolog(context);
          sj_load();
        } else {
          if (SJAdHelpers().ad_Entity!.scxji_int.first.feytgpub == 'max') {
            // 获取最大ecpm Ad
            SJAdModellist shwoAd = getMaxNumber(rewardSucAds);
            bool isReady = (await AppLovinMAX.isRewardedAdReady(shwoAd.hnmkuhdz))!;
            if (isReady){
              "scratchjoy ad reward show pos_id ${placeIdentifer} adUnitId ${shwoAd.hnmkuhdz}".log();
              is_ad_play = true;
              AppLovinMAX.showRewardedAd(shwoAd.hnmkuhdz);
              hasCache(true);
            }

          } else {
            SJAdModellist shwoAd = getMaxNumber(rewardSucAds);
            bool isReady = (await ATRewardedManager
                .rewardedVideoReady(
              placementID: shwoAd.hnmkuhdz,)) ?? false;
            if (isReady) {
              Future.delayed(Duration(seconds: 1), () {
                hasCache(true);
              });
              is_ad_play = true;
              await ATRewardedManager
                  .showRewardedVideo(
                placementID: shwoAd.hnmkuhdz,
              );
            }
          }
        }
      }
    }
  }
  // 显示失败弹框
  showfaildDiolog(BuildContext context) async {
    // 展示上限
    if (SJLocalProvider.instance.sj_ad_show_index >= SJFKManger().fkModel.behavior.ad_daily_show){
      sj_event_fire('see_you_tommorow', {});
      context.tipShow(SJPopAdLimitDialog());
    } else {
      // 无网络
      bool isConnected = await NetworkUtils.isConnected();
      if (isConnected) {
        print("有网加载失败");
        context.tipShow(SJPopAdLoadFailDialog());
      } else {
        context.tipShow(SJPopAdNotWiFiDialog());
        print("设备无网络连接");
      }
    }
  }

  // 获取最大ecpm
  SJAdModellist getMaxNumber(List<SJAdModellist> numbers) {
    // 处理空数组（可选：根据需求决定是否抛异常或返回默认值）
    if (numbers.isEmpty) {
      return SJAdModellist();
    }
    // 初始化最大值为数组第一个元素（转换为double）
    double maxValue = numbers.first.ecpm!;
    SJAdModellist maxModel = numbers.first;
    // 遍历数组，比较并更新最大值
    for (final SJAdModellist number in numbers) {
      final double current = number.ecpm!;
      if (current > maxValue) {
        maxValue = current;
        maxModel = number;
      }
    }
    return maxModel;
  }
  // 插屏回调
  sp_intListener(){
    AppLovinMAX.setInterstitialListener(
      InterstitialListener(
        onAdLoadedCallback: (ad) {
          // 请求成功
          "scratchjoy ad Int Load Success ${ad.adUnitId} revenue=${ad.revenue}".log();
          for (var ads in intAds){
            if (ads.hnmkuhdz == ad.adUnitId){
              ads.ecpm = ad.revenue;
              intSucAds.add(ads);
            }
          }
          sj_event_fire('kmrol_ad_return', {
            "ad_pos_id": placeId ?? "init_Load",
            'ad_format' : ad.adFormat,
            'ad_platform' : 'max',
            'ad_code_id' : ad.adUnitId,
            'ad_request_time' : DateTime.now().difference(int_start).inMilliseconds
          });
        },
        onAdLoadFailedCallback: (adUnitId, error) {
          "scratchjoy ad Int Load Failed ${adUnitId} error=${error}".log();
          sj_event_fire('kmrol_ad_return_fail', {
            "ad_pos_id": placeId ?? "init_Load",
            'ad_format' : 'interstitial',
            'ad_platform' : 'max',
            'ad_code_id' : adUnitId,
            'reason' : error.toString(),
            'timeout' : DateTime.now().difference(int_start).inMilliseconds
          });
          // 请求失败
          sj_load();
        },
        onAdDisplayedCallback: (ad) async {
          await SJLocalProvider.instance.updateint(SJLocalProvider.instance.sj_ad_show_numberName, SJLocalProvider.instance.sj_ad_show_number + 1);
          await SJLocalProvider.instance.updateint(SJLocalProvider.instance.sj_ad_all_numberName, SJLocalProvider.instance.sj_ad_all_number + 1);
          if (SJLocalProvider.instance.sj_ad_show_number % 5 == 0 && SJLocalProvider.instance.sj_ad_show_number > 0) {
            sj_event_fire(
              "cash_ad_detail",
              {
                "ad": SJLocalProvider.instance.sj_ad_show_number ?? "",
              },
            );
          }
          sj_ad_fire({
            "baldwin": ad.revenue * 1000000,
            "cursive": ad.networkName,
            "furnish": "max",
            "pay": ad.adUnitId,
            "apoplexy": placeId ?? "",
            "revelry": ad.adFormat,
            "oriole" : ad.revenuePrecision,
          });
          "scratchjoy ad int show Success ${ad.adUnitId} revenue=${ad.revenue}".log();
          await SJLocalProvider.instance.updateint(SJLocalProvider.instance.sj_ad_show_indexName, SJLocalProvider.instance.sj_ad_show_index + 1);
        },
        onAdDisplayFailedCallback: (ad, error) {
          // 显示失败
          "scratchjoy ad int show faild to display ${error.message}".log();
          intSucAds.removeWhere((ads) => ads.hnmkuhdz == ad.adUnitId);
          if (finishIntAd != null) {
            finishIntAd!(false);
          }
          sj_load();
        },
        onAdClickedCallback: (ad) {
          // 点击
          "scratchjoy ad Int did click ${ad.adUnitId}".log();
        },
        onAdHiddenCallback: (ad) {
          is_ad_play = false;
          sj_event_fire('kmrol_ad_imp_close', {
            "ad_pos_id": placeId ?? "init_Load",
            'ad_format' : ad.adFormat,
            'ad_platform' : 'max',
            'ad_code_id' : ad.adUnitId,
          });
          if (this.finishIntAd != null) {
            this.finishIntAd!(true);
          }
          // 消失
          "scratchjoy ad Int Hidden ${ad.adUnitId}".log();
          intSucAds.removeWhere((ads) => ads.hnmkuhdz == ad.adUnitId);
          // 补充广告
          sj_load();

        },
        onAdRevenuePaidCallback: (ad) {
          // 返回奖励
          SJSDKHelpers().sj_sendAdToSdk(ad);
        },
      ),
    );

  }
  // 激励回调
  sp_rewardListener(){
    AppLovinMAX.setRewardedAdListener(
      RewardedAdListener(
        onAdLoadedCallback: (ad) {
          // 请求成功
          "scratchjoy ad reward Load Success ${ad.adUnitId} revenue=${ad.revenue}".log();
          for (var ads in rewardAds){
            if (ads.hnmkuhdz == ad.adUnitId){
              ads.ecpm = ad.revenue;
              rewardSucAds.add(ads);
            }
          }
          sj_event_fire('kmrol_ad_return', {
            "ad_pos_id": placeId ?? "init_Load",
            'ad_format' : ad.adFormat,
            'ad_platform' : 'max',
            'ad_code_id' : ad.adUnitId,
            'ad_request_time' : DateTime.now().difference(read_start).inMilliseconds
          });
        },
        onAdLoadFailedCallback: (adUnitId, error) {
          "scratchjoy ad reward Load Failed ${adUnitId} error=${error}".log();
          sj_event_fire('kmrol_ad_return_fail', {
            "ad_pos_id": placeId ?? "init_Load",
            'ad_format' : 'reward',
            'ad_platform' : 'max',
            'ad_code_id' : adUnitId,
            'reason' : error.toString(),
            'timeout' : DateTime.now().difference(read_start).inMilliseconds
          });
          // 请求失败
          sj_load();
        },
        onAdDisplayedCallback: (ad) async {
          _savedPlayAndCloseTime = DateTime.now();
          await SJLocalProvider.instance.updateint(SJLocalProvider.instance.sj_ad_all_numberName, SJLocalProvider.instance.sj_ad_all_number + 1);
          await SJLocalProvider.instance.updateint(SJLocalProvider.instance.sj_ad_reawrd_all_numberName, SJLocalProvider.instance.sj_ad_reawrd_all_number + 1);
          // 判断两次播放间隔小于30s
          int secondsDiff = DateTime.now().difference(_savedTime!).inSeconds;
          if (secondsDiff < SJFKManger().fkModel.behavior.ad_short_show.duration && _savedTime != null){
            // 添加次数
            await SJLocalProvider.instance.updateint(SJLocalProvider.instance.sj_ad_short_show_numberName, SJLocalProvider.instance.sj_ad_short_show_number + 1);
            // 大于等于次数被风控
            'SJFKManger().fkModel.behavior.ad_short_show.value=${SJFKManger().fkModel.behavior.ad_short_show.value}'.log();
            'WUUserHelpers().wu_ad_short_show_number=${SJLocalProvider.instance.sj_ad_short_show_number}'.log();
            if (SJFKManger().fkModel.behavior.ad_short_show.value <= SJLocalProvider.instance.sj_ad_short_show_number){
              sj_event_fire('risk_chance', {'risk_from' : 'ad_short_show'});
              await SJLocalProvider.instance.updateBool(SJLocalProvider.instance.sj_fk_ad_short_showName, true);
            }
          }
          // 广告显示
          await SJLocalProvider.instance.updateint(SJLocalProvider.instance.sj_ad_show_numberName, SJLocalProvider.instance.sj_ad_show_number + 1);
          if (SJLocalProvider.instance.sj_ad_show_number % 5 == 0 && SJLocalProvider.instance.sj_ad_show_number > 0) {
            sj_event_fire(
              "cash_ad_detail",
              {
                "ad": SJLocalProvider.instance.sj_ad_show_number ?? "",
              },
            );
          }
          sj_ad_fire({
            "baldwin": ad.revenue * 1000000,
            "cursive": ad.networkName,
            "furnish": "max",
            "pay": ad.adUnitId,
            "apoplexy": placeId ?? "",
            "revelry": ad.adFormat,
            "oriole" : ad.revenuePrecision,
          });
          "scratchjoy ad reward show Success ${ad.adUnitId} revenue=${ad.revenue}".log();
          await SJLocalProvider.instance.updateint(SJLocalProvider.instance.sj_ad_show_indexName, SJLocalProvider.instance.sj_ad_show_index + 1);
        },
        onAdDisplayFailedCallback: (ad, error) {
          // 显示失败
          "scratchjoy ad Reward show faild to display ${error.message}".log();
          // 显示失败
          rewardSucAds.removeWhere((ads) => ads.hnmkuhdz == ad.adUnitId);
          if (finishIntAd != null) {
            finishIntAd!(false);
          }
          sj_load();
        },
        onAdClickedCallback: (ad) {
          // 点击
          "scratchjoy ad Reward did click ${ad.adUnitId}".log();
        },
        onAdHiddenCallback: (ad) async {
          is_ad_play = false;
          // 保存上次关闭广告时间仅限激励
          _savedTime = DateTime.now();
          // 判断播发到关闭播放间隔小于20s
          int secondsDiff = DateTime.now().difference(_savedPlayAndCloseTime!).inSeconds;
          if (secondsDiff < SJFKManger().fkModel.behavior.ad_short_close.duration && _savedPlayAndCloseTime != null){
            // 添加次数
            await SJLocalProvider.instance.updateint(SJLocalProvider.instance.sj_ad_short_close_numberName, SJLocalProvider.instance.sj_ad_short_close_number + 1);
            // 大于等于次数被风控
            if (SJFKManger().fkModel.behavior.ad_short_close.value <= SJLocalProvider.instance.sj_ad_short_close_number){
              sj_event_fire('risk_chance', {'risk_from' : 'ad_short_close'});
              await SJLocalProvider.instance.updateBool(SJLocalProvider.instance.sj_fk_ad_short_closeName, true);
            }
          }
          // 消失
          rewardSucAds.removeWhere((ads) => ads.hnmkuhdz == ad.adUnitId);
          "scratchjoy ad Reward did hide - ${ad.adUnitId}".log();
          if (this.finishIntAd != null) {
            this.finishIntAd!(true);
          }
          sj_event_fire('kmrol_ad_imp_close', {
            "ad_pos_id": placeId ?? "init_Load",
            'ad_format' : ad.adFormat,
            'ad_platform' : 'max',
            'ad_code_id' : ad.adUnitId,
          });
          sj_load();
        },
        onAdRevenuePaidCallback: (ad) {
          // 上报收入
          "scratchjoy ad Reward did pay ${ad.revenue} - ${ad.adUnitId}".log();
          SJSDKHelpers().sj_sendAdToSdk(ad);
        },
        onAdReceivedRewardCallback: (MaxAd ad, MaxReward reward) {

        },
      ),
    );

  }
  // topOn激励回掉
  wu_rewarderListen() {

    ATListenerManager.rewardedVideoEventHandler.listen((value) async {
      switch (value.rewardStatus) {
      //广告加载失败
        case RewardedStatus.rewardedVideoDidFailToLoad:
          print("flutter rewardedVideoDidFailToLoad ---- placementID: ${value.placementID} ---- errStr:${value.requestMessage}");
          sj_load();
          sj_event_fire('kmrol_ad_return_fail', {
            "ad_pos_id": placeId ?? "init_Load",
            'ad_format' : 'interstitial',
            'ad_platform' : 'topon',
            'ad_code_id' : value.placementID,
            'reason' : value.requestMessage,
            'timeout' : DateTime.now().difference(read_start).inMilliseconds
          });
          break;
      //广告加载成功
        case RewardedStatus.rewardedVideoDidFinishLoading:
          print("flutter rewardedVideoDidFinishLoading ---- placementID: ${value.placementID}");
          for (var ads in rewardAds){
            if (ads.hnmkuhdz == value.placementID){
              ads.ecpm = value.extraMap["publisher_revenue"] ?? 0;
              rewardSucAds.add(ads);
            }
          }
          sj_event_fire('kmrol_ad_return', {
            "ad_pos_id": placeId ?? "init_Load",
            'ad_format' : 'reward',
            'ad_platform' : 'topon',
            'ad_code_id' : value.placementID,
            'ad_request_time' : DateTime.now().difference(read_start).inMilliseconds
          });
          break;
      //广告开始播放
        case RewardedStatus.rewardedVideoDidStartPlaying:
          print("flutter rewardedVideoDidStartPlaying ---- placementID: ${value.placementID} ---- extra:${value.extraMap}");
          await SJLocalProvider.instance.updateint(SJLocalProvider.instance.sj_ad_all_numberName, SJLocalProvider.instance.sj_ad_all_number + 1);
          await SJLocalProvider.instance.updateint(SJLocalProvider.instance.sj_ad_reawrd_all_numberName, SJLocalProvider.instance.sj_ad_reawrd_all_number + 1);
          // 播放到关闭时间保存
          _savedPlayAndCloseTime = DateTime.now();
          // 判断两次播放间隔小于30s
          int secondsDiff = DateTime.now().difference(_savedTime!).inSeconds;
          if (secondsDiff < SJFKManger().fkModel.behavior.ad_short_show.duration && _savedTime != null){
            // 添加次数
            await SJLocalProvider.instance.updateint(SJLocalProvider.instance.sj_ad_show_numberName, SJLocalProvider.instance.sj_ad_show_number + 1);
            // 大于等于次数被风控
            'SJFKManger().fkModel.behavior.ad_short_show.value=${SJFKManger().fkModel.behavior.ad_short_show.value}'.log();
            'WUUserHelpers().wu_ad_short_show_number=${SJLocalProvider.instance.sj_ad_short_show_number}'.log();
            if (SJFKManger().fkModel.behavior.ad_short_show.value <= SJLocalProvider.instance.sj_ad_short_show_number){
              sj_event_fire('risk_chance', {'risk_from' : 'ad_short_show'});
              await SJLocalProvider.instance.updateBool(SJLocalProvider.instance.sj_fk_ad_short_showName, true);
            }
          }
          await SJLocalProvider.instance.updateint(SJLocalProvider.instance.sj_ad_show_numberName, SJLocalProvider.instance.sj_ad_show_number + 1);
          if (SJLocalProvider.instance.sj_ad_show_number % 5 == 0 && SJLocalProvider.instance.sj_ad_show_number > 0) {
            sj_event_fire(
              "cash_ad_detail",
              {
                "ad": SJLocalProvider.instance.sj_ad_show_number ?? "",
              },
            );
          }
          sj_event_fire(
            "cvmad_ad_impression",
            {"ad_pos_id": placeId ?? ""},
          );
          final revenue = value.extraMap["publisher_revenue"] ?? 0;
          final network = value.extraMap["network_name"];
          sj_ad_fire({
            "baldwin": revenue * 1000000,
            "cursive": network,
            "furnish": "topon",
            "pay": value.placementID,
            "apoplexy": placeId ?? "",
            "revelry": "reward",
          });
          await SJLocalProvider.instance.updateint(SJLocalProvider.instance.sj_ad_show_indexName, SJLocalProvider.instance.sj_ad_show_index + 1);
          break;
      //广告结束播放
        case RewardedStatus.rewardedVideoDidEndPlaying:
          print("flutter rewardedVideoDidEndPlaying ---- placementID: ${value.placementID} ---- extra:${value.extraMap}");
          break;
      //广告播放失败
        case RewardedStatus.rewardedVideoDidFailToPlay:
          sj_event_fire(
            "kmrol_ad_impression_fail",
            {"ad_pos_id": placeId ?? ""},
          );
          "scratchjoy ad Reward did faild to display ${value.requestMessage}".log();
          if (this.finishIntAd != null) {
            this.finishIntAd!(false);
          }
          print("flutter rewardedVideoDidFailToPlay ---- placementID: ${value.placementID} ---- errStr:${value.extraMap}");
          break;
      //激励成功，建议在此回调中下发奖励
        case RewardedStatus.rewardedVideoDidRewardSuccess:
          print("flutter rewardedVideoDidRewardSuccess ---- placementID: ${value.placementID} ---- extra:${value.extraMap}");
          "scratchjoy ad Reward did display ${value.placementID}".log();
          "scratchjoy ad Reward did pay ${value.placementID} - ${value.placementID}".log();
          "scratchjoy ad Int did pay finally ${value.placementID} - ${value.placementID}".log();
          SJSDKHelpers().sj_sendintTopOnAdToSdk(value.extraMap);
          break;
      //广告被点击
        case RewardedStatus.rewardedVideoDidClick:
          "scratchjoy ad Reward did click ${value.placementID}".log();
          print("flutter rewardedVideoDidClick ---- placementID: ${value.placementID} ---- extra:${value.extraMap}");
          break;
      //Deeplink
        case RewardedStatus.rewardedVideoDidDeepLink:
          print("flutter rewardedVideoDidDeepLink ---- placementID: ${value.placementID} ---- extra:${value.extraMap} ---- isDeeplinkSuccess:${value.isDeeplinkSuccess}");
          break;
      //广告被关闭
        case RewardedStatus.rewardedVideoDidClose:
          sj_event_fire('kmrol_ad_imp_close', {
            "ad_pos_id": placeId ?? "init_Load",
            'ad_format' : 'reward',
            'ad_platform' : 'topon',
            'ad_code_id' : value.placementID,
          });
          is_ad_play = false;
          "scratchjoy ad Reward did hide - ${value.placementID}".log();
          // 保存上次关闭广告时间仅限激励
          _savedTime = DateTime.now();
          // 判断播发到关闭播放间隔小于20s
          int secondsDiff = DateTime.now().difference(_savedPlayAndCloseTime!).inSeconds;
          if (secondsDiff < SJFKManger().fkModel.behavior.ad_short_close.duration && _savedPlayAndCloseTime != null){
            // 添加次数
            await SJLocalProvider.instance.updateint(SJLocalProvider.instance.sj_ad_short_close_numberName, SJLocalProvider.instance.sj_ad_short_close_number + 1);
            // 大于等于次数被风控
            if (SJFKManger().fkModel.behavior.ad_short_close.value <= SJLocalProvider.instance.sj_ad_short_close_number){
              sj_event_fire('risk_chance', {'risk_from' : 'ad_short_close'});
              await SJLocalProvider.instance.updateBool(SJLocalProvider.instance.sj_fk_ad_short_closeName, true);
            }
          }
          if (this.finishIntAd != null) {
            this.finishIntAd!(true);
          }
          rewardSucAds.removeWhere((ads) => ads.hnmkuhdz == value.placementID);
          sj_load();
          print("flutter rewardedVideoDidClose ---- placementID: ${value.placementID} ---- extra:${value.extraMap}");
          break;
        case RewardedStatus.rewardedVideoUnknown:
          print("flutter rewardedVideoUnknown");
          break;
        case RewardedStatus.rewardedVideoDidAgainStartPlaying:
        // TODO: Handle this case.
          throw UnimplementedError();
        case RewardedStatus.rewardedVideoDidAgainEndPlaying:
        // TODO: Handle this case.
          throw UnimplementedError();
        case RewardedStatus.rewardedVideoDidAgainFailToPlay:
        // TODO: Handle this case.
          throw UnimplementedError();
        case RewardedStatus.rewardedVideoDidAgainRewardSuccess:
        // TODO: Handle this case.
          throw UnimplementedError();
        case RewardedStatus.rewardedVideoDidAgainClick:
        // TODO: Handle this case.
          throw UnimplementedError();
      }
    });
  }
  // topon
  wu_interListen() {
    ATListenerManager.interstitialEventHandler.listen((value) async {

      switch (value.interstatus) {
      //广告加载失败
        case InterstitialStatus.interstitialAdFailToLoadAD:
          print("flutter interstitialAdFailToLoadAD ---- placementID: ${value.placementID} ---- errStr:${value.requestMessage}");
          sj_load();
          sj_event_fire('kmrol_ad_return_fail', {
            "ad_pos_id": placeId ?? "init_Load",
            'ad_format' : 'interstitial',
            'ad_platform' : 'topon',
            'ad_code_id' : value.placementID,
            'reason' : value.requestMessage,
            'timeout' : DateTime.now().difference(int_start).inMilliseconds
          });
          break;
      //广告加载成功
        case InterstitialStatus.interstitialAdDidFinishLoading:
          print("flutter interstitialAdDidFinishLoading ---- placementID: ${value.placementID}");
          for (var ads in intAds){
            if (ads.hnmkuhdz == value.placementID){
              ads.ecpm = value.extraMap["publisher_revenue"] ?? 0;
              intSucAds.add(ads);
            }
          }
          sj_event_fire('kmrol_ad_return', {
            "ad_pos_id": placeId ?? "init_Load",
            'ad_format' : 'reward',
            'ad_platform' : 'topon',
            'ad_code_id' : value.placementID,
            'ad_request_time' : DateTime.now().difference(int_start).inMilliseconds
          });
          break;
      //广告视频开始播放，部分平台有此回调
        case InterstitialStatus.interstitialAdDidStartPlaying:
          print("flutter interstitialAdDidStartPlaying ---- placementID: ${value.placementID} ---- extra:${value.extraMap}");
          break;
      //广告视频播放结束，部分广告平台有此回调
        case InterstitialStatus.interstitialAdDidEndPlaying:
          print("flutter interstitialAdDidEndPlaying ---- placementID: ${value.placementID} ---- extra:${value.extraMap}");
          break;
      //广告视频播放失败，部分广告平台有此回调
        case InterstitialStatus.interstitialDidFailToPlayVideo:
          print("flutter interstitialDidFailToPlayVideo ---- placementID: ${value.placementID} ---- errStr:${value.requestMessage}");
          break;
      //广告展示成功
        case InterstitialStatus.interstitialDidShowSucceed:
          print("flutter interstitialDidShowSucceed ---- placementID: ${value.placementID} ---- extra:${value.extraMap}");
          await SJLocalProvider.instance.updateint(SJLocalProvider.instance.sj_ad_all_numberName, SJLocalProvider.instance.sj_ad_all_number + 1);
          await SJLocalProvider.instance.updateint(SJLocalProvider.instance.sj_ad_show_numberName, SJLocalProvider.instance.sj_ad_show_number + 1);
          if (SJLocalProvider.instance.sj_ad_show_number % 5 == 0 && SJLocalProvider.instance.sj_ad_show_number > 0) {
            sj_event_fire(
              "cash_ad_detail",
              {
                "ad": SJLocalProvider.instance.sj_ad_show_number ?? "",
              },
            );
          }
          sj_event_fire(
            "cvmad_ad_impression",
            {"ad_pos_id": placeId ?? ""},
          );
          final revenue = value.extraMap["publisher_revenue"] ?? 0;
          final network = value.extraMap["network_name"];
          sj_ad_fire({
            "baldwin": revenue * 1000000,
            "cursive": network,
            "furnish": "topon",
            "pay": value.placementID,
            "apoplexy": placeId ?? "",
            "revelry": "interstitial",
          });
          SJSDKHelpers().sj_sendintTopOnAdToSdk(value.extraMap);
          await SJLocalProvider.instance.updateint(SJLocalProvider.instance.sj_ad_show_indexName, SJLocalProvider.instance.sj_ad_show_index + 1);
          break;
      //广告展示失败
        case InterstitialStatus.interstitialFailedToShow:
          print("flutter interstitialFailedToShow ---- placementID: ${value.placementID} ---- errStr:${value.requestMessage}");
          sj_event_fire(
            "kmrol_ad_impression_fail",
            {"ad_pos_id": placeId ?? ""},
          );
          "scratchjoy ad Reward did faild to display ${value.requestMessage}".log();
          if (this.finishIntAd != null) {
            this.finishIntAd!(false);
          }
          sj_load();
          break;
      //广告被点击
        case InterstitialStatus.interstitialAdDidClick:
          print("flutter interstitialAdDidClick ---- placementID: ${value.placementID} ---- extra:${value.extraMap}");

          break;
      //Deeplink
        case InterstitialStatus.interstitialAdDidDeepLink:
          print("flutter interstitialAdDidDeepLink ---- placementID: ${value.placementID} ---- extra:${value.extraMap}");
          break;
      //广告被关闭
        case InterstitialStatus.interstitialAdDidClose:
          is_ad_play = false;
          sj_event_fire('kmrol_ad_imp_close', {
            "ad_pos_id": placeId ?? "init_Load",
            'ad_format' : 'interstitial',
            'ad_platform' : 'topon',
            'ad_code_id' : value.placementID,
          });
          print("flutter interstitialAdDidClose ---- placementID: ${value.placementID} ---- extra:${value.extraMap}");
          // 消失
          intSucAds.removeWhere((ads) => ads.hnmkuhdz == value.placementID);
          "scratchjoy ad Reward did hide - ${value.placementID}".log();
          if (this.finishIntAd != null) {
            this.finishIntAd!(true);
          }
          sj_load();

          break;

        case InterstitialStatus.interstitialUnknown:
          print("flutter interstitialUnknown");
          break;
      }
    });


  }

}

extension AdAdsHelperExtension on SJAdManager {
  initIntAdDatasource() {
    intAds = SJAdHelpers().ad_Entity?.scxji_int ?? [];
    rewardAds = SJAdHelpers().ad_Entity?.scxji_rv ?? [];
    sj_load();
  }
}
class NetworkUtils {
  /// 检查当前是否有网络连接（移动数据或Wi-Fi）
  static Future<bool> isConnected() async {
    // 获取当前网络状态
    final connectivityResult = await (Connectivity().checkConnectivity());

    // 判断是否有网络连接
    if (connectivityResult == ConnectivityResult.mobile ||
        connectivityResult == ConnectivityResult.wifi) {
      return true; // 有移动数据或Wi-Fi连接
    }

    return false; // 无网络连接
  }

  /// 监听网络状态变化
  static Stream<ConnectivityResult> getNetworkChanges() {
    return Connectivity().onConnectivityChanged;
  }
}