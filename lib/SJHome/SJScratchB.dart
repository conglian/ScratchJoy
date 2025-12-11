import 'dart:async';
import 'dart:math';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import 'package:scratchjoy/SJDilaog/SJDialog.dart';
import 'package:scratchjoy/SJTool/SJTBAInfoTool.dart';
import 'package:scratchjoy/SJTool/sj_NumberHelper.dart' hide SJ3x3Result;
import 'package:scratchjoy/SJTool/sj_extension_help.dart';
import 'package:scratchjoy/SJTool/sj_mp3_player.dart';
import 'package:scratchjoy/SJTool/sj_number_helper.dart';
import 'package:scratchjoy/SJTool/sj_stroke_text.dart';
import 'package:scratchjoy/main.dart';
import 'package:spine_flutter/spine_widget.dart';
import '../SJTool/sj_GradientNumber.dart';
import '../SJTool/sj_LocalProvider.dart';
import '../SJTool/sj_img.dart';
import '../SJTool/sj_numberBHelper.dart';
import '../SJTool/sj_scratch_card_image_prize.dart';
import '../SJTool/sj_text.dart';
import 'SJCash.dart';
import 'SJDiceRollWidget.dart';
import 'SJHome.dart';
import 'SJScratchA.dart';
import 'SJScratchB.dart';
import 'SJScratchRatio.dart';



class SJScratchB extends StatefulWidget {
  final int type;
  SJScratchB({super.key, required this.type});
  @override
  State<SJScratchB> createState() => _SJScratchBState();
}

class _SJScratchBState extends State<SJScratchB> {

  late SpineWidgetController _controller0;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // 当前帧构建完成后
    WidgetsBinding.instance.addPostFrameCallback((_) {
      // 在这里执行需要更新UI的操作
    });

    _controller0 = SpineWidgetController(onInitialized: (controller) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        controller.animationState.setAnimationByName(0, "animation", true);
      });
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    SJMP3Player().pauseEffect();
    if (SJLocalProvider.instance.sj_bg_music){
      SJMP3Player().playBackground();
    } else {
      SJMP3Player().pauseBackground();
    }
    super.dispose();
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
        child: Stack(
          children: [
            Positioned(top: 118 - 12,child:
            SizedBox(width: 0.width(context), height: 0.height(context) - 118 - 60, child: SJScratchContentBWidget(type: widget.type),),
            ),
            Column(
              children: [
                SJDetailsBarWidget(isCash: false),
                Spacer(),
                SJBottomDetailsBarWidget(),
              ],
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
                            Future.delayed(Duration(milliseconds: 1800), (){
                              SJLocalProvider.instance.updateBool(SJLocalProvider.instance.sj_show_dolas_aniName, false);
                            });
                          }
                      ),
                    ));
                  }
              ),
            ),
            // Positioned(left: 4.w,bottom: 56.h,child:
            // Consumer<SJLocalProvider>(
            //   builder: (context, provider, child) {
            //     return Visibility(
            //       visible: provider.sj_show_box_tips,
            //       child: Container(
            //         width: 285.w,
            //         height: 71.h,
            //         decoration: BoxDecoration(
            //             image: SJDImg('sj_box_tips')
            //         ),
            //         child: Column(
            //           children: [
            //             SizedBox(height: 15.h,),
            //             SJText(text: 'Open A Gift Chest Every 3 Scratches', size: 18, color: '#7B4311'.color(), weight: FontWeight.w400)
            //           ],
            //         ),
            //       ),
            //     );
            //   },
            // ),
            // ),
            // Positioned(
            //   bottom: 0.h,
            //   left: 44.w,
            //   width: 60,
            //   height: 60,
            //   child:Consumer<SJLocalProvider>(
            //       builder: (context, provider, child) {
            //         return  Visibility(visible: provider.sj_show_box_tips, child: InkWell(
            //           onTap: () async {
            //             await SJLocalProvider.instance.updateBool(SJLocalProvider.instance.sj_show_box_tipsName, false);
            //             await SJLocalProvider.instance.updateBool(SJLocalProvider.instance.sj_first_box_tipsName, true);
            //             if (!mounted) return;
            //             context.tipShow(SJBoxOpenDiaologWidget());
            //           },
            //           child: Lottie.asset(
            //             width: 80,
            //             height: 80,
            //             fit: BoxFit.fill,
            //             "sj_shou_anmation.zip".files(),
            //             repeat: true,
            //           ),
            //         ));
            //       }
            //   ),
            // ),
            Positioned(child: SJBubbleButton()),
            Positioned(
                top: 75,
                left: 88,
                child:Consumer<SJLocalProvider>(
                    builder: (context, provider, child) {
                      return  Visibility(visible: provider.sj_first_show_cash, child: InkWell(
                        onTap: () async {
                          await SJLocalProvider.instance.updateBool(SJLocalProvider.instance.sj_first_show_cashName, false);
                          if (!context.mounted) return;
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (builder) {
                                return SJCash();
                              },
                            ),
                          );
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
            Positioned(
              top: 338.h,
              left: 30.w,
              child: Visibility(visible: SJLocalProvider.instance.sj_scratch_guide, child: Lottie.asset(
                  width: 320.w,
                  height: 260.h,
                  fit: BoxFit.fill,
                  "sj_scratch_guide.zip".files(),
                  repeat: false,
                  onLoaded: (composition) async {
                    Future.delayed(Duration(milliseconds: 1200), () async {
                      await SJLocalProvider.instance.updateBool(SJLocalProvider.instance.sj_scratch_guideName, false);
                      setState(() {});
                    });
                  }
              )),
            ),
          ],
        ),
      ),
    );
  }
}

class SJScratchContentBWidget extends StatefulWidget {
  final int type;
  SJScratchContentBWidget({super.key, required this.type});
  @override
  State<SJScratchContentBWidget> createState() => _SJScratchContentBWidgetState();
}

class _SJScratchContentBWidgetState extends State<SJScratchContentBWidget> {

  late double scratch_h = 0.height(context) - 118 - 60;

  bool shai_anim = false;

  bool star_awarad = false;

  bool is_100ratio = false;

  bool is_end_Scratch = false;

  SJPlayJoyResult extra_bonusResult = SJNumberBHelper().generateextra_bonusNumbers(forceWin: !SJLocalProvider.instance.sj_new_guide);

  SJ3x3Result goldRushResult = SJNumberBHelper().generate3x3NumbersWithPrizeAndDice();

  SJPlayJoyResult lucku_momentResultb = SJNumberBHelper().generatelucku_momentNumbers();

  SJsecret_stashResult  secret_stashResult = SJNumberBHelper().generatesecret_stashStash();

  SJsuperMultipleResult superMultipleResult = SJNumberBHelper().generateSuperMultiple();

  SJfortuneRushResult fortuneRushResult = SJNumberBHelper().generateFortuneRush();

  SJSweetTimeResult sweetTimeResult = SJNumberBHelper().generateSweetTime();


  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    updatescratchstatus();
    // 100% 中奖处理，只保留当前的记录退出不算
    SJScratchProbabilityUpNotificationService.stream.listen((value) async {
      // 当前帧构建完成后
      WidgetsBinding.instance.addPostFrameCallback((_) {
        updateBaifenbai();
      });
    });

    SJScratchNextNotificationService.stream.listen((value) async {
      popToNextScratch();
    });

  }
  @override
  void dispose() {
    super.dispose();
  }

  Future<void> updatescratchstatus() async {
    await SJLocalProvider.instance.updateBool(SJLocalProvider.instance.is_end_ScratchName, true);
  }

  Future<void> updateBaifenbai() async {
    await Future.delayed(Duration(milliseconds: 50)); // 重要：等待 overlay 完全 detach
    if (widget.type == 0){
      setState(() {
        extra_bonusResult = SJNumberBHelper().generateextra_bonusNumbers(forceWin: true);
        SJScratchUpdateNotificationService.sendToDomandNumberNotification(0);
      });
    } else if (widget.type == 1){
      setState(() {
        goldRushResult = SJNumberBHelper().generate3x3NumbersWithPrizeAndDice(forceWin: true);
        SJScratchUpdateNotificationService.sendToDomandNumberNotification(0);
      });
    } else if (widget.type == 2){
      setState(() {
        lucku_momentResultb = SJNumberBHelper().generatelucku_momentNumbers(forceWin: true);
        SJScratchUpdateNotificationService.sendToDomandNumberNotification(0);
      });
    } else if (widget.type == 3){
      setState(() {
        secret_stashResult = SJNumberBHelper().generatesecret_stashStash(forceWin: true);
        SJScratchUpdateNotificationService.sendToDomandNumberNotification(0);
      });
    } else if (widget.type == 4){
      setState(() {
        superMultipleResult = SJNumberBHelper().generateSuperMultiple(forceWin: true);
        SJScratchUpdateNotificationService.sendToDomandNumberNotification(0);
      });
    } else if (widget.type == 5){
      setState(() {
        fortuneRushResult = SJNumberBHelper().generateFortuneRush(forceWin: true);
        SJScratchUpdateNotificationService.sendToDomandNumberNotification(0);
      });
    } else if (widget.type == 6){
      setState(() {
        sweetTimeResult = SJNumberBHelper().generateSweetTime(forceWin: true);
        SJScratchUpdateNotificationService.sendToDomandNumberNotification(0);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 0.width(context), height: scratch_h,
      child: _setContentsWidget(),
    );
  }

  Widget _setContentsWidget(){
    if (widget.type == 0) {
      return Stack(
        children: [
          CardSwapAnimator(
            key: swapKey,
            child: buildScratchCard0(),   // 封装你的刮卡UI
          ),
          Positioned(left: (0.width(context) - 304) * 0.5, top: 72.h,child: Container(
              width: 304,
              height: 80,
              decoration: BoxDecoration(
                  image: SJDImg('sj_scratch_top_0')
              ),
              child: Stack(
                children: [
                  Positioned(left: 180, top: 12, child: SJGradientNumberRoller(
                    value: SJNumberBHelper().numberEntity!.extraBonus.winupNumber,
                    duration: 800,
                    fontSize: 32.0,
                    gradientColors: ['#FFE342'.color(), '#FFFADD'.color()],
                    borderColor: '#82180F'.color(),
                    borderWidth: 2.0,
                    decimalPlaces: 0,
                  )),
                ],
              )
          )),
          Positioned(left: (0.width(context) - 318) * 0.5, bottom:70.h, child: InkWell(
              onTap: (){

              }, child: BouncySJImg())),
          Positioned(left: (0.width(context) - 320) * 0.5, bottom:24, width: 320, height: 30, child: RichText(
            textAlign: TextAlign.center,
            maxLines: 2,
            text: TextSpan(
              style: TextStyle(
                fontSize: 12.0,
                fontWeight: FontWeight.w800,
                color: '#E9E4BD'.color(),
              ),
              children: <TextSpan>[
                TextSpan(
                  text: 'match any of ',
                ),
                TextSpan(
                  text: 'Your Numbers ',
                  style: TextStyle(color:'#FFEF40'.color()),
                ),
                TextSpan(
                  text: 'to any of the ',
                ),
                TextSpan(
                  text: 'winning number ',
                  style: TextStyle(color:'#FFEF40'.color()),
                ),
                TextSpan(
                  text: '& win the prize shown for that number.',
                ),
              ],
            ),
          )),
        ],
      );
    } else if (widget.type == 1) {
      return Stack(
        children: [
          CardSwapAnimator(
            key: swapKey1,
            child: buildScratchCard1(),   // 封装你的刮卡UI
          ),
          Positioned(right: 32.w, top: 84.h,child: Container(
              width: 218,
              height: 66,
              decoration: BoxDecoration(
                  image: SJDImg('sj_scratch_top_1')
              ),
              child: Stack(
                children: [
                  Positioned(left: 132, top: 10, child: SJGradientNumberRoller(
                    value: SJNumberBHelper().numberEntity!.goldRush.winupNumber,
                    duration: 800,
                    fontSize: 32.0,
                    gradientColors: ['#FFE342'.color(), '#FFFADD'.color()],
                    borderColor: '#82180F'.color(),
                    borderWidth: 2.0,
                    decimalPlaces: 0,
                  )),
                ],
              )
          )),
          Positioned(left: (0.width(context) - 318) * 0.5, bottom:70.h, child: InkWell(
              onTap: (){

              }, child: BouncySJImg())),
          Positioned(left: (0.width(context) - 320) * 0.5, bottom:24, width: 320, height: 30, child: RichText(
            textAlign: TextAlign.center,
            maxLines: 2,
            text: TextSpan(
              style: TextStyle(
                fontSize: 12.0,
                fontWeight: FontWeight.w800,
                color: '#E9E4BD'.color(),
              ),
              children: <TextSpan>[
                TextSpan(
                  text: 'Match ',
                ),
                TextSpan(
                  text: '3 identical symbols ',
                  style: TextStyle(color:'#FFEF40'.color()),
                ),
                TextSpan(
                  text: 'in a row to win the prize.If you uncover A ',
                ),
                TextSpan(
                  text: '"Gold Mine"',
                  style: TextStyle(color:'#FFEF40'.color()),
                ),
                TextSpan(
                  text: ' symbol, your prize will be doubled!',
                ),
              ],
            ),
          )),
        ],
      );
    } else if (widget.type == 2) {
      return Stack(
        children: [
          CardSwapAnimator(
            key: swapKey2,
            child: buildScratchCard2(),   // 封装你的刮卡UI
          ),
          Positioned(right: (0.width(context) - 301) * 0.5, top: 86.h,child: Container(
              width: 301,
              height: 48,
              decoration: BoxDecoration(
                  image: SJDImg('sj_scratch_top_2')
              ),
              child: Stack(
                children: [
                  Positioned(left: 180, top: 0, child: SJGradientNumberRoller(
                    value: SJNumberBHelper().numberEntity!.luckyMoment.winupNumber,
                    duration: 800,
                    fontSize: 32.0,
                    gradientColors: ['#FEFFED'.color(), '#FFD900'.color()],
                    borderColor: '#714006'.color(),
                    borderWidth: 2.0,
                    decimalPlaces: 0,
                  )),
                ],
              )
          )),
          Positioned(left: (0.width(context) - 318) * 0.5, bottom:70.h, child: InkWell(
               child: BouncySJImg())),
          Positioned(left: (0.width(context) - 320) * 0.5, bottom:24, width: 320, height: 30, child: RichText(
            textAlign: TextAlign.center,
            maxLines: 2,
            text: TextSpan(
              style: TextStyle(
                fontSize: 11.0,
                fontWeight: FontWeight.w800,
                color: '#C5B19E'.color(),
              ),
              children: <TextSpan>[
                TextSpan(
                  text: 'Match any of ',
                ),
                TextSpan(
                  text: 'YOUR NUMBERS ',
                  style: TextStyle(color:'#FFEF40'.color()),
                ),
                TextSpan(
                  text: 'to any ',
                ),
                TextSpan(
                  text: 'WINNING NUMBERS',
                  style: TextStyle(color:'#FFEF40'.color()),
                ),
                TextSpan(
                  text: ',win prize shown for that Number.',
                ),
              ],
            ),
          )),
        ],
      );
    } else if (widget.type == 3) {
      return Stack(
        children: [
          CardSwapAnimator(
            key: swapKey3,
            child: buildScratchCard3(),   // 封装你的刮卡UI
          ),
          Positioned(right: (0.width(context) - 279) * 0.5, top: 72.h,child: Container(
              width: 279,
              height: 100,
              decoration: BoxDecoration(
                  image: SJDImg('sj_scratch_top_3')
              ),
              child: Stack(
                children: [
                  Positioned(left: 160, top: 30, child: SJGradientNumberRoller(
                    value: SJNumberBHelper().numberEntity!.secretStash.winupNumber,
                    duration: 800,
                    fontSize: 36.0,
                    gradientColors: ['#FFFFFF'.color(), '#FFEE91'.color()],
                    borderColor: '#000000'.color(),
                    borderWidth: 2.0,
                    decimalPlaces: 0,
                  )),
                ],
              )
          )),
          Positioned(left: (0.width(context) - 318) * 0.5, bottom:70.h, child: InkWell(
              onTap: (){

              }, child: BouncySJImg())),
          Positioned(left: (0.width(context) - 320) * 0.5, bottom:24, width: 320, height: 30, child: RichText(
            textAlign: TextAlign.center,
            maxLines: 2,
            text: TextSpan(
              style: TextStyle(
                fontSize: 13.0,
                fontWeight: FontWeight.w800,
                color: '#C5B19E'.color(),
              ),
              children: <TextSpan>[
                TextSpan(
                  text: 'Match The ',
                ),
                TextSpan(
                  text: 'Winning Symbol ',
                  style: TextStyle(color:'#FFEF40'.color()),
                ),
                TextSpan(
                  text: 'To Win Multiple Rewards',
                ),
              ],
            ),
          )),
        ],
      );
    } else if (widget.type == 4) {
      return Stack(
        children: [
          CardSwapAnimator(
            key: swapKey4,
            child: buildScratchCard4(),   // 封装你的刮卡UI
          ),
          Positioned(right: (0.width(context) - 112) * 0.25, top: 180.h,child: SizedBox(
              width: 112,
              height: 50,
              child: Stack(
                children: [
                  Positioned(left: 0, top: 0, child: SJGradientNumberRoller(
                    value: SJNumberBHelper().numberEntity!.superMultiple.winupNumber,
                    duration: 800,
                    fontSize: 36.0,
                    gradientColors: ['#FFE342'.color(), '#FFFADD'.color()],
                    borderColor: '#000000'.color(),
                    borderWidth: 2.0,
                    decimalPlaces: 0,
                  )),
                ],
              )
          )),
          Positioned(left: (0.width(context) - 318) * 0.5, bottom:70.h, child: InkWell(
              onTap: (){

              }, child: BouncySJImg())),
          Positioned(left: (0.width(context) - 240) * 0.5, bottom:22, width: 240, height: 36, child: RichText(
            textAlign: TextAlign.center,
            maxLines: 2,
            text: TextSpan(
              style: TextStyle(
                fontSize: 15.0,
                fontWeight: FontWeight.w800,
                color: '#C5B19E'.color(),
              ),
              children: <TextSpan>[
                TextSpan(
                  text: 'Reveal ',
                ),
                TextSpan(
                  text: '20X/30X/50X ',
                  style: TextStyle(color:'#FFEF40'.color()),
                ),
                TextSpan(
                  text: '→Win prize shown below × multiplier',
                ),
              ],
            ),
          )),
        ],
      );
    } else if (widget.type == 5) {
      return Stack(
        children: [
          CardSwapAnimator(
            key: swapKey5,
            child: buildScratchCard5(),   // 封装你的刮卡UI
          ),
          Positioned(right: (0.width(context) - 259) * 0.5, top: 70.h,child: Container(
              width: 259,
              height: 95,
              decoration: BoxDecoration(
                  image: SJDImg('sj_scratch_top_3')
              ),
              child: Stack(
                children: [
                  Positioned(left: 160, top: 28, child: SJGradientNumberRoller(
                    value: SJNumberBHelper().numberEntity!.fortuneRush.winupNumber,
                    duration: 800,
                    fontSize: 36.0,
                    gradientColors: ['#FFE342'.color(), '#FFFADD'.color()],
                    borderColor: '#02413B'.color(),
                    borderWidth: 2.0,
                    decimalPlaces: 0,
                  )),
                ],
              )
          )),
          Positioned(left: (0.width(context) - 318) * 0.5, bottom:70.h, child: InkWell(
              onTap: (){

              }, child: BouncySJImg())),
          Positioned(left: (0.width(context) - 320) * 0.5, bottom:24, width: 320, height: 30, child: RichText(
            textAlign: TextAlign.center,
            maxLines: 2,
            text: TextSpan(
              style: TextStyle(
                fontSize: 13.0,
                fontWeight: FontWeight.w800,
                color: '#C5B19E'.color(),
              ),
              children: <TextSpan>[
                TextSpan(
                  text: 'Scratch to reveal — match ',
                ),
                TextSpan(
                  text: 'Any Number ',
                  style: TextStyle(color:'#FFEF40'.color()),
                ),
                TextSpan(
                  text: 'in a row with the ',
                ),
                TextSpan(
                  text: 'Winning Number ',
                  style: TextStyle(color:'#FFEF40'.color()),
                ),
                TextSpan(
                  text: 'to win the prize shown',
                ),
              ],
            ),
          )),
        ],
      );
    } else if (widget.type == 6) {
      return Stack(
        children: [
          CardSwapAnimator(
            key: swapKey6,
            child: buildScratchCard6(),   // 封装你的刮卡UI
          ),
          Positioned(right: (0.width(context) - 281) * 0.5, top: 188.h,child: Container(
              width: 281,
              height: 71,
              decoration: BoxDecoration(
                  image: SJDImg('sj_scratch_top_6')
              ),
              child: Stack(
                children: [
                  Positioned(left: 160, top: 10, child: SJGradientNumberRoller(
                    value: SJNumberBHelper().numberEntity!.sweetTime.winupNumber,
                    duration: 800,
                    fontSize: 36.0,
                    gradientColors: ['#FFE342'.color(), '#FFFADD'.color()],
                    borderColor: '#8B0746'.color(),
                    borderWidth: 2.0,
                    decimalPlaces: 0,
                  )),
                ],
              )
          )),
          Positioned(left: (0.width(context) - 318) * 0.5, bottom:70.h, child: InkWell(
              onTap: (){
              }, child: BouncySJImg())),
          Positioned(left: (0.width(context) - 320) * 0.5, bottom:24, width: 320, height: 30, child: InkWell(
            child: RichText(
              textAlign: TextAlign.center,
              maxLines: 2,
              text: TextSpan(
                style: TextStyle(
                  fontSize: 14.0,
                  fontWeight: FontWeight.w800,
                  color: '#E9E4BD'.color(),
                ),
                children: <TextSpan>[
                  TextSpan(
                    text: 'Match ',
                  ),
                  TextSpan(
                    text: '3 Symbols ',
                    style: TextStyle(color:'#FFEF40'.color()),
                  ),
                  TextSpan(
                    text: 'in a line to win the shown prize',
                  ),
                ],
              ),
            ),
          )),
        ],
      );
    }
    return SizedBox();
  }
  // 刮卡0
  Widget buildScratchCard0() {
    return SJLocalImageScratchCard(autoStartY: 235.h,coverImagePath: 'sj_scratch_content_0'.image(), contentW: 0.width(context), contentH: scratch_h, onScratchEnd: () async {
      if (!mounted)return;
      setState(() {
        shai_anim = true;
        star_awarad = true;
      });
      await SJLocalProvider.instance.updateint(SJLocalProvider.instance.sj_scrach_end_number_0Name, SJLocalProvider.instance.sj_scrach_end_number_0 + 1);
      Future.delayed(Duration(seconds: 2), () async {
        // 更新本地数据
        await SJLocalProvider.instance.updateint(
          SJLocalProvider.instance.sj_card_numberName,
          SJLocalProvider.instance.sj_card_number + 1,
        );
        await SJLocalProvider.instance.updateint(
          SJLocalProvider.instance.sj_box_indexName,
          SJLocalProvider.instance.sj_box_index + 1,
        );
        await SJLocalProvider.instance.updateint(
          SJLocalProvider.instance.sj_tx_card_indexName,
          SJLocalProvider.instance.sj_tx_card_index + 1,
        );
        if (SJLocalProvider.instance.sj_tx_box_index >= SJNumberHelpers().last_taskModel!.task.first.first.num && SJLocalProvider.instance.sj_tx_card_index >= SJNumberHelpers().last_taskModel!.task.first.last.num && SJLocalProvider.instance.sj_tx_first_status == true) {
          await SJLocalProvider.instance.updateint(SJLocalProvider.instance.sj_tx_probability_indexName, 0);
          await SJLocalProvider.instance.updateint(SJLocalProvider.instance.sj_tx_dice_indexName, 0);
        }
        if (!SJLocalProvider.instance.sj_first_box_tips && SJLocalProvider.instance.sj_box_index >= SJNumberBHelper().numberEntity!.boxInterval){
          await SJLocalProvider.instance.updateBool(
            SJLocalProvider.instance.sj_first_box_tipsName,
            true,
          );
          await SJLocalProvider.instance.updateBool(
            SJLocalProvider.instance.sj_show_box_tipsName,
            true,
          );
        }
        if (!mounted) return; // ✅ 页面已经被销毁就直接返回
        SJLocalProvider.instance.updateint(SJLocalProvider.instance.sj_Level_inedxName, SJLocalProvider.instance.sj_Level_inedx + 1);
        if (extra_bonusResult.diceHit){
          SJLocalProvider.instance.updateint(SJLocalProvider.instance.sj_dice_numberName, SJLocalProvider.instance.sj_dice_number + 1);
        }
        if (extra_bonusResult.isWin) {
          await SJLocalProvider.instance.updateint(SJLocalProvider.instance.sj_scratch_not_award_numberName, 0);
          showAwardWidget(SJNumberHelpers().bonusConfigModel!.extraBonus.pop!, extra_bonusResult.winMatchNumbers[extra_bonusResult
              .winIndex], 'extra_bonus');
          if (!mounted)return;
          setState(() {
            shai_anim = false;
            star_awarad = false;
          });
          if (SJLocalProvider.instance.sj_Level_inedx >= 5){
            await SJLocalProvider.instance.updateint(SJLocalProvider.instance.sj_Level_inedxName, 0);
            await SJLocalProvider.instance.updateint(SJLocalProvider.instance.sj_Level_numberName, SJLocalProvider.instance.sj_Level_number + 1);
          }

        } else {
          await SJLocalProvider.instance.updateint(SJLocalProvider.instance.sj_scratch_not_award_numberName, SJLocalProvider.instance.sj_scratch_not_award_number + 1);
          if (!mounted) return;
          var code = await context.tipShow(SJPopUnAwardDialog());
          if(code >= 0){
            if (!mounted)return;
            setState(() {
              shai_anim = false;
              star_awarad = false;
            });
            if (SJLocalProvider.instance.sj_Level_inedx >= 5){
              await SJLocalProvider.instance.updateint(SJLocalProvider.instance.sj_Level_inedxName, 0);
              await SJLocalProvider.instance.updateint(SJLocalProvider.instance.sj_Level_numberName, SJLocalProvider.instance.sj_Level_number + 1);
              showLevelDialog();
            }
            showRatioDilog();
          }
        }
      });
    },child: Container(
        width: 0.width(context),
        height: scratch_h,
        decoration: BoxDecoration(
            image: SJDImg('sj_scratch_bg_0')
        ),
        child: Column(
          children: [
            SizedBox(height: 228.h,),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                SJText(text: '${extra_bonusResult.winNumbers.first}', size: 40, color: '#25211D'.color(), weight: FontWeight.w900),
                SJText(text: '${extra_bonusResult.winNumbers[1]}', size: 40, color: '#25211D'.color(), weight: FontWeight.w900),
                SJText(text: '${extra_bonusResult.winNumbers[2]}', size: 40, color: '#25211D'.color(), weight: FontWeight.w900),
                SJText(text: '${extra_bonusResult.winNumbers.last}', size: 40, color: '#25211D'.color(), weight: FontWeight.w900),
              ],
            ),
            SizedBox(height: 40.h,),
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 4, // 一行5个
                mainAxisSpacing: 0, // 垂直间距
                crossAxisSpacing: 0, // 水平间距
                childAspectRatio: 56 / 56, // 宽高比
              ),
              itemCount: 12,
              padding: EdgeInsets.only(top: 14.h, left: 60.w, right: 32.w), // 移除默认的padding// 最多显示10个
              itemBuilder: (context, index) {
                return SizedBox(
                    width: 70,
                    height: 56,
                    child: Stack(
                        children: [
                          if(extra_bonusResult.displayNumbers[index] == -2)
                            SJAnimatedImageMove(imageUrl: 'sj_shaizi_icon', isAnimationEnabled: shai_anim, ws: 56, hs: 56, targetKey: targetimageKey),
                          if(extra_bonusResult.displayNumbers[index] != -2)
                            Positioned(width: 56,child: SJBouncyText(text: '${extra_bonusResult.displayNumbers[index]}', fontSize: 36, color:(extra_bonusResult.winNumbers.contains(extra_bonusResult.displayNumbers[index]) && star_awarad == true) ? '#FFF600'.color() : '#3A3025'.color(), enableAnimation: (extra_bonusResult.winNumbers.contains(extra_bonusResult.displayNumbers[index]) && star_awarad == true))),
                          if(extra_bonusResult.displayNumbers[index] != -2)
                            Positioned(top: 36,width: 56,child: SJBouncyText(text: '\$${extra_bonusResult.winMatchNumbers[index].toStringAsFixed(2)}', fontSize: 14.spMax, color: (extra_bonusResult.winNumbers.contains(extra_bonusResult.displayNumbers[index]) && star_awarad == true) ? '#FFF600'.color() : '#62594E'.color(), enableAnimation: (extra_bonusResult.winNumbers.contains(extra_bonusResult.displayNumbers[index]) && star_awarad == true))),
                        ]
                    )
                );
              },
            )
          ],
        ),
      ),
    );
  }
  // 刮卡1
  Widget buildScratchCard1() {
    return SJLocalImageScratchCard(autoStartY: 220.h,coverImagePath: 'sj_scratch_content_1'.image(), contentW: 0.width(context), contentH: scratch_h,  onScratchEnd: () async {
      if (!mounted)return;
      setState(() {
          shai_anim = true;
          star_awarad = true;
        });
      await SJLocalProvider.instance.updateint(SJLocalProvider.instance.sj_scrach_end_number_1Name, SJLocalProvider.instance.sj_scrach_end_number_1 + 1);
      Future.delayed(Duration(seconds: 2), () async {
        // 更新本地数据
        await SJLocalProvider.instance.updateint(
          SJLocalProvider.instance.sj_card_numberName,
          SJLocalProvider.instance.sj_card_number + 1,
        );
        await SJLocalProvider.instance.updateint(
          SJLocalProvider.instance.sj_box_indexName,
          SJLocalProvider.instance.sj_box_index + 1,
        );
        await SJLocalProvider.instance.updateint(
          SJLocalProvider.instance.sj_tx_card_indexName,
          SJLocalProvider.instance.sj_tx_card_index + 1,
        );
        if (SJLocalProvider.instance.sj_tx_box_index >= SJNumberHelpers().last_taskModel!.task.first.first.num && SJLocalProvider.instance.sj_tx_card_index >= SJNumberHelpers().last_taskModel!.task.first.last.num && SJLocalProvider.instance.sj_tx_first_status == true) {
          await SJLocalProvider.instance.updateint(SJLocalProvider.instance.sj_tx_probability_indexName, 0);
          await SJLocalProvider.instance.updateint(SJLocalProvider.instance.sj_tx_dice_indexName, 0);
        }
        if (!SJLocalProvider.instance.sj_first_box_tips && SJLocalProvider.instance.sj_box_index >= SJNumberBHelper().numberEntity!.boxInterval){
          await SJLocalProvider.instance.updateBool(
            SJLocalProvider.instance.sj_first_box_tipsName,
            true,
          );
          await SJLocalProvider.instance.updateBool(
            SJLocalProvider.instance.sj_show_box_tipsName,
            true,
          );
        }
        if (!mounted) return; // ✅ 页面已经被销毁就直接返回
        SJLocalProvider.instance.updateint(SJLocalProvider.instance.sj_Level_inedxName, SJLocalProvider.instance.sj_Level_inedx + 1);
        if (goldRushResult.diceHit){
          SJLocalProvider.instance.updateint(SJLocalProvider.instance.sj_dice_numberName, SJLocalProvider.instance.sj_dice_number + 1);
        }
        if (goldRushResult.isWin) {
          await SJLocalProvider.instance.updateint(SJLocalProvider.instance.sj_scratch_not_award_numberName, 0);
          showAwardWidget(SJNumberHelpers().bonusConfigModel!.goldRush.pop!, goldRushResult.prize, 'gold_rush');
          if (!mounted)return;
          setState(() {
            shai_anim = false;
            star_awarad = false;
          });
          if (SJLocalProvider.instance.sj_Level_inedx >= 5){
            await SJLocalProvider.instance.updateint(SJLocalProvider.instance.sj_Level_inedxName, 0);
            await SJLocalProvider.instance.updateint(SJLocalProvider.instance.sj_Level_numberName, SJLocalProvider.instance.sj_Level_number + 1);
            showLevelDialog();
          }
        } else {
          await SJLocalProvider.instance.updateint(SJLocalProvider.instance.sj_scratch_not_award_numberName, SJLocalProvider.instance.sj_scratch_not_award_number + 1);
          if (!mounted) return;
          var code = await context.tipShow(SJPopUnAwardDialog());
          if(code >= 0){
            if (!mounted)return;
            setState(() {
              shai_anim = false;
              star_awarad = false;
            });
            if (SJLocalProvider.instance.sj_Level_inedx >= 5){
              await SJLocalProvider.instance.updateint(SJLocalProvider.instance.sj_Level_inedxName, 0);
              await SJLocalProvider.instance.updateint(SJLocalProvider.instance.sj_Level_numberName, SJLocalProvider.instance.sj_Level_number + 1);
              showLevelDialog();
            }
            showRatioDilog();
          }
        }
      });
    },child: Container(
      width: 0.width(context),
      height: scratch_h,
      decoration: BoxDecoration(
          image: SJDImg('sj_scratch_bg_1')
      ),
      child: Column(
        children: [
          SizedBox(height: 216.h,),
          Row(
            children: [
              SizedBox(width: 108.w,),
              SJText(text: 'Prize', size: 40, color: '#3A0153'.color(), weight: FontWeight.w900),
              SizedBox(width: 23.w,),
              SJText(text: '\$${goldRushResult.prize.toStringAsFixed(2)}', size: 40, color: '#25211D'.color(), weight: FontWeight.w900),
            ],
          ),
          SizedBox(height: 38.h,),
          SizedBox(
            width: 323.w,
            child: GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3, // 一行5个
                mainAxisSpacing: 10.w, // 垂直间距
                crossAxisSpacing: 30.w, // 水平间距
                childAspectRatio: 60 / 60, // 宽高比
              ),
              itemCount: 9,
              padding: EdgeInsets.only(top: 12.h, left: 42.w, right: 32.w), // 移除默认的padding// 最多显示10个
              itemBuilder: (context, index) {
                return SizedBox(
                    width: 60,
                    height: 60,
                    child: Stack(
                        children: [
                          if(goldRushResult.numbers[index] == -2)
                            SJAnimatedImageMove(imageUrl: 'sj_shaizi_icon', isAnimationEnabled: shai_anim, ws: 56, hs: 56, targetKey: targetimageKey),
                          if(goldRushResult.numbers[index] != -2)
                            Positioned(width: 56,child: SJBouncyImage(imagePath: 'sj_scratch_icon_1_${goldRushResult.numbers[index]}'.image(), width: 74, height: 65, enableAnimation: (star_awarad == true && goldRushResult.winIndexes!.contains(index)))),
                        ]
                    )
                );
              },
            ),
          )
        ],
      ),
    ));
  }
  // 刮卡2
  Widget buildScratchCard2() {
    return SJLocalImageScratchCard(autoStartY: 230.h,coverImagePath: 'sj_scratch_content_2'.image(), contentW: 0.width(context), contentH: scratch_h, onScratchEnd: () async {
      if (!mounted)return;
      setState(() {
        shai_anim = true;
        star_awarad = true;
      });
      await SJLocalProvider.instance.updateint(SJLocalProvider.instance.sj_scrach_end_number_2Name, SJLocalProvider.instance.sj_scrach_end_number_2 + 1);
      Future.delayed(Duration(seconds: 2), () async {
        // 更新本地数据
        await SJLocalProvider.instance.updateint(
          SJLocalProvider.instance.sj_card_numberName,
          SJLocalProvider.instance.sj_card_number + 1,
        );
        await SJLocalProvider.instance.updateint(
          SJLocalProvider.instance.sj_box_indexName,
          SJLocalProvider.instance.sj_box_index + 1,
        );
        await SJLocalProvider.instance.updateint(
          SJLocalProvider.instance.sj_tx_card_indexName,
          SJLocalProvider.instance.sj_tx_card_index + 1,
        );
        if (SJLocalProvider.instance.sj_tx_box_index >= SJNumberHelpers().last_taskModel!.task.first.first.num && SJLocalProvider.instance.sj_tx_card_index >= SJNumberHelpers().last_taskModel!.task.first.last.num && SJLocalProvider.instance.sj_tx_first_status == true) {
          await SJLocalProvider.instance.updateint(SJLocalProvider.instance.sj_tx_probability_indexName, 0);
          await SJLocalProvider.instance.updateint(SJLocalProvider.instance.sj_tx_dice_indexName, 0);
        }
        if (!SJLocalProvider.instance.sj_first_box_tips && SJLocalProvider.instance.sj_box_index >= SJNumberBHelper().numberEntity!.boxInterval){
          await SJLocalProvider.instance.updateBool(
            SJLocalProvider.instance.sj_first_box_tipsName,
            true,
          );
          await SJLocalProvider.instance.updateBool(
            SJLocalProvider.instance.sj_show_box_tipsName,
            true,
          );
        }
        if (!mounted) return; // ✅ 页面已经被销毁就直接返回
        SJLocalProvider.instance.updateint(SJLocalProvider.instance.sj_Level_inedxName, SJLocalProvider.instance.sj_Level_inedx + 1);
        if (lucku_momentResultb.diceHit){
          SJLocalProvider.instance.updateint(SJLocalProvider.instance.sj_dice_numberName, SJLocalProvider.instance.sj_dice_number + 1);
        }
        if (lucku_momentResultb.isWin) {
          await SJLocalProvider.instance.updateint(SJLocalProvider.instance.sj_scratch_not_award_numberName, 0);
          showAwardWidget(SJNumberHelpers().bonusConfigModel!.luckyMoment.pop!, lucku_momentResultb.winMatchNumbers.first, 'lucky_moment');
          if (!mounted)return;
          setState(() {
            shai_anim = false;
            star_awarad = false;
          });
          if (SJLocalProvider.instance.sj_Level_inedx >= 5){
            await SJLocalProvider.instance.updateint(SJLocalProvider.instance.sj_Level_inedxName, 0);
            await SJLocalProvider.instance.updateint(SJLocalProvider.instance.sj_Level_numberName, SJLocalProvider.instance.sj_Level_number + 1);
            showLevelDialog();
          }
        } else {
          await SJLocalProvider.instance.updateint(SJLocalProvider.instance.sj_scratch_not_award_numberName, SJLocalProvider.instance.sj_scratch_not_award_number + 1);
          if (!mounted) return;
          var code = await context.tipShow(SJPopUnAwardDialog());
          if(code >= 0){
            if (!mounted)return;
            setState(() {
              shai_anim = false;
              star_awarad = false;
            });
            if (SJLocalProvider.instance.sj_Level_inedx >= 5){
              await SJLocalProvider.instance.updateint(SJLocalProvider.instance.sj_Level_inedxName, 0);
              await SJLocalProvider.instance.updateint(SJLocalProvider.instance.sj_Level_numberName, SJLocalProvider.instance.sj_Level_number + 1);
              showLevelDialog();
            }
            showRatioDilog();
          }
        }
      });
    }, child: Container(
      width: 0.width(context),
      height: scratch_h,
      decoration: BoxDecoration(
          image: SJDImg('sj_scratch_bg_2')
      ),
      child: Column(
        children: [
          SizedBox(height: 217.h,),
          Row(
            children: [
              SizedBox(width: 32.w,),
              SizedBox(
                width: 100,
                height: 30,
                child: Stack(
                  children: [
                    if(lucku_momentResultb.winIndex == 0)
                      SizedBox(width: 100, height: 30,child: SJStrokeText(text: '\$${lucku_momentResultb.winMatchNumbers.first.toStringAsFixed(2)}', size: 24, color: '#FBE600'.color(), weight: FontWeight.w900, skWidth: 2, skColor: '#23362B'.color())),
                    if(lucku_momentResultb.winIndex != 0)
                      Center(child: SJImg(name: 'sj_scratch_icon_2_0', width: 50, height: 30,)),
                  ],
                ),
              ),
              SizedBox(width: 28.w,),
              SizedBox(
                width: 100,
                height: 30,
                child: Stack(
                  children: [
                    if(lucku_momentResultb.winIndex == 1)
                      SizedBox(width: 100, height: 30,child: SJStrokeText(text: '\$${lucku_momentResultb.winMatchNumbers.first.toStringAsFixed(2)}', size: 24, color: '#FBE600'.color(), weight: FontWeight.w900, skWidth: 2, skColor: '#23362B'.color())),
                    if(lucku_momentResultb.winIndex != 1)
                      Center(child: SJImg(name: 'sj_scratch_icon_2_0', width: 50, height: 30,)),
                  ],
                ),
              ),
              Spacer(),
              SizedBox(
                width: 100,
                height: 30,
                child: Stack(
                  children: [
                    if(lucku_momentResultb.winIndex == 2)
                      SizedBox(width: 100, height: 30,child: SJStrokeText(text: '\$${lucku_momentResultb.winMatchNumbers.first.toStringAsFixed(2)}', size: 24, color: '#FBE600'.color(), weight: FontWeight.w900, skWidth: 2, skColor: '#23362B'.color())),
                    if(lucku_momentResultb.winIndex != 2)
                      Center(child: SJImg(name: 'sj_scratch_icon_2_0', width: 50, height: 30,)),
                  ],
                ),
              ),
              SizedBox(width: 32.w,),
            ],
          ),
          SizedBox(height: 45.h,),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              SJText(text: '${lucku_momentResultb.winNumbers.first}', size: 40, color: '#25211D'.color(), weight: FontWeight.w900),
              SJText(text: '${lucku_momentResultb.winNumbers[1]}', size: 40, color: '#25211D'.color(), weight: FontWeight.w900),
              SJText(text: '${lucku_momentResultb.winNumbers[2]}', size: 40, color: '#25211D'.color(), weight: FontWeight.w900),
              SJText(text: '${lucku_momentResultb.winNumbers.last}', size: 40, color: '#25211D'.color(), weight: FontWeight.w900),
            ],
          ),
          SizedBox(height: 30.h,),
          SizedBox(
            width: 350.w,
            child: GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 4, // 一行5个
                mainAxisSpacing: 0, // 垂直间距
                crossAxisSpacing: 10, // 水平间距
                childAspectRatio: 70 / 50, // 宽高比
              ),
              itemCount: 12,
              padding: EdgeInsets.only(top: 15, left: 28.w, right: 0), // 移除默认的padding// 最多显示10个
              itemBuilder: (context, index) {
                return SizedBox(
                    width: 50,
                    height: 50,
                    child: Stack(
                        children: [
                          if(lucku_momentResultb.displayNumbers[index] == -2)
                            SJAnimatedImageMove(imageUrl: 'sj_shaizi_icon', isAnimationEnabled: shai_anim, ws: 50, hs: 50, targetKey: targetimageKey),
                          if(lucku_momentResultb.displayNumbers[index] != -2)
                            Positioned(width: 56,child: SJBouncyText(text: '${lucku_momentResultb.displayNumbers[index]}', fontSize: 32, color: lucku_momentResultb.winNumbers.contains(lucku_momentResultb.displayNumbers[index]) && star_awarad == true ? '#FBE600'.color() : '#23362B'.color(), enableAnimation: (lucku_momentResultb.winNumbers.contains(lucku_momentResultb.displayNumbers[index]) && star_awarad == true))),
                        ]
                    )
                );
              },
            ),
          )
        ],
      ),
    ));
  }
  // 刮卡3
  Widget buildScratchCard3() {
    return SJLocalImageScratchCard(autoStartY: 210.h,coverImagePath: 'sj_scratch_content_3'.image(), contentW: 0.width(context), contentH: scratch_h, onScratchEnd: () async {

      if (!mounted)return;
      setState(() {
        shai_anim = true;
        star_awarad = true;
      });
      await SJLocalProvider.instance.updateint(SJLocalProvider.instance.sj_scrach_end_number_3Name, SJLocalProvider.instance.sj_scrach_end_number_3 + 1);
      Future.delayed(Duration(seconds: 2), () async {
        // 更新本地数据
        await SJLocalProvider.instance.updateint(
          SJLocalProvider.instance.sj_card_numberName,
          SJLocalProvider.instance.sj_card_number + 1,
        );
        await SJLocalProvider.instance.updateint(
          SJLocalProvider.instance.sj_box_indexName,
          SJLocalProvider.instance.sj_box_index + 1,
        );
        await SJLocalProvider.instance.updateint(
          SJLocalProvider.instance.sj_tx_card_indexName,
          SJLocalProvider.instance.sj_tx_card_index + 1,
        );
        if (SJLocalProvider.instance.sj_tx_box_index >= SJNumberHelpers().last_taskModel!.task.first.first.num && SJLocalProvider.instance.sj_tx_card_index >= SJNumberHelpers().last_taskModel!.task.first.last.num && SJLocalProvider.instance.sj_tx_first_status == true) {
          await SJLocalProvider.instance.updateint(SJLocalProvider.instance.sj_tx_probability_indexName, 0);
          await SJLocalProvider.instance.updateint(SJLocalProvider.instance.sj_tx_dice_indexName, 0);
        }
        if (!SJLocalProvider.instance.sj_first_box_tips && SJLocalProvider.instance.sj_box_index >= SJNumberBHelper().numberEntity!.boxInterval){
          await SJLocalProvider.instance.updateBool(
            SJLocalProvider.instance.sj_first_box_tipsName,
            true,
          );
          await SJLocalProvider.instance.updateBool(
            SJLocalProvider.instance.sj_show_box_tipsName,
            true,
          );
        }
        if (!mounted) return; // ✅ 页面已经被销毁就直接返回
        SJLocalProvider.instance.updateint(SJLocalProvider.instance.sj_Level_inedxName, SJLocalProvider.instance.sj_Level_inedx + 1);
        if (secret_stashResult.diceHit){
          SJLocalProvider.instance.updateint(SJLocalProvider.instance.sj_dice_numberName, SJLocalProvider.instance.sj_dice_number + 1);
        }
        if (secret_stashResult.isWin) {
          await SJLocalProvider.instance.updateint(SJLocalProvider.instance.sj_scratch_not_award_numberName, 0);
          showAwardWidget(SJNumberHelpers().bonusConfigModel!.secretStash.pop!, 0.to2Double(secret_stashResult.prizeValues[secret_stashResult.winIndex] * secret_stashResult.multiplier), 'secret_stash');
          if (!mounted)return;
          setState(() {
            shai_anim = false;
            star_awarad = false;
          });
          if (SJLocalProvider.instance.sj_Level_inedx >= 5){
            await SJLocalProvider.instance.updateint(SJLocalProvider.instance.sj_Level_inedxName, 0);
            await SJLocalProvider.instance.updateint(SJLocalProvider.instance.sj_Level_numberName, SJLocalProvider.instance.sj_Level_number + 1);
            showLevelDialog();
          }
        } else {
          await SJLocalProvider.instance.updateint(SJLocalProvider.instance.sj_scratch_not_award_numberName, SJLocalProvider.instance.sj_scratch_not_award_number + 1);
          if (!mounted) return;
          var code = await context.tipShow(SJPopUnAwardDialog());
          if(code >= 0){
            if (!mounted)return;
            setState(() {
              shai_anim = false;
              star_awarad = false;
            });
            if (SJLocalProvider.instance.sj_Level_inedx >= 5){
              await SJLocalProvider.instance.updateint(SJLocalProvider.instance.sj_Level_inedxName, 0);
              await SJLocalProvider.instance.updateint(SJLocalProvider.instance.sj_Level_numberName, SJLocalProvider.instance.sj_Level_number + 1);
              showLevelDialog();
            }
            showRatioDilog();
          }
        }
      });
    }, child: Container(
      width: 0.width(context),
      height: scratch_h,
      decoration: BoxDecoration(
          image: SJDImg('sj_scratch_bg_3')
      ),
      child: Column(
        children: [
          SizedBox(height: 208.h,),
          Row(
            children: [
              SizedBox(width: 38.w,),
              Column(
                children: [
                  SizedBox(height: 50.h,),
                  SJImg(name: 'sj_scratch_icon_3_${secret_stashResult.winNumbers.first}', width: 53, height: 53,),
                  SizedBox(height: 35.h,),
                  SJImg(name: 'sj_scratch_icon_3_${secret_stashResult.winNumbers.last}', width: 53, height: 53,),
                ],
              ),
              SizedBox(width: 25.w,),
              SizedBox(
                width: 244.w,
                child: GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3, // 一行5个
                    mainAxisSpacing: 0, // 垂直间距
                    crossAxisSpacing: 10, // 水平间距
                    childAspectRatio: 53 / 70, // 宽高比
                  ),
                  itemCount: 9,
                  padding: EdgeInsets.only(top: 18.h, left: 28.w, right: 0), // 移除默认的padding// 最多显示10个
                  itemBuilder: (context, index) {
                    return SizedBox(
                        width: 53,
                        height: 73,
                        child: Stack(
                            children: [
                              if(secret_stashResult.numbers[index] == -2)
                                SJAnimatedImageMove(imageUrl: 'sj_shaizi_icon', isAnimationEnabled: shai_anim, ws: 53, hs: 53, targetKey: targetimageKey),
                              if(secret_stashResult.numbers[index] != -2)
                                Positioned(width: 53,child: SJBouncyImage(imagePath: 'sj_scratch_icon_3_${secret_stashResult.numbers[index]}'.image(), width: 53, height: 53, enableAnimation: (secret_stashResult.winNumbers.contains(secret_stashResult.numbers[index]) && star_awarad == true))),
                              if(secret_stashResult.numbers[index] != -2)
                                Positioned(width: 53,top: 40.h,child: SJBouncyText(text: '\$${secret_stashResult.prizeValues[index].toStringAsFixed(2)}', fontSize: 16, color: '#30190A'.color(), enableAnimation: (secret_stashResult.winNumbers.contains(secret_stashResult.numbers[index]) && star_awarad == true))),
                            ]
                        )
                    );
                  },
                ),
              )
            ],
          )
        ],
      ),
    ));
  }
  // 刮卡4
  Widget buildScratchCard4() {
    return SJLocalImageScratchCard(autoStartY: 265.h,coverImagePath: 'sj_scratch_content_4'.image(), contentW: 0.width(context), contentH: scratch_h, onScratchEnd: () async {
      if (!mounted)return;
      setState(() {
        shai_anim = true;
        star_awarad = true;
      });
      await SJLocalProvider.instance.updateint(SJLocalProvider.instance.sj_scrach_end_number_4Name, SJLocalProvider.instance.sj_scrach_end_number_4 + 1);
      Future.delayed(Duration(seconds: 2), () async {
        // 更新本地数据
        await SJLocalProvider.instance.updateint(
          SJLocalProvider.instance.sj_card_numberName,
          SJLocalProvider.instance.sj_card_number + 1,
        );
        await SJLocalProvider.instance.updateint(
          SJLocalProvider.instance.sj_tx_card_indexName,
          SJLocalProvider.instance.sj_tx_card_index + 1,
        );
        if (SJLocalProvider.instance.sj_tx_box_index >= SJNumberHelpers().last_taskModel!.task.first.first.num && SJLocalProvider.instance.sj_tx_card_index >= SJNumberHelpers().last_taskModel!.task.first.last.num && SJLocalProvider.instance.sj_tx_first_status == true) {
          await SJLocalProvider.instance.updateint(SJLocalProvider.instance.sj_tx_probability_indexName, 0);
          await SJLocalProvider.instance.updateint(SJLocalProvider.instance.sj_tx_dice_indexName, 0);
        }
        await SJLocalProvider.instance.updateint(
          SJLocalProvider.instance.sj_box_indexName,
          SJLocalProvider.instance.sj_box_index + 1,
        );
        if (!SJLocalProvider.instance.sj_first_box_tips && SJLocalProvider.instance.sj_box_index >= SJNumberBHelper().numberEntity!.boxInterval){
          await SJLocalProvider.instance.updateBool(
            SJLocalProvider.instance.sj_first_box_tipsName,
            true,
          );
          await SJLocalProvider.instance.updateBool(
            SJLocalProvider.instance.sj_show_box_tipsName,
            true,
          );
        }
        if (!mounted) return; // ✅ 页面已经被销毁就直接返回
        SJLocalProvider.instance.updateint(SJLocalProvider.instance.sj_Level_inedxName, SJLocalProvider.instance.sj_Level_inedx + 1);
        if (superMultipleResult.diceHit){
          SJLocalProvider.instance.updateint(SJLocalProvider.instance.sj_dice_numberName, SJLocalProvider.instance.sj_dice_number + 1);
        }
        if (superMultipleResult.isWin) {
          await SJLocalProvider.instance.updateint(SJLocalProvider.instance.sj_scratch_not_award_numberName, 0);
          showAwardWidget(SJNumberHelpers().bonusConfigModel!.superMultiple.pop!, 0.to2Double(superMultipleResult.prizeValues[superMultipleResult.winIndex] * superMultipleResult.multiplier), 'super_multiple');
          if (!mounted)return;
          setState(() {
            shai_anim = false;
            star_awarad = false;
          });
          if (SJLocalProvider.instance.sj_Level_inedx >= 5){
            await SJLocalProvider.instance.updateint(SJLocalProvider.instance.sj_Level_inedxName, 0);
            await SJLocalProvider.instance.updateint(SJLocalProvider.instance.sj_Level_numberName, SJLocalProvider.instance.sj_Level_number + 1);
            showLevelDialog();
          }
        } else {
          await SJLocalProvider.instance.updateint(SJLocalProvider.instance.sj_scratch_not_award_numberName, SJLocalProvider.instance.sj_scratch_not_award_number + 1);
          if (!mounted) return;
          var code = await context.tipShow(SJPopUnAwardDialog());
          if(code >= 0){
            if (!mounted)return;
            setState(() {
              shai_anim = false;
              star_awarad = false;
            });
            if (SJLocalProvider.instance.sj_Level_inedx >= 5){
              await SJLocalProvider.instance.updateint(SJLocalProvider.instance.sj_Level_inedxName, 0);
              await SJLocalProvider.instance.updateint(SJLocalProvider.instance.sj_Level_numberName, SJLocalProvider.instance.sj_Level_number + 1);
              showLevelDialog();
            }
            showRatioDilog();
          }
        }
      });
    }, child: Container(
      width: 0.width(context),
      height: scratch_h,
      decoration: BoxDecoration(
          image: SJDImg('sj_scratch_bg_4')
      ),
      child: Column(
        children: [
          SizedBox(height: 268.h,),
          SJImg(name: 'sj_scratch_icon_4_0', width: 102, height: 102,),
          SizedBox(height: 10.h,),
          SizedBox(
            width: 350.w,
            child: GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 5, // 一行5个
                mainAxisSpacing: 0, // 垂直间距
                crossAxisSpacing: 0, // 水平间距
                childAspectRatio: 50 / 55, // 宽高比
              ),
              itemCount: 10,
              padding: EdgeInsets.only(top: 10.h, left: 28.w, right: 0), // 移除默认的padding// 最多显示10个
              itemBuilder: (context, index) {
                return SizedBox(
                    width: 53,
                    height: 73,
                    child: Stack(
                        children: [
                          if(superMultipleResult.numbers[index] == -5)
                            SJAnimatedImageMove(imageUrl: 'sj_shaizi_icon', isAnimationEnabled: shai_anim, ws: 53, hs: 53, targetKey: targetimageKey),
                          if(superMultipleResult.numbers[index] != -5)
                            Positioned(width: 53,child: SJBouncyImage(imagePath: 'sj_scratch_icon_4_${superMultipleResult.numbers[index]}'.image(), width: 50, height: 50, enableAnimation: (superMultipleResult.numbers[index] < 0 && star_awarad == true))),
                          if(superMultipleResult.numbers[index] != -5)
                            Positioned(width: 53,top: 38.h,child: SJBouncyText(text: '\$${superMultipleResult.prizeValues[index].toStringAsFixed(2)}', fontSize: 16, color: '#22292E'.color(), enableAnimation: (superMultipleResult.numbers[index] < 0 && star_awarad == true))),
                        ]
                    )
                );
              },
            ),
          )
        ],
      ),
    ));
  }
  // 刮卡5
  Widget buildScratchCard5() {
    return SJLocalImageScratchCard(autoStartY: 220.h,coverImagePath: 'sj_scratch_content_5'.image(), contentW: 0.width(context), contentH: scratch_h, onScratchEnd: () async {
      if (!mounted)return;
      setState(() {
        shai_anim = true;
        star_awarad = true;
      });
      await SJLocalProvider.instance.updateint(SJLocalProvider.instance.sj_scrach_end_number_5Name, SJLocalProvider.instance.sj_scrach_end_number_5 + 1);
      Future.delayed(Duration(seconds: 2), () async {
        // 更新本地数据
        await SJLocalProvider.instance.updateint(
          SJLocalProvider.instance.sj_card_numberName,
          SJLocalProvider.instance.sj_card_number + 1,
        );
        await SJLocalProvider.instance.updateint(
          SJLocalProvider.instance.sj_box_indexName,
          SJLocalProvider.instance.sj_box_index + 1,
        );
        await SJLocalProvider.instance.updateint(
          SJLocalProvider.instance.sj_tx_card_indexName,
          SJLocalProvider.instance.sj_tx_card_index + 1,
        );
        if (SJLocalProvider.instance.sj_tx_box_index >= SJNumberHelpers().last_taskModel!.task.first.first.num && SJLocalProvider.instance.sj_tx_card_index >= SJNumberHelpers().last_taskModel!.task.first.last.num && SJLocalProvider.instance.sj_tx_first_status == true) {
          await SJLocalProvider.instance.updateint(SJLocalProvider.instance.sj_tx_probability_indexName, 0);
          await SJLocalProvider.instance.updateint(SJLocalProvider.instance.sj_tx_dice_indexName, 0);
        }
        if (!SJLocalProvider.instance.sj_first_box_tips && SJLocalProvider.instance.sj_box_index >= SJNumberBHelper().numberEntity!.boxInterval){
          await SJLocalProvider.instance.updateBool(
            SJLocalProvider.instance.sj_first_box_tipsName,
            true,
          );
          await SJLocalProvider.instance.updateBool(
            SJLocalProvider.instance.sj_show_box_tipsName,
            true,
          );
        }
        if (!mounted) return; // ✅ 页面已经被销毁就直接返回
        SJLocalProvider.instance.updateint(SJLocalProvider.instance.sj_Level_inedxName, SJLocalProvider.instance.sj_Level_inedx + 1);
        if (fortuneRushResult.diceHit){
          SJLocalProvider.instance.updateint(SJLocalProvider.instance.sj_dice_numberName, SJLocalProvider.instance.sj_dice_number + 1);
        }
        if (fortuneRushResult.isWin) {
          await SJLocalProvider.instance.updateint(SJLocalProvider.instance.sj_scratch_not_award_numberName, 0);
          showAwardWidget(SJNumberHelpers().bonusConfigModel!.fortuneRush.pop!, 0.to2Double(fortuneRushResult.prizeValues[fortuneRushResult.winRow]), 'fortune_rush');
          if (!mounted)return;
          setState(() {
            shai_anim = false;
            star_awarad = false;
          });
          if (SJLocalProvider.instance.sj_Level_inedx >= 5){
            await SJLocalProvider.instance.updateint(SJLocalProvider.instance.sj_Level_inedxName, 0);
            await SJLocalProvider.instance.updateint(SJLocalProvider.instance.sj_Level_numberName, SJLocalProvider.instance.sj_Level_number + 1);
            showLevelDialog();
          }
        } else {
          await SJLocalProvider.instance.updateint(SJLocalProvider.instance.sj_scratch_not_award_numberName, SJLocalProvider.instance.sj_scratch_not_award_number + 1);
          if (!mounted) return;
          var code = await context.tipShow(SJPopUnAwardDialog());
          if(code >= 0){
            if (!mounted)return;
            setState(() {
              shai_anim = false;
              star_awarad = false;
            });
            if (SJLocalProvider.instance.sj_Level_inedx >= 5){
              await SJLocalProvider.instance.updateint(SJLocalProvider.instance.sj_Level_inedxName, 0);
              await SJLocalProvider.instance.updateint(SJLocalProvider.instance.sj_Level_numberName, SJLocalProvider.instance.sj_Level_number + 1);
              showLevelDialog();
            }
            showRatioDilog();
          }
        }
      });
    }, child: Container(
      width: 0.width(context),
      height: scratch_h,
      decoration: BoxDecoration(
          image: SJDImg('sj_scratch_bg_5')
      ),
      child: Stack(
        children: [
          Column(
            children: [
              SizedBox(height: 230.h,),
              Row(
                children: [
                  SizedBox(
                    width: 278.w,
                    child: GridView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 5, // 一行5个
                        mainAxisSpacing: 0, // 垂直间距
                        crossAxisSpacing: 4, // 水平间距
                        childAspectRatio: 50 / 58, // 宽高比
                      ),
                      itemCount: 25,
                      padding: EdgeInsets.only(top: 10.h, left: 32.w), // 移除默认的padding// 最多显示10个
                      itemBuilder: (context, index) {
                        return SizedBox(
                            width: 60.w,
                            height: 40,
                            child: Stack(
                                children: [
                                  if(fortuneRushResult.numbers[index] == -1)
                                    Positioned(left: 10.w,child: SJAnimatedImageMove(imageUrl: 'sj_shaizi_icon', isAnimationEnabled: star_awarad, ws: 40, hs: 40, targetKey: targetimageKey)),
                                  if(fortuneRushResult.numbers[index] != -1 && index >= 2)
                                    Positioned(width: 60.w,child: SJBouncyText(text: '${fortuneRushResult.numbers[index]}', fontSize: 32, color:fortuneRushResult.numbers[index] == fortuneRushResult.winNumber && star_awarad == true ? '#FFDF23'.color() : '#2C302F'.color(), enableAnimation: (fortuneRushResult.numbers[index] == fortuneRushResult.winNumber && star_awarad == true))),
                                ]
                            )
                        );
                      },
                    ),
                  ),
                  SizedBox(width: 8.w,),
                  SizedBox(
                    width: 0.width(context) - 8.w - 278.w - 28.w,
                    height: 300.h,
                    child: Column(
                      children: [
                        SizedBox(height: 28.h,),
                        SJStrokeText(text: '\$${fortuneRushResult.prizeValues.first.toStringAsFixed(2)}', size: 20.spMin, color: '#FFDF23'.color(), weight: FontWeight.w400, skWidth: 2, skColor: '#00332E'.color()),
                        SizedBox(height: 34.h,),
                        SJStrokeText(text: '\$${fortuneRushResult.prizeValues[1].toStringAsFixed(2)}', size: 20.spMin, color: '#FFDF23'.color(), weight: FontWeight.w400, skWidth: 2, skColor: '#00332E'.color()),
                        SizedBox(height: 34.h,),
                        SJStrokeText(text: '\$${fortuneRushResult.prizeValues[2].toStringAsFixed(2)}', size: 20.spMin, color: '#FFDF23'.color(), weight: FontWeight.w400, skWidth: 2, skColor: '#00332E'.color()),
                        SizedBox(height: 34.h,),
                        SJStrokeText(text: '\$${fortuneRushResult.prizeValues[3].toStringAsFixed(2)}', size: 20.spMin, color: '#FFDF23'.color(), weight: FontWeight.w400, skWidth: 2, skColor: '#00332E'.color()),
                        SizedBox(height: 34.h,),
                        SJStrokeText(text: '\$${fortuneRushResult.prizeValues.last.toStringAsFixed(2)}', size: 20.spMin, color: '#FFDF23'.color(), weight: FontWeight.w400, skWidth: 2, skColor: '#00332E'.color()),
                      ],
                    ),
                  )
                ],
              )
            ],
          ),
          Positioned(left: 43.w, top: 218.h, child: SizedBox(width: 81, height:81, child: Center(child: SJText(text: '${fortuneRushResult.winNumber}', size: 64, color:fortuneRushResult.isWin == true ? 'FFDF23'.color() : '#191A1A'.color(), weight: FontWeight.w400, align: TextAlign.center,))))
        ],
      ),
    ));
  }
 // 刮卡6
  Widget buildScratchCard6() {
    return SJLocalImageScratchCard(autoStartY: 288.h,coverImagePath: 'sj_scratch_content_6'.image(), contentW: 0.width(context), contentH: scratch_h, onScratchEnd: () async {
      if (!mounted)return;
      setState(() {
        shai_anim = true;
        star_awarad = true;
      });
      await SJLocalProvider.instance.updateint(SJLocalProvider.instance.sj_scrach_end_number_6Name, SJLocalProvider.instance.sj_scrach_end_number_6 + 1);
      Future.delayed(Duration(seconds: 2), () async {
        // 更新本地数据
        await SJLocalProvider.instance.updateint(
          SJLocalProvider.instance.sj_card_numberName,
          SJLocalProvider.instance.sj_card_number + 1,
        );
        await SJLocalProvider.instance.updateint(
          SJLocalProvider.instance.sj_box_indexName,
          SJLocalProvider.instance.sj_box_index + 1,
        );
        await SJLocalProvider.instance.updateint(
          SJLocalProvider.instance.sj_tx_card_indexName,
          SJLocalProvider.instance.sj_tx_card_index + 1,
        );
        if (SJLocalProvider.instance.sj_tx_box_index >= SJNumberHelpers().last_taskModel!.task.first.first.num && SJLocalProvider.instance.sj_tx_card_index >= SJNumberHelpers().last_taskModel!.task.first.last.num && SJLocalProvider.instance.sj_tx_first_status == true) {
          await SJLocalProvider.instance.updateint(SJLocalProvider.instance.sj_tx_probability_indexName, 0);
          await SJLocalProvider.instance.updateint(SJLocalProvider.instance.sj_tx_dice_indexName, 0);
        }
        if (!SJLocalProvider.instance.sj_first_box_tips && SJLocalProvider.instance.sj_box_index >= SJNumberBHelper().numberEntity!.boxInterval){
          await SJLocalProvider.instance.updateBool(
            SJLocalProvider.instance.sj_first_box_tipsName,
            true,
          );
          await SJLocalProvider.instance.updateBool(
            SJLocalProvider.instance.sj_show_box_tipsName,
            true,
          );
        }
        if (!mounted) return; // ✅ 页面已经被销毁就直接返回
        SJLocalProvider.instance.updateint(SJLocalProvider.instance.sj_Level_inedxName, SJLocalProvider.instance.sj_Level_inedx + 1);
        if (sweetTimeResult.diceHit){
          SJLocalProvider.instance.updateint(SJLocalProvider.instance.sj_dice_numberName, SJLocalProvider.instance.sj_dice_number + 1);
        }
        if (sweetTimeResult.isWin) {
          await SJLocalProvider.instance.updateint(SJLocalProvider.instance.sj_scratch_not_award_numberName, 0);
          showAwardWidget(SJNumberHelpers().bonusConfigModel!.sweetTime.pop!, 0.to2Double(sweetTimeResult.prizeValues[sweetTimeResult.winningRow]), 'sweet_time');
          if (!mounted)return;
          setState(() {
            shai_anim = false;
            star_awarad = false;
          });
          if (SJLocalProvider.instance.sj_Level_inedx >= 5){
            await SJLocalProvider.instance.updateint(SJLocalProvider.instance.sj_Level_inedxName, 0);
            await SJLocalProvider.instance.updateint(SJLocalProvider.instance.sj_Level_numberName, SJLocalProvider.instance.sj_Level_number + 1);
            showLevelDialog();
          }
        } else {
          await SJLocalProvider.instance.updateint(SJLocalProvider.instance.sj_scratch_not_award_numberName, SJLocalProvider.instance.sj_scratch_not_award_number + 1);
          if (!mounted) return;
          var code = await context.tipShow(SJPopUnAwardDialog());
          if(code >= 0){
            if (!mounted)return;
            setState(() {
              shai_anim = false;
              star_awarad = false;
            });
            if (SJLocalProvider.instance.sj_Level_inedx >= 5){
              await SJLocalProvider.instance.updateint(SJLocalProvider.instance.sj_Level_inedxName, 0);
              await SJLocalProvider.instance.updateint(SJLocalProvider.instance.sj_Level_numberName, SJLocalProvider.instance.sj_Level_number + 1);
              showLevelDialog();
            }
            showRatioDilog();
          }
        }
      });
    }, child: Container(
      width: 0.width(context),
      height: scratch_h,
      decoration: BoxDecoration(
          image: SJDImg('sj_scratch_bg_6')
      ),
      child: Column(
        children: [
          SizedBox(height: 267.h,),
          Row(
            children: [
              SizedBox(width: 12.w,),
              SizedBox(
                width: 120.w,
                child: Column(
                  children: [
                    SizedBox(height: 12.h,),
                    SizedBox(width: 120.w, height: 53, child: SJText(text: '\$${sweetTimeResult.prizeValues.first.toStringAsFixed(2)}', size: 32, color: '#7C183C'.color(), weight: FontWeight.w500, align: TextAlign.center,)),
                    SizedBox(height: 38.h,),
                    SizedBox(width: 120.w, height: 53, child: SJText(text: '\$${sweetTimeResult.prizeValues[1].toStringAsFixed(2)}', size: 32, color: '#7C183C'.color(), weight: FontWeight.w500, align: TextAlign.center,)),
                    SizedBox(height: 32.h,),
                    SizedBox(width: 120.w, height: 53, child: SJText(text: '\$${sweetTimeResult.prizeValues.last.toStringAsFixed(2)}', size: 32, color: '#7C183C'.color(), weight: FontWeight.w500, align: TextAlign.center,)),
                  ],
                ),
              ),
              SizedBox(
                width: 212.w,
                child: GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3, // 一行5个
                    mainAxisSpacing: 0, // 垂直间距
                    crossAxisSpacing: 4, // 水平间距
                    childAspectRatio: 64 / 80, // 宽高比
                  ),
                  itemCount: 9,
                  padding: EdgeInsets.only(top: 28.h, left: 8.w), // 移除默认的padding// 最多显示10个
                  itemBuilder: (context, index) {
                    return SizedBox(
                        width: 64,
                        height: 64,
                        child: Stack(
                            children: [
                              if(sweetTimeResult.numbers[index] == -1)
                                SJAnimatedImageMove(imageUrl: 'sj_shaizi_icon', isAnimationEnabled: shai_anim, ws: 64, hs: 64, targetKey: targetimageKey),
                              if(sweetTimeResult.numbers[index] != -1)
                                SJBouncyImage(imagePath: 'sj_scratch_icon_6_${sweetTimeResult.numbers[index]}'.image(), width: 64, height: 64, enableAnimation: (sweetTimeResult.winningRowIndexes.contains(index) && star_awarad == true),)
                            ]
                        )
                    );
                  },
                ),
              ),
            ],
          )
        ],
      ),
    ));
  }
  // 是否显示概率栏
  Future<void> showRatioDilog() async {
    if (SJLocalProvider.instance.sj_scratch_not_award_number == 2){
      await SJLocalProvider.instance.updateint(SJLocalProvider.instance.sj_scratch_not_award_numberName, 0);
      if (!mounted) return;
      context.tipShow(SJPopRatioDialog());
    }
  }
  void showLevelDialog(){
    // context.tipShow(SJPopLevelADialog());
  }
  // 展示奖励弹框
  Future<void> showAwardWidget(List<int> pops, double award, String types) async {
    sj_event_fire('scratch_card_suc', {});
    bool isShow = false;
    bool isShowThree = false;

    if (award < pops.first) {
      isShow = false;
      isShowThree = false;
    } else if (award < pops.last) {
      isShow = true;
      isShowThree = false;
    } else {
      isShow = true;
      isShowThree = true;
    }
    if(!mounted)return;
    // 调用弹框
    await (context.tipShow2(
      SJPopYouWinBDialog(
        award: award,
        is_show: isShow,
        is_showThree: isShowThree,
        type: types,
      ),
    ));
  }
  // 进入下一个主题
  Future<void> popToNextScratch() async {
    await Future.delayed(Duration(milliseconds: 50),(){});
    await SJLocalProvider.instance.updateBool(SJLocalProvider.instance.is_end_ScratchName, true);
    if (SJLocalProvider.instance.sj_Scratch_timeKey_0.isEmpty && SJLocalProvider.instance.sj_scrach_end_number_0 >= 10){
      if (!mounted)return;
      Navigator.of(context).pop();
      SJScratchPushNextNotificationService.sendToDomandNumberNotification(1);
      await SJLocalProvider.instance.updateString(SJLocalProvider.instance.sj_Scratch_timeKey_0Name,DateTime.now().toIso8601String());
    } else if (SJLocalProvider.instance.sj_Scratch_timeKey_1.isEmpty && SJLocalProvider.instance.sj_scrach_end_number_1 >= 10){
      if (!mounted)return;
      Navigator.of(context).pop();
      SJScratchPushNextNotificationService.sendToDomandNumberNotification(2);
      await SJLocalProvider.instance.updateString(SJLocalProvider.instance.sj_Scratch_timeKey_1Name,DateTime.now().toIso8601String());
    } else if (SJLocalProvider.instance.sj_Scratch_timeKey_2.isEmpty && SJLocalProvider.instance.sj_scrach_end_number_2 >= 10){
      if (!mounted)return;
      Navigator.of(context).pop();
      SJScratchPushNextNotificationService.sendToDomandNumberNotification(3);
      await SJLocalProvider.instance.updateString(SJLocalProvider.instance.sj_Scratch_timeKey_2Name,DateTime.now().toIso8601String());
    } else if (SJLocalProvider.instance.sj_Scratch_timeKey_3.isEmpty && SJLocalProvider.instance.sj_scrach_end_number_3 >= 10){
      if (!mounted)return;
      Navigator.of(context).pop();
      SJScratchPushNextNotificationService.sendToDomandNumberNotification(4);
      await SJLocalProvider.instance.updateString(SJLocalProvider.instance.sj_Scratch_timeKey_3Name,DateTime.now().toIso8601String());
    } else if (SJLocalProvider.instance.sj_Scratch_timeKey_4.isEmpty && SJLocalProvider.instance.sj_scrach_end_number_4 >= 10){
      if (!mounted)return;
      Navigator.of(context).pop();
      SJScratchPushNextNotificationService.sendToDomandNumberNotification(5);
      await SJLocalProvider.instance.updateString(SJLocalProvider.instance.sj_Scratch_timeKey_4Name,DateTime.now().toIso8601String());
    } else if (SJLocalProvider.instance.sj_Scratch_timeKey_5.isEmpty && SJLocalProvider.instance.sj_scrach_end_number_5 >= 10){
      if (!mounted)return;
      Navigator.of(context).pop();
      SJScratchPushNextNotificationService.sendToDomandNumberNotification(6);
      await SJLocalProvider.instance.updateString(SJLocalProvider.instance.sj_Scratch_timeKey_5Name,DateTime.now().toIso8601String());
    } else if (SJLocalProvider.instance.sj_Scratch_timeKey_6.isEmpty && SJLocalProvider.instance.sj_scrach_end_number_6 >= 10){
      if (!mounted)return;
      Navigator.of(context).pop();
      SJScratchPushNextNotificationService.sendToDomandNumberNotification(0);
      await SJLocalProvider.instance.updateString(SJLocalProvider.instance.sj_Scratch_timeKey_6Name,DateTime.now().toIso8601String());
    } else {
      if (!mounted) return;
      poptxTaskContent();
      // 下一张内容刷新
      if (widget.type == 0) {
        setState(() {
          extra_bonusResult = SJNumberBHelper().generateextra_bonusNumbers();
          SJScratchUpdateNotificationService.sendToDomandNumberNotification(0);
        });
      } else if (widget.type == 1) {
        setState(() {
          goldRushResult =
              SJNumberBHelper().generate3x3NumbersWithPrizeAndDice();
          SJScratchUpdateNotificationService.sendToDomandNumberNotification(0);
        });
      } else if (widget.type == 2) {
        setState(() {
          lucku_momentResultb = SJNumberBHelper().generatelucku_momentNumbers();
          SJScratchUpdateNotificationService.sendToDomandNumberNotification(0);
        });
      } else if (widget.type == 3) {
        setState(() {
          secret_stashResult = SJNumberBHelper().generatesecret_stashStash();
          SJScratchUpdateNotificationService.sendToDomandNumberNotification(0);
        });
      } else if (widget.type == 4) {
        setState(() {
          superMultipleResult = SJNumberBHelper().generateSuperMultiple();
          SJScratchUpdateNotificationService.sendToDomandNumberNotification(0);
        });
      } else if (widget.type == 5) {
        setState(() {
          fortuneRushResult = SJNumberBHelper().generateFortuneRush();
          SJScratchUpdateNotificationService.sendToDomandNumberNotification(0);
        });
      } else if (widget.type == 6) {
        setState(() {
          sweetTimeResult = SJNumberBHelper().generateSweetTime();
          SJScratchUpdateNotificationService.sendToDomandNumberNotification(0);
        });
      }
      if (widget.type == 0) {
        swapKey.currentState?.runSwap(buildScratchCard0());
      } else if (widget.type == 1) {
        swapKey1.currentState?.runSwap(buildScratchCard1());
      } else if (widget.type == 2) {
        swapKey2.currentState?.runSwap(buildScratchCard2());
      } else if (widget.type == 3) {
        swapKey3.currentState?.runSwap(buildScratchCard3());
      } else if (widget.type == 4) {
        swapKey4.currentState?.runSwap(buildScratchCard4());
      } else if (widget.type == 5) {
        swapKey5.currentState?.runSwap(buildScratchCard5());
      } else if (widget.type == 6) {
        swapKey6.currentState?.runSwap(buildScratchCard6());
      }
    }
  }

  // 运营逻辑添加
  Future<void> poptxTaskContent() async {
    await Future.delayed(Duration(milliseconds: 50),(){});
    if(SJLocalProvider.instance.sj_card_number == 4 && SJLocalProvider.instance.sj_yunying_1 == false){
      await SJLocalProvider.instance.updateBool(SJLocalProvider.instance.sj_yunying_1Name, true);
      if (!mounted) return;
      context.tipShow(SJPopSubmitAccountDialog());
    } else if (SJLocalProvider.instance.sj_card_number == 7 && SJLocalProvider.instance.sj_yunying_3 == false){
      await SJLocalProvider.instance.updateBool(SJLocalProvider.instance.sj_yunying_3Name, true);
      if (!mounted) return;
      context.tipShow(SJPopSubmitLastDialog());
    } else if (SJLocalProvider.instance.sj_dolas_number >= 800 && SJLocalProvider.instance.sj_dolas_800 == false){
      await SJLocalProvider.instance.updateBool(SJLocalProvider.instance.sj_dolas_800Name, true);
      if (!mounted) return;
      context.tipShow(SJPopTXDiceDialog());
    } else if (SJLocalProvider.instance.sj_dolas_number >= 1000 && SJLocalProvider.instance.sj_dolas_1000 == false){
      await SJLocalProvider.instance.updateBool(SJLocalProvider.instance.sj_dolas_1000Name, true);
      if (!mounted) return;
      context.tipShow(SJPopTXWallerDialog());
    }
  }
}


final swapKey = GlobalKey<_CardSwapAnimatorState>();
final swapKey1 = GlobalKey<_CardSwapAnimatorState>();
final swapKey2 = GlobalKey<_CardSwapAnimatorState>();
final swapKey3 = GlobalKey<_CardSwapAnimatorState>();
final swapKey4 = GlobalKey<_CardSwapAnimatorState>();
final swapKey5 = GlobalKey<_CardSwapAnimatorState>();
final swapKey6 = GlobalKey<_CardSwapAnimatorState>();

class CardSwapAnimator extends StatefulWidget {
  final Widget child;                 // 初始卡片
  final Duration duration;

  const CardSwapAnimator({
    super.key,
    required this.child,
    this.duration = const Duration(milliseconds: 650),
  });

  @override
  State<CardSwapAnimator> createState() => _CardSwapAnimatorState();
}

class _CardSwapAnimatorState extends State<CardSwapAnimator>
    with SingleTickerProviderStateMixin {

  late Widget _current;
  Widget? _next;

  late AnimationController _controller;

  late Animation<double> oldOffsetX;
  late Animation<double> oldRotation;

  late Animation<double> newOffsetX;
  late Animation<double> newRotation;
  late Animation<double> newOpacity;

  @override
  void initState() {
    super.initState();

    _current = widget.child;

    _controller = AnimationController(
      vsync: this,
      duration: widget.duration,
    );

    oldOffsetX = Tween<double>(begin: 0, end: 280).animate(
      CurvedAnimation(parent: _controller,
          curve: const Interval(0.0, 0.65, curve: Curves.easeIn)),
    );

    oldRotation = Tween<double>(begin: 0, end: 0.35).animate(
      CurvedAnimation(parent: _controller,
          curve: const Interval(0.0, 0.7, curve: Curves.easeIn)),
    );

    newOffsetX = Tween<double>(begin: -280, end: 0).animate(
      CurvedAnimation(parent: _controller,
          curve: const Interval(0.35, 1.0, curve: Curves.easeOutBack)),
    );

    newRotation = Tween<double>(begin: -0.35, end: 0).animate(
      CurvedAnimation(parent: _controller,
          curve: const Interval(0.35, 1.0, curve: Curves.easeOut)),
    );

    newOpacity = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _controller,
          curve: const Interval(0.3, 1.0, curve: Curves.easeOut)),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override void didUpdateWidget(CardSwapAnimator oldWidget) {
    super.didUpdateWidget(oldWidget);
    // 当外部 child 改变时，如果没有正在动画，需要更新 _current
    if (oldWidget.child != widget.child && _next == null) {
      setState(() {
        _current = widget.child;
      });
    }
  }

  /// 外部调用 controller.swapTo(newCard) 时触发此处
  Future<void> runSwap(Widget newCard) async {
    if (!mounted) return;

    if (_next != null) return; // 动画未结束时不允许叠加切换

    _next = newCard;

    await _controller.forward();

    if (!mounted) return;

    // 动画结束：替换 current
    setState(() {
      _current = _next!;
      _next = null;
    });

    _controller.reset();
    // 切完卡 显示宝箱
    if (SJLocalProvider.instance.sj_box_index >=
        SJNumberBHelper().numberEntity!.boxInterval &&
        SJLocalProvider.instance.sj_show_box == false) {
      await SJLocalProvider.instance.updateBool(
          SJLocalProvider.instance.sj_show_boxName, false);
      await SJLocalProvider.instance.updateBool(
          SJLocalProvider.instance.sj_show_boxName, true);
      if (!mounted) return;
      context.tipShow(SJBoxOpenDiaologWidget());
    }
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (_, __) {
        return Stack(
          children: [

            /// OLD CARD
            Transform.translate(
              offset: Offset(oldOffsetX.value, 0),
              child: Transform.rotate(
                angle: oldRotation.value,
                child: _current,
              ),
            ),

            /// NEW CARD（可能为空）
            if (_next != null)
              Opacity(
                opacity: newOpacity.value,
                child: Transform.translate(
                  offset: Offset(newOffsetX.value, 0),
                  child: Transform.rotate(
                    angle: newRotation.value,
                    child: _next!,
                  ),
                ),
              ),
          ],
        );
      },
    );
  }
}



class SJScratchNextNotificationService {
  static final StreamController<int> _streamController = StreamController<int>.broadcast();

  static Stream<int> get stream => _streamController.stream;

  static void sendToDomandNumberNotification(int value) {
    _streamController.sink.add(value);
  }

  static void close() {
    _streamController.close();
  }
}


class SJBottomDetailsBarWidget extends StatefulWidget {
  SJBottomDetailsBarWidget({super.key});
  @override
  State<SJBottomDetailsBarWidget> createState() => _SJBottomDetailsBarWidgetState();
}

class _SJBottomDetailsBarWidgetState extends State<SJBottomDetailsBarWidget> {

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
          SizedBox(width: 16.w),
          SizedBox(
            width: 100,
            height: 89,
            child: InkWell(
              onTap: () async {
                if (SJLocalProvider.instance.sj_box_index >= SJNumberBHelper().numberEntity!.boxInterval){
                  await SJLocalProvider.instance.updateBool(SJLocalProvider.instance.sj_show_box_tipsName, false);
                  if (!context.mounted) return;
                  context.tipShow(SJBoxOpenDiaologWidget());
                } else {
                  SJDialogTool.toast(homeKey.currentState!.ctx, 'open a gift chest every 3 scratches');
                }
              },
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
          SizedBox(width: 4.w),
          SizedBox(
            width: 200, height: 80,
            child: Consumer<SJLocalProvider>(
              builder: (context, provider, child) {
                return InkWell(
                  onTap: () async {
                    if (provider.is_end_Scratch){
                      await SJLocalProvider.instance.updateBool(SJLocalProvider.instance.is_end_ScratchName, false);
                      sj_event_fire('scratch_card', {'type' : 'aut'});
                      sj_event_fire('scratch_card_aut', {});
                      SJScratchUpdateNotificationService.sendToDomandNumberNotification(1);
                    }
                  },
                  child: SJImg(name: 'sj_revall_btn', width: 200, height: 80),
                );
              },
            ),
          ),
          Spacer(),
        SizedBox(
          width: 70,
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
                key: targetimageKey,
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
          SizedBox(width: 16.w),
        ],
      ),
    );
  }
}

class BouncySJImg extends StatefulWidget {
  const BouncySJImg({super.key});

  @override
  State<BouncySJImg> createState() => _BouncySJImgState();
}

class _BouncySJImgState extends State<BouncySJImg>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _scaleAnim;

  @override
  void initState() {
    super.initState();

    // 再加快节奏：500ms 一次循环（更明显更灵动）
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );

    // 调整幅度和曲线，使弹性更Q更自然
    _scaleAnim = Tween(begin: 0.98, end: 1.07)
        .chain(CurveTween(curve: Curves.easeInOut))
        .animate(_controller);

    // 循环呼吸动画
    _controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        _controller.reverse();
      } else if (status == AnimationStatus.dismissed) {
        _controller.forward();
      }
    });

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ScaleTransition(
      scale: _scaleAnim,
      child: InkWell(
        onTap: () async {
          if (!SJLocalProvider.instance.is_end_Scratch) return;
          var code = await context.tipShow(CardShuffleAnimation(is_start: false, souce_fromat: 'card',));
          if (code == 1){
            SJScratchProbabilityUpNotificationService.notify(0);
          }
        },
        child:Consumer<SJLocalProvider>(
          builder: (context, provider, child) {
            return SJImg(
              name: 'sj_${provider.sj_ratio_str}%_btn',
              width: 318,
              height: 48,
            );
          },
        ),
      ),
    );
  }
}

class SJDetailsBarWidget extends StatefulWidget {
  final bool isCash;
  SJDetailsBarWidget({super.key, required this.isCash});
  @override
  State<SJDetailsBarWidget> createState() => _SJDetailsBarWidgetState();
}

class _SJDetailsBarWidgetState extends State<SJDetailsBarWidget> {

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
                width: 155,
                height: 49,
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
                              return InkWell(
                                onTap: (){
                                  if (widget.isCash) return;
                                  Navigator.of(homeKey.currentState!.ctx).push(
                                    MaterialPageRoute(
                                      builder: (builder) {
                                        return SJCash();
                                      },
                                    ),
                                  );
                                },
                                child: Padding(
                                  padding: EdgeInsets.only(top: 2.0, left: 32.12),
                                  child: Center(
                                    child: SJGradientNumberRoller(
                                      value: provider.sj_dolas_number,
                                      duration: 800,
                                      fontSize: 20.0,
                                      gradientColors: ['#FFFFFF'.color(), '#FFCD61'.color()],
                                      borderColor: '#FFFFFF'.color(),
                                      borderWidth: 0.0,
                                      decimalPlaces: 2,
                                    ),
                                  ),
                                ),
                              );
                            },
                          )
                      ),
                    ),
                    SJImg(name: 'sj_dolas_icon', width: 49, height: 49,)
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
            InkWell(
              onTap: (){
                Navigator.pop(context);
              },
              child: SJImg(name: 'sj_home_btn', width: 34, height: 34,),
            ),
            SizedBox(width: 21,)
          ],
        ),
      ),
    );
  }
}

/// 全局通知服务：概率提升事件
class SJScratchProbabilityUpNotificationService {
  // ---- 1. 全局广播 StreamController ----
  static final StreamController<int> _controller =
  StreamController<int>.broadcast();

  // ---- 2. 对外暴露 Stream ----
  static Stream<int> get stream => _controller.stream;

  // ---- 3. 全局发送事件 ----
  static void notify(int value) {
    if (!_controller.isClosed) {
      _controller.add(value);
    }
  }

  // ---- 4. 禁止随便关闭（除非整个 APP 销毁）----
  static void dispose() {
    if (!_controller.isClosed) {
      _controller.close();
    }
  }
}
