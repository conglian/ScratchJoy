import 'dart:async';

import 'package:fl_toast/fl_toast.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:scratchjoy/SJTool/sj_GradientText.dart';
import 'package:scratchjoy/SJTool/sj_LocalProvider.dart';
import 'package:scratchjoy/SJTool/sj_extension_help.dart';
import 'package:scratchjoy/SJTool/sj_img.dart';
import 'package:scratchjoy/SJTool/sj_stroke_text.dart';
import 'package:scratchjoy/SJTool/sj_text.dart';
import 'package:spine_flutter/spine_flutter.dart' as spine;

import '../SJHome/SJHome.dart';
import '../SJHome/SJScratchA.dart';
import '../SJTool/SJAdAHelp.dart';
import '../SJTool/sj_WebKitView.dart';
import '../SJTool/sj_mp3_player.dart';


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
                            urlString: "https://sites.google.com/view/130scratchjoyprivacy-policy/home",
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
                SJAdAHelper().show(context, (hasCache){
                  if (!hasCache){
                    SJAdAHelper().resetBlock();
                  }
                }, (finished) async {
                  SJAdAHelper().resetBlock();
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
                  SJAdAHelper().show(context, (hasCache){
                    if (!hasCache){
                      SJAdAHelper().resetBlock();
                    }
                  }, (finished) async {
                    SJAdAHelper().resetBlock();
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