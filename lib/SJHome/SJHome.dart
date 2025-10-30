import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:scratchjoy/SJTool/sj_GradientText.dart';
import 'package:scratchjoy/SJTool/sj_NumberHelper.dart';
import 'package:scratchjoy/SJTool/sj_extension_help.dart';
import '../SJDilaog/SJDialog.dart';
import '../SJTool/sj_GradientNumber.dart';
import '../SJTool/sj_LocalProvider.dart';
import '../SJTool/sj_img.dart';
import '../SJTool/sj_text.dart';
import 'SJDiceRollWidget.dart';
import 'SJScratchA.dart';

var history_index = 0;

class SJHome extends StatefulWidget {
  SJHome({super.key});
  @override
  State<SJHome> createState() => _SJHomeState();
}

class _SJHomeState extends State<SJHome> {

  Timer? _timer;

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

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // 当前帧构建完成后
    WidgetsBinding.instance.addPostFrameCallback((_) {
      // 在这里执行需要更新UI的操作
      sj_setStarTime();
      sjsj_startTimer();
    });
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
      '1111111'.log();
      sj_startTime1 = DateTime.parse(SJLocalProvider.instance.sj_Scratch_timeKey_1);
      'sj_startTime1=$sj_startTime1'.log();
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
      body: Container(
        width: 0.width(context),
        height: 0.height(context),
        decoration: BoxDecoration(
          image: SJDImg('sj_home_bg')
        ),
        child: Column(
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
      ),
    );
  }
}


class SJClickableImageList extends StatelessWidget {
  final List<String> imageNames = const [
    'sj_scratch_list_0',
    'sj_scratch_list_1',
    'sj_scratch_list_2',
    'sj_scratch_list_3',
    'sj_scratch_list_4',
    'sj_scratch_list_5',
    'sj_scratch_list_6',
  ];
  final List<Duration?> sjRemainingDurations; // 👈 新增
  const SJClickableImageList({super.key, required this.sjRemainingDurations});

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
            onTap: () {
              history_index = index;
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (builder) {
                    return SJScratchA(
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
                              num = SJNumberAHelper().numberEntity.extraBonus.winupNumber;
                              gradientColor = ['#FFE342'.color(),'#FFFADD'.color()];
                              strokeColors = '#82180F'.color();
                            } else if (index == 1){
                              num = SJNumberAHelper().numberEntity.goldRush.winupNumber;
                              gradientColor = ['#FFE342'.color(),'#FFFADD'.color()];
                              strokeColors = '#82180F'.color();
                            } else if (index == 2){
                              num = SJNumberAHelper().numberEntity.luckuMoment.winupNumber;
                              gradientColor = ['#FEFFED'.color(),'#FFD900'.color()];
                              strokeColors = '#714006'.color();
                            } else if (index == 3){
                              num = SJNumberAHelper().numberEntity.secretStash.winupNumber;
                              gradientColor = ['#FFEE91'.color(),'#FFEE91'.color()];
                              strokeColors = '#000000'.color();
                            } else if (index == 4){
                              num = SJNumberAHelper().numberEntity.superMultiple.winupNumber;
                              gradientColor = ['#FFE342'.color(),'#FFFADD'.color()];
                              strokeColors = '#000000'.color();
                            } else if (index == 5){
                              num = SJNumberAHelper().numberEntity.fortuneRush.winupNumber;
                              gradientColor = ['#FFE342'.color(),'#FFFADD'.color()];
                              strokeColors = '#02413B'.color();
                            } else if (index == 6){
                              num = SJNumberAHelper().numberEntity.sweetTime.winupNumber;
                              gradientColor = ['#FFE342'.color(),'#FFFADD'.color()];
                              strokeColors = '#8B0746'.color();
                            }
                            return SJGradientStrokeText(text: '$num', fontSize: 24, gradientColors: gradientColor, strokeWidth: 2,strokeColor: strokeColors, width: 60, height: 30,);
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
      num = 112.h;
    } else if (index == 1){
      num = 46.h;
    } else if (index == 2){
      num = 116.h;
    } else if (index == 3){
      num = 116.h;
    } else if (index == 4){
      num = 38.h;
    } else if (index == 5){
      num = 70.h;
    } else if (index == 6){
      num = 114.h;
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
            SizedBox(width: 12,),
            SizedBox(
                width: 124,
                height: 37,
                child: Stack(
                  children: [
                    Center(
                      child: Container(
                          width: 124,
                          height: 32,
                          decoration: BoxDecoration(
                              image: SJDImg('sj_nav_pro_bg')
                          ),
                          child: Consumer<SJLocalProvider>(
                            builder: (context, provider, child) {
                              return InkWell(
                                onTap: (){

                                },
                                child: Padding(
                                  padding: EdgeInsets.only(top: 2.0, left: 32.12),
                                  child: Center(
                                    child: SJGradientNumberRoller(
                                      value: provider.sj_domand_number,
                                      duration: 800,
                                      fontSize: 20.0,
                                      gradientColors: ['#FFFFFF'.color(), '#FFCD61'.color()],
                                      borderColor: '#FFFFFF'.color(),
                                      borderWidth: 0.0,
                                      decimalPlaces: 0,
                                    ),
                                  ),
                                ),
                              );
                            },
                          )
                      ),
                    ),
                    SJImg(name: 'sj_home_domand_icon', width: 35.12, height: 37,)
                  ],
                )
            ),
            SizedBox(width: 11.0),
            SizedBox(
                width: 147,
                height: 40,
                child: Stack(
                  children: [
                    Padding(
                      padding: EdgeInsets.only(top: 4, left: 19),
                      child: Container(
                            width: 131,
                            height: 32,
                            decoration: BoxDecoration(
                                image: SJDImg('sj_nav_pro_bg')
                            ),
                            child: Consumer<SJLocalProvider>(
                              builder: (context, provider, child) {
                                return ClipRRect(
                                    borderRadius: BorderRadius.circular(15),
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
                                      child: LinearProgressIndicator(
                                        value: provider.sj_Level_inedx / 5.0,
                                        minHeight: 30,
                                        backgroundColor: Colors.transparent,
                                        valueColor: const AlwaysStoppedAnimation<Color>(Colors.white),
                                      ),
                                    ),
                                );
                                },
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 4, left: 19),
                      child: SizedBox(
                        width: 131,
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
                context.tipShow(SJPopSettingDialog());
              },
              child: SJImg(name: 'sj_home_set_icon', width: 34, height: 34,),
            ),
            SizedBox(width: 21,)
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
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            // SizedBox(width: 10.w),
            Padding(
              padding: EdgeInsets.only(top: 16),
              child: InkWell(
                onTap: (){

                },
                child: Visibility(visible: false, child: SJImg(name: 'sj_box_icon', width: 65, height: 65)),
              ),
            ),
            SizedBox(width: 32,),
            Padding(
              padding: EdgeInsets.only(top: 0),
              child: InkWell(
                onTap: (){
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (builder) {
                        return SJScratchA(
                            type: history_index);
                      },
                    ),
                  );
                },
                child: SJImg(name: 'sj_cards_btn', width: 200, height: 75),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(top: 16),
              child: InkWell(
                onTap: (){
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (builder) {
                        return SJDiceRollWidget();
                      },
                    ),
                  );
                },
                child: SizedBox(
                  width: 65,
                  height: 65,
                  child: Stack(
                    children: [
                      SJImg(name: 'sj_shai_icon'),
                      Positioned(right: 0,child: Container(
                        width: 20,
                        height: 20,
                        decoration: BoxDecoration(
                          image: SJDImg('sj_home_jiao_bg')
                        ),
                        child: Center(
                          child: Consumer<SJLocalProvider>(
                            builder: (context, provider, child) {
                              return SJText(text: '${provider.sj_dice_number}', size: 14, color: '#FFE6AF'.color(), weight: FontWeight.w700);
                            },
                          ),
                        ),
                      ))
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
    );
  }
}