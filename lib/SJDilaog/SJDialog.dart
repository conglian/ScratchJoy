import 'dart:async';
import 'dart:convert';
import 'dart:math';
import 'package:fl_toast/fl_toast.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:scratchjoy/SJHome/SJScratchRatio.dart';
import 'package:scratchjoy/SJTool/sj_GradientText.dart';
import 'package:scratchjoy/SJTool/sj_LocalProvider.dart';
import 'package:scratchjoy/SJTool/sj_extension_help.dart';
import 'package:scratchjoy/SJTool/sj_img.dart';
import 'package:scratchjoy/SJTool/sj_number_helper.dart';
import 'package:scratchjoy/SJTool/sj_stroke_text.dart';
import 'package:scratchjoy/SJTool/sj_text.dart';
import 'package:scratchjoy/main.dart';
import 'package:spine_flutter/spine_flutter.dart' as spine;
import '../SJHome/SJCash.dart';
import '../SJHome/SJDiceRollWidget.dart';
import '../SJHome/SJHome.dart';
import '../SJHome/SJScratchA.dart';
import '../SJTool/SJAdAHelp.dart';
import '../SJTool/SJAdManager.dart';
import '../SJTool/SJTBAInfoTool.dart';
import '../SJTool/sj_GradientNumber.dart';
import '../SJTool/sj_WebKitView.dart';
import '../SJTool/sj_mp3_player.dart';
import 'package:app_settings/app_settings.dart';

// 骰子🎲奖励
class SJPopYouWinBDialog extends StatefulWidget {
  final bool is_show;
  final bool is_showThree;
  final String type;
  final int award;
  SJPopYouWinBDialog({super.key, required this.award, required this.is_show, required this.is_showThree, required this.type});
  @override
  State<SJPopYouWinBDialog> createState() => SJPopdiceBwardDialogState();
}

class SJPopdiceBwardDialogState extends State<SJPopYouWinBDialog>
    with TickerProviderStateMixin {
  late final AnimationController _controller;
  late final AnimationController _scaleController;
  late final AnimationController _scaleController2;
  late final Animation<double> _scaleAnimation2;
  late spine.SpineWidgetController _controller0;
  @override
  void initState() {
    super.initState();
    sj_event_fire('coin_pop', {'source_from' : widget.type});
    _controller0 = spine.SpineWidgetController(onInitialized: (controller) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        controller.animationState.setAnimationByName(0, "animation", true);
      });
    });

    // 匀速旋转动画
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 6),
    )..repeat();

    // 顶部图片放大缩小动画 ✅ 修复版
    _scaleController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    )..repeat(reverse: true);

    _scaleController2 = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    )..repeat(reverse: true);

    _scaleAnimation2 = Tween(begin: 1.0, end: 1.2)
        .animate(CurvedAnimation(parent: _scaleController, curve: Curves.easeInOut));

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      if (SJLocalProvider.instance.sj_sound_music){
        await SJMP3Player().pauseBackground();
        await SJMP3Player().playEffect4();
      }
      Future.delayed(Duration(milliseconds: 1000), () async {
        await SJMP3Player().pauseEffect4();
        if (SJLocalProvider.instance.sj_bg_music){
          await SJMP3Player().playBackground();
        }
      });
      if (widget.is_show){
        Future.delayed(Duration(milliseconds: 1000), () async {
          if (mounted){
            Navigator.pop(context);
            navigatorKey.currentContext!.tipShow(SJPopSuperWinBDialog(award: widget.award, is_show: widget.is_showThree, type: widget.type));
          }
        });
      }
    });
  }

  void playAwardmp3(){
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      if (SJLocalProvider.instance.sj_sound_music){
        await SJMP3Player().pauseBackground();
        await SJMP3Player().playEffect3();
      }
      Future.delayed(Duration(milliseconds: 1300), () async {
        await SJMP3Player().pauseEffect3();
        if (SJLocalProvider.instance.sj_bg_music){
          await SJMP3Player().playBackground();
        }
      });
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    _scaleController.dispose();
    _scaleController2.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 0.width(context),
      height: 0.height(context),
      child: Stack(
        children: [
          // ✅ 顶部加放大缩小动画
          Positioned(
            top: 240.h,
            left: (0.width(context) - 267) * 0.5,
            width: 267,
            height: 63,
            child: spine.SpineWidget.fromAsset('assets/spine/youwin.atlas', 'assets/spine/youwin.json', _controller0),
          ),
          // 其余完全不变 ↓
          Positioned(top: 147.h, child: ScaleTransition(scale: _scaleAnimation2,child: SJImg(name: 'sj_dice_conten_1', width: 0.width(context), height: 441.h))),
          Positioned(
            top: 310.h,
            left: (MediaQuery.of(context).size.width - 222) * 0.5,
            child: RotationTransition(
              turns: _controller,
              child: SJImg(name: 'sj_dice_conten_2', width: 222, height: 222),
            ),
          ),
          Positioned(top: 320.h, left: (0.width(context) - 165) * 0.5, child: SJImg(name: 'sj_dolas_big_1', width: 165, height: 165)),
          Positioned(top: 438.h, width: 0.width(context), height:30,child: SJGradientStrokeText(text: '\$${widget.award}', gradientColors: ['#FFFFFF'.color(),'#FFFB8E'.color()], fontSize: 40, strokeWidth: 2, strokeColor: '#3F1D05'.color(), width: 260, height: 42,)),
          Positioned(top: 560.h,left: (0.width(context) - 260) * 0.5, child: Visibility(
            visible: !widget.is_show,
            child: InkWell(
                onTap: (){
                  sj_event_fire('coin_pop_c', {'source_from' : widget.type});
                  SJAdManager().sj_showAd(false, 'scxji_carreward_rv', context, (hasCache){
                    if (!mounted)return;
                    Navigator.pop(context, 0);
                  }, (finished) async {
                    SJLocalProvider.instance.updateint(SJLocalProvider.instance.sj_dolas_numberName, SJLocalProvider.instance.sj_dolas_number + (widget.award * 2));
                    Navigator.pop(context, 1);
                    playAwardmp3();
                    poptxTaskContent();
                  });
                },
                child: Container(
                  width: 260, height: 74,
                  decoration: BoxDecoration(image: SJDImg('sj_dice_btn_bg')),
                  child: Stack(
                    children: [
                      Positioned(top: 18,child: SJGradientStrokeText(text: 'Claim \$${widget.award * 2}', gradientColors: ['#BE982A'.color(),'#FFE9A3'.color(),'#FFF6D7'.color(),'#FFF0B4'.color(),], fontSize: 32, strokeWidth: 2, strokeColor: '#000000'.color(),width: 260, height: 40,),)
                    ],
                  ),
                )
            ),
          )),
          Positioned(
            top: 542.h,
            right: 60.w,
            child: Visibility(
              visible: !widget.is_show,
              child: InkWell(
                  onTap: (){
                    sj_event_fire('coin_pop_c', {'source_from' : widget.type});
                    // 看ad-重新刷新
                    SJAdManager().sj_showAd(false, 'scxji_carreward_rv', context, (hasCache){
                      if (!mounted)return;
                      Navigator.pop(context, 0);
                    }, (finished) async {
                      SJLocalProvider.instance.updateint(SJLocalProvider.instance.sj_dolas_numberName, SJLocalProvider.instance.sj_dolas_number + (widget.award * 2));
                      Navigator.pop(context, 0);
                      playAwardmp3();
                      poptxTaskContent();
                    });
                  },
                  child: SJImg(name: 'sj_rv_icon', width: 70, height: 70,)),
            ),
          ),
          Positioned(top: 560.h + 74,left: (0.width(context) - 260) * 0.5, child: Visibility(
            visible: !widget.is_show,
            child: InkWell(
              onTap: () async {
                sj_event_fire('coin_pop_cint', {'source_from' : widget.type});
                if (SJNumberHelpers().checkProbability()) {
                  // 看ad-重新刷新
                  SJAdManager().sj_showAd(true, 'scxji_carreward_int', context, (hasCache){
                    if (!mounted)return;
                    Navigator.pop(context, 0);
                  }, (finished) async {
                    SJLocalProvider.instance.updateint(SJLocalProvider.instance.sj_dolas_numberName, SJLocalProvider.instance.sj_dolas_number + (widget.award));
                    if (!mounted)return;
                    Navigator.pop(context, 0);
                    playAwardmp3();
                    poptxTaskContent();
                  });
                  
                } else {
                  SJLocalProvider.instance.updateint(SJLocalProvider.instance.sj_dolas_numberName, SJLocalProvider.instance.sj_dolas_number + (widget.award));
                  if (!mounted)return;
                  Navigator.pop(context, 0);
                  poptxTaskContent();
                }
              },
              child: SizedBox(width: 260, height:74,child: SJUnderlineTextButton(text: '\$${widget.award}', fontSize: 24.spMin, underlineColor: '#C5A213'.color(),gradientColors: ['#BE982A'.color(),'#FFE9A3'.color(),'#FFF6D7'.color(),'#FFF0B4'.color(),],)),
            ),
          )),
        ],
      ),
    );
  }

  // 运营逻辑添加
  Future<void> poptxTaskContent() async {
    if(SJLocalProvider.instance.sj_card_number == 3){
      navigatorKey.currentContext!.tipShow(SJPopSubmitAccountDialog());
    } else if (SJLocalProvider.instance.sj_card_number == 6){
      navigatorKey.currentContext!.tipShow(SJPopSubmitLastDialog());
    } else if (SJLocalProvider.instance.sj_dolas_number >= 800 && SJLocalProvider.instance.sj_dolas_800 == false){
      await SJLocalProvider.instance.updateBool(SJLocalProvider.instance.sj_dolas_800Name, true);
      navigatorKey.currentContext!.tipShow(SJPopTXDiceDialog());
    } else if (SJLocalProvider.instance.sj_dolas_number >= 1000 && SJLocalProvider.instance.sj_dolas_1000 == false){
      await SJLocalProvider.instance.updateBool(SJLocalProvider.instance.sj_dolas_1000Name, true);
      navigatorKey.currentContext!.tipShow(SJPopTXWallerDialog());
    }
  }
}

class SJPopSuperWinBDialog extends StatefulWidget {
  final bool is_show;
  final int award;
  final String type;
  SJPopSuperWinBDialog({super.key, required this.award, required this.is_show, required this.type});
  @override
  State<SJPopSuperWinBDialog> createState() => SJPopSuperWinBDialogState();
}

class SJPopSuperWinBDialogState extends State<SJPopSuperWinBDialog>
    with TickerProviderStateMixin {
  late final AnimationController _controller;
  late final AnimationController _scaleController;
  late final Animation<double> _scaleAnimation;
  late final AnimationController _scaleController2;
  late spine.SpineWidgetController _controller0;
  late spine.SpineWidgetController _controller1;

  @override
  void initState() {
    super.initState();
    sj_event_fire('coin_pop', {'source_from' : widget.type});

    _controller0 = spine.SpineWidgetController(onInitialized: (controller) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        controller.animationState.setAnimationByName(0, "animation", true);
      });
    });

    _controller1 = spine.SpineWidgetController(onInitialized: (controller) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        controller.animationState.setAnimationByName(0, "animation", true);
      });
    });

    // 匀速旋转动画
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 6),
    )..repeat();

    // 顶部图片放大缩小动画 ✅ 修复版
    _scaleController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    )..repeat(reverse: true);

    _scaleAnimation = Tween(begin: 1.0, end: 1.2)
        .animate(CurvedAnimation(parent: _scaleController, curve: Curves.easeInOut));

    _scaleController2 = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    )..repeat(reverse: true);

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      if (SJLocalProvider.instance.sj_sound_music){
        await SJMP3Player().pauseBackground();
        await SJMP3Player().playEffect4();
      }
      Future.delayed(Duration(milliseconds: 1000), () async {
        await SJMP3Player().pauseEffect4();
        if (SJLocalProvider.instance.sj_bg_music){
          await SJMP3Player().playBackground();
        }
      });
      Future.delayed(Duration(milliseconds: 1000), () async {
        if (widget.is_show && mounted){
          Navigator.pop(context);
          context.tipShow(SJPopEpicWinBDialog(award: widget.award, type: widget.type));
        }
      });
    });
  }

  void playAwardmp3(){
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      if (SJLocalProvider.instance.sj_sound_music){
        await SJMP3Player().pauseBackground();
        await SJMP3Player().playEffect3();
      }
      Future.delayed(Duration(milliseconds: 1300), () async {
        await SJMP3Player().pauseEffect3();
        if (SJLocalProvider.instance.sj_bg_music){
          await SJMP3Player().playBackground();
        }
      });
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    _scaleController.dispose();
    _scaleController2.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 0.width(context),
      height: 0.height(context),
      child: Stack(
        children: [
          // 其余完全不变 ↓
          Positioned(top: 147.h, child: SJImg(name: 'sj_superwin_1', width: 0.width(context), height: 441.h)),
          Positioned(
            top: 210.h,
            left: (0.width(context) - 362) * 0.5,
            width: 362,
            height: 149,
            child: spine.SpineWidget.fromAsset('assets/spine/superwin.atlas', 'assets/spine/superwin.json', _controller0),
          ),
          Positioned(
            top: 310.h,
            left: (MediaQuery.of(context).size.width - 222) * 0.5,
            width: 222, height: 222,
            child: RotationTransition(
              turns: _controller,
              child: SJImg(name: 'sj_dice_conten_2', width: 222, height: 222),
            ),
          ),
          Positioned(top: 320.h, left: (0.width(context) - 190) * 0.5, child: SJImg(name: 'sj_dolas_big_2', width: 190, height: 190)),
          Positioned(top: 465.h, width: 0.width(context), height:30,child: SJGradientStrokeText(text: '\$${widget.award}', gradientColors: ['#FFFFFF'.color(),'#FFFB8E'.color()], fontSize: 40, strokeWidth: 2, strokeColor: '#3F1D05'.color(), width: 260, height: 42,)),
          Positioned(top: 560.h,left: (0.width(context) - 260) * 0.5, child: Visibility(
            visible: !widget.is_show,
            child: InkWell(
                onTap: (){
                  sj_event_fire('coin_pop_c', {'source_from' : widget.type});
                  SJAdManager().sj_showAd(false, 'scxji_carreward_rv', context, (hasCache){
                    if (!mounted)return;
                    Navigator.pop(context, 0);
                  }, (finished) async {
                    SJLocalProvider.instance.updateint(SJLocalProvider.instance.sj_dolas_numberName, SJLocalProvider.instance.sj_dolas_number + (widget.award * 2));
                    if (!mounted)return;
                    Navigator.pop(context, 0);
                    playAwardmp3();
                    poptxTaskContent();
                  });
                },
                child: Container(
                  width: 260, height: 74,
                  decoration: BoxDecoration(image: SJDImg('sj_dice_btn_bg')),
                  child: Stack(
                    children: [
                      Positioned(top: 18,child: SJGradientStrokeText(text: 'Claim \$${widget.award * 2}', gradientColors: ['#BE982A'.color(),'#FFE9A3'.color(),'#FFF6D7'.color(),'#FFF0B4'.color(),], fontSize: 32, strokeWidth: 2, strokeColor: '#000000'.color(),width: 260, height: 40,),)
                    ],
                  ),
                )
            ),
          )),
          Positioned(
            top: 542.h,
            right: 60.w,
            child: Visibility(
              visible: !widget.is_show,
              child: InkWell(
                  onTap: (){
                    sj_event_fire('coin_pop_c', {'source_from' : widget.type});
                    // 看ad-重新刷新
                    SJAdManager().sj_showAd(false, 'scxji_carreward_rv', context, (hasCache){
                      if (!mounted)return;
                      Navigator.pop(context, 0);
                    }, (finished) async {
                      SJLocalProvider.instance.updateint(SJLocalProvider.instance.sj_dolas_numberName, SJLocalProvider.instance.sj_dolas_number + (widget.award * 2));
                      if (!mounted)return;
                      Navigator.pop(context, 0);
                      playAwardmp3();
                      poptxTaskContent();
                    });
                  },
                  child: SJImg(name: 'sj_rv_icon', width: 70, height: 70,)),
            ),
          ),
          Positioned(top: 560.h + 74,left: (0.width(context) - 260) * 0.5, child: Visibility(
            visible: !widget.is_show,
            child: InkWell(
              onTap: () async {
                sj_event_fire('coin_pop_cint', {'source_from' : widget.type});
                if (SJNumberHelpers().checkProbability()) {
                  // 看ad-重新刷新
                  SJAdManager().sj_showAd(true, 'scxji_carreward_int', context, (hasCache){
                    Navigator.pop(context, 0);
                  }, (finished) async {
                    SJLocalProvider.instance.updateint(SJLocalProvider.instance.sj_dolas_numberName, SJLocalProvider.instance.sj_dolas_number + (widget.award));
                    if (!mounted)return;
                    Navigator.pop(context, 0);
                    playAwardmp3();
                    poptxTaskContent();
                  });

                } else {
                  SJLocalProvider.instance.updateint(SJLocalProvider.instance.sj_dolas_numberName, SJLocalProvider.instance.sj_dolas_number + (widget.award));
                  if (!mounted)return;
                  Navigator.pop(context, 0);
                  poptxTaskContent();
                }
              },
              child: SizedBox(width: 260, height:74,child: SJUnderlineTextButton(text: '\$${widget.award}', fontSize: 24.spMin, underlineColor: '#C5A213'.color(),gradientColors: ['#BE982A'.color(),'#FFE9A3'.color(),'#FFF6D7'.color(),'#FFF0B4'.color(),],)),
            ),
          )),
        ],
      ),
    );
  }

  // 运营逻辑添加
  Future<void> poptxTaskContent() async {
    if(SJLocalProvider.instance.sj_card_number == 3){
      navigatorKey.currentContext!.tipShow(SJPopSubmitAccountDialog());
    } else if (SJLocalProvider.instance.sj_card_number == 6){
      navigatorKey.currentContext!.tipShow(SJPopSubmitLastDialog());
    } else if (SJLocalProvider.instance.sj_dolas_number >= 800 && SJLocalProvider.instance.sj_dolas_800 == false){
      await SJLocalProvider.instance.updateBool(SJLocalProvider.instance.sj_dolas_800Name, true);
      navigatorKey.currentContext!.tipShow(SJPopTXDiceDialog());
    } else if (SJLocalProvider.instance.sj_dolas_number >= 1000 && SJLocalProvider.instance.sj_dolas_1000 == false){
      await SJLocalProvider.instance.updateBool(SJLocalProvider.instance.sj_dolas_1000Name, true);
      navigatorKey.currentContext!.tipShow(SJPopTXWallerDialog());
    }
  }
}

class SJPopEpicWinBDialog extends StatefulWidget {
  final int award;
  final String type;
  SJPopEpicWinBDialog({super.key, required this.award, required this.type});
  @override
  State<SJPopEpicWinBDialog> createState() => SJPopEpicWinBDialogState();
}

class SJPopEpicWinBDialogState extends State<SJPopEpicWinBDialog>
    with TickerProviderStateMixin {
  late final AnimationController _controller;
  late final AnimationController _scaleController;
  late final Animation<double> _scaleAnimation;
  late final AnimationController _scaleController2;
  late spine.SpineWidgetController _controller0;
  late spine.SpineWidgetController _controller1;

  @override
  void initState() {
    super.initState();
    sj_event_fire('coin_pop', {'source_from' : widget.type});

    _controller0 = spine.SpineWidgetController(onInitialized: (controller) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        controller.animationState.setAnimationByName(0, "animation", true);
      });
    });

    _controller1 = spine.SpineWidgetController(onInitialized: (controller) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        controller.animationState.setAnimationByName(0, "animation", true);
      });
    });

    // 匀速旋转动画
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 6),
    )..repeat();

    // 顶部图片放大缩小动画 ✅ 修复版
    _scaleController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    )..repeat(reverse: true);

    _scaleAnimation = Tween(begin: 1.0, end: 1.2)
        .animate(CurvedAnimation(parent: _scaleController, curve: Curves.easeInOut));

    _scaleController2 = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    )..repeat(reverse: true);


    WidgetsBinding.instance.addPostFrameCallback((_) async {
      if (SJLocalProvider.instance.sj_sound_music){
        await SJMP3Player().pauseBackground();
        await SJMP3Player().playEffect4();
      }
      Future.delayed(Duration(milliseconds: 1000), () async {
        await SJMP3Player().pauseEffect4();
        if (SJLocalProvider.instance.sj_bg_music){
          await SJMP3Player().playBackground();
        }
      });
    });
  }

  void playAwardmp3(){
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      if (SJLocalProvider.instance.sj_sound_music){
        await SJMP3Player().pauseBackground();
        await SJMP3Player().playEffect3();
      }
      Future.delayed(Duration(milliseconds: 1300), () async {
        await SJMP3Player().pauseEffect3();
        if (SJLocalProvider.instance.sj_bg_music){
          await SJMP3Player().playBackground();
        }
      });
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    _scaleController.dispose();
    _scaleController2.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 0.width(context),
      height: 0.height(context),
      child: Stack(
        children: [
          // 其余完全不变 ↓
          Positioned(top: 147.h, child: SJImg(name: 'sj_epic_bg', width: 0.width(context), height: 441.h)),
          Positioned(
            top: 170.h,
            left: (0.width(context) - 365) * 0.5,
            width: 365,
            height: 174,
            child: spine.SpineWidget.fromAsset('assets/spine/epicwin.atlas', 'assets/spine/epicwin.json', _controller0),
          ),
          Positioned(
            top: 278.h,
            left: (MediaQuery.of(context).size.width - 300) * 0.5,
            width: 300, height: 300,
            child: spine.SpineWidget.fromAsset('assets/spine/epiclight.atlas', 'assets/spine/epiclight.json', _controller1),
          ),
          Positioned(top: 320.h, left: (0.width(context) - 259) * 0.5, child: SJImg(name: 'sj_dolas_big_3', width: 259, height: 192)),
          Positioned(top: 485.h, width: 0.width(context), height: 30, child: SJGradientStrokeText(text: '\$${widget.award}', gradientColors: ['#FFFFFF'.color(),'#FFFB8E'.color()], fontSize: 40, strokeWidth: 2, strokeColor: '#3F1D05'.color(), width: 260, height: 42,)),
          Positioned(top: 572.h,left: (0.width(context) - 260) * 0.5, child: InkWell(
              onTap: (){
                sj_event_fire('coin_pop_c', {'source_from' : widget.type});
                SJAdManager().sj_showAd(false, widget.type == 'dice' ? 'scxji_dicereward_rv' : 'scxji_carreward_rv', context, (hasCache){
                  if (!mounted)return;
                  Navigator.pop(context, 0);
                }, (finished) async {
                  SJLocalProvider.instance.updateint(SJLocalProvider.instance.sj_dolas_numberName, SJLocalProvider.instance.sj_dolas_number + (widget.award * 2));
                  if (!mounted)return;
                  Navigator.pop(context, 0);
                  playAwardmp3();
                  poptxTaskContent();
                });
              },
              child: Container(
                width: 260, height: 74,
                decoration: BoxDecoration(image: SJDImg('sj_dice_btn_bg')),
                child: Stack(
                  children: [
                    Positioned(top: 18,child: SJGradientStrokeText(text: 'Claim \$${widget.award * 2}', gradientColors: ['#BE982A'.color(),'#FFE9A3'.color(),'#FFF6D7'.color(),'#FFF0B4'.color(),], fontSize: 32, strokeWidth: 2, strokeColor: '#000000'.color(),width: 260, height: 40,),)
                  ],
                ),
              )
          )),
          Positioned(
            top: 556.h,
            right: 60.w,
            child: InkWell(
                onTap: (){
                  sj_event_fire('coin_pop_c', {'source_from' : widget.type});
                  // 看ad-重新刷新
                  SJAdManager().sj_showAd(false, widget.type == 'dice' ? 'scxji_dicereward_rv' : 'scxji_carreward_rv', context, (hasCache){
                    if (!mounted)return;
                    Navigator.pop(context, 0);
                  }, (finished) async {
                    SJLocalProvider.instance.updateint(SJLocalProvider.instance.sj_dolas_numberName, SJLocalProvider.instance.sj_dolas_number + (widget.award * 2));
                    if (!mounted)return;
                    Navigator.pop(context, 0);
                    playAwardmp3();
                    poptxTaskContent();
                  });
                },
                child: SJImg(name: 'sj_rv_icon', width: 70, height: 70,)),
          ),
          Positioned(top: 572.h + 74,left: (0.width(context) - 260) * 0.5, child: InkWell(
            onTap: () async {
              sj_event_fire('coin_pop_cint', {'source_from' : widget.type});
              if (SJNumberHelpers().checkProbability()) {
                // 看ad-重新刷新
                SJAdManager().sj_showAd(true, widget.type == 'dice' ? 'scxji_dicereward_int' : 'scxji_carreward_int', context, (hasCache){
                  if (!mounted)return;
                  Navigator.pop(context, 0);
                }, (finished) async {
                  SJLocalProvider.instance.updateint(SJLocalProvider.instance.sj_dolas_numberName, SJLocalProvider.instance.sj_dolas_number + (widget.award));
                  if (!mounted)return;
                  Navigator.pop(context, 0);
                  playAwardmp3();
                  poptxTaskContent();
                });

              } else {
                SJLocalProvider.instance.updateint(SJLocalProvider.instance.sj_dolas_numberName, SJLocalProvider.instance.sj_dolas_number + (widget.award));
                if (!mounted)return;
                Navigator.pop(context, 0);
                poptxTaskContent();
              }
            },
            child: SizedBox(width: 260, height:74,child: SJUnderlineTextButton(text: '\$${widget.award}', fontSize: 24.spMin, underlineColor: '#C5A213'.color(),gradientColors: ['#BE982A'.color(),'#FFE9A3'.color(),'#FFF6D7'.color(),'#FFF0B4'.color(),],)),
          )),
        ],
      ),
    );
  }

  // 运营逻辑添加
  Future<void> poptxTaskContent() async {
    if(SJLocalProvider.instance.sj_card_number == 3){
      navigatorKey.currentContext!.tipShow(SJPopSubmitAccountDialog());
    } else if (SJLocalProvider.instance.sj_card_number == 6){
      navigatorKey.currentContext!.tipShow(SJPopSubmitLastDialog());
    } else if (SJLocalProvider.instance.sj_dolas_number >= 800 && SJLocalProvider.instance.sj_dolas_800 == false){
      await SJLocalProvider.instance.updateBool(SJLocalProvider.instance.sj_dolas_800Name, true);
      navigatorKey.currentContext!.tipShow(SJPopTXDiceDialog());
    } else if (SJLocalProvider.instance.sj_dolas_number >= 1000 && SJLocalProvider.instance.sj_dolas_1000 == false){
      await SJLocalProvider.instance.updateBool(SJLocalProvider.instance.sj_dolas_1000Name, true);
      navigatorKey.currentContext!.tipShow(SJPopTXWallerDialog());
    }
  }
}
// 广告上线
class SJPopAdLimitDialog extends StatefulWidget {
  SJPopAdLimitDialog({super.key});
  @override
  State<SJPopAdLimitDialog> createState() => SJPopAdLimitDialogState();
}

class SJPopAdLimitDialogState extends State<SJPopAdLimitDialog> {

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 0.width(context),
      height: 0.height(context),
      child: Stack(
        alignment: Alignment.center,
        children: [
          Container(
            width: 263.w,
            height: 370.h,
            decoration: BoxDecoration(
                image: SJDImg('sj_pop_bg_1')
            ),
            child: Column(
              children: [
                SizedBox(height: 20.h,),
                SJStrokeText(text: 'Ad Limit Reached', size: 22, color: '#FFFEE8'.color(), weight: FontWeight.w400, skWidth: 1, skColor: '#000000'.color()),
                SizedBox(height: 28.0.h,),
                Container(
                  width: 193.w,
                  height: 130.h,
                  decoration: BoxDecoration(
                    image: SJDImg('sj_pop_center_1')
                  ),
                  child: Center(
                    child: SJImg(name: 'sj_pop_rv_big', width: 107.w, height: 107.w,),
                  ),
                ),
                SizedBox(height: 30.h,),
                SizedBox(
                  width: 209.w,
                  height: 34.h,
                  child: SJText(text: 'You’ve watched all available ads for today. Try again tomorrow', size: 14.sp, color: '#F4D896'.color(), weight: FontWeight.w400, maxLines: 2, align: TextAlign.center),
                ),
                SizedBox(height: 21.h,),
                Container(
                  width: 197.w,
                  height: 56.h,
                  decoration: BoxDecoration(
                      image: SJDImg('sj_ok_btn')
                  ),
                  child: InkWell(
                    onTap: (){
                      Navigator.pop(context);
                    },
                  ),
                ),
              ],
            ),
          ),
          Positioned(
            right: 48.w,
            top: (0.height(context) - 370.h) * 0.48,
            width: 45,
            height: 48,
            child: InkWell(onTap: (){
              Navigator.pop(context);
            }, child: SJImg(name: 'sj_close_btn')),
          ),
        ],
      ),
    );
  }

}
// 广告无网络
class SJPopAdNotWiFiDialog extends StatefulWidget {
  SJPopAdNotWiFiDialog({super.key});
  @override
  State<SJPopAdNotWiFiDialog> createState() => SJPopAdNotWiFiDialogState();
}

class SJPopAdNotWiFiDialogState extends State<SJPopAdNotWiFiDialog> {

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    sj_event_fire('network_no', {});
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 0.width(context),
      height: 0.height(context),
      child: Stack(
        alignment: Alignment.center,
        children: [
          Container(
            width: 263.w,
            height: 370.h,
            decoration: BoxDecoration(
                image: SJDImg('sj_pop_bg_1')
            ),
            child: Column(
              children: [
                SizedBox(height: 20.h,),
                SJStrokeText(text: 'No Network', size: 22, color: '#FFFEE8'.color(), weight: FontWeight.w400, skWidth: 1, skColor: '#000000'.color()),
                SizedBox(height: 28.0.h,),
                Container(
                  width: 193.w,
                  height: 130.h,
                  decoration: BoxDecoration(
                      image: SJDImg('sj_pop_center_1')
                  ),
                  child: Center(
                    child: SJImg(name: 'sj_wifi_icon', width: 107.w, height: 107.w,),
                  ),
                ),
                SizedBox(height: 30.h,),
                SizedBox(
                  width: 209.w,
                  height: 34.h,
                  child: SJText(text: 'Large rewards were interrupted', size: 14.sp, color: '#F4D896'.color(), weight: FontWeight.w400, maxLines: 1, align: TextAlign.center),
                ),
                SizedBox(height: 21.h,),
                Container(
                  width: 197.w,
                  height: 56.h,
                  decoration: BoxDecoration(
                      image: SJDImg('sj_try_btn')
                  ),
                  child: InkWell(
                    onTap: (){
                      sj_event_fire('network_no_c', {});
                      Navigator.pop(context);
                    },
                  ),
                ),
              ],
            ),
          ),
          Positioned(
            right: 48.w,
            top: (0.height(context) - 370.h) * 0.48,
            width: 45,
            height: 48,
            child: InkWell(onTap: (){
              Navigator.pop(context);
            }, child: SJImg(name: 'sj_close_btn')),
          ),
        ],
      ),
    );
  }

}
// 广告加载失败
class SJPopAdLoadFailDialog extends StatefulWidget {
  SJPopAdLoadFailDialog({super.key});
  @override
  State<SJPopAdLoadFailDialog> createState() => SJPopAdLoadFailDialogState();
}

class SJPopAdLoadFailDialogState extends State<SJPopAdLoadFailDialog> {

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    sj_event_fire('ad_retry', {});
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 0.width(context),
      height: 0.height(context),
      child: Stack(
        alignment: Alignment.center,
        children: [
          Container(
            width: 263.w,
            height: 370.h,
            decoration: BoxDecoration(
                image: SJDImg('sj_pop_bg_1')
            ),
            child: Column(
              children: [
                SizedBox(height: 20.h,),
                SJStrokeText(text: 'Quick Break - Back Soon!', size: 22, color: '#FFFEE8'.color(), weight: FontWeight.w400, skWidth: 1, skColor: '#000000'.color()),
                SizedBox(height: 28.0.h,),
                Container(
                  width: 193.w,
                  height: 130.h,
                  decoration: BoxDecoration(
                      image: SJDImg('sj_pop_center_1')
                  ),
                  child: Center(
                    child: SJImg(name: 'sj_rvfaid_icon', width: 89.w, height: 103.h,),
                  ),
                ),
                SizedBox(height: 30.h,),
                SizedBox(
                  width: 209.w,
                  height: 34.h,
                  child: SJText(text: 'More Cash Coming!', size: 20.sp, color: '#F4D896'.color(), weight: FontWeight.w400, maxLines: 1, align: TextAlign.center),
                ),
                SizedBox(height: 21.h,),
                Container(
                  width: 197.w,
                  height: 56.h,
                  decoration: BoxDecoration(
                      image: SJDImg('sj_try_btn')
                  ),
                  child: InkWell(
                    onTap: (){
                      Navigator.pop(context);
                      sj_event_fire('ad_retry_c', {});
                      SJAdManager().initIntAdDatasource();
                    },
                  ),
                ),
              ],
            ),
          ),
          Positioned(
            right: 48.w,
            top: (0.height(context) - 370.h) * 0.48,
            width: 45,
            height: 48,
            child: InkWell(onTap: (){
              Navigator.pop(context);
            }, child: SJImg(name: 'sj_close_btn')),
          ),
        ],
      ),
    );
  }

}

// 通知二次弹框
class SJPopNoticeDialog extends StatefulWidget {
  SJPopNoticeDialog({super.key});
  @override
  State<SJPopNoticeDialog> createState() => SJPopNoticeDialogState();
}

class SJPopNoticeDialogState extends State<SJPopNoticeDialog> {
  
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    sj_event_fire('noti_confirm_pop', {});
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 0.width(context),
      height: 0.height(context),
      child: Stack(
        alignment: Alignment.center,
        children: [
          Container(
            width: 263.w,
            height: 370.h,
            decoration: BoxDecoration(
                image: SJDImg('sj_pop_bg_1')
            ),
            child: Column(
              children: [
                SizedBox(height: 20.h,),
                SJStrokeText(text: 'Turn On Push Notifications', size: 22, color: '#FFFEE8'.color(), weight: FontWeight.w400, skWidth: 1, skColor: '#000000'.color()),
                SizedBox(height: 28.0.h,),
                Container(
                  width: 193.w,
                  height: 130.h,
                  decoration: BoxDecoration(
                      image: SJDImg('sj_pop_center_1')
                  ),
                  child: Center(
                    child: SJImg(name: 'sj_notoce_icon', width: 132.w, height: 119.h,),
                  ),
                ),
                SizedBox(height: 8.h,),
                SizedBox(
                  width: 209.w,
                  height: 34.h,
                  child: SJText(text: 'Your next big win could be one tap away!', size: 14.sp, color: '#F4D896'.color(), weight: FontWeight.w400, maxLines: 2, align: TextAlign.center),
                ),
                SizedBox(height: 12.h,),
                Container(
                  width: 197.w,
                  height: 56.h,
                  decoration: BoxDecoration(
                      image: SJDImg('sj_alls_btn')
                  ),
                  child: InkWell(
                    onTap: () async {
                      sj_event_fire('noti_confirm_pop_allow', {});
                      Navigator.pop(context, 1);
                      AppSettings.openAppSettings(
                        type: AppSettingsType.notification,
                      );
                      sj_event_fire('noti_confirm_pop_suc', {});
                      SJLocalProvider.instance.updateint(SJLocalProvider.instance.sj_dolas_numberName, SJLocalProvider.instance.sj_dolas_number + 10);
                    },
                  ),
                ),
                SizedBox(
                  width: 197.w,
                  height: 40.h,
                  child: InkWell(
                    onTap: () async {
                      sj_event_fire('noti_confirm_pop_skip', {});
                      Navigator.pop(context, 0);
                    },
                    child: SizedBox(width: 260, height:74,child: SJUnderlineTextButton(text: 'Not Now', fontSize: 20.spMin, underlineColor: '#C5A213'.color(),gradientColors: ['#BE982A'.color(),'#FFE9A3'.color(),'#FFF6D7'.color(),'#FFF0B4'.color(),],)),
                  ),
                ),
              ],
            ),
          ),
          Positioned(
            right: 48.w,
            top: (0.height(context) - 370.h) * 0.48,
            width: 45,
            height: 48,
            child: InkWell(onTap: (){
              Navigator.pop(context);
            }, child: SJImg(name: 'sj_close_btn')),
          ),
        ],
      ),
    );
  }

}

// 未中奖
class SJPopNotAwardDialog extends StatefulWidget {
  SJPopNotAwardDialog({super.key});
  @override
  State<SJPopNotAwardDialog> createState() => SJPopNotAwardDialogState();
}

class SJPopNotAwardDialogState extends State<SJPopNotAwardDialog> {

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 0.width(context),
      height: 0.height(context),
      child: Stack(
        alignment: Alignment.center,
        children: [
          Container(
            width: 255.w,
            height: 310.h,
            decoration: BoxDecoration(
                image: SJDImg('sj_pop_bg_2')
            ),
            child: Column(
              children: [
                SizedBox(height: 20.h,),
                SJStrokeText(text: 'A Large Bonus Was Missed', size: 22, color: '#FFFEE8'.color(), weight: FontWeight.w400, skWidth: 1, skColor: '#000000'.color()),
                SizedBox(height: 29.0.h,),
                Container(
                  width: 193.w,
                  height: 130.h,
                  decoration: BoxDecoration(
                      image: SJDImg('sj_pop_center_1')
                  ),
                  child: Center(
                    child: SJImg(name: 'sj_faild_icon', width: 118.w, height: 118.h,),
                  ),
                ),
                SizedBox(height: 26.h,),
                Container(
                  width: 197.w,
                  height: 56.h,
                  decoration: BoxDecoration(
                      image: SJDImg('sj_try_btn')
                  ),
                  child: InkWell(
                    onTap: (){
                      Navigator.pop(context);
                    },
                  ),
                ),
              ],
            ),
          ),
          Positioned(
            right: 48.w,
            top: (0.height(context) - 310.h) * 0.47,
            width: 45,
            height: 48,
            child: InkWell(onTap: (){
              Navigator.pop(context);
            }, child: SJImg(name: 'sj_close_btn')),
          ),
        ],
      ),
    );
  }

}
// 新增任务3
class SJPopTask3Dialog extends StatefulWidget {
  SJPopTask3Dialog({super.key});
  @override
  State<SJPopTask3Dialog> createState() => SJPopTask3DialogState();
}

class SJPopTask3DialogState extends State<SJPopTask3Dialog> {

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    sj_event_fire('cash_task_s', {});
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 0.width(context),
      height: 0.height(context),
      child: Stack(
        alignment: Alignment.center,
        children: [
          Container(
            width: 329.w,
            height: 398.h,
            decoration: BoxDecoration(
                image:(SJLocalProvider.instance.sj_tx_box_index >= SJNumberHelpers().taskModel!.task.first.first.num && SJLocalProvider.instance.sj_tx_card_index >= SJNumberHelpers().taskModel!.task.first.last.num) ? SJDImg('sj_task_4_bg') : SJDImg('sj_task_3_bg')
            ),
            child: Column(
              children: [
                SizedBox(height: 29.h,),
                SJText(text:(SJLocalProvider.instance.sj_tx_box_index >= SJNumberHelpers().taskModel!.task.first.first.num && SJLocalProvider.instance.sj_tx_card_index >= SJNumberHelpers().taskModel!.task.first.last.num) ? 'Human Verfication' : 'Compliance Check', size: 24, color: '#FFFFFF'.color(), weight: FontWeight.w400),
                SizedBox(height: 89.0.h,),
                SizedBox(
                  width: 278.w,
                  height: 88.h,
                  child: Center(child: SJText(text:(SJLocalProvider.instance.sj_tx_box_index >= SJNumberHelpers().taskModel!.task.first.first.num && SJLocalProvider.instance.sj_tx_card_index >= SJNumberHelpers().taskModel!.task.first.last.num) ? 'Please complete human verfication before withdrawing' :  'Your withdrawal is pending compliance review. Complete the required steps to validate your accountand release funds.', size: 18, color: '#000000'.color(), weight: FontWeight.w400, maxLines: 4, align: TextAlign.center)),
                ),
                SizedBox(height: 27.h,),
                Container(
                  width: 313.w,
                  height: 43.h,
                  decoration: BoxDecoration(
                      image: SJDImg('sj_account_center_bg')
                  ),
                  child: Row(
                    children: [
                      SizedBox(width: 13.w,),
                      SJText(text: _getTxTaskString().first, size: 20, color: '#FFFFFF'.color(), weight: FontWeight.w400),
                      Spacer(),
                      SJImg(name: _getTxTaskStatus().first ? 'sj_seletecd_s' : 'sj_seletecd_n', width: 29.w, height: 29.w,),
                      SizedBox(width: 9.w,),
                    ],
                  ),
                ),
                SizedBox(height: 8.h,),
                Container(
                  width: 313.w,
                  height: 43.h,
                  decoration: BoxDecoration(
                      image: SJDImg('sj_account_center_bg')
                  ),
                  child: Row(
                    children: [
                      SizedBox(width: 13.w,),
                      SJText(text: _getTxTaskString().last, size: 20, color: '#FFFFFF'.color(), weight: FontWeight.w400),
                      Spacer(),
                      SJImg(name: _getTxTaskStatus().last ? 'sj_seletecd_s' : 'sj_seletecd_n', width: 29.w, height: 29.w,),
                      SizedBox(width: 9.w,),
                    ],
                  ),
                )
              ],
            ),
          ),
          Positioned(
            right: 32.w,
            top: (0.height(context) - 398.h) * 0.35,
            width: 45,
            height: 48,
            child: InkWell(onTap: (){
              Navigator.pop(context);
            }, child: SJImg(name: 'sj_close_btn')),
          ),
        ],
      ),
    );
  }

  List<String> _getTxTaskString(){
    String text1 = '';
    String text2 = '';
    if (SJLocalProvider.instance.sj_tx_box_index < SJNumberHelpers().taskModel!.task.first.first.num || SJLocalProvider.instance.sj_tx_card_index < SJNumberHelpers().taskModel!.task.first.last.num) {
      text2 =
      'Scratch ${SJLocalProvider.instance.sj_tx_card_index}/${SJNumberHelpers()
          .taskModel!
          .task.first.last.num} treasure chests';
      text1 =
      'Open ${SJLocalProvider.instance.sj_tx_box_index}/${SJNumberHelpers()
          .taskModel!
          .task.first.first.num} Dice';
    } else if (SJLocalProvider.instance.sj_tx_dice_index < SJNumberHelpers().taskModel!.task.last.first.num || SJLocalProvider.instance.sj_tx_probability_index < SJNumberHelpers().taskModel!.task.last.last.num) {
      text2 =
      'Draw ${SJLocalProvider.instance.sj_tx_probability_index}/${SJNumberHelpers()
          .taskModel!
          .task.last.last.num} probability cards';
      text1 =
      'Play ${SJLocalProvider.instance.sj_tx_dice_index}/${SJNumberHelpers()
          .taskModel!
          .task.last.first.num} Dice';
    }
    return [text1, text2];
  }

  List<bool> _getTxTaskStatus(){
    bool text1 = false;
    bool text2 = false;
    if (SJLocalProvider.instance.sj_tx_box_index < SJNumberHelpers().taskModel!.task.first.first.num || SJLocalProvider.instance.sj_tx_card_index < SJNumberHelpers().taskModel!.task.first.last.num) {
      if (SJLocalProvider.instance.sj_tx_box_index < SJNumberHelpers().taskModel!.task.first.first.num) {
        text1 = false;
      } else {
        text1 = true;
      }
      if (SJLocalProvider.instance.sj_tx_card_index < SJNumberHelpers().taskModel!.task.first.last.num) {
        text2 = false;
      } else {
        text2 = true;
      }
    } else if (SJLocalProvider.instance.sj_tx_dice_index < SJNumberHelpers().taskModel!.task.last.first.num || SJLocalProvider.instance.sj_tx_probability_index < SJNumberHelpers().taskModel!.task.last.last.num) {
      if (SJLocalProvider.instance.sj_tx_dice_index < SJNumberHelpers().taskModel!.task.last.first.num) {
        text1 = false;
      } else {
        text1 = true;
      }
      if (SJLocalProvider.instance.sj_tx_probability_index < SJNumberHelpers().taskModel!.task.last.last.num) {
        text2 = false;
      } else {
        text2 = true;
      }
    }
    return [text1, text2];
  }

}
// 概率提醒
class SJPopRatioDialog extends StatefulWidget {
  SJPopRatioDialog({super.key});
  @override
  State<SJPopRatioDialog> createState() => SJPopRatioDialogState();
}

class SJPopRatioDialogState extends State<SJPopRatioDialog> {
 @override
  void initState() {
    // TODO: implement initState
    super.initState();
    sj_event_fire('probability_tips_pop', {});
  }
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 0.width(context),
      height: 0.height(context),
      child: Stack(
        alignment: Alignment.center,
        children: [
          Container(
            width: 255.w,
            height: 383.h,
            decoration: BoxDecoration(
                image: SJDImg('sj_pop_bg_1')
            ),
            child: Column(
              children: [
                SizedBox(height: 26.h,),
                SJStrokeText(text: 'This is the PERFECT time to spin!', size: 14.spMax, color: '#FFFEE8'.color(), weight: FontWeight.w400, skWidth: 1, skColor: '#000000'.color()),
                SizedBox(height: 28.0.h,),
                Container(
                  width: 193.w,
                  height: 130.h,
                  decoration: BoxDecoration(
                      image: SJDImg('sj_pop_center_1')
                  ),
                  child: Column(
                    children: [
                      SizedBox(height: 14.h,),
                      SJText(text: 'Boost Lottery Odds.', size: 18, color: '#F4FF1F'.color(), weight: FontWeight.w400),
                      SizedBox(height: 6.h,),
                      SJImg(name: 'sj_dolas_big_4', width: 109.w, height: 87.h,)
                    ],
                  ),
                ),
                SizedBox(height: 12.h,),
                SizedBox(
                  width: 213.w,
                  height: 51.h,
                  child: SJText(text: "Don't let this hot streak cool off! Tap below and see what epicness awaits...", size: 14.sp, color: '#F4D896'.color(), weight: FontWeight.w400, maxLines: 3, align: TextAlign.center),
                ),
                SizedBox(height: 10.h,),
                Container(
                  width: 197.w,
                  height: 56.h,
                  decoration: BoxDecoration(
                      image: SJDImg('sj_boost_btn')
                  ),
                  child: InkWell(
                    onTap: (){
                      sj_event_fire('probability_tips_pop_c', {});
                      Navigator.pop(context, 1);
                      context.tipShow(CardShuffleAnimation(is_start: false, souce_fromat: 'card',));
                    },
                  ),
                ),
                SizedBox(
                  width: 197.w,
                  height: 40.h,
                  child: InkWell(
                    onTap: () async {
                      sj_event_fire('probability_tips_pop_close', {});
                      Navigator.pop(context, 0);
                    },
                    child: SizedBox(width: 260, height:74,child: SJUnderlineTextButton(text: 'Next Time', fontSize: 20.spMin, underlineColor: '#C5A213'.color(),gradientColors: ['#BE982A'.color(),'#FFE9A3'.color(),'#FFF6D7'.color(),'#FFF0B4'.color(),],)),
                  ),
                ),
              ],
            ),
          ),
          Positioned(
            right: 48.w,
            top: (0.height(context) - 383.h) * 0.48,
            width: 45,
            height: 48,
            child: InkWell(onTap: (){
              sj_event_fire('probability_tips_pop_close', {});
              Navigator.pop(context);
            }, child: SJImg(name: 'sj_close_btn')),
          ),
        ],
      ),
    );
  }

}

// 信息确认
class SJPopAccountConfinDialog extends StatefulWidget {
  SJPopAccountConfinDialog({super.key});
  @override
  State<SJPopAccountConfinDialog> createState() => SJPopAccountConfinDialogState();
}

class SJPopAccountConfinDialogState extends State<SJPopAccountConfinDialog> {

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    sj_event_fire('cash_confirmation', {});
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 0.width(context),
      height: 0.height(context),
      child: Stack(
        alignment: Alignment.center,
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              RichText(
              textAlign: TextAlign.center,
              text: TextSpan(
                style: TextStyle(
                  fontSize: 18.0.spMax,
                  fontWeight: FontWeight.w700,
                  color: '#FFFFFF'.color()
                ),
                children: <TextSpan>[
                  TextSpan(
                    text: 'Please Verify Your ',
                  ),
                  TextSpan(
                    text: 'Payout Account',
                    style: TextStyle(color: '#FF2633'.color()),
                  ),
                  TextSpan(
                    text: '!',
                  ),
                ],
               ),
              ),
              SizedBox(height: 16.h,),
              Container(
                width: 329.w,
                height: 516.h,
                decoration: BoxDecoration(
                  image: SJDImg('sj_pap_bgs')
                ),
                child: Column(
                  children: [
                    SizedBox(height: 29.h),
                    SJText(text: 'Withdrawal Amount', size: 18.spMax, color: '#42401E'.color(), weight: FontWeight.w400),
                    SizedBox(height: 9.h),
                    SJText(text: '\$${SJLocalProvider.instance.sj_dolas_number}', size: 48.spMax, color: '#0B851C'.color(), weight: FontWeight.w400),
                    SizedBox(height: 52.h),
                    Row(
                      children: [
                        SizedBox(width: 22.w,),
                        SJText(text: 'Payout Platform', size: 16.spMax, color: '#4D3C3C'.color(), weight: FontWeight.w400),
                        Spacer(),
                        SJText(text: 'App', size: 16.spMax, color: '#C06913'.color(), weight: FontWeight.w400),
                        SizedBox(width: 22.w,),
                      ],
                    ),
                    SizedBox(height: 24.h),
                    Row(
                      children: [
                        SizedBox(width: 22.w,),
                        SJText(text: 'Payout Instructions', size: 16.spMax, color: '#4D3C3C'.color(), weight: FontWeight.w400),
                        Spacer(),
                        SJText(text: 'Game Rewards', size: 16.spMax, color: '#C06913'.color(), weight: FontWeight.w400),
                        SizedBox(width: 22.w,),
                      ],
                    ),
                    SizedBox(height: 24.h),
                    Row(
                      children: [
                        SizedBox(width: 22.w,),
                        SJText(text: 'Creation Time', size: 16.spMax, color: '#4D3C3C'.color(), weight: FontWeight.w400),
                        Spacer(),
                        SJText(text: formatNow(), size: 16.spMax, color: '#C06913'.color(), weight: FontWeight.w400),
                        SizedBox(width: 22.w,),
                      ],
                    ),
                    SizedBox(height: 24.h),
                    Row(
                      children: [
                        SizedBox(width: 22.w,),
                        SJText(text: 'Account Information', size: 16.spMax, color: '#4D3C3C'.color(), weight: FontWeight.w400),
                        Spacer(),
                        SJText(text: SJLocalProvider.instance.sj_account_id.isEmpty ? 'Submit later' : SJLocalProvider.instance.sj_account_id, size: 16.spMax, color: '#C06913'.color(), weight: FontWeight.w400),
                        SizedBox(width: 22.w,),
                      ],
                    ),
                    SizedBox(height: 24.h),
                    Row(
                      children: [
                        SizedBox(width: 22.w,),
                        SJText(text: 'Frequency', size: 16.spMax, color: '#4D3C3C'.color(), weight: FontWeight.w400),
                        Spacer(),
                        SJText(text: 'One Time', size: 16.spMax, color: '#C06913'.color(), weight: FontWeight.w400),
                        SizedBox(width: 22.w,),
                      ],
                    ),
                    SizedBox(height: 24.h),
                    Row(
                      children: [
                        SizedBox(width: 22.w,),
                        SJText(text: 'Payment Method', size: 16.spMax, color: '#4D3C3C'.color(), weight: FontWeight.w400),
                        Spacer(),
                        SJImg(name: 'sj_pap_icon_${SJLocalProvider.instance.sj_tx_ing_account}', width: 93.w, height: 24.h,),
                        SizedBox(width: 22.w,),
                      ],
                    ),
                    SizedBox(height: 37.h),
                    Container(
                      width: 197.w,
                      height: 56.h,
                      decoration: BoxDecoration(
                          image: SJDImg('sj_confim_btn')
                      ),
                      child: InkWell(
                        onTap: (){
                          Navigator.pop(context);
                          context.tipShow(SJPopTXLoadingDialog());
                        },
                      ),
                    ),
                  ],
                ),
              )
            ],
          )
        ],
      ),
    );
  }

  String formatNow() {
    final now = DateTime.now();

    final year = now.year.toString();
    final month = now.month.toString().padLeft(2, '0');
    final day = now.day.toString().padLeft(2, '0');
    final hour = now.hour.toString().padLeft(2, '0');
    final minute = now.minute.toString().padLeft(2, '0');

    return "$year.$month.$day $hour:$minute";
  }

}

// 提现loading
class SJPopTXLoadingDialog extends StatefulWidget {
  SJPopTXLoadingDialog({super.key});
  @override
  State<SJPopTXLoadingDialog> createState() => SJPopTXLoadingDialogState();
}

class SJPopTXLoadingDialogState extends State<SJPopTXLoadingDialog> {

  late spine.SpineWidgetController _controller0;

  @override
  void initState() {
    super.initState();

    // ✅ 2 秒后关闭弹窗
    Future.delayed(const Duration(seconds: 2), () {
      if (mounted){
        Navigator.of(context).pop();
        context.tipShow(SJPopTXTaskDialog());
      }
    });

    _controller0 = spine.SpineWidgetController(onInitialized: (controller) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        controller.animationState.setAnimationByName(0, "animation", true);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 0.width(context),
      height: 0.height(context),
      child: Stack(
        alignment: Alignment.center,
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(width: 0.width(context), height: 200.h,child: spine.SpineWidget.fromAsset('assets/spine/loading.atlas', 'assets/spine/loading.json', _controller0)),
              SizedBox(height: 63.h,),
              SizedBox(width:321.w,height:48.h,child: SJText(text: 'Due to a high number of requests, processing may take a bit longer.', size: 20.sp, color: '#FFFFFF'.color(), weight: FontWeight.w400,maxLines: 2,align: TextAlign.center,))
            ],
          )
        ],
      ),
    );
  }

}
// 提现申请中...
class SJPopTXTaskDialog extends StatefulWidget {
  SJPopTXTaskDialog({super.key});
  @override
  State<SJPopTXTaskDialog> createState() => SJPopTXTaskDialogState();
}

class SJPopTXTaskDialogState extends State<SJPopTXTaskDialog> {

  @override
  void initState() {
    super.initState();
    sj_event_fire('cash_task_pop', {});
    sj_event_fire('cash_task_s', {});
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 0.width(context),
      height: 0.height(context),
      child: Stack(
        alignment: Alignment.center,
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Row(
                children: [
                  Spacer(),
                  InkWell(onTap: (){
                    Navigator.pop(context);
                  }, child: SJImg(name: 'sj_close_btn', width: 45, height: 48,)),
                  SizedBox(width: 20.w,),
                ],
              ),
              SizedBox(height: 32.h,),
              SJText(text: 'Withdrawal in Progress', size: 28.spMax, color: '#FCFF98'.color(), weight: FontWeight.w400),
              SizedBox(height: 24.h,),
              SizedBox(
                width: 343.w,
                height: 172.h,
                child: VerticalMarquee(items: List.generate(
                  99,
                      (i) => Container(
                    color: Colors.transparent,
                    child: _buildItem(),
                  ),
                )
                ),
              ),
              SizedBox(
                width: 280.w,
                height: 20.h,
                child: SJText(text: 'Your withdrawal request is currently', size: 16.sp, color: '#FFFFFF'.color(), weight: FontWeight.w400),
              ),
              SizedBox(
                width: 280.w,
                height: 40.h,
                child: SJText(text: 'Being Processed . ', size: 32.sp, color: '#27D70F'.color(), weight: FontWeight.w400, align: TextAlign.center,),
              ),
              SizedBox(height: 13.h,),
              Container(
                width: 280.w,
                height: 17.h,
                decoration: BoxDecoration(
                  image: SJDImg('sj_account_center_pro_bg')
                ),
                child: Column(
                  children: [
                    SizedBox(height: 1.h,),
                    SizedBox(
                      width: 274.w,
                      height: 12.h,
                      child: LinearProgressIndicator(
                        borderRadius: BorderRadius.all(Radius.circular(12.h)),
                        value: _gettaskProgress() / 4.0,
                        minHeight: 12.h,
                        backgroundColor: Colors.transparent,
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.green),
                      ),
                    ),
                  ],
                )
              ),
              SizedBox(height: 6.h,),
              SJText(text: '(estimated 3–5 business days)', size: 14, color: '#AFA289'.color(), weight: FontWeight.w400),
              SizedBox(height: 20.h,),
              Container(
                width: 343.w,
                height: 189.h,
                decoration: BoxDecoration(
                  image: SJDImg('sj_account_bgs')
                ),
                child: Column(
                  children: [
                    SizedBox(height: 18.h,),
                    SizedBox(
                      width: 305.w,
                      height: 38.h,
                      child: SJText(text: 'Complete a few quick tasks to move up in the queue and get your payout faster!', size: 16.sp, color: '#FFFCEB'.color(), weight: FontWeight.w400, maxLines: 2, align: TextAlign.center,),
                    ),
                    SizedBox(height: 21.h,),
                    Container(
                      width: 313.w,
                      height: 43.h,
                      decoration: BoxDecoration(
                        image: SJDImg('sj_account_center_bg')
                      ),
                      child: Row(
                        children: [
                          SizedBox(width: 13.w,),
                          SJText(text: _getTxTaskString().first, size: 20.sp, color: '#FFFFFF'.color(), weight: FontWeight.w400),
                          Spacer(),
                          SJImg(name: _getTxTaskStatus().first ? 'sj_seletecd_s' : 'sj_seletecd_n', width: 29.w, height: 29.w,),
                          SizedBox(width: 9.w,),
                        ],
                      ),
                    ),
                    SizedBox(height: 8.h,),
                    Container(
                      width: 313.w,
                      height: 43.h,
                      decoration: BoxDecoration(
                          image: SJDImg('sj_account_center_bg')
                      ),
                      child: Row(
                        children: [
                          SizedBox(width: 13.w,),
                          SJText(text: _getTxTaskString().last, size: 20.sp, color: '#FFFFFF'.color(), weight: FontWeight.w400),
                          Spacer(),
                          SJImg(name: _getTxTaskStatus().last ? 'sj_seletecd_s' : 'sj_seletecd_n', width: 29.w, height: 29.w,),
                          SizedBox(width: 9.w,),
                        ],
                      ),
                    )
                  ],
                ),
              )
            ],
          )
        ],
      ),
    );
  }

  int _gettaskProgress(){
    int row = 0;
    if (SJLocalProvider.instance.sj_tx_card_index >= SJNumberHelpers().taskModel!.task.first.first.num) {
      row += 1;
    }
    if (SJLocalProvider.instance.sj_tx_dice_index >= SJNumberHelpers().taskModel!.task.first.last.num) {
      row += 1;
    }
    if (SJLocalProvider.instance.sj_login_index >= SJNumberHelpers().taskModel!.task.last.first.num) {
      row += 1;
    }
    if (SJLocalProvider.instance.sj_tx_probability_index >= SJNumberHelpers().taskModel!.task.last.last.num) {
      row += 1;
    }
    return row;
  }

  List<String> _getTxTaskString(){
    String text1 = '';
    String text2 = '';
    if (SJLocalProvider.instance.sj_tx_card_index < SJNumberHelpers().taskModel!.task.first.first.num || SJLocalProvider.instance.sj_tx_dice_index < SJNumberHelpers().taskModel!.task.first.last.num) {
      text1 =
      'Scratch ${SJLocalProvider.instance.sj_tx_card_index}/${SJNumberHelpers()
          .taskModel!
          .task.first.first.num} Card';
      text2 =
      'Play ${SJLocalProvider.instance.sj_tx_dice_index}/${SJNumberHelpers()
          .taskModel!
          .task.first.last.num} Dice';
    } else if (SJLocalProvider.instance.sj_login_index < SJNumberHelpers().taskModel!.task.last.first.num || SJLocalProvider.instance.sj_tx_probability_index < SJNumberHelpers().taskModel!.task.last.last.num) {
      text1 =
      'Log in ${SJLocalProvider.instance.sj_login_index}/${SJNumberHelpers()
          .taskModel!
          .task.last.first.num} days in a row';
      text2 =
      'Play ${SJLocalProvider.instance.sj_tx_probability_index}/${SJNumberHelpers()
          .taskModel!
          .task.last.last.num} Dice';
    }
    return [text1, text2];
  }

  List<bool> _getTxTaskStatus(){
    bool text1 = false;
    bool text2 = false;
    if (SJLocalProvider.instance.sj_tx_card_index < SJNumberHelpers().taskModel!.task.first.first.num || SJLocalProvider.instance.sj_tx_dice_index < SJNumberHelpers().taskModel!.task.first.last.num) {
      if (SJLocalProvider.instance.sj_tx_card_index < SJNumberHelpers().taskModel!.task.first.first.num) {
        text1 = false;
      } else {
        text1 = true;
      }
      if (SJLocalProvider.instance.sj_tx_dice_index < SJNumberHelpers().taskModel!.task.first.last.num) {
        text2 = false;
      } else {
        text2 = true;
      }
    } else if (SJLocalProvider.instance.sj_login_index < SJNumberHelpers().taskModel!.task.last.first.num || SJLocalProvider.instance.sj_tx_probability_index < SJNumberHelpers().taskModel!.task.last.last.num) {
      if (SJLocalProvider.instance.sj_login_index < SJNumberHelpers().taskModel!.task.last.first.num) {
        text1 = false;
      } else {
        text1 = true;
      }
      if (SJLocalProvider.instance.sj_tx_probability_index < SJNumberHelpers().taskModel!.task.last.last.num) {
        text2 = false;
      } else {
        text2 = true;
      }
    }
    return [text1, text2];
  }

  Widget _buildItem() {
    return Container(
      width: 343.w,
      height: 43.h,
      decoration: BoxDecoration(
        image: SJDImg('sj_accout_bgs')
      ),
      child: Column(
        children: [
          SizedBox(height: 7.h,),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              SJText(text: randomDateInPastYear(), size: 16.sp, color: '#FCF0A9'.color(), weight: FontWeight.w400),
              SJText(text: 'In Progress', size: 16.sp, color: '#FCF0A9'.color(), weight: FontWeight.w400),
              SJText(text: randomUserMask(), size: 16.sp, color: '#FCF0A9'.color(), weight: FontWeight.w400),
            ],
          )
        ],
      ),
    );
  }

  String randomDateInPastYear() {
    final now = DateTime.now();
    final random = Random();

    // 过去一年共 60 天
    int randomDays = random.nextInt(60); // 0~364

    // 生成随机日期
    DateTime date = now.subtract(Duration(days: randomDays));

    // 格式化成 MM/dd/yyyy
    String mm = date.month.toString().padLeft(2, '0');
    String dd = date.day.toString().padLeft(2, '0');
    String yyyy = date.year.toString();

    return "$mm/$dd/$yyyy";
  }

  String randomUserMask() {
    const letters = 'abcdefghijklmnopqrstuvwxyz';
    final rand = Random();

    // 前缀长度 3~5
    int prefixLength = 3 + rand.nextInt(3); // 3,4,5
    // 后缀长度 2~3
    int suffixLength = 2 + rand.nextInt(2); // 2,3

    // 生成前缀
    String prefix = List.generate(
      prefixLength,
          (_) => letters[rand.nextInt(letters.length)],
    ).join();

    // 生成后缀
    String suffix = List.generate(
      suffixLength,
          (_) => letters[rand.nextInt(letters.length)],
    ).join();

    return "$prefix****$suffix";
  }

}
// 提现安全页
class SJPopTXSafetyDialog extends StatefulWidget {
  SJPopTXSafetyDialog({super.key});
  @override
  State<SJPopTXSafetyDialog> createState() => SJPopTXSafetyDialogState();
}

class SJPopTXSafetyDialogState extends State<SJPopTXSafetyDialog> {

  late spine.SpineWidgetController _controller0;

  @override
  void initState() {
    super.initState();

    _controller0 = spine.SpineWidgetController(onInitialized: (controller) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        controller.animationState.setAnimationByName(0, "animation", true);
      });
    });

    // ✅ 2 秒后关闭弹窗
    Future.delayed(const Duration(seconds: 2), () {
      if (mounted){
        Navigator.of(context).pop();
        context.tipShow(SJPopTXLastDialog());
      }
    });

  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 0.width(context),
      height: 0.height(context),
      child: Stack(
        alignment: Alignment.center,
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SJText(text: 'Security Verification', size: 28, color: '#FCFF98'.color(), weight: FontWeight.w400),
              SizedBox(height: 20.h,),
              SizedBox(width:300.w, height: 300.w,child: spine.SpineWidget.fromAsset('assets/spine/Safety.atlas', 'assets/spine/Safety.json', _controller0)),
              SizedBox(height: 12.h,),
              SizedBox(width:250.w,height:48.h,child: SJText(text: 'Your withdrawal is under security verification. ', size: 20.sp, color: '#FFFFFF'.color(), weight: FontWeight.w400,maxLines: 2,align: TextAlign.center,))
            ],
          )
        ],
      ),
    );
  }

}
// 最后一步提现任务
class SJPopTXLastDialog extends StatefulWidget {
  SJPopTXLastDialog({super.key});
  @override
  State<SJPopTXLastDialog> createState() => SJPopTXLastDialogState();
}

class SJPopTXLastDialogState extends State<SJPopTXLastDialog> {

  @override
  void initState() {
    super.initState();

  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 0.width(context),
      height: 0.height(context),
      child: Stack(
        alignment: Alignment.center,
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Row(
                children: [
                  Spacer(),
                  InkWell(
                    onTap: (){
                      Navigator.pop(context);
                    },
                    child: SJImg(name: 'sj_close_btn', width: 48, height: 49,),
                  ),
                  SizedBox(width: 32.w,)
                ],
              ),
              SizedBox(height: 12.h,),
              SJText(text: 'Security Verification', size: 28, color: '#FCFF98'.color(), weight: FontWeight.w400),
              SizedBox(height: 51.h,),
              SJImg(name: 'sj_gan_icon', width: 146.w, height: 131.w,),
              SizedBox(height: 40.h,),
              SizedBox(width:303.w,height:48.h,child: SJText(text: 'The payment was forced to stop. please verify your identity.', size: 20.sp, color: '#FFFFFF'.color(), weight: FontWeight.w400,maxLines: 2,align: TextAlign.center,)),
              SizedBox(height: 20.h,),Container(
                width: 343.w,
                height: 125.h,
                decoration: BoxDecoration(
                    image: SJDImg('sj_last_tx_bg')
                ),
                child: Column(
                  children: [
                    SizedBox(height: 12.h,),
                    Container(
                      width: 313.w,
                      height: 43.h,
                      decoration: BoxDecoration(
                          image: SJDImg('sj_account_center_bg')
                      ),
                      child: Row(
                        children: [
                          SizedBox(width: 13.w,),
                          SJText(text: 'XXXXXXXXXXXXX', size: 20.sp, color: '#FFFFFF'.color(), weight: FontWeight.w400),
                          Spacer(),
                          SJImg(name: 'sj_seletecd_s', width: 29.w, height: 29.w,),
                          SizedBox(width: 9.w,),
                        ],
                      ),
                    ),
                    SizedBox(height: 8.h,),
                    Container(
                      width: 313.w,
                      height: 43.h,
                      decoration: BoxDecoration(
                          image: SJDImg('sj_account_center_bg')
                      ),
                      child: Row(
                        children: [
                          SizedBox(width: 13.w,),
                          SJText(text: 'XXXXXXXXXX', size: 20.sp, color: '#FFFFFF'.color(), weight: FontWeight.w400),
                          Spacer(),
                          SJImg(name: 'sj_seletecd_n', width: 29.w, height: 29.w,),
                          SizedBox(width: 9.w,),
                        ],
                      ),
                    )
                  ],
                ),
              )
            ],
          )
        ],
      ),
    );
  }

}
// 提现成功
class SJPopTXSulsDialog extends StatefulWidget {
  SJPopTXSulsDialog({super.key});
  @override
  State<SJPopTXSulsDialog> createState() => SJPopTXSulsDialogState();
}

class SJPopTXSulsDialogState extends State<SJPopTXSulsDialog> {

  @override
  void initState() {
    super.initState();
    sj_event_fire('congratulation_s', {});
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 0.width(context),
      height: 0.height(context),
      child: Stack(
        alignment: Alignment.center,
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Row(
                children: [
                  Spacer(),
                  InkWell(
                    onTap: (){
                      Navigator.pop(context);
                    },
                    child: SJImg(name: 'sj_close_btn', width: 48, height: 49,),
                  ),
                  SizedBox(width: 32.w,)
                ],
              ),
              SizedBox(height: 22.h,),
              Container(
                width: 329.w,
                height: 389.h,
                decoration: BoxDecoration(
                  image: SJDImg('sj_tx_sul_bg')
                ),
                child:
                Column(
                  children: [
                    SizedBox(height: 24.h,),
                    SJStrokeText(text: 'Application Successful', size: 24.sp, color: '#FFFFFF'.color(), weight: FontWeight.w400, skWidth: 2, skColor: '#5A3703'.color()),
                    SizedBox(height: 61.h,),
                    SJText(text: '7 working days after application.', size: 16.sp, color: '#54442E'.color(), weight: FontWeight.w400),
                    SizedBox(height: 19.h,),
                    SJText(text: 'A 1% fee applies per withdrawal.', size: 16.sp, color: '#54442E'.color(), weight: FontWeight.w400),
                    SizedBox(height: 19.h,),
                    SizedBox(width: 284.w, height:58.h,child: SJText(text: 'Keep growing your wealth while you wait!', size: 24.sp, color: '#038605'.color(), weight: FontWeight.w400,maxLines: 2, align: TextAlign.center,)),
                    SizedBox(height: 44.h,),
                    InkWell(
                      onTap: (){
                        Navigator.pop(context);
                      },
                      child: SJImg(name: 'sj_play_more_btn', width: 204.w,height: 54.h,),
                    )
                  ],
                ),
              )
            ],
          )
        ],
      ),
    );
  }

}
// 发起提现
class SJPopSubmitOneDialog extends StatefulWidget {
  final int number_index;
  SJPopSubmitOneDialog({super.key, required this.number_index});
  @override
  State<SJPopSubmitOneDialog> createState() => SJPopSubmitOneDialogState();
}

class SJPopSubmitOneDialogState extends State<SJPopSubmitOneDialog> {
  
  int seletecd_index = 0;

  final TextEditingController _controller = TextEditingController();

  FocusNode _focusNode = FocusNode();

  List<int> tx_list = [1000, 1500, 3000];

  @override
  void initState() {
    super.initState();
    sj_event_fire('cash_page_c', {});
  }

  @override
  void dispose() {
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 0.width(context),
      height: 0.height(context),
      child: Stack(
        alignment: Alignment.center,
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 329.w,
                height: 493.h,
                decoration: BoxDecoration(
                  image: SJDImg('sj_tx_sub_bg')
                ),
                child: Column(
                  children: [
                    SizedBox(height: 29.h,),
                    SJText(text: 'Payment Information', size: 18.sp, color: '#42401E'.color(), weight: FontWeight.w400),
                    SizedBox(height: 18.h,),
                    InkWell(
                      onTap: (){
                        setState(() {
                          seletecd_index = 0;
                        });
                      },
                      child: SJImg(name: seletecd_index == 0 ? 'sj_account_0_s' : 'sj_account_0_n', width: 176.w, height: 61.w,),
                    ),
                    SizedBox(height: 12.h,),
                    InkWell(
                      onTap: (){
                        setState(() {
                          seletecd_index = 1;
                        });
                      },
                      child: SJImg(name: seletecd_index == 1 ? 'sj_account_1_s' : 'sj_account_1_n', width: 176.w, height: 61.w,),
                    ),
                    SizedBox(height: 40.h,),
                    Row(
                      children: [
                        SizedBox(width: 22.w,),
                        SJText(text: 'Account/Phone', size: 16.sp, color: '#4D3C3C'.color(), weight: FontWeight.w400)
                      ],
                    ),
                    SizedBox(height: 6.h,),
                    Container(
                      width: 287.w,
                      height: 48.h,
                      decoration: BoxDecoration(
                        color: '#D8D8D3'.color(),
                        borderRadius: BorderRadius.all(Radius.circular(5))
                      ),
                      child: TextField(
                        controller: _controller,
                        focusNode: _focusNode,
                        decoration:  InputDecoration(
                          labelText: 'E.G. 123456789@abc.com',
                          labelStyle: TextStyle(
                            color: '#9A9881'.color(), // 设置字体颜色为蓝色
                            fontSize: 13.0,     // 可选：设置字体大小
                            fontWeight: FontWeight.bold, // 可选：设置字体粗细
                          ),
                          border:  OutlineInputBorder(),
                          // 设置启用状态下的边框颜色
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.transparent),
                          ),
                          // 设置聚焦状态下的边框颜色
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: '#E38AF9'.color()),
                          ),
                        ),
                        style: TextStyle(
                          color: '#000000'.color(), // 设置字体颜色为蓝色
                          fontSize: 15.0,     // 可选：设置字体大小
                          fontWeight: FontWeight.bold, // 可选：设置字体粗细
                        ),
                      ),
                    ),
                    SizedBox(height: 34.h,),
                    Row(
                      children: [
                        SizedBox(width: 22.w,),
                        SJText(text: 'Direct to Your paypal  Instant Payment', size: 14.sp, color: '#5A5544'.color(), weight: FontWeight.w400),
                      ],
                    ),
                    SizedBox(height: 7.h,),
                    Row(
                      children: [
                        SizedBox(width: 22.w,),
                        SJText(text: 'Direct to Your cash app Instant Payment', size: 14.sp, color: '#5A5544'.color(), weight: FontWeight.w400),
                      ],
                    ),
                    SizedBox(height: 30.h,),
                    InkWell(
                      onTap: () async {
                        if (_controller.text.isEmpty){
                          Navigator.pop(context);
                          SJDialogTool.toast(context, 'Please Enter Your Account.');
                        } else {
                          Navigator.pop(context);
                          await SJLocalProvider.instance.updateint(SJLocalProvider.instance.sj_tx_ing_numberName, widget.number_index);
                          await SJLocalProvider.instance.updateint(SJLocalProvider.instance.sj_account_seled_indexName, seletecd_index);
                          await SJLocalProvider.instance.updateint(SJLocalProvider.instance.sj_tx_ing_accountName, seletecd_index);
                          await SJLocalProvider.instance.updateint(SJLocalProvider.instance.sj_dolas_numberName, SJLocalProvider.instance.sj_dolas_number - tx_list[widget.number_index]);
                          await SJLocalProvider.instance.updateTXInStatus(1);
                          await SJLocalProvider.instance.updateint(SJLocalProvider.instance.sj_tx_dice_indexName, 0);
                          await SJLocalProvider.instance.updateint(SJLocalProvider.instance.sj_tx_card_indexName, 0);
                          await SJLocalProvider.instance.updateint(SJLocalProvider.instance.sj_login_indexName, 0);
                          await SJLocalProvider.instance.updateint(SJLocalProvider.instance.sj_tx_probability_indexName, 0);
                          await SJLocalProvider.instance.updateint(SJLocalProvider.instance.sj_tx_box_indexName, 0);
                          await SJLocalProvider.instance.updateString(SJLocalProvider.instance.sj_account_idName, _controller.text);
                          if (SJLocalProvider.instance.sj_dolas_number >= 1000){
                            if(mounted){
                              context.tipShow(SJPopTXWallerDialog());
                            }
                          }
                        }
                      },
                      child: SJImg(name: 'sj_submit_btn', width: 202.w, height: 51.5.h,),
                    )
                  ],
                ),
              )
            ],
          ),
        ],
      ),
    );
  }

}
// 运营1
class SJPopSubmitAccountDialog extends StatefulWidget {
  SJPopSubmitAccountDialog({super.key});
  @override
  State<SJPopSubmitAccountDialog> createState() => SJPopSubmitAccountDialogState();
}

class SJPopSubmitAccountDialogState extends State<SJPopSubmitAccountDialog> {

  late spine.SpineWidgetController _controller1;

  @override
  void initState() {
    super.initState();

    _controller1 = spine.SpineWidgetController(onInitialized: (controller) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        controller.animationState.setAnimationByName(0, "animation", true);
      });
    });

  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 0.width(context),
      height: 0.height(context),
      child: Stack(
        alignment: Alignment.center,
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SJText(text: "Don't Leave Your Money Behind!", size: 24.sp, color: '#F1F80E'.color(), weight: FontWeight.w400),
              SizedBox(height: 6.h,),
              SizedBox(width: 231.w, height:58.h,child:
              RichText(
                textAlign: TextAlign.center,
                text: TextSpan(
                  style: TextStyle(
                      fontSize: 24.0.spMax,
                      fontWeight: FontWeight.w400,
                      color: '#FFFFFF'.color(),
                      fontFamily: 'Barlow_Black'
                  ),
                  children: <TextSpan>[
                    TextSpan(
                      text: 'Secure Your Earnings in ',
                    ),
                    TextSpan(
                      text: 'One Quick Step',
                      style: TextStyle(color: '#0EC120'.color()),
                    ),
                  ],
                ),
              ),
              ),
              SizedBox(height: 4.h,),
              SizedBox(
                width: 0.width(context),
                height: 220.h,
                child: Stack(
                  children: [
                    Column(
                      children: [
                        SizedBox(width: 0.width(context), height: 220.w, child: spine.SpineWidget.fromAsset('assets/spine/yunying1.atlas', 'assets/spine/yunying1.json', _controller1)),
                      ],
                    ),
                  ],
                )
              ),
              SizedBox(height: 109.h,),
              SizedBox(
                width: 338.w,
                height: 38.h,
                child: SJText(text: 'Your game was a success! To send your \$1000 in earnings, we just need your payout info.', size: 16.sp, color: '#FFFFFF'.color(), weight: FontWeight.w400, maxLines: 2, align: TextAlign.center,),
              ),
              SizedBox(height: 25.h,),
              InkWell(
                onTap: (){
                  Navigator.pop(context);
                  context.tipShow(SJPopTXTipsDialog());
                },
                child: SJImg(name: 'sj_secure_btn', width: 260.w, height: 74.h,),
              ),
              InkWell(
                  onTap: (){
                    Navigator.pop(context);
                    context.tipShow(SJPopTXTipsDialog());
                  },
                  child: SizedBox(width: 260.w, height: 45.h, child: SJUnderlineTextButton(text: 'Later On', fontSize: 20.spMin, underlineColor: '#C5A213'.color(),gradientColors: ['#BE982A'.color(),'#FFE9A3'.color(),'#FFF6D7'.color(),'#FFF0B4'.color(),],),)
              ),
            ],
          ),
          Positioned(top: 350.h, left:(0.width(context) - 265.w) * 0.5,child: Container(
            width: 265.w,
            height: 110.h,
            decoration: BoxDecoration(
                image: SJDImg('sj_tips_0')
            ),
            child: Column(
              children: [
                SizedBox(height: 39.h,),
                SizedBox(
                  width: 217.w,
                  height: 53.h,
                  child: RichText(
                    textAlign: TextAlign.center,
                    text: TextSpan(
                      style: TextStyle(
                        fontSize: 24.0.spMax,
                        fontWeight: FontWeight.w400,
                        color: '#C61013'.color(),
                        fontFamily: 'Barlow_Black',
                      ),
                      children: <TextSpan>[
                        TextSpan(
                          text: 'Only 1 Minute\n',
                        ),
                        TextSpan(
                          text: 'Secure Your Winnings Now',
                          style: TextStyle(color: '#594211'.color(), fontSize: 18.sp),
                        ),
                      ],
                    ),
                  ),
                )
              ],
            ),
          ))
        ],
      ),
    );
  }

}
// 运营3
class SJPopSubmitLastDialog extends StatefulWidget {
  SJPopSubmitLastDialog({super.key});
  @override
  State<SJPopSubmitLastDialog> createState() => SJPopSubmitLastDialogState();
}

class SJPopSubmitLastDialogState extends State<SJPopSubmitLastDialog> {

  @override
  void initState() {
    super.initState();

    // ✅ 2 秒后关闭弹窗
    Future.delayed(const Duration(seconds: 2), () {
      if (mounted){
        Navigator.of(context).pop();
        context.tipShow(SJPopTXTipsDialog());
      }
    });

  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 0.width(context),
      height: 0.height(context),
      child: Stack(
        alignment: Alignment.center,
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
                Container(
                  width: 379.w,
                  height: 200.h,
                  decoration: BoxDecoration(
                    image: SJDImg('sj_tx_3_bg')
                  ),
                  child: SJImg(name: 'sj_tx_3_center'),
                )
              ],
            ),
        ],
      ),
    );
  }

}

// 提现不足
class SJPopTXNotDialog extends StatefulWidget {
  SJPopTXNotDialog({super.key});
  @override
  State<SJPopTXNotDialog> createState() => SJPopTXNotDialogState();
}

class SJPopTXNotDialogState extends State<SJPopTXNotDialog> {

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    sj_event_fire('cash_not_pop', {});
  }
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 0.width(context),
      height: 0.height(context),
      child: Stack(
        alignment: Alignment.center,
        children: [
          Container(
            width: 263.w,
            height: 370.h,
            decoration: BoxDecoration(
                image: SJDImg('sj_pop_bg_1')
            ),
            child: Column(
              children: [
                SizedBox(height: 20.h,),
                SJStrokeText(text: 'Account Security Restrictions', size: 16.sp, color: '#FFFEE8'.color(), weight: FontWeight.w400, skWidth: 1, skColor: '#000000'.color()),
                SizedBox(height: 28.0.h,),
                Container(
                  width: 193.w,
                  height: 130.h,
                  decoration: BoxDecoration(
                      image: SJDImg('sj_pop_center_1')
                  ),
                  child: Center(
                    child: SJImg(name: 'sj_faild_icon', width: 118.w, height: 118.w,),
                  ),
                ),
                SizedBox(height: 15.h,),
                SizedBox(
                  width: 209.w,
                  height: 34.h,
                  child: SJText(text: 'For security,\nhe minimum withdrawal is 1000.', size: 14.sp, color: '#F4D896'.color(), weight: FontWeight.w400, maxLines: 2, align: TextAlign.center),
                ),
                SizedBox(height: 24.h,),
                Container(
                  width: 197.w,
                  height: 56.h,
                  decoration: BoxDecoration(
                      image: SJDImg('sj_try_btn')
                  ),
                  child: InkWell(
                    onTap: (){
                      sj_event_fire('cash_not_pop_c', {});
                      Navigator.pop(context);
                    },
                  ),
                ),
              ],
            ),
          ),
          Positioned(
            right: 48.w,
            top: (0.height(context) - 370.h) * 0.48,
            width: 45,
            height: 48,
            child: InkWell(onTap: (){
              sj_event_fire('cash_not_pop_c', {});
              Navigator.pop(context);
            }, child: SJImg(name: 'sj_close_btn')),
          ),
        ],
      ),
    );
  }

}

// 运营4
class SJPopTXTipsDialog extends StatefulWidget {
  SJPopTXTipsDialog({super.key});
  @override
  State<SJPopTXTipsDialog> createState() => SJPopTXTipsDialogState();
}

class SJPopTXTipsDialogState extends State<SJPopTXTipsDialog> {

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 0.width(context),
      height: 0.height(context),
      child: Stack(
        alignment: Alignment.center,
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ThreeRowHorizontalMarquee(containerWidth: 0.width(context), containerHeight: 110.h,itemsPerRow:3),
              SizedBox(height: 15.h,),
              SJText(text: 'Almost There! ', size: 36.sp, color: '#F1F80E'.color(), weight: FontWeight.w400),
              SizedBox(
                width: 255.w,
                height: 48.h,
                child: RichText(
                  textAlign: TextAlign.center,
                  text: TextSpan(
                    style: TextStyle(
                      fontSize: 20.0,
                      fontWeight: FontWeight.w400,
                      color: '#FFFFFF'.color(),
                      fontFamily: 'Barlow_Black'
                    ),
                    children: <TextSpan>[
                      TextSpan(
                        text: 'Your withdrawal progress is ahead of',
                      ),
                      TextSpan(
                        text: ' ${SJLocalProvider.instance.sj_dolas_number / 1000}% ',
                        style: TextStyle(color: '#65DE38'.color()),
                      ),
                      TextSpan(
                        text: 'of users! ',
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 11.h,),
              Container(
                width: 289.w,
                height: 107.h,
                decoration: BoxDecoration(
                  image: SJDImg('sj_tx_center_3')
                ),
                child: Column(
                  children: [
                    SizedBox(height: 31.h,),
                    SJText(text: '\$${SJLocalProvider.instance.sj_dolas_number}', size: 40.sp, color: '#4C3117'.color(), weight: FontWeight.w400),
                  ],
                ),
              ),
              SizedBox(height: 28.h,),
              Row(
                children: [
                  SizedBox(width: 61.w,),
                  SizedBox(
                    width: 28.w,
                    height: 108.h,
                    child: SJImg(name: 'sj_tx_center_4'),
                  ),
                  SizedBox(width: 19.w,),
                  SizedBox(
                    width: 216.w,
                    height: 108.h,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        SJText(text: 'Submit payment information', size: 16.sp, color: '#48D038'.color(), weight: FontWeight.w400),
                        RichText(
                          textAlign: TextAlign.center,
                          text: TextSpan(
                            style: TextStyle(
                                fontSize: 16.0,
                                fontWeight: FontWeight.w400,
                                color: '#FAFAF0'.color(),
                                fontFamily: 'Barlow_Black'
                            ),
                            children: <TextSpan>[
                              TextSpan(
                                text: 'Just',
                              ),
                              TextSpan(
                                text: ' \$${1000 - SJLocalProvider.instance.sj_dolas_number} ',
                                style: TextStyle(color: '#C61013'.color()),
                              ),
                              TextSpan(
                                text: 'Away From Payout!',
                              ),
                            ],
                          ),
                        ),
                        SJText(text: 'Revenue Received', size: 16.sp, color: '#FAFAF0'.color(), weight: FontWeight.w400),
                      ],
                    ),
                  )
                ],
              ),
              SizedBox(height: 22.w,),
              InkWell(
                onTap: (){
                  Navigator.pop(context);
                },
                child: SJImg(name: 'sj_gets_btn', width: 260.w, height: 74.h,),
              ),
              SizedBox(height: 22.w,),
              Container(
                width: 343.w,
                height: 106.h,
                decoration: BoxDecoration(
                  image: SJDImg('sj_pa_center_bg_0')
                ),
                child: Column(
                  children: [
                    SizedBox(height: 8.h,),
                    Row(
                      children: [
                        Spacer(),
                        InkWell(
                          onTap: (){
                            Navigator.pop(context);
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (builder) {
                                  return SJCash();
                                },
                              ),
                            );
                          }, child: SJImg(name: 'sj_cash_out_btn', width: 151.w, height: 40.h,)),
                        SizedBox(width: 8.w,)
                      ],
                    ),
                    SizedBox(height: 5.h,),
                    Row(
                      children: [
                        SizedBox(width: 15.w,),
                        SJText(text: 'Accumulate \$1000 to cash out.', size: 14.sp, color: '#FFF9B5'.color(), weight: FontWeight.w400),
                      ],
                    ),
                    SizedBox(height: 3.5.h,),
                    Row(
                      children: [
                        SizedBox(width: 18.w,),
                        SizedBox(
                          width:307.w,
                          height: 14.h,
                          child: LinearProgressIndicator(
                            borderRadius: BorderRadius.all(Radius.circular(14.h)),
                            value: SJLocalProvider.instance.sj_dolas_number / 1000.0,
                            minHeight: 14.h,
                            backgroundColor: Colors.transparent,
                            valueColor: AlwaysStoppedAnimation<Color>('#F7FF0F'.color()),
                          ),
                        )
                      ],
                    )
                  ],
                )
              )
            ],
          )
        ],
      ),
    );
  }

}

// 运营5
class SJPopTXDiceDialog extends StatefulWidget {
  SJPopTXDiceDialog({super.key});
  @override
  State<SJPopTXDiceDialog> createState() => SJPopTXDiceDialogState();
}

class SJPopTXDiceDialogState extends State<SJPopTXDiceDialog> {

  late spine.SpineWidgetController _controller0;

  late spine.SpineWidgetController _controller1;

  @override
  void initState() {
    // TODO: implement initState
    _controller0 = spine.SpineWidgetController(onInitialized: (controller) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        controller.animationState.setAnimationByName(0, "animation", true);
      });
    });
    _controller1 = spine.SpineWidgetController(onInitialized: (controller) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        controller.animationState.setAnimationByName(0, "animation", true);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 0.width(context),
      height: 0.height(context),
      child: Stack(
        alignment: Alignment.center,
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Row(
                children: [
                  Spacer(),
                  Container(
                    width: 149.w,
                    height: 43.h,
                    decoration: BoxDecoration(
                      image: SJDImg('sj_pa_top_time_bg')
                    ),
                    child: Padding(
                      padding: EdgeInsets.only(top: 3.h),
                      child: Row(
                        children: [
                          SizedBox(width: 50.w,),
                          RichText(
                            textAlign: TextAlign.center,
                            text: TextSpan(
                              style: TextStyle(
                                  fontSize: 9.0,
                                  fontWeight: FontWeight.w400,
                                  color: '#441F0D'.color(),
                                  fontFamily: 'Barlow_Black'
                              ),
                              children: <TextSpan>[
                                TextSpan(
                                  text: 'Remaining Time: ',
                                ),
                                TextSpan(
                                  text: '100s',
                                  style: TextStyle(color: '#27A214'.color()),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(width: 50.w,)
                ],
              ),
              ThreeRowHorizontalMarquee(containerWidth: 0.width(context), containerHeight: 110.h,itemsPerRow:3),
              SizedBox(height: 15.h,),
              SJGradientStrokeText(text: 'Celebrate Early!', gradientColors: ['#F1F80E'.color(),'#FF5912'.color(),'#FF1BD1'.color()], width: 262.w, height: 43.h, fontSize: 36),
              SizedBox(height: 10.h,),
              SizedBox(
                width: 0.width(context),
                height: 228.h,
                child: Stack(
                  children: [
                    spine.SpineWidget.fromAsset('assets/spine/l.atlas', 'assets/spine/l.json', _controller1),
                    spine.SpineWidget.fromAsset('assets/spine/caidai.atlas', 'assets/spine/caidai.json', _controller0),
                    Center(child: SizedBox(width: 285.w, height: 228.h, child: SJImg(name: 'sj_yunyings_iocn')),),
                  ],
                ),
              ),
              SizedBox(height: 20.h,),
              SizedBox(
                width: 330.w,
                height: 48.h,
                child: RichText(
                  textAlign: TextAlign.center,
                  text: TextSpan(
                    style: TextStyle(
                        fontSize: 20.0,
                        fontWeight: FontWeight.w400,
                        color: '#FFFFFF'.color(),
                        fontFamily: 'Barlow_Black'
                    ),
                    children: <TextSpan>[
                      TextSpan(
                        text: 'You’re about to cash out ',
                      ),
                      TextSpan(
                        text: '\$1000',
                        style: TextStyle(color: '#64DE38'.color()),
                      ),
                      TextSpan(
                        text: '!\n',
                      ),
                      TextSpan(
                        text: 'Enjoy 100 seconds of unlimited dice!',
                        style: TextStyle(color: '#FFFA71'.color()),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 11.h,),
              InkWell(
                onTap: (){
                  Navigator.pop(context);
                  SJLocalProvider.instance.updateBool(SJLocalProvider.instance.sj_100_timer_starName, true);
                  SJScratchDiceTimerNotificationService.sendToDomandNumberNotification(0);
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (builder) {
                        return SJDiceRollWidget(souce_fromat: 'card',);
                      },
                    ),
                  );
                },
                child: SJImg(name: 'sj_confim_btn', width: 260.w, height: 74.h,),
              ),
              SizedBox(height: 22.w,),
              Container(
                  width: 343.w,
                  height: 106.h,
                  decoration: BoxDecoration(
                      image: SJDImg('sj_pa_center_bg_0')
                  ),
                  child: Column(
                    children: [
                      SizedBox(height: 8.h,),
                      Row(
                        children: [
                          Spacer(),
                          InkWell(
                              onTap: (){
                                Navigator.pop(context);
                                SJLocalProvider.instance.updateBool(SJLocalProvider.instance.sj_100_timer_starName, true);
                                SJScratchDiceTimerNotificationService.sendToDomandNumberNotification(0);
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (builder) {
                                      return SJCash();
                                    },
                                  ),
                                );
                              }, child: SJImg(name: 'sj_cash_out_btn', width: 151.w, height: 40.h,)),
                          SizedBox(width: 8.w,)
                        ],
                      ),
                      SizedBox(height: 5.h,),
                      Row(
                        children: [
                          SizedBox(width: 15.w,),
                          SJText(text: 'Accumulate \$1000 to cash out.', size: 14.sp, color: '#FFF9B5'.color(), weight: FontWeight.w400),
                        ],
                      ),
                      SizedBox(height: 3.5.h,),
                      Row(
                        children: [
                          SizedBox(width: 18.w,),
                          SizedBox(
                            width:307.w,
                            height: 14.h,
                            child: LinearProgressIndicator(
                              borderRadius: BorderRadius.all(Radius.circular(14.h)),
                              value: SJLocalProvider.instance.sj_dolas_number / 1000,
                              minHeight: 14.h,
                              backgroundColor: Colors.transparent,
                              valueColor: AlwaysStoppedAnimation<Color>('#F7FF0F'.color()),
                            ),
                          )
                        ],
                      )
                    ],
                  )
              )
            ],
          )
        ],
      ),
    );
  }

}

// 运营6
class SJPopTXWallerDialog extends StatefulWidget {
  SJPopTXWallerDialog({super.key});
  @override
  State<SJPopTXWallerDialog> createState() => SJPopTXWallerDialogState();
}

class SJPopTXWallerDialogState extends State<SJPopTXWallerDialog> {

  late spine.SpineWidgetController _controller0;

  @override
  void initState() {
    super.initState();
    sj_event_fire('meet_withdraw', {});
    _controller0 = spine.SpineWidgetController(onInitialized: (controller) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        controller.animationState.setAnimationByName(0, "animation", true);
      });
    });
  }

    @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 0.width(context),
      height: 0.height(context),
      child: Stack(
        alignment: Alignment.center,
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SJText(text: 'Milestone Achieved!', size: 28.sp, color: '#FCFF98'.color(), weight: FontWeight.w400),
              SizedBox(height: 11.h,),
              SizedBox(width: 197.w, height: 197.w,child: spine.SpineWidget.fromAsset('assets/spine/yunying6.atlas', 'assets/spine/yunying6.json', _controller0),),
              SizedBox(height: 34.h,),
              SizedBox(
                width: 344.w,
                height: 91.h,
                child: RichText(
                  textAlign: TextAlign.center,
                  text: TextSpan(
                    style: TextStyle(
                        fontSize: 20.0,
                        fontWeight: FontWeight.w400,
                        color: '#FFFFFF'.color(),
                        fontFamily: 'Barlow_Black'
                    ),
                    children: <TextSpan>[
                      TextSpan(
                        text: 'Your effort has paid off!\n',
                      ),
                      TextSpan(
                        text: "You've earned \$1000!\n",
                        style: TextStyle(color: '#18AC04'.color(), fontSize: 36.sp),
                      ),
                      TextSpan(
                        text: 'And Are Ready To Withdraw.',
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 11.h,),
              InkWell(
                onTap: (){
                  sj_event_fire('meet_withdraw_c', {});
                  Navigator.pop(context);
                  if (SJLocalProvider.instance.sj_account_id.isEmpty) {
                    context.tipShow(SJPopSubmitOneDialog(number_index: 0));
                  } else {
                    context.tipShow(SJPopAccountConfinDialog());
                  }
                },
                child: SJImg(name: 'sj_claim_btns', width: 260.w, height: 74.h,),
              ),
              SizedBox(height: 12.w,),
              SizedBox(width: 260.w, height: 45.h, child: SJUnderlineTextButton(text: 'Later On', fontSize: 20.spMin, underlineColor: '#C5A213'.color(),gradientColors: ['#BE982A'.color(),'#FFE9A3'.color(),'#FFF6D7'.color(),'#FFF0B4'.color(),],onPressed: (){
                Navigator.pop(context);
                if (SJLocalProvider.instance.sj_account_id.isEmpty) {
                  context.tipShow(SJPopSubmitOneDialog(number_index: 0));
                } else {
                  context.tipShow(SJPopAccountConfinDialog());
                }
              },),)
            ],
          )
        ],
      ),
    );
  }

}


// 开宝箱
class SJBoxOpenDiaologWidget extends StatefulWidget {
  SJBoxOpenDiaologWidget({super.key});
  @override
  State<SJBoxOpenDiaologWidget> createState() => SJBoxOpenDiaologWidgetState();
}

class SJBoxOpenDiaologWidgetState extends State<SJBoxOpenDiaologWidget> with SingleTickerProviderStateMixin {

  var _showanimation = true;

  var _showBottom = false;

  var _openOne = false;

  var _openTwo = false;

  var _openThree = false;

  var doals_one = 20.0;

  var doals_two = 30.0;

  var doals_three = 40.0;

  var open_index = 0.0;

  late spine.SpineWidgetController _controller0;

  late spine.SpineWidgetController _controller1;

  late spine.SpineWidgetController _controller2;

  late spine.SpineWidgetController _controller3;

  late spine.SpineWidgetController _controller4;

  late spine.SpineWidgetController _controller5;

  late spine.SpineWidgetController _controller6;

  late spine.SpineWidgetController _controller7;

  late spine.SpineWidgetController _controller8;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    sj_event_fire('box_pop', {});

    _controller0 = spine.SpineWidgetController(onInitialized: (controller) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        controller.animationState.setAnimationByName(0, "animation", true);
      });
    });

    _controller1 = spine.SpineWidgetController(onInitialized: (controller) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        controller.animationState.setAnimationByName(0, "animation", true);
      });
    });

    _controller2 = spine.SpineWidgetController(onInitialized: (controller) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        controller.animationState.setAnimationByName(0, "animation", true);
      });
    });

    _controller3 = spine.SpineWidgetController(onInitialized: (controller) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        controller.animationState.setAnimationByName(0, "animation", true);
      });
    });

    _controller4 = spine.SpineWidgetController(onInitialized: (controller) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        controller.animationState.setAnimationByName(0, "animation", true);
      });
    });

    _controller5 = spine.SpineWidgetController(onInitialized: (controller) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        controller.animationState.setAnimationByName(0, "animation", true);
      });
    });

    _controller6 = spine.SpineWidgetController(onInitialized: (controller) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        controller.animationState.setAnimationByName(0, "animation", true);
      });
    });

    _controller7 = spine.SpineWidgetController(onInitialized: (controller) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        controller.animationState.setAnimationByName(0, "animation", true);
      });
    });

    _controller8 = spine.SpineWidgetController(onInitialized: (controller) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        controller.animationState.setAnimationByName(0, "animation", true);
      });
    });

  }

  openBox(){
    setState(() {
      _showBottom = true;
      _showanimation = false;
    });
    Future.delayed(Duration(milliseconds: 1200), (){
      setState(() {
        if (!_openOne){
          _openOne = true;
        }
        if (!_openTwo){
          _openTwo = true;
        }
        if (!_openThree){
          _openThree = true;
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 0.width(context),
      height: 0.height(context),
      child: Stack(
        alignment: Alignment.center,
        children: [
          Positioned(child: SizedBox(
            width: 0.width(context),
            height: 0.height(context),
            child: Column(
              children: [
                SizedBox(height: 120.h,),
                SJImg(name: 'sj_box_top_title', width: 357.w, height: 134.h,),
              ],
            ),
          )),
          Visibility(
            visible: true,
            child: Positioned(
              left: 0.w, top: 400.h,
              width: 174.0.w,
              height: 141.0.h,
              child: spine.SpineWidget.fromAsset('assets/spine/l.atlas', 'assets/spine/l.json', _controller0),
            ),
          ),
          Visibility(
            visible: true,
            child: Positioned(
              left: 20.w, top: 428.h,
              width: 137.0.w,
              height: 113.0.h,
              child: InkWell(
                  onTap: (){
                    open_index = doals_one;
                    _openOne = true;
                    openBox();
                  },
                  child: spine.SpineWidget.fromAsset(_openOne ? 'assets/spine/box.atlas' : 'assets/spine/box1.atlas', _openOne ? 'assets/spine/box.json' : 'assets/spine/box1.json', _controller1)
              ),
            ),
          ),
          Visibility(
            visible: _openOne,
            child: Positioned(
              left: 62.w, top: 510.h,
              width: 120.0.w,
              height: 30.h,
              child: SizedBox(
                width: 120.0.w,
                height: 30.h,
                child: Row(
                  children: [
                    SizedBox(width: 10.w,),
                    SJGradientNumberRoller(
                      value: doals_one,
                      duration: 1000,
                      fontSize: 24.0.sp,
                      gradientColors: ['#FFE386'.color(), '#FFFFFF'.color()],
                      borderColor: '#601D09'.color(),
                      borderWidth: 1.0,
                      decimalPlaces: 0, // 动态调整小数位
                    ),
                  ],
                ),
              ),
            ),
          ),
          Visibility(
            visible: true,
            child: Positioned(
              right: 0.w, top: 400.h,
              width: 174.0.w,
              height: 141.0.h,
              child: spine.SpineWidget.fromAsset('assets/spine/l.atlas', 'assets/spine/l.json', _controller2),
            ),
          ),
          Visibility(
            visible: true,
            child: Positioned(
              right: 20.w, top: 428.h,
              width: 137.0.w,
              height: 113.0.h,
              child: InkWell(
                onTap: (){
                  open_index = doals_two;
                  _openTwo = true;
                  openBox();
                },
                child: spine.SpineWidget.fromAsset(_openTwo ? 'assets/spine/box.atlas' : 'assets/spine/box1.atlas', _openTwo ? 'assets/spine/box.json' : 'assets/spine/box1.json', _controller3),
              ),
            ),
          ),
          Visibility(
            visible: _openTwo,
            child: Positioned(
              right: 60.w, top: 510.h,
              width: 120.0.w,
              height: 30.h,
              child: SizedBox(
                width: 120.0.w,
                height: 30.h,
                child: Row(
                  children: [
                    SizedBox(width: 75.w,),
                    SJGradientNumberRoller(
                      value: doals_two,
                      duration: 1000,
                      fontSize: 24.0.sp,
                      gradientColors: ['#FFE386'.color(), '#FFFFFF'.color()],
                      borderColor: '#601D09'.color(),
                      borderWidth: 1.0,
                      decimalPlaces: 0, // 动态调整小数位
                    ),
                  ],
                ),
              ),
            ),
          ),
          Visibility(
            visible: true,
            child: Positioned(
              right: (0.width(context) - 174.0.w) * 0.5, top: 248.h,
              width: 174.0.w,
              height: 141.0.h,
              child: spine.SpineWidget.fromAsset('assets/spine/l.atlas', 'assets/spine/l.json', _controller4),
            ),
          ),
          Visibility(
            visible: true,
            child: Positioned(
              right: (0.width(context) - 137.0.w) * 0.5, top: 280.h,
              width: 137.0.w,
              height: 113.0.h,
              child: InkWell(
                onTap: (){
                  open_index = doals_three;
                  _openThree = true;
                  openBox();
                },
                child: spine.SpineWidget.fromAsset(_openThree ? 'assets/spine/box.atlas' : 'assets/spine/box1.atlas', _openThree ? 'assets/spine/box.json' : 'assets/spine/box1.json', _controller5),
              ),
            ),
          ),
          Visibility(
            visible: _openThree,
            child: Positioned(
              right: (0.width(context) - 120.w) * 0.5, top: 364.h,
              width: 120.0.w,
              height: 30.h,
              child: SizedBox(
                width: 120.0.w,
                height: 30.h,
                child: Row(
                  children: [
                    SizedBox(width: 40.w,),
                    SJGradientNumberRoller(
                      value: doals_three,
                      duration: 1000,
                      fontSize: 24.0.sp,
                      gradientColors: ['#FFE386'.color(), '#FFFFFF'.color()],
                      borderColor: '#601D09'.color(),
                      borderWidth: 1.0,
                      decimalPlaces: 0, // 动态调整小数位
                    ),
                  ],
                ),
              ),
            ),
          ),
          Visibility(
            visible: _showanimation,
            child: Positioned(
                left: 18.w, top: 525.h,
                width: 142.0.w,
                height: 42.0.h,
                child: InkWell(
                  onTap: (){
                    open_index = doals_one;
                    _openOne = true;
                    openBox();
                  },
                  child: Container(decoration: BoxDecoration(
                      image: SJDImg('sj_open_btn')
                  ),
                  ),
                )
            ),
          ),
          Visibility(
            visible: _showanimation,
            child: Positioned(
                right: 18.w, top: 525.h,
                width: 142.0.w,
                height: 42.0.h,
                child: InkWell(
                  onTap: (){
                    open_index = doals_two;
                    _openTwo = true;
                    openBox();
                  },
                  child: Container(decoration: BoxDecoration(
                      image: SJDImg('sj_open_btn')
                  ),
                  ),
                )
            ),
          ),
          Visibility(
            visible: _showanimation,
            child: Positioned(
                right: (0.width(context) - 142.0.w) * 0.5, top: 375.h,
                width: 142.0.w,
                height: 42.0.h,
                child: InkWell(
                  onTap: (){
                    open_index = doals_three;
                    _openThree = true;
                    openBox();
                  },
                  child: Container(decoration: BoxDecoration(
                      image: SJDImg('sj_open_btn')
                  ),
                  ),
                )
            ),
          ),
          // Visibility(
          //   visible: _showanimation,
          //   child: Positioned(
          //       left: 120.w, top: 508.h,
          //       width: 60.0,
          //       height: 60.0,
          //       child: InkWell(
          //         onTap: (){
          //           open_index = 0;
          //           _openOne = true;
          //           openBox();
          //         },
          //         child: spine.SpineWidget.fromAsset('assets/spine/hand1.atlas', 'assets/spine/hand1.json', _controller6),
          //       )
          //   ),
          // ),
          // Visibility(
          //   visible: _showanimation,
          //   child: Positioned(
          //       right: 15.w, top: 508.h,
          //       width: 60.0,
          //       height: 60.0,
          //       child: InkWell(
          //         onTap: (){
          //           open_index = 1;
          //           _openTwo = true;
          //           openBox();
          //         },
          //         child: spine.SpineWidget.fromAsset('assets/spine/hand1.atlas', 'assets/spine/hand1.json', _controller7),
          //       )
          //   ),
          // ),
          // Visibility(
          //   visible: _showanimation,
          //   child: Positioned(
          //       right: (0.width(context) - 100) * 0.39, top: 370.h,
          //       width: 60.0,
          //       height: 60.0,
          //       child: InkWell(
          //         onTap: (){
          //           open_index = 2;
          //           _openThree = true;
          //           openBox();
          //         },
          //         child: spine.SpineWidget.fromAsset('assets/spine/hand1.atlas', 'assets/spine/hand1.json', _controller8),
          //       )
          //   ),
          // ),
          Visibility(
            visible: _showBottom,
            child: Positioned(
                right: (0.width(context) - 260.w) * 0.5, top: 550.h,
                width: 260.0.w,
                height: 74.0.h,
                child: Container(
                  width: 260.0.w,
                  height: 74.0.h,
                  decoration: BoxDecoration(
                      image: SJDImg('sj_claimall_btn')
                  ),
                  child: Stack(
                    children: [
                      Center(
                        child: InkWell(
                            onTap: (){
                              sj_event_fire('box_pop_claim', {});
                              SJAdManager().sj_showAd(false,'scxji_boxreward_rv', context, (hasCache){
                                if (!hasCache) {

                                }
                              }, (finished) async {
                                var value = doals_one + doals_two + doals_three;
                                 SJLocalProvider.instance.updateint(SJLocalProvider.instance.sj_box_indexName, 0);
                                 SJLocalProvider.instance.updateint(SJLocalProvider.instance.sj_tx_box_indexName, SJLocalProvider.instance.sj_tx_box_index + 1);
                                 SJLocalProvider.instance.updateint(SJLocalProvider.instance.sj_dolas_numberName, (SJLocalProvider.instance.sj_dolas_number + value).toInt());
                              });
                              Navigator.pop(context, 0);
                            }
                        ),
                      ),
                    ],
                  ),
                )
            ),
          ),
          Visibility(
            visible: _showBottom,
            child: Positioned(
                right: (0.width(context) - 200) * 0.5, top: 652.h,
                width: 200.0,
                height: 52.0,
                child: SJUnderlineTextButton(text: 'Claim \$${open_index}', fontSize: 20.sp,gradientColors: ['#BE982A'.color(),'#FFE9A3'.color(),'#FFF6D7'.color(),'#FFF0B4'.color()], underlineColor: '#C5A213'.color(), onPressed: () async {
                  sj_event_fire('box_pop_claim', {});
                  if (SJNumberHelpers().checkProbability()){
                    SJAdManager().sj_showAd(true,'scxji_boxreward_int', context, (hasCache){
                      if (!hasCache) {

                      }
                    }, (finished) async {
                      var value = 0.0;
                      if (_openOne){
                        value = doals_one;
                      } else if (_openTwo){
                        value = doals_two;
                      } else {
                        value = doals_three;
                      }
                       SJLocalProvider.instance.updateint(SJLocalProvider.instance.sj_box_indexName, 0);
                       SJLocalProvider.instance.updateint(SJLocalProvider.instance.sj_tx_box_indexName, SJLocalProvider.instance.sj_tx_box_index + 1);
                       SJLocalProvider.instance.updateint(SJLocalProvider.instance.sj_dolas_numberName, (SJLocalProvider.instance.sj_dolas_number + value).toInt());
                    });
                  } else {

                    var value = 0.0;
                    if (_openOne){
                      value = doals_one;
                    } else if (_openTwo){
                      value = doals_two;
                    } else {
                      value = doals_three;
                    }
                     SJLocalProvider.instance.updateint(SJLocalProvider.instance.sj_box_indexName, 0);
                     SJLocalProvider.instance.updateint(SJLocalProvider.instance.sj_tx_box_indexName, SJLocalProvider.instance.sj_tx_box_index + 1);
                     SJLocalProvider.instance.updateint(SJLocalProvider.instance.sj_dolas_numberName, (SJLocalProvider.instance.sj_dolas_number + value).toInt());
                  }
                  Navigator.pop(context, 0);
                },)
            ),
          ),
          Visibility(
            visible: _showBottom,
            child: Positioned(
                right: 43.w, top: 535.h,
                width: 70,
                height: 70,
                child: SJImg(name: 'sj_rv_icon', width: 70, height: 70,)
            ),
          ),
        ],
      ),
    );
  }

}
// 老用户宝箱
class SJBoxOldDiaologWidget extends StatefulWidget {
  SJBoxOldDiaologWidget({super.key});
  @override
  State<SJBoxOldDiaologWidget> createState() => SJBoxOldDiaologWidgetState();
}

class SJBoxOldDiaologWidgetState extends State<SJBoxOldDiaologWidget> with SingleTickerProviderStateMixin {

  var _showanimation = true;

  var _showBottom = false;

  var _openOne = false;

  var doals_one = 20.0;

  var open_index = 0.0;

  late spine.SpineWidgetController _controller0;

  late spine.SpineWidgetController _controller1;

  late spine.SpineWidgetController _controller2;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    sj_event_fire('box_pop_nu', {});

    _controller0 = spine.SpineWidgetController(onInitialized: (controller) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        controller.animationState.setAnimationByName(0, "animation", true);
      });
    });

    _controller1 = spine.SpineWidgetController(onInitialized: (controller) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        controller.animationState.setAnimationByName(0, "animation", true);
      });
    });

    _controller2 = spine.SpineWidgetController(onInitialized: (controller) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        controller.animationState.setAnimationByName(0, "animation", true);
      });
    });

  }

  openBox(){
    setState(() {
      _showBottom = true;
      _showanimation = false;
    });
    Future.delayed(Duration(milliseconds: 1200), (){
      setState(() {
        if (!_openOne){
          _openOne = true;
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 0.width(context),
      height: 0.height(context),
      child: Stack(
        alignment: Alignment.center,
        children: [
          Positioned(child: SizedBox(
            width: 0.width(context),
            height: 0.height(context),
            child: Column(
              children: [
                SizedBox(height: 120.h,),
                Container(
                  width: 357.w, height: 134.h,
                  decoration: BoxDecoration(
                    image: SJDImg('sj_box_title2')
                  ),
                  child: Column(
                    children: [
                      SizedBox(height: 62.h,),
                      SJGradientStrokeText(text: randomTitle(), gradientColors: ['#FFFFFF'.color(),'#FFEB88'.color()], width: 261.w, height: 29.h, fontSize: 24, strokeWidth: 1, strokeColor: '#6A2C1B'.color(),)
                    ],
                  ),
                )
              ],
            ),
          )),
          Visibility(
            visible: true,
            child: Positioned(
              left: (0.width(context) - 250.w) * 0.5, top: 260.h,
              width: 250.0.w,
              height: 250.0.h,
              child: spine.SpineWidget.fromAsset('assets/spine/l.atlas', 'assets/spine/l.json', _controller0),
            ),
          ),
          Visibility(
            visible: true,
            child: Positioned(
              left: (0.width(context) - 157.w) * 0.5, top: 320.h,
              width: 157.0.w,
              height: 133.0.h,
              child: InkWell(
                  onTap: (){
                    open_index = doals_one;
                    _openOne = true;
                    openBox();
                  },
                  child: spine.SpineWidget.fromAsset(_openOne ? 'assets/spine/box.atlas' : 'assets/spine/box1.atlas', _openOne ? 'assets/spine/box.json' : 'assets/spine/box1.json', _controller1)
              ),
            ),
          ),
          Visibility(
            visible: _openOne,
            child: Positioned(
              left: (0.width(context) - 80.w) * 0.5, top: 438.h,
              width: 120.0.w,
              height: 40.h,
              child: SizedBox(
                width: 120.0.w,
                height: 30.h,
                child: Row(
                  children: [
                    SizedBox(width: 10.w,),
                    SJGradientNumberRoller(
                      value: doals_one,
                      duration: 1000,
                      fontSize: 32.0.sp,
                      gradientColors: ['#FFE386'.color(), '#FFFFFF'.color()],
                      borderColor: '#601D09'.color(),
                      borderWidth: 1.0,
                      decimalPlaces: 0, // 动态调整小数位
                    ),
                  ],
                ),
              ),
            ),
          ),
          Visibility(
            visible: _showanimation,
            child: Positioned(
                left: (0.width(context) - 142.w) * 0.5, top: 438.h,
                width: 142.0.w,
                height: 42.0.h,
                child: InkWell(
                  onTap: (){
                    open_index = doals_one;
                    _openOne = true;
                    openBox();
                  },
                  child: Container(decoration: BoxDecoration(
                      image: SJDImg('sj_open_btn')
                  ),
                  ),
                )
            ),
          ),
          Visibility(
            visible: _showBottom,
            child: Positioned(
                right: (0.width(context) - 260.w) * 0.5, top: 550.h,
                width: 260.0.w,
                height: 74.0.h,
                child: Container(
                  width: 260.0.w,
                  height: 74.0.h,
                  decoration: BoxDecoration(
                      image: SJDImg('sj_claimall_btn')
                  ),
                  child: Stack(
                    children: [
                      Center(
                        child: InkWell(
                            onTap: (){
                              sj_event_fire('box_pop_c', {});
                              if (SJNumberHelpers().checkProbability()){
                                SJAdManager().sj_showAd(true,'scxji_dailyolduser_int', context, (hasCache){
                                  if (!hasCache) {

                                  }
                                }, (finished) async {
                                  var value = 0.0;
                                  if (_openOne){
                                    value = doals_one;
                                  }
                                  SJLocalProvider.instance.updateint(SJLocalProvider.instance.sj_box_indexName, 0);
                                  SJLocalProvider.instance.updateint(SJLocalProvider.instance.sj_tx_box_indexName, SJLocalProvider.instance.sj_tx_box_index + 1);
                                  SJLocalProvider.instance.updateint(SJLocalProvider.instance.sj_dolas_numberName, (SJLocalProvider.instance.sj_dolas_number + value).toInt());
                                });
                              } else {

                                var value = 0.0;
                                if (_openOne){
                                  value = doals_one;
                                }
                                SJLocalProvider.instance.updateint(SJLocalProvider.instance.sj_box_indexName, 0);
                                SJLocalProvider.instance.updateint(SJLocalProvider.instance.sj_dolas_numberName, (SJLocalProvider.instance.sj_dolas_number + value).toInt());
                              }
                              Navigator.pop(context, 0);
                            }
                        ),
                      ),
                    ],
                  ),
                )
            ),
          ),
        ],
      ),
    );
  }

  String randomTitle() {
    const titles = [
      "Ready！Set！ Cash！",
      "You've Got Mail!",
      "Lookin' Sharp!",
      "Claim Your Daily Bonus!",
      "Daily Wealth Moment！",
    ];

    return titles[Random().nextInt(titles.length)];
  }

}
///******************** A **************************///
class SJDialogTool {
  // tosat
  static void toast(BuildContext buildContext, String text) async {
    await showAndroidToast(
      padding: 0.0.all(16),
      margin: 0.0.all(32),
      alignment: Alignment.center,
      backgroundColor: '#000000'.color(opacity: 0.8),
      duration: Duration(seconds: 2),
      child: Text(
        text,
        style: TextStyle(
          color: Colors.white,
          fontSize: 15,
          fontWeight: FontWeight.w700,
        ),
      ),
      context: buildContext,
    );
  }

  static void toastRanking(BuildContext buildContext, int num) async {
    await showAndroidToast(
      padding: 0.0.all(0),
      margin: 0.0.all(0),
      backgroundColor: Colors.transparent,
      alignment: Alignment.center,
      duration: Duration(seconds: 3),
      child: Container(
        width: 205,
        height: 50.5,
        decoration: BoxDecoration(
          color: '#000000'.color(opacity: 0.8),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Center(
          child: RichText(
            textAlign: TextAlign.center,
            text: TextSpan(
              style: const TextStyle(
                fontSize: 14.0,
                fontWeight: FontWeight.w500,
              ),
              children: <TextSpan>[
                TextSpan(
                  text: 'Your Current rank: ',
                  style: TextStyle(color: Colors.white),
                ),
                TextSpan(
                  text: '$num',
                  style: TextStyle(color: '#16FF16'.color(), fontSize: 14),
                ),
              ],
            ),
          ),
        ),
      ),
      context: buildContext,
    );
  }
}
// 无骰子🎲
class SJPopNotdiceDialog extends StatefulWidget {
  SJPopNotdiceDialog({super.key});
  @override
  State<SJPopNotdiceDialog> createState() => SJPopNotdiceDialogState();
}

class SJPopNotdiceDialogState extends State<SJPopNotdiceDialog> {


  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      if (SJLocalProvider.instance.sj_sound_music){
        await SJMP3Player().pauseBackground();
        await SJMP3Player().playEffect2();
      }
      Future.delayed(Duration(milliseconds: 400), () async {
        await SJMP3Player().pauseEffect2();
        if (SJLocalProvider.instance.sj_bg_music){
          await SJMP3Player().playBackground();
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 0.width(context),
      height: 0.height(context),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 322,
            height: 52,
            decoration: BoxDecoration(
              image: SJDImg('sj_not_dice_top')
            ),
            child: Center(
              child: SJText(text: 'Not Enough Dice To Roll', size: 24, color: '#0A2946'.color(), weight: FontWeight.w400),
            ),
          ),
          SizedBox(height: 48.h,),
          Container(
            width: 125,
            height: 125,
            decoration: BoxDecoration(
              image: SJDImg('sj_shai_cenrer_bg')
            ),
            child: Center(
              child: SJImg(name: 'dice_1', width: 87, height: 87,),
            ),
          ),
          SizedBox(height: 58.h,),
          InkWell(
            onTap: (){
              sj_event_fire('dice_page_not_find', {});
              // 返回根目录进度最近进入的页面
              Navigator.pop(context);
              // 根目录
              Navigator.of(context).popUntil((route) => route.isFirst);
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (builder) {
                    return SJScratchA(
                        type: history_index);
                  },
                ),
              );
            },
            child: SJImg(name: 'sj_find_btn', width: 260, height: 74,),
          )
        ],
      ),
    );
  }

}
// 骰子🎲奖励
class SJPopYouWinADialog extends StatefulWidget {
  final int award;
  SJPopYouWinADialog({super.key, required this.award});
  @override
  State<SJPopYouWinADialog> createState() => SJPopdiceAwardDialogState();
}

class SJPopdiceAwardDialogState extends State<SJPopYouWinADialog>
    with TickerProviderStateMixin {
  late final AnimationController _controller;
  late final AnimationController _scaleController;
  late final Animation<double> _scaleAnimation;
  late final AnimationController _scaleController2;
  late final Animation<double> _scaleAnimation2;

  @override
  void initState() {
    super.initState();

    // 匀速旋转动画
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 6),
    )..repeat();

    // 顶部图片放大缩小动画 ✅ 修复版
    _scaleController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    )..repeat(reverse: true);

    _scaleAnimation = Tween(begin: 1.0, end: 1.2)
        .animate(CurvedAnimation(parent: _scaleController, curve: Curves.easeInOut));

    _scaleController2 = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    )..repeat(reverse: true);

    _scaleAnimation2 = Tween(begin: 1.0, end: 1.2)
        .animate(CurvedAnimation(parent: _scaleController, curve: Curves.easeInOut));

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      if (SJLocalProvider.instance.sj_sound_music){
        await SJMP3Player().pauseBackground();
        await SJMP3Player().playEffect4();
      }
      Future.delayed(Duration(milliseconds: 1000), () async {
        await SJMP3Player().pauseEffect4();
        if (SJLocalProvider.instance.sj_bg_music){
          await SJMP3Player().playBackground();
        }
      });
    });
  }

  void playAwardmp3(){
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      if (SJLocalProvider.instance.sj_sound_music){
        await SJMP3Player().pauseBackground();
        await SJMP3Player().playEffect3();
      }
      Future.delayed(Duration(milliseconds: 1300), () async {
        await SJMP3Player().pauseEffect3();
        if (SJLocalProvider.instance.sj_bg_music){
          await SJMP3Player().playBackground();
        }
      });
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    _scaleController.dispose();
    _scaleController2.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 0.width(context),
      height: 0.height(context),
      child: Stack(
        children: [
          // ✅ 顶部加放大缩小动画
          Positioned(
            top: 257.h,
            left: (0.width(context) - 267) * 0.5,
            child: ScaleTransition(
              scale: _scaleAnimation,
              child: SJImg(
                name: 'sj_dice_tops',
                width: 267,
                height: 63,
              ),
            ),
          ),

          // 其余完全不变 ↓
          Positioned(top: 147.h, child: ScaleTransition(scale: _scaleAnimation2,child: SJImg(name: 'sj_dice_conten_1', width: 0.width(context), height: 441.h))),
          Positioned(
            top: 310.h,
            left: (MediaQuery.of(context).size.width - 222) * 0.5,
            child: RotationTransition(
              turns: _controller,
              child: SJImg(name: 'sj_dice_conten_2', width: 222, height: 222),
            ),
          ),
          Positioned(top: 295.h, left: (0.width(context) - 211) * 0.5, child: SJImg(name: 'sj_dice_conten_3', width: 211, height: 211)),
          Positioned(top: 438.h, width: 0.width(context), height:30,child: SJGradientStrokeText(text: '${widget.award}', gradientColors: ['#FFFFFF'.color(),'#FFFB8E'.color()], fontSize: 40, strokeWidth: 2, strokeColor: '#3F1D05'.color(), width: 260, height: 42,)),
          Positioned(top: 560.h,left: (0.width(context) - 260) * 0.5, child: InkWell(
              onTap: (){
                Navigator.pop(context, 1);
                SJAdAHelper().show(context, (hasCache){
                  if (!hasCache){
                    SJAdAHelper().resetBlock();
                  }
                }, (finished) async {
                  SJAdAHelper().resetBlock();
                  playAwardmp3();
                  Navigator.pop(context);
                  await SJLocalProvider.instance.updateint(SJLocalProvider.instance.sj_domand_numberName, SJLocalProvider.instance.sj_domand_number + (widget.award * 2));
                });
              },
              child: Container(
                width: 260, height: 74,
                decoration: BoxDecoration(image: SJDImg('sj_dice_btn_bg')),
                child: Stack(
                  children: [
                    Positioned(top: 18,child: SJGradientStrokeText(text: 'Claim ${widget.award * 2}', gradientColors: ['#BE982A'.color(),'#FFE9A3'.color(),'#FFF6D7'.color(),'#FFF0B4'.color(),], fontSize: 32, strokeWidth: 2, strokeColor: '#000000'.color(),width: 260, height: 40,),)
                  ],
                ),
              )
          )),
          Positioned(
            top: 542.h,
            right: 60.w,
            child: InkWell(
                onTap: (){
                  // 看ad-重新刷新
                  SJAdAHelper().show(context, (hasCache){
                    if (!hasCache){
                      SJAdAHelper().resetBlock();
                    }
                  }, (finished) async {
                    SJAdAHelper().resetBlock();
                    playAwardmp3();
                    Navigator.pop(context);
                    await SJLocalProvider.instance.updateint(SJLocalProvider.instance.sj_domand_numberName, SJLocalProvider.instance.sj_domand_number + (widget.award * 2));
                  });
                },
                child: SJImg(name: 'sj_rv_icon', width: 70, height: 70,)),
          ),
          Positioned(top: 560.h + 74,left: (0.width(context) - 260) * 0.5, child: InkWell(
            onTap: () async {
              playAwardmp3();
              Navigator.pop(context, 0);
              await SJLocalProvider.instance.updateint(SJLocalProvider.instance.sj_domand_numberName, SJLocalProvider.instance.sj_domand_number + widget.award);
            },
            child: SizedBox(width: 260, height:74,child: SJUnderlineTextButton(text: '${widget.award}', fontSize: 24.spMin, underlineColor: '#C5A213'.color(),gradientColors: ['#BE982A'.color(),'#FFE9A3'.color(),'#FFF6D7'.color(),'#FFF0B4'.color(),],)),
          )),
        ],
      ),
    );
  }
}

// 设置
class SJPopSettingDialog extends StatefulWidget {
  SJPopSettingDialog({super.key});
  @override
  State<SJPopSettingDialog> createState() => SJPopSettingDialogState();
}

class SJPopSettingDialogState extends State<SJPopSettingDialog> {

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 0.width(context),
      height: 0.height(context),
      child: Stack(
        alignment: Alignment.center,
        children: [
          Container(
            width: 255.w,
            height: 362.h,
            decoration: BoxDecoration(
                image: SJDImg('sj_set_bg')
            ),
            child: Column(
              children: [
                SizedBox(height: 20.h,),
                SJStrokeText(text: 'Settings', size: 24, color: '#FFFEE8'.color(), weight: FontWeight.w400, skWidth: 1, skColor: '#000000'.color()),
                SizedBox(height: 25.0.h,),
                Row(
                  children: [
                    SizedBox(width: 31.w,),
                    Container(
                      width: 193.w,
                      height: 60.h,
                      decoration: BoxDecoration(
                          image: SJDImg('sj_center_bg')
                      ),
                      child: Row(
                            children: [
                              SizedBox(width: 32.w,),
                              SJImg(name: 'sj_sound_icon', width: 31, height: 31,),
                              SizedBox(width: 7.w,),
                              SJText(text: 'Sound', size: 14, color: '#F4D896'.color(), weight: FontWeight.w400),
                              Spacer(),
                              SizedBox(
                                width: 60,
                                height: 40,
                                child: InkWell(
                                  onTap: () async {
                                    if (SJLocalProvider.instance.sj_sound_music){
                                      await SJLocalProvider.instance.updateBool(SJLocalProvider.instance.sj_sound_musicName, false);
                                    } else {
                                      await SJLocalProvider.instance.updateBool(SJLocalProvider.instance.sj_sound_musicName, true);
                                    }
                                    setState(() {});
                                  },
                                  child: Center(child: SJImg(name: SJLocalProvider.instance.sj_sound_music ? 'sj_on_btn' : 'sj_off_btn', width: 57, height: 22,)),
                                ),
                              ),
                              SizedBox(width: 20.w,),
                            ],
                          ),
                    ),
                  ],
                ),
                SizedBox(height: 10.0.h,),
                Row(
                  children: [
                    SizedBox(width: 31.w,),
                    Container(
                      width: 193.w,
                      height: 60.h,
                      decoration: BoxDecoration(
                          image: SJDImg('sj_center_bg')
                      ),
                      child: Row(
                            children: [
                              SizedBox(width: 32.w,),
                              SJImg(name: 'sj_music_icon', width: 31, height: 31,),
                              SizedBox(width: 7.w,),
                              SJText(text: 'Music', size: 14, color: '#F4D896'.color(), weight: FontWeight.w400),
                              Spacer(),
                              SizedBox(
                                width: 60,
                                height: 40,
                                child: InkWell(
                                  onTap: () async {
                                    if (SJLocalProvider.instance.sj_bg_music){
                                      await SJMP3Player().pauseBackground();
                                      await SJLocalProvider.instance.updateBool(SJLocalProvider.instance.sj_bg_musicName,false);
                                    } else {
                                      await SJMP3Player().playBackground();
                                      await SJLocalProvider.instance.updateBool(SJLocalProvider.instance.sj_bg_musicName,true);
                                    }
                                    setState(() {});
                                  },
                                  child: Center(child: SJImg(name: SJLocalProvider.instance.sj_bg_music ? 'sj_on_btn' : 'sj_off_btn', width: 57, height: 22,)),
                                ),
                              ),
                              SizedBox(width: 20.w,),
                            ],
                          ),
                    ),
                  ],
                ),
                SizedBox(height: 21.12.h,),
                Container(
                  width: 197,
                  height: 56,
                  decoration: BoxDecoration(
                      image: SJDImg('sj_tohome_btn')
                  ),
                  child: InkWell(
                    onTap: (){
                      Navigator.of(context).pop();
                    },
                  ),
                ),
                SizedBox(height: 11.12.h,),
                Container(
                  width: 197,
                  height: 56,
                  decoration: BoxDecoration(
                      image: SJDImg('sj_prvity_btn')
                  ),
                  child: InkWell(
                    onTap: (){
                      Navigator.of(context).pop();
                      Navigator.of(context).push(
                        MaterialPageRoute(builder: (builder) {
                          return SJwebkitview(
                            url: "https://sites.google.com/view/130scratchjoyprivacy-policy/home",
                            title: 'Privacy Policy',
                          );
                        }),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
          Positioned(
            right: 48.w,
            top: (0.height(context) - 362.h) * 0.48,
            width: 45,
            height: 48,
            child: InkWell(onTap: (){
              Navigator.pop(context);
            }, child: SJImg(name: 'sj_close_btn')),
          ),
        ],
      ),
    );
  }

}

class SJPopUnluckADialog extends StatefulWidget {
  final int type;
  SJPopUnluckADialog({super.key, required this.type});
  @override
  State<SJPopUnluckADialog> createState() => SJPopUnluckADialogState();
}

class SJPopUnluckADialogState extends State<SJPopUnluckADialog>
    with TickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();

    // 匀速旋转动画
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 6),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 0.width(context),
      height: 0.height(context),
      child: Stack(
        children: [
          // ✅ 顶部加放大缩小动画
          Positioned(
            top: 158.h,
            left: (0.width(context) - 342) * 0.5,
            child: RotationTransition(
              turns: _controller,
              child: SJImg(
                name: 'sj_unluck_bg',
                width: 342,
                height: 341,
              ),
            ),
          ),

          // 其余完全不变 ↓
          Positioned(top: 224.h, left: (0.width(context) - 280) * 0.5, child: SJImg(name: 'sj_unluck_center', width: 280, height: 163)),
          Positioned(
            top: 440.h,
            left: (MediaQuery.of(context).size.width - 260) * 0.5,
            child: InkWell(
              onTap: (){
                Navigator.pop(context, 1);
                // 看ad-重新刷新
                SJAdManager().sj_showAd(false, 'scxji_unlock_rv', context, (hasCache){}, (finished){
                  unlocklevelsluck();
                });

              }, child: SJImg(name: 'sj_frees_btn', width: 260, height: 74)),
          ),
          Positioned(
            top: 420.h,
            right: 60.w,
            child: InkWell(
                onTap: (){
                  // 看ad-重新刷新
                  SJAdManager().sj_showAd(false, 'scxji_unlock_rv', context, (hasCache){}, (finished){
                    unlocklevelsluck();
                  });
                },
                child: SJImg(name: 'sj_rv_icon', width: 70, height: 70,)),
          ),
          Positioned(top: 528.h,left: (0.width(context) - 124) * 0.5, child: InkWell(
            onTap: () async {
               if (SJLocalProvider.instance.sj_domand_number >= 1000){
                 await SJLocalProvider.instance.updateint(SJLocalProvider.instance.sj_domand_numberName, SJLocalProvider.instance.sj_domand_number - 1000);
                 unlocklevelsluck();
               } else {
                 Navigator.pop(context);
                 SJDialogTool.toast(context, 'Not enough coins? Go play games to earn more!');
               }
            },
            child: SJImg(name: 'sj_spend_btn', width: 124, height: 22,),
          )),
        ],
      ),
    );
  }

  Future<void> unlocklevelsluck() async {
    if (widget.type == 0){
      await SJLocalProvider.instance.updateint(SJLocalProvider.instance.sj_scrach_end_number_0Name, 0);
      await SJLocalProvider.instance.updateString(SJLocalProvider.instance.sj_Scratch_timeKey_0Name, '');
    } else if (widget.type == 1){
      await SJLocalProvider.instance.updateint(SJLocalProvider.instance.sj_scrach_end_number_1Name, 0);
      await SJLocalProvider.instance.updateString(SJLocalProvider.instance.sj_Scratch_timeKey_1Name, '');
    } else if (widget.type == 2){
      await SJLocalProvider.instance.updateint(SJLocalProvider.instance.sj_scrach_end_number_2Name, 0);
      await SJLocalProvider.instance.updateString(SJLocalProvider.instance.sj_Scratch_timeKey_2Name, '');
    } else if (widget.type == 3){
      await SJLocalProvider.instance.updateint(SJLocalProvider.instance.sj_scrach_end_number_3Name, 0);
      await SJLocalProvider.instance.updateString(SJLocalProvider.instance.sj_Scratch_timeKey_3Name, '');
    } else if (widget.type == 4){
      await SJLocalProvider.instance.updateint(SJLocalProvider.instance.sj_scrach_end_number_4Name, 0);
      await SJLocalProvider.instance.updateString(SJLocalProvider.instance.sj_Scratch_timeKey_4Name, '');
    } else if (widget.type == 5){
      await SJLocalProvider.instance.updateint(SJLocalProvider.instance.sj_scrach_end_number_5Name, 0);
      await SJLocalProvider.instance.updateString(SJLocalProvider.instance.sj_Scratch_timeKey_5Name, '');
    } else if (widget.type == 6){
      await SJLocalProvider.instance.updateint(SJLocalProvider.instance.sj_scrach_end_number_6Name, 0);
      await SJLocalProvider.instance.updateString(SJLocalProvider.instance.sj_Scratch_timeKey_6Name, '');
    }
    if (!mounted) return; // ✅ 页面已经被销毁就直接返回
    Navigator.pop(context);
  }
}
// 未中奖
class SJPopUnAwardDialog extends StatefulWidget {
  SJPopUnAwardDialog({super.key});
  @override
  State<SJPopUnAwardDialog> createState() => SJPopUnAwardDialogState();
}

class SJPopUnAwardDialogState extends State<SJPopUnAwardDialog> {
  late spine.SpineWidgetController _controller;

  @override
  void initState() {
    super.initState();
    sj_event_fire('scratch_card_fail_pop', {});
    _controller = spine.SpineWidgetController(onInitialized: (controller) {
      WidgetsBinding.instance.addPostFrameCallback((_) async {
        controller.animationState.setAnimationByName(0, "animation", true);
        if (SJLocalProvider.instance.sj_sound_music){
          await SJMP3Player().pauseBackground();
          await SJMP3Player().playEffect2();
        }
        Future.delayed(Duration(milliseconds: 400), () async {
          await SJMP3Player().pauseEffect2();
          if (SJLocalProvider.instance.sj_bg_music){
            await SJMP3Player().playBackground();
          }
        });
      });
    });

  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 0.width(context),
      height: 0.height(context),
      child: Stack(
        children: [
          // ✅ 顶部加放大缩小动画
          Positioned(
            top: 222.h,
            child:  SJImg(
                name: 'sj_not_bgs',
                width: 0.width(context),
                height: 234,
            ),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Center(child: SizedBox(width: 125, height:125, child: spine.SpineWidget.fromAsset('assets/spine/cry.atlas', 'assets/spine/cry.json', _controller))),
              SizedBox(height: 28.h,),
              Center(child: SJText(text: 'A Large Bonus Was Missed', size: 24, color: '#FFFFFF'.color(), weight: FontWeight.w400)),
              SizedBox(height: 43.h,),
              Center(
                child: InkWell(
                  onTap: (){
                    sj_event_fire('scratch_card_fail_pop_c', {});
                    Navigator.pop(context, 0);
                  },
                  child: SJImg(name: 'sj_playagin_btn', width: 262, height: 76,),
                ),
              )
            ],
          )
        ],
      ),
    );
  }
}
// 升级
class SJPopLevelADialog extends StatefulWidget {
  SJPopLevelADialog({super.key});
  @override
  State<SJPopLevelADialog> createState() => SJPopLevelADialogState();
}

class SJPopLevelADialogState extends State<SJPopLevelADialog>
    with TickerProviderStateMixin {
  late final AnimationController _controller;
  Timer? _timer;

  @override
  void initState() {
    super.initState();

    // 匀速旋转动画
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 6),
    )..repeat();

    _timer = Timer(const Duration(milliseconds: 2000), () {
      Navigator.pop(context);
    });
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      if (SJLocalProvider.instance.sj_sound_music){
        await SJMP3Player().pauseBackground();
        await SJMP3Player().playEffect9();
      }
      Future.delayed(Duration(milliseconds: 1000), () async {
        await SJMP3Player().pauseEffect9();
        if (SJLocalProvider.instance.sj_bg_music){
          await SJMP3Player().playBackground();
        }
      });
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 0.width(context),
      height: 0.height(context),
      child: Stack(
        children: [
          // ✅ 顶部加放大缩小动画
          Positioned(
            top: 173.h,
            left: (0.width(context) - 360) * 0.5,
            child:  Center(
              child: RotationTransition(
                turns: _controller,
                child: SJImg(
                  name: 'sj_guangs_icon',
                  width: 360,
                  height: 359,
                ),
              ),
            ),
          ),
          Positioned(
            top: 244.h,
            left: (0.width(context) - 354) * 0.5,
            child:  Center(
              child:SJImg(
                  name: 'sj_level_bg',
                  width: 354,
                  height: 303,
              ),
            ),
          ),
          Positioned(
            top: 408.h,
            left: (0.width(context) - 280) * 0.5,
            child:  Center(
              child:SizedBox(width: 280, height: 55,child: SJStrokeText(text: 'Lv.${SJLocalProvider.instance.sj_Level_number}', size: 48, color: '#FFFFFF'.color(), weight: FontWeight.w400, skWidth: 2, skColor: '#580707'.color())),
            ),
          ),
        ],
      ),
    );
  }
}

class VerticalMarquee extends StatefulWidget {
  final List<Widget> items;

  const VerticalMarquee({super.key, required this.items});

  @override
  State<VerticalMarquee> createState() => _VerticalMarqueeState();
}

class _VerticalMarqueeState extends State<VerticalMarquee>
    with SingleTickerProviderStateMixin {
  late AnimationController controller;
  late Animation<double> animation;

  final double itemContentHeight = 33.h;
  final double spacing = 10.h;

  double get itemHeight => itemContentHeight + spacing;

  @override
  void initState() {
    super.initState();

    controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );

    animation = Tween<double>(
      begin: 0,
      end: -itemHeight,
    ).animate(CurvedAnimation(parent: controller, curve: Curves.linear));

    controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        controller.reset();

        setState(() {
          final first = widget.items.removeAt(0);
          widget.items.add(first);
        });

        controller.forward();
      }
    });

    controller.forward();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ClipRect(
      child: SizedBox(
        width: 343.w,
        height: 174.h,
        child: AnimatedBuilder(
          animation: animation,
          builder: (_, child) {
            return Transform.translate(
              offset: Offset(0, animation.value),
              child: child,
            );
          },
          child: ListView.builder(
            padding: EdgeInsets.zero,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: widget.items.length,
            itemBuilder: (_, index) {
              return SizedBox(
                width: 343.w,
                height: itemHeight,
                child: SizedBox(
                  width: 343.w,
                  height: itemContentHeight,
                  child: widget.items[index],
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}

class ThreeRowHorizontalMarquee extends StatefulWidget {
  final double containerWidth;
  final double containerHeight;
  final int itemsPerRow;

  const ThreeRowHorizontalMarquee({
    super.key,
    required this.containerWidth,
    required this.containerHeight,
    required this.itemsPerRow,
  });

  @override
  State<ThreeRowHorizontalMarquee> createState() =>
      _ThreeRowHorizontalMarqueeState();
}

class _ThreeRowHorizontalMarqueeState extends State<ThreeRowHorizontalMarquee> {
  final int rowCount = 3;
  final double itemWidth = 208.w;
  final double itemHeight = 21.h;
  final double spacing = 100.w;
  final double speed = 1.5;

  late List<double> _dxs;
  late List<List<String>> _accounts; // 每行每个账号
  late List<List<int>> _amounts; // 每行每个金额
  late List<List<int>> _bgIndexes; // 每行每个 item 背景
  late Timer _timer;
  final Random _random = Random();

  @override
  void initState() {
    super.initState();

    _dxs = List.generate(rowCount, (index) => _random.nextDouble() * 300);

    _bgIndexes = List.generate(
      rowCount,
          (row) => List.generate(widget.itemsPerRow, (i) => _random.nextInt(2)),
    );

    _accounts = List.generate(
      rowCount,
          (row) => List.generate(widget.itemsPerRow, (i) => _randomAccount()),
    );

    _amounts = List.generate(
      rowCount,
          (row) => List.generate(widget.itemsPerRow, (i) => _randomAmount()),
    );

    _timer = Timer.periodic(const Duration(milliseconds: 16), (timer) {
      setState(() {
        for (int row = 0; row < rowCount; row++) {
          _dxs[row] -= speed;
          double totalWidth =
              widget.itemsPerRow * (itemWidth + spacing); // 单份宽度

          if (_dxs[row] <= -totalWidth) {
            _dxs[row] += totalWidth;

            // 滚动消失的 item 更新账号和金额，但背景保持不变
            _accounts[row].removeAt(0);
            _accounts[row].add(_randomAccount());

            _amounts[row].removeAt(0);
            _amounts[row].add(_randomAmount());
          }
        }
      });
    });
  }

  String _randomAccount() {
    int suffix = 100 + _random.nextInt(900);
    return '1****$suffix';
  }

  int _randomAmount() {
    List<int> amounts = [1000, 1500, 2000, 3000];
    return amounts[_random.nextInt(amounts.length)];
  }

  List<Widget> _buildItems(int row) {
    List<Widget> result = [];
    for (int i = 0; i < widget.itemsPerRow; i++) {
      result.add(
        Container(
          width: itemWidth,
          height: itemHeight,
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage(
                  'assets/images/sj_pa_top_bg_${_bgIndexes[row][i]}.png'),
              fit: BoxFit.fill,
            ),
          ),
          alignment: Alignment.center,
          child: RichText(
            text: TextSpan(
              children: [
                TextSpan(
                  text: 'Congrats, ',
                  style: TextStyle(
                    fontFamily: 'Barlow_Black',
                    fontSize: 9.sp,
                    color: Colors.white,
                    fontWeight: FontWeight.w400,
                  ),
                ),
                TextSpan(
                  text: _accounts[row][i] + ' ',
                  style: TextStyle(
                    fontSize: 9.sp,
                    fontFamily: 'Barlow_Black',
                    color: '#20D810'.color(),
                    fontWeight: FontWeight.w400,
                  ),
                ),
                TextSpan(
                  text: 'withdraw ',
                  style: TextStyle(
                    fontSize: 9.sp,
                    fontFamily: 'Barlow_Black',
                    color: Colors.white,
                    fontWeight: FontWeight.w400,
                  ),
                ),
                TextSpan(
                  text: '\$${_amounts[row][i]}',
                  style: TextStyle(
                    fontSize: 9.sp,
                    fontFamily: 'Barlow_Black',
                    color: '#FFEA00'.color(),
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ],
            ),
          ),
        ),
      );
      result.add(SizedBox(width: spacing));
    }
    return result;
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: widget.containerWidth,
      height: widget.containerHeight,
      child: ClipRect(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: List.generate(rowCount, (row) {
            double totalWidth =
                widget.itemsPerRow * (itemWidth + spacing); // 单份宽度
            return SizedBox(
              height: itemHeight,
              child: Stack(
                children: [
                  Positioned(
                    left: _dxs[row],
                    child: Row(
                      children: [
                        ..._buildItems(row),
                        ..._buildItems(row), // 双份无缝滚动
                      ],
                    ),
                  ),
                ],
              ),
            );
          }),
        ),
      ),
    );
  }
}
