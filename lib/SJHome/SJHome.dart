import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_tba_info/flutter_tba_info.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import 'package:scratchjoy/SJHome/SJScratchA.dart';
import 'package:scratchjoy/SJTool/SJTBAInfoTool.dart';
import 'package:scratchjoy/SJTool/sj_GradientText.dart';
import 'package:scratchjoy/SJTool/sj_NumberHelper.dart';
import 'package:scratchjoy/SJTool/sj_extension_help.dart';
import 'package:scratchjoy/SJTool/sj_numberBHelper.dart';
import 'package:scratchjoy/SJTool/sj_stroke_text.dart';
import 'package:scratchjoy/main.dart';
import 'package:spine_flutter/spine_widget.dart';
import '../SJDilaog/SJDialog.dart';
import '../SJTool/SJAdManager.dart';
import '../SJTool/SJNoticeTool.dart';
import '../SJTool/sj_GradientNumber.dart';
import '../SJTool/sj_LocalProvider.dart';
import '../SJTool/sj_WebKitView.dart';
import '../SJTool/sj_ad_manger.dart';
import '../SJTool/sj_fkmanger.dart';
import '../SJTool/sj_img.dart';
import '../SJTool/sj_mp3_player.dart';
import '../SJTool/sj_number_helper.dart';
import '../SJTool/sj_text.dart';
import 'SJCash.dart';
import 'SJDiceRollWidget.dart';
import 'SJScratchB.dart';
import 'SJScratchRatio.dart';

var history_index = 0;

final GlobalKey<_SJHomeState> homeKey = GlobalKey<_SJHomeState>();

class SJHome extends StatefulWidget{
  SJHome({super.key});
  @override
  State<SJHome> createState() => _SJHomeState();
}

class _SJHomeState extends State<SJHome> with RouteAware, SingleTickerProviderStateMixin {

  BuildContext get ctx => context;

  late SpineWidgetController _controller0;

  Duration? sj_remainingDuration0;

  Duration? sj_remainingDuration1;

  Duration? sj_remainingDuration2;

  Duration? sj_remainingDuration3;

  Duration? sj_remainingDuration4;

  Duration? sj_remainingDuration5;

  Duration? sj_remainingDuration6;

  DateTime? sj_startTime0;

  DateTime? sj_startTime1;

  DateTime? sj_startTime2;

  DateTime? sj_startTime3;

  DateTime? sj_startTime4;

  DateTime? sj_startTime5;

  DateTime? sj_startTime6;

  int _countdown = 100;

  Timer? _timer;

  bool is_yunyingshow1 = false;

  bool is_yunyingshow2 = false;

  bool is_yunyingshow3 = false;

  bool is_yunyingshow4 = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if (SJLocalProvider.instance.sj_login_status) {
      '1111111111'.log();
      SJLocatilNoticeHelper().initSJNotifications();
    }
    // 当前帧构建完成后
    WidgetsBinding.instance.addPostFrameCallback((_) {
      // 在这里执行需要更新UI的操作
      shownewGuideA();
      sj_setStarTime();
      sjsj_startTimer();
      sj_newUserGuide();
      if (SJLocalProvider.instance.sj_old_guide == false && SJLocalProvider.instance.sj_login_status) {
        context.tipShow(SJBoxOldDiaologWidget());
        SJLocalProvider.instance.updateBool(SJLocalProvider.instance.sj_old_guideName, true);
      }
    });

    // 100% 中奖处理，只保留当前的记录退出不算
    SJScratchDiceTimerNotificationService.stream.listen((value) async {
      sj_event_fire('countdown_open', {});
      _startCountdown();
    });
    // push next
    SJScratchPushNextNotificationService.stream.listen((value) async {
      sjsj_startTimer();
      if (value == 0){
        await SJLocalProvider.instance.updateString(SJLocalProvider.instance.sj_Scratch_timeKey_0Name,DateTime.now().toIso8601String());
        setState(() {});
      } else if (value == 1){
        await SJLocalProvider.instance.updateString(SJLocalProvider.instance.sj_Scratch_timeKey_1Name,DateTime.now().toIso8601String());
        setState(() {});
      } else if (value == 2){
        await SJLocalProvider.instance.updateString(SJLocalProvider.instance.sj_Scratch_timeKey_2Name,DateTime.now().toIso8601String());
        setState(() {});
      } else if (value == 3){
        await SJLocalProvider.instance.updateString(SJLocalProvider.instance.sj_Scratch_timeKey_3Name,DateTime.now().toIso8601String());
        setState(() {});
      } else if (value == 4){
        await SJLocalProvider.instance.updateString(SJLocalProvider.instance.sj_Scratch_timeKey_4Name,DateTime.now().toIso8601String());
        setState(() {});
      } else if (value == 5){
        await SJLocalProvider.instance.updateString(SJLocalProvider.instance.sj_Scratch_timeKey_5Name,DateTime.now().toIso8601String());
        setState(() {});
      } else if (value == 6){
        await SJLocalProvider.instance.updateString(SJLocalProvider.instance.sj_Scratch_timeKey_6Name,DateTime.now().toIso8601String());
        setState(() {});
      }
      await SJLocalProvider.instance.updateString(SJLocalProvider.instance.sj_ratio_strName, '80');
      await SJLocalProvider.instance.updateBool(SJLocalProvider.instance.is_end_ScratchName, true);
      history_index = value;
      if (!mounted)return;
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (builder) {
            return SJLocalProvider.instance.sj_login_status == true ? SJScratchB(
                type: value == 6 ? 0 : value + 1) : SJScratchA(
                type: value == 6 ? 0 : value + 1);
          },
        )
      );
      await Future.delayed(Duration(milliseconds: 50),(){});
      poptxTaskContent();
    });
    _controller0 = SpineWidgetController(onInitialized: (controller) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        controller.animationState.setAnimationByName(0, "animation", true);
      });
    });
    sj_event_fire('home_page', {});
  }

  void shownewGuideA(){
    if (!SJLocalProvider.instance.sj_login_status && SJLocalProvider.instance.sj_newA_guide == false){
      context.tipShow(SJPopQuestDialog());
    }
  }

  void _refresh() {
    print('每次进入页面都会走这里');
    setState(() {});
  }

  // 运营逻辑添加
  Future<void> poptxTaskContent() async {
    await Future.delayed(Duration(milliseconds: 50),(){});
    if(SJLocalProvider.instance.sj_card_number == 4 && SJLocalProvider.instance.sj_yunying_1 == false && is_yunyingshow1 == false){
      is_yunyingshow1 = true;
      await SJLocalProvider.instance.updateBool(SJLocalProvider.instance.sj_yunying_1Name, true);
      if (!mounted) return;
      context.tipShow(SJPopSubmitAccountDialog());
    } else if (SJLocalProvider.instance.sj_card_number == 7 && SJLocalProvider.instance.sj_yunying_3 == false && is_yunyingshow2 == false){
      is_yunyingshow2 = true;
      await SJLocalProvider.instance.updateBool(SJLocalProvider.instance.sj_yunying_3Name, true);
      if (!mounted) return;
      context.tipShow(SJPopSubmitLastDialog());
    } else if (SJLocalProvider.instance.sj_dolas_number >= 800 && SJLocalProvider.instance.sj_dolas_800 == false && is_yunyingshow3 == false){
      is_yunyingshow3 = true;
      await SJLocalProvider.instance.updateBool(SJLocalProvider.instance.sj_dolas_800Name, true);
      if (!mounted) return;
      context.tipShow(SJPopTXDiceDialog());
    } else if (SJLocalProvider.instance.sj_dolas_number >= 1000 && SJLocalProvider.instance.sj_dolas_1000 == false && is_yunyingshow4 == false){
      is_yunyingshow4 = true;
      await SJLocalProvider.instance.updateBool(SJLocalProvider.instance.sj_dolas_1000Name, true);
      if (!mounted) return;
      context.tipShow(SJPopTXWallerDialog());
    }
  }

  // 100s 倒计时
  void _startCountdown() {
    _timer?.cancel();
    _countdown = 100;

    _timer = Timer.periodic(const Duration(seconds: 1), (timer) async {
      if (_countdown <= 1) {
        timer.cancel();
        await SJLocalProvider.instance.updateBool(SJLocalProvider.instance.sj_100_timer_starName, false);
      } else {
        setState(() {
          _countdown--;
        });
      }
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final route = ModalRoute.of(context);
    if (route is PageRoute) {
      routeObserver.subscribe(this, route);
    }
  }

  @override
  void dispose() {
    routeObserver.unsubscribe(this);
    _timer?.cancel();
    super.dispose();
  }

  // 新用户
  Future<void> sj_newUserGuide() async {
    if (!SJLocalProvider.instance.sj_new_guide && SJNumberHelpers().probabilityConfigModel!.probabilityopen == 1 && SJLocalProvider.instance.sj_login_status){
      var code = await context.tipShow(CardShuffleAnimation(is_start: false, souce_fromat: 'home',));
      if (code == 1){
        SJScratchProbabilityUpNotificationService.notify(0);
      }
    }
  }

  // 开始计时器
  void sjsj_startTimer() {

    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (SJLocalProvider.instance.sj_Scratch_timeKey_0.isNotEmpty){
        final now = DateTime.now();
        sj_startTime0 ??= DateTime.parse(SJLocalProvider.instance.sj_Scratch_timeKey_0);
        final elapsed = now.difference(sj_startTime0!);
        if (elapsed < const Duration(hours: 1)) {
         sj_remainingDuration0 = const Duration(hours: 1) - elapsed;
        } else {
         sj_remainingDuration0 = Duration.zero;
          SJLocalProvider.instance.updateString(SJLocalProvider.instance.sj_Scratch_timeKey_0Name,'');
          SJLocalProvider.instance.updateint(SJLocalProvider.instance.sj_scrach_end_number_0Name,0);
        }
      }
      if (SJLocalProvider.instance.sj_Scratch_timeKey_1.isNotEmpty){
        final now = DateTime.now();
        sj_startTime1 ??= DateTime.parse(SJLocalProvider.instance.sj_Scratch_timeKey_1);
        final elapsed = now.difference(sj_startTime1!);
        if (elapsed < const Duration(hours: 1)) {
         sj_remainingDuration1 = const Duration(hours: 1) - elapsed;
        } else {
         sj_remainingDuration1 = Duration.zero;
         SJLocalProvider.instance.updateString(SJLocalProvider.instance.sj_Scratch_timeKey_1Name,'');
         SJLocalProvider.instance.updateint(SJLocalProvider.instance.sj_scrach_end_number_1Name,0);
        }
      }
      if (SJLocalProvider.instance.sj_Scratch_timeKey_2.isNotEmpty){
        final now = DateTime.now();
        sj_startTime2 ??= DateTime.parse(SJLocalProvider.instance.sj_Scratch_timeKey_2);
        final elapsed = now.difference(sj_startTime2!);
        if (elapsed < const Duration(hours: 1)) {
         sj_remainingDuration2 = const Duration(hours: 1) - elapsed;
        } else {
         sj_remainingDuration2 = Duration.zero;
         SJLocalProvider.instance.updateString(SJLocalProvider.instance.sj_Scratch_timeKey_2Name,'');
         SJLocalProvider.instance.updateint(SJLocalProvider.instance.sj_scrach_end_number_2Name,0);
        }
      }
      if (SJLocalProvider.instance.sj_Scratch_timeKey_3.isNotEmpty){
        final now = DateTime.now();
        sj_startTime3 ??= DateTime.parse(SJLocalProvider.instance.sj_Scratch_timeKey_3);
        final elapsed = now.difference(sj_startTime3!);
        if (elapsed < const Duration(hours: 1)) {
         sj_remainingDuration3 = const Duration(hours: 1) - elapsed;
        } else {
         sj_remainingDuration3 = Duration.zero;
         SJLocalProvider.instance.updateString(SJLocalProvider.instance.sj_Scratch_timeKey_3Name,'');
         SJLocalProvider.instance.updateint(SJLocalProvider.instance.sj_scrach_end_number_3Name,0);
        }
      }
      if (SJLocalProvider.instance.sj_Scratch_timeKey_4.isNotEmpty){
        final now = DateTime.now();
        sj_startTime4 ??= DateTime.parse(SJLocalProvider.instance.sj_Scratch_timeKey_4);
        final elapsed = now.difference(sj_startTime4!);
        if (elapsed < const Duration(hours: 1)) {
         sj_remainingDuration4 = const Duration(hours: 1) - elapsed;
        } else {
         sj_remainingDuration4 = Duration.zero;
         SJLocalProvider.instance.updateString(SJLocalProvider.instance.sj_Scratch_timeKey_4Name,'');
         SJLocalProvider.instance.updateint(SJLocalProvider.instance.sj_scrach_end_number_4Name,0);
        }
      }
      if (SJLocalProvider.instance.sj_Scratch_timeKey_5.isNotEmpty){
        final now = DateTime.now();
        sj_startTime5 ??= DateTime.parse(SJLocalProvider.instance.sj_Scratch_timeKey_5);
        final elapsed = now.difference(sj_startTime5!);
        if (elapsed < const Duration(hours: 1)) {
         sj_remainingDuration5 = const Duration(hours: 1) - elapsed;
        } else {
         sj_remainingDuration5 = Duration.zero;
         SJLocalProvider.instance.updateString(SJLocalProvider.instance.sj_Scratch_timeKey_5Name,'');
         SJLocalProvider.instance.updateint(SJLocalProvider.instance.sj_scrach_end_number_5Name,0);
        }
      }
      if (SJLocalProvider.instance.sj_Scratch_timeKey_6.isNotEmpty){
        final now = DateTime.now();
        sj_startTime6 ??= DateTime.parse(SJLocalProvider.instance.sj_Scratch_timeKey_6);
        final elapsed = now.difference(sj_startTime6!);
        if (elapsed < const Duration(hours: 1)) {
         sj_remainingDuration6 = const Duration(hours: 1) - elapsed;
        } else {
         sj_remainingDuration6 = Duration.zero;
         SJLocalProvider.instance.updateString(SJLocalProvider.instance.sj_Scratch_timeKey_6Name,'');
         SJLocalProvider.instance.updateint(SJLocalProvider.instance.sj_scrach_end_number_6Name,0);
        }
      }
      if (SJLocalProvider.instance.sj_Scratch_timeKey_0.isNotEmpty || SJLocalProvider.instance.sj_Scratch_timeKey_1.isNotEmpty || SJLocalProvider.instance.sj_Scratch_timeKey_2.isNotEmpty || SJLocalProvider.instance.sj_Scratch_timeKey_3.isNotEmpty || SJLocalProvider.instance.sj_Scratch_timeKey_4.isNotEmpty || SJLocalProvider.instance.sj_Scratch_timeKey_5.isNotEmpty || SJLocalProvider.instance.sj_Scratch_timeKey_6.isNotEmpty){
        if (mounted){
          setState(() {});
        }
      }
    });
  }
  // 设置计时器
  sj_setStarTime(){
    if (SJLocalProvider.instance.sj_Scratch_timeKey_0.isNotEmpty){
      sj_startTime0 = DateTime.parse(SJLocalProvider.instance.sj_Scratch_timeKey_0);
    }
    if (SJLocalProvider.instance.sj_Scratch_timeKey_1.isNotEmpty){
      sj_startTime1 = DateTime.parse(SJLocalProvider.instance.sj_Scratch_timeKey_1);
    }
    if (SJLocalProvider.instance.sj_Scratch_timeKey_2.isNotEmpty){
      sj_startTime2 = DateTime.parse(SJLocalProvider.instance.sj_Scratch_timeKey_2);
    }
    if (SJLocalProvider.instance.sj_Scratch_timeKey_3.isNotEmpty){
      sj_startTime3 = DateTime.parse(SJLocalProvider.instance.sj_Scratch_timeKey_3);
    }
    if (SJLocalProvider.instance.sj_Scratch_timeKey_4.isNotEmpty){
      sj_startTime4 = DateTime.parse(SJLocalProvider.instance.sj_Scratch_timeKey_4);
    }
    if (SJLocalProvider.instance.sj_Scratch_timeKey_5.isNotEmpty){
      sj_startTime5 = DateTime.parse(SJLocalProvider.instance.sj_Scratch_timeKey_5);
    }
    if (SJLocalProvider.instance.sj_Scratch_timeKey_6.isNotEmpty){
      sj_startTime6 = DateTime.parse(SJLocalProvider.instance.sj_Scratch_timeKey_6);
    }
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      extendBodyBehindAppBar: true,
      backgroundColor: Colors.transparent,
      body: SingleChildScrollView(
        child: Container(
          width: 0.width(context),
          height: 0.height(context),
          decoration: BoxDecoration(
            image: SJDImg('sj_home_bg')
          ),
          child: Stack(
            children: [
              Column(
                children: [
                  SJNavBarWidget(),
                  SizedBox(width: 0.width(context), height: 0.height(context) - 118 - 89, child: SJClickableImageList(sjRemainingDurations:[
                    sj_remainingDuration0,
                    sj_remainingDuration1,
                    sj_remainingDuration2,
                    sj_remainingDuration3,
                    sj_remainingDuration4,
                    sj_remainingDuration5,
                    sj_remainingDuration6,
                  ])),
                  Spacer(),
                  SJBottomBarWidget(),
                ],
              ),
              Positioned(left: 4.w,bottom: 56.h,child:
              Consumer<SJLocalProvider>(
                builder: (context, provider, child) {
                  return Visibility(
                    visible: provider.sj_show_box_tips,
                    child: Container(
                      width: 285.w,
                      height: 71.h,
                      decoration: BoxDecoration(
                          image: SJDImg('sj_box_tips')
                      ),
                      child: Column(
                        children: [
                          SizedBox(height: 15.h,),
                          SJText(text: 'Open A Gift Chest Every 3 Scratches', size: 16.spMin, color: '#7B4311'.color(), weight: FontWeight.w400)
                        ],
                      ),
                    ),
                  );
                },
              ),
              ),
              Positioned(
                top: 0.h,
                left: 0.w,
                child: Consumer<SJLocalProvider>(
                    builder: (context, provider, child) {
                      return Visibility(visible: provider.sj_show_dolas_ani, child: Padding(
                        padding: EdgeInsets.only(top: 8.h),
                        child: Lottie.asset(
                            width: 0.width(context),
                            height: 720.h,
                            fit: BoxFit.fill,
                            "sj_dolas_aniamtion.zip".files(),
                            repeat: false,
                            onLoaded: (composition) async {
                              Future.delayed(Duration(milliseconds: 1800), () async {
                                await SJLocalProvider.instance.updateBool(SJLocalProvider.instance.sj_show_dolas_aniName, false);
                              });
                            }
                        ),
                      ));
                    }
                ),
              ),
              Positioned(
                bottom: 0.h,
                left: 44.w,
                width: 60,
                height: 60,
                child:Consumer<SJLocalProvider>(
                    builder: (context, provider, child) {
                      return  Visibility(visible: provider.sj_box_index >= SJNumberBHelper().numberEntity!.boxInterval, child: InkWell(
                        onTap: () async {
                          await SJLocalProvider.instance.updateBool(SJLocalProvider.instance.sj_show_box_tipsName, false);
                          await SJLocalProvider.instance.updateBool(SJLocalProvider.instance.sj_first_box_tipsName, true);
                          if (!context.mounted) return;
                          context.tipShow(SJBoxOpenDiaologWidget());
                        },
                        child: Lottie.asset(
                          width: 80,
                          height: 80,
                          fit: BoxFit.fill,
                          "sj_shou_anmation.zip".files(),
                          repeat: true,
                        ),
                      ));
                    }
                ),
              ),
              // Positioned(
              //   bottom: 174.h,
              //   left: 16.w,
              //   width: 70,
              //   height: 66,
              //   child: InkWell(
              //     onTap: (){
              //       Navigator.of(context).push(
              //         MaterialPageRoute(builder: (builder) {
              //           return SJwebkitview(
              //             url: "https://tinyurl.com/ycy7yfzz",
              //             title: 'More Game',
              //           );
              //         }),
              //       );
              //     },
              //     child: SJImg(name: 'sj_moregame_icon', width: 70, height: 66),
              //   )
              // ),
              // Positioned(
              //     bottom: 174.h,
              //     right: 16.w,
              //     width: 66,
              //     height: 68,
              //     child: InkWell(
              //       onTap: () async {
              //         String gaids = await FlutterTbaInfo.instance.getGaid();
              //         'gaids=$gaids'.log();
              //         Navigator.of(homeKey.currentState!.ctx).push(
              //         MaterialPageRoute(builder: (builder) {
              //             return SJwebkitview(
              //               url: "https://blog.crystalliax.com/scene?sk=q81aa21d0e9c080ad&lzdid=${gaids}",
              //               title: 'GamePlay',
              //             );
              //           }),
              //         );
              //       },
              //       child: SJImg(name: 'sj_7h5_icon', width: 66, height: 68),
              //     )
              // ),
              if (SJLocalProvider.instance.sj_login_status)
                Positioned(child: SJBubbleButton()),
            ],
          )
        ),
      ),
    );
  }
}


class SJClickableImageList extends StatelessWidget {
  final List<String> imageNames = [
    'sj_scratch_list_0',
    'sj_scratch_list_1',
    SJLocalProvider.instance.sj_login_status ? 'sj_scratch_list_2' : 'sj_scratch_list_2s',
    'sj_scratch_list_3',
    'sj_scratch_list_4',
    'sj_scratch_list_5',
    'sj_scratch_list_6',
  ];
  final List<Duration?> sjRemainingDurations; // 👈 新增
  SJClickableImageList({super.key, required this.sjRemainingDurations});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: ListView.builder(
        padding: const EdgeInsets.all(0),
        itemCount: imageNames.length,
        itemBuilder: (context, index) {
          final img = imageNames[index];
          return GestureDetector(
            onTap: () async {
              await SJLocalProvider.instance.updateString(SJLocalProvider.instance.sj_ratio_strName, '80');
              history_index = index;
              if(!context.mounted)return;
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (builder) {
                    return SJLocalProvider.instance.sj_login_status == true ? SJScratchB(
                      type: index) : SJScratchA(
                        type: index);
                  },
                ),
              );
              // 这里可以跳转或执行其它操作
            },
            child: Container(
              margin: const EdgeInsets.symmetric(vertical: 0),
              clipBehavior: Clip.antiAlias,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(0),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 6,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: SizedBox(
                width: 0.width(context), height: 184.h,
                child: Stack(
                  alignment: AlignmentGeometry.center,
                  children: [
                    SJImg(name: img, width: 0.width(context) - 12, height: 184.h),
                    Positioned(bottom: 0, left: (0.width(context) - 186) * 0.5,child: SJImg(name: 'sj_free_btn', width: 188, height: 44,)),
                    Positioned(right: 48.w, top: 42.h,child: Consumer<SJLocalProvider>(
                        builder: (context, provider, child) {
                          int num = provider.sj_scrach_end_number_0;
                          if (index == 0){
                            num = provider.sj_scrach_end_number_0;
                          } else if (index == 1){
                            num = provider.sj_scrach_end_number_1;
                          } else if (index == 2){
                            num = provider.sj_scrach_end_number_2;
                          } else if (index == 3){
                            num = provider.sj_scrach_end_number_3;
                          } else if (index == 4){
                            num = provider.sj_scrach_end_number_4;
                          } else if (index == 5){
                            num = provider.sj_scrach_end_number_5;
                          } else if (index == 6){
                            num = provider.sj_scrach_end_number_6;
                          }
                          return SJText(text: 'Card $num/10', size: 14, color: '#FFE77B'.color(), weight: FontWeight.w700);
                        }
                    )),
                    Positioned( left: numberLeftValue(index), top: numberTopValue(index),
                      child: Consumer<SJLocalProvider>(
                          builder: (context, provider, child) {
                            int num = SJNumberAHelper().numberEntity.extraBonus.winupNumber;
                            List<Color> gradientColor = [];
                            Color strokeColors = Colors.transparent;
                            if (index == 0){
                              num = SJNumberBHelper().numberEntity!.extraBonus.winupNumber;
                              gradientColor = ['#FFE342'.color(),'#FFFADD'.color()];
                              strokeColors = '#82180F'.color();
                            } else if (index == 1){
                              num = SJNumberBHelper().numberEntity!.goldRush.winupNumber;
                              gradientColor = ['#FFE342'.color(),'#FFFADD'.color()];
                              strokeColors = '#82180F'.color();
                            } else if (index == 2){
                              num = SJNumberBHelper().numberEntity!.luckyMoment.winupNumber;
                              gradientColor = ['#FEFFED'.color(),'#FFD900'.color()];
                              strokeColors = '#714006'.color();
                            } else if (index == 3){
                              num = SJNumberBHelper().numberEntity!.secretStash.winupNumber;
                              gradientColor = ['#FFEE91'.color(),'#FFEE91'.color()];
                              strokeColors = '#000000'.color();
                            } else if (index == 4){
                              num = SJNumberBHelper().numberEntity!.superMultiple.winupNumber;
                              gradientColor = ['#FFE342'.color(),'#FFFADD'.color()];
                              strokeColors = '#000000'.color();
                            } else if (index == 5){
                              num = SJNumberBHelper().numberEntity!.fortuneRush.winupNumber;
                              gradientColor = ['#FFE342'.color(),'#FFFADD'.color()];
                              strokeColors = '#02413B'.color();
                            } else if (index == 6){
                              num = SJNumberBHelper().numberEntity!.sweetTime.winupNumber;
                              gradientColor = ['#FFE342'.color(),'#FFFADD'.color()];
                              strokeColors = '#8B0746'.color();
                            }
                            return SJGradientStrokeText(text: SJLocalProvider.instance.sj_login_status ? '\$$num' : '${1000 * (index + 1)}', fontSize: 22, gradientColors: gradientColor, strokeWidth: 2,strokeColor: strokeColors, width: 60, height: 30,);
                          }
                      ),
                    ),
                    Consumer<SJLocalProvider>(
                        builder: (context, provider, child) {
                          bool status = provider.sj_Scratch_timeKey_0.isNotEmpty;
                          if (index == 0){
                            status = provider.sj_Scratch_timeKey_0.isNotEmpty;
                          } else if (index == 1){
                            status = provider.sj_Scratch_timeKey_1.isNotEmpty;
                          } else if (index == 2){
                            status = provider.sj_Scratch_timeKey_2.isNotEmpty;
                          } else if (index == 3){
                            status = provider.sj_Scratch_timeKey_3.isNotEmpty;
                          } else if (index == 4){
                            status = provider.sj_Scratch_timeKey_4.isNotEmpty;
                          } else if (index == 5){
                            status = provider.sj_Scratch_timeKey_5.isNotEmpty;
                          } else if (index == 6){
                            status = provider.sj_Scratch_timeKey_6.isNotEmpty;
                          }
                          return Visibility(visible: status, child: Container(
                            width: 0.width(context),
                            height: 187.h,
                            color: Colors.transparent,
                            child: InkWell(
                              onTap: (){
                                context.tipShow(SJPopUnluckADialog(type: index));
                              },
                              child: Center(
                                child: Container(
                                  width: 205,
                                  height: 45,
                                  decoration: BoxDecoration(
                                    image: SJDImg('sj_time_bg')
                                  ),
                                  child: Row(
                                    children: [
                                      SizedBox(width: 8,),
                                      SJImg(name: 'sj_time_replece_icon', width: 31, height: 31,),
                                      RichText(
                                        textAlign: TextAlign.center,
                                        text: TextSpan(
                                          style: TextStyle(
                                              fontSize: 14.0,
                                              fontWeight: FontWeight.w400,
                                              color: '#FFFFFF'.color(),
                                              fontFamily: 'Barlow_Black'
                                          ),
                                          children: <TextSpan>[
                                            TextSpan(
                                              text: 'Refresh In ',
                                            ),
                                            TextSpan(
                                              text: '${getTimetext(index)} ',
                                              style: TextStyle(color: '#FFA402'.color(), fontSize: 20),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            )
                          ));
                        }
                    )
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  String getTimetext(int index){
    if (index == 0){
      return formatDuration(sjRemainingDurations.first ?? Duration.zero);
    } else if (index == 1) {
      return formatDuration(sjRemainingDurations[1] ?? Duration.zero);
    } else if (index == 2) {
      return formatDuration(sjRemainingDurations[2] ?? Duration.zero);
    } else if (index == 3) {
      return formatDuration(sjRemainingDurations[3] ?? Duration.zero);
    } else if (index == 4) {
      return formatDuration(sjRemainingDurations[4] ?? Duration.zero);
    } else if (index == 5) {
      return formatDuration(sjRemainingDurations[5] ?? Duration.zero);
    } else if (index == 6) {
      return formatDuration(sjRemainingDurations.last ?? Duration.zero);
    }
    return formatDuration(sjRemainingDurations.first ?? Duration.zero);
  }
  
  // 格式化剩余时间为 HH:MM:SS 格式
  String formatDuration(Duration duration) {
    final hours = duration.inHours.toString().padLeft(2, '0');
    final minutes = (duration.inMinutes % 60).toString().padLeft(2, '0');
    final seconds = (duration.inSeconds % 60).toString().padLeft(2, '0');
    return '$hours:$minutes:$seconds';
  }
  
  double numberLeftValue(int index){
    double num = 0;
    if (index == 0){
      num = 188.w;
    } else if (index == 1){
      num = 128.w;
    } else if (index == 2){
      num = 200.w;
    } else if (index == 3){
      num = 200.w;
    } else if (index == 4){
      num = 192.w;
    } else if (index == 5){
      num = 200.w;
    } else if (index == 6){
      num = 188.w;
    }
    return num;
  }
  double numberTopValue(int index){
    double num = 0;
    if (index == 0){
      num = 110.h;
    } else if (index == 1){
      num = 45.h;
    } else if (index == 2){
      num = 115.h;
    } else if (index == 3){
      num = 115.h;
    } else if (index == 4){
      num = 34.h;
    } else if (index == 5){
      num = 70.h;
    } else if (index == 6){
      num = 113.h;
    }
    return num;

  }
}

class SJNavBarWidget extends StatefulWidget {
  SJNavBarWidget({super.key});
  @override
  State<SJNavBarWidget> createState() => _SJNavBarWidgetState();
}

class _SJNavBarWidgetState extends State<SJNavBarWidget> {

  @override
  Widget build(BuildContext context) {

    return Container(
      width: 0.width(context),
      height: 118,
      decoration: BoxDecoration(
          image: SJDImg('sj_nav_bg')
      ),
      child: Padding(
        padding: EdgeInsets.only(top: 34),
        child: Row(
          children: [
            SizedBox(width: 12.w,),
            SizedBox(
                width: 155.w,
                height: 49,
                child: InkWell(
                  onTap: (){
                    if (SJLocalProvider.instance.sj_login_status){
                      Navigator.of(homeKey.currentState!.ctx).push(
                        MaterialPageRoute(
                          builder: (builder) {
                            return SJCash();
                          },
                        ),
                      );
                    }
                  },
                  child: Stack(
                    children: [
                      Center(
                        child: Container(
                            width: 155,
                            height: 32,
                            decoration: BoxDecoration(
                                image: SJDImg('sj_nav_pro_bg')
                            ),
                            child: Consumer<SJLocalProvider>(
                              builder: (context, provider, child) {
                                return Padding(
                                    padding: EdgeInsets.only(top: 2.0, left: 32.12),
                                    child: Center(
                                      child: SJGradientNumberRoller(
                                        value: provider.sj_login_status ? provider.sj_dolas_number : provider.sj_domand_number,
                                        duration: 800,
                                        fontSize: 20.0,
                                        gradientColors: ['#FFFFFF'.color(), '#FFCD61'.color()],
                                        borderColor: '#FFFFFF'.color(),
                                        borderWidth: 0.0,
                                        decimalPlaces: provider.sj_login_status ? 2 : 0,
                                      ),
                                    ),
                                );
                              },
                            )
                        ),
                      ),
                      InkWell(onTap: (){
                        if (SJLocalProvider.instance.sj_login_status){
                          Navigator.of(homeKey.currentState!.ctx).push(
                            MaterialPageRoute(
                              builder: (builder) {
                                return SJCash();
                              },
                            ),
                          );
                        }
                      },child: SJImg(name: !SJLocalProvider.instance.sj_login_status ? 'sj_home_domand_icon' : 'sj_dolas_icon', width: 49, height: 49,))
                    ],
                  ),
                )
            ),
            SizedBox(width: 11.w,),
            SizedBox(
                width: 140.w,
                height: 40,
                child: Stack(
                  children: [
                    Padding(
                      padding: EdgeInsets.only(top: 4, left: 19),
                      child: Container(
                        width: 131.w,
                        height: 32,
                        decoration: BoxDecoration(
                            image: SJDImg('sj_nav_pro_bg')
                        ),
                        child: Consumer<SJLocalProvider>(
                          builder: (context, provider, child) {
                            return Stack(
                              children: [
                                Positioned(
                                  left: 4,
                                  top: 4,
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(20),
                                    child: ShaderMask(
                                      shaderCallback: (Rect bounds) {
                                        return LinearGradient(
                                          begin: Alignment.topCenter,
                                          end: Alignment.bottomCenter,
                                          colors: [
                                            '#8D1C47'.color(),
                                            '#F71C65'.color(),
                                            '#EA0B58'.color(),
                                            '#6C092E'.color(),
                                          ],
                                        ).createShader(bounds);
                                      },
                                      child: Padding(
                                        padding: EdgeInsets.only(top: 0),
                                        child: SizedBox(
                                          width: 120,
                                          height: 24,
                                          child: LinearProgressIndicator(
                                            value: provider.sj_Level_inedx / 5.0,
                                            minHeight: 24,
                                            backgroundColor: Colors.transparent,
                                            valueColor: const AlwaysStoppedAnimation<Color>(Colors.white),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            );
                          },
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 4, left: 19.w),
                      child: SizedBox(
                        width: 131.w,
                        height: 32,
                        child: Consumer<SJLocalProvider>(
                          builder: (context, provider, child) {
                            return Center(
                              child: SJText(text: 'LV.${provider.sj_Level_number}', size: 16, color: '#FFEAEA'.color(), weight: FontWeight.w700),
                            );
                          },
                        ),
                      ),
                    ),
                    Container(
                      width: 55,
                      height: 40,
                      decoration: BoxDecoration(
                          image: SJDImg('sj_lev_bg')
                      ),
                      child: Center(
                        child: Consumer<SJLocalProvider>(
                          builder: (context, provider, child) {
                            return Padding(
                                padding: EdgeInsets.only(top: 0.0, left: 0),
                                child: SJText(text: '${provider.sj_Level_number}', size: 16, color: '#FFFFFF'.color(), weight: FontWeight.w700)
                            );
                          },
                        ),
                      ),
                    )
                  ],
                )
            ),
            Spacer(),
            // InkWell(
            //   onTap: (){
            //     // test
            //     // SJLocalProvider.instance.add_sp_dolas_number(1000);
            //     Navigator.of(context).push(
            //       MaterialPageRoute(builder: (builder) {
            //         return SJwebkitview(
            //           urlString: "https://tinyurl.com/r3wkjwjz",
            //         );
            //       }),
            //     );
            //   },
            //   child: SJImg(name: 'sp_h5_icon', width: 34, height: 34,),
            // ),
            InkWell(
              onTap: (){
                // test
                // SJLocalProvider.instance.updatedouble(SJLocalProvider.instance.sj_dolas_numberName, SJLocalProvider.instance.sj_dolas_number + 500);
                context.tipShow(SJPopSettingDialog());
              },
              child: SJImg(name: 'sj_home_set_icon', width: 34, height: 34,),
            ),
            SizedBox(width: 12.w,)
          ],
        ),
      ),
    );
  }
}


class SJBottomBarWidget extends StatefulWidget {
  SJBottomBarWidget({super.key});
  @override
  State<SJBottomBarWidget> createState() => _SJBottomBarWidgetState();
}

class _SJBottomBarWidgetState extends State<SJBottomBarWidget> {

  @override
  Widget build(BuildContext context) {

    return Container(
      width: 0.width(context),
      height: 89,
      decoration: BoxDecoration(
          image: SJDImg('sj_tbabar_bg')
      ),
      child: Row(
          children: [
            SizedBox(width: 8.w),
            SizedBox(
              width: 89.w,
              height: 89,
              child: InkWell(
                onTap: () async {
                  if (!SJLocalProvider.instance.sj_login_status) return;
                  if (SJLocalProvider.instance.sj_box_index >= SJNumberBHelper().numberEntity!.boxInterval){
                    await SJLocalProvider.instance.updateBool(SJLocalProvider.instance.sj_show_box_tipsName, false);
                    context.tipShow(SJBoxOpenDiaologWidget());
                  } else {
                    SJDialogTool.toast(context, 'open a gift chest every 3 scratches');
                  }
                },
                child: Visibility(
                  visible: SJLocalProvider.instance.sj_login_status,
                  child: Stack(
                    children: [
                      Positioned(top: 18,child: SJImg(name: 'sj_box_icon', width: 65, height: 65)),
                      Positioned(top: 68,child:Stack(
                        children: [
                          // 背景图 71 × 15
                          SizedBox(
                            width: 71,
                            height: 15,
                            child: SJImg(name: 'sj_box_pro_bg'),
                          ),
                          // 进度条（居中）67 × 11
                          Positioned(
                            left: (71 - 67) / 2,  // = 2 px
                            top: 1,   // = 2 px
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(6),
                              child: Container(
                                width: 67,
                                height: 11,
                                color: Colors.transparent,
                                child: Align(
                                  alignment: Alignment.centerLeft,
                                  child: Consumer<SJLocalProvider>(
                                      builder: (context, provider, child) {
                                        return  Container(
                                          width: 67 * (provider.sj_box_index / SJNumberBHelper().numberEntity!.boxInterval.toDouble()), // 根据进度变化
                                          height: 11,
                                          decoration: const BoxDecoration(
                                            gradient: LinearGradient(
                                              begin: Alignment.centerLeft,
                                              end: Alignment.centerRight,
                                              colors: [
                                                Color(0xFFFDEB5A),
                                                Color(0xFFFFC700),
                                                Color(0xFFB87400),
                                              ],
                                            ),
                                          ),
                                        );
                                      })
                                ),
                              ),
                            ),
                          ),
                        ],
                      ))
                    ],
                  ),
                ),
              ),
            ),
            SizedBox(
             width: 200.w, height: 75,
              child: Padding(
                padding: EdgeInsets.only(top: 0),
                child: InkWell(
                  onTap: ()  {
                    if (SJLocalProvider.instance.sj_login_status){
                      Navigator.of(homeKey.currentState!.ctx).push(
                        MaterialPageRoute(
                          builder: (builder) {
                            return SJCash();
                          },
                        ),
                      );
                    } else {
                      int row = 0;
                      if (SJLocalProvider.instance.sj_scrach_end_number_0 < 10){
                        row = 0;
                      } else if (SJLocalProvider.instance.sj_scrach_end_number_1 < 10){
                        row = 1;
                      } else if (SJLocalProvider.instance.sj_scrach_end_number_2 < 10){
                        row = 2;
                      } else if (SJLocalProvider.instance.sj_scrach_end_number_3 < 10){
                        row = 3;
                      } else if (SJLocalProvider.instance.sj_scrach_end_number_4 < 10){
                        row = 4;
                      } else if (SJLocalProvider.instance.sj_scrach_end_number_5 < 10){
                        row = 5;
                      } else if (SJLocalProvider.instance.sj_scrach_end_number_6 < 10){
                        row = 6;
                      }
                      Navigator.of(homeKey.currentState!.ctx).push(
                        MaterialPageRoute(
                          builder: (builder) {
                            return SJScratchA(type: row);
                          },
                        ),
                      );
                    }
                  },
                  child: SJImg(name: SJLocalProvider.instance.sj_login_status ? 'sj_cash_btns' : 'sj_cards_btn', width: 200.w, height: 75),
                ),
              ),
            ),
            Spacer(),
            SizedBox(
              width: 70.w,
              height: 73,
              child: Padding(
                padding: EdgeInsets.only(top: 8, left: 5),
                child: InkWell(
                  onTap: (){
                    Navigator.of(homeKey.currentState!.ctx).push(
                      MaterialPageRoute(
                        builder: (builder) {
                          return SJDiceRollWidget(souce_fromat: 'home',);
                        },
                      ),
                    );
                  },
                  child: SizedBox(
                    width: 65,
                    height: 65,
                    child: Stack(
                      children: [
                        Positioned(child: SJImg(name: 'sj_shai_icon', width: 65, height: 65,)),
                        Positioned(right: 10,child: Container(
                          width: 20,
                          height: 20,
                          decoration: BoxDecoration(
                            image: SJDImg('sj_home_jiao_bg')
                          ),
                          child: Center(
                            child: Consumer<SJLocalProvider>(
                              builder: (context, provider, child) {
                                return SJText(text: SJLocalProvider.instance.sj_100_timer_star == true ? '∞' : '${provider.sj_dice_number}', size: 14, color: '#FFE6AF'.color(), weight: FontWeight.w700);
                              },
                            ),
                          ),
                        ))
                      ],
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(width: 8.w),
          ],
        ),
    );
  }
}


// 气泡
class SJBubbleButton extends StatefulWidget {
  const SJBubbleButton({super.key});

  @override
  _SJBubbleButtonState createState() => _SJBubbleButtonState();
}

class _SJBubbleButtonState extends State<SJBubbleButton>
    with SingleTickerProviderStateMixin {

  late AnimationController _controller;

  double _top = 100;
  double _left = 100;
  double _dx = 50; // 每秒移动多少 px
  double _dy = 80;

  double _iconSize = 75;

  bool _showPop = true;
  double _pptReward = SJNumberHelpers().getPrizeWithBoxorBubble();

  late double maxW, maxH;

  late int _lastTime; // 用来计算 deltaTime

  late double screenWidth;

  late double screenHeight;

  @override
  void initState() {
    super.initState();

    _lastTime = DateTime.now().millisecondsSinceEpoch;

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(days: 10),
    )..addListener(_onTick);

    _controller.repeat();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    screenWidth = MediaQuery.of(context).size.width;
    screenHeight = MediaQuery.of(context).size.height;
  }


  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _onTick() {
    if (!mounted) return;

    final now = DateTime.now().millisecondsSinceEpoch;
    final dt = (now - _lastTime) / 1000.0; // dt 秒
    _lastTime = now;

    maxW = screenWidth - _iconSize;
    maxH = screenHeight - _iconSize - 100;

    // 按时间移动，而不是按帧
    _left += _dx * dt;
    _top += _dy * dt;

    if (_left <= 0) {
      _left = 0;
      _dx = -_dx;
    } else if (_left >= maxW) {
      _left = maxW;
      _dx = -_dx;
    }

    if (_top <= 0) {
      _top = 0;
      _dy = -_dy;
    } else if (_top >= maxH) {
      _top = maxH;
      _dy = -_dy;
    }

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    if (!_showPop) return SizedBox.shrink();

    return Padding(
      padding: EdgeInsets.only(left: _left, top: _top),
      child: GestureDetector(
        onTap: _openPopPT,
        child: SizedBox(
          width: _iconSize,
          height: _iconSize,
          child: Container(
            width: _iconSize,
            height: _iconSize,
            decoration: BoxDecoration(
              image: SJDImg('sj_bubble_icon')
            ),
            child: Column(
              children: [
                Spacer(),
                SJStrokeText(
                  text: '\$${_pptReward.toStringAsFixed(2)}',
                  size: 19,
                  color: '#FFF3BD'.color(),
                  weight: FontWeight.w400,
                  skWidth: 1,
                  skColor: '#000000'.color(),
                )
              ],
            ),
          )
        ),
      ),
    );
  }

  void _openPopPT() {
    sj_event_fire('bubble_c', {});
    SJJoyAds().sj_showAd(context, 'scxji_bubble_rv', onCacheResponse: (onCacheResponse){
      _hidePoPT();
    }, adDidClosed: (adDidClosed) async {
      await SJLocalProvider.instance.updatedouble(
        SJLocalProvider.instance.sj_dolas_numberName, _pptReward
      );
      playAwardmp3();
      _hidePoPT();
    });
  }

  void playAwardmp3(){
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await SJAudioUtils().playDolasAudio();
      Future.delayed(Duration(milliseconds: 1300), () async {
        await SJAudioUtils().stopAllTempAudio();
        if (SJLocalProvider.instance.sj_bg_music){
          await SJAudioUtils().playBGM();
        }
      });
    });
  }

  void _hidePoPT() {
    _pptReward = SJNumberHelpers().getPrizeWithBoxorBubble();
    if (mounted) {
      setState(() {
        _showPop = false;
      });
    }
    Future.delayed(const Duration(seconds: 5), () {
      if (mounted) {
        setState(() {
          _showPop = true;
        });
      }
    });
  }
}


class SJScratchDiceTimerNotificationService {
  static final StreamController<int> _streamController =
  StreamController<int>.broadcast();

  static Stream<int> get stream => _streamController.stream;

  static void sendToDomandNumberNotification(int value) {
    _streamController.sink.add(value);
  }

  static void close() {
    _streamController.close();
  }
}
class SJScratchPushNextNotificationService {
  static final StreamController<int> _streamController = StreamController<int>.broadcast();

  static Stream<int> get stream => _streamController.stream;

  static void sendToDomandNumberNotification(int value) {
    _streamController.sink.add(value);
  }

  static void close() {
    _streamController.close();
  }
}

class SJScratchYunyingNotificationService {
  static final StreamController<int> _streamController = StreamController<int>.broadcast();

  static Stream<int> get stream => _streamController.stream;

  static void sendToDomandNumberNotification(int value) {
    _streamController.sink.add(value);
  }

  static void close() {
    _streamController.close();
  }
}