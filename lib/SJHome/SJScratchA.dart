import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:scratchjoy/SJDilaog/SJDialog.dart';
import 'package:scratchjoy/SJTool/SJTBAInfoTool.dart';
import 'package:scratchjoy/SJTool/sj_NumberHelper.dart';
import 'package:scratchjoy/SJTool/sj_extension_help.dart';
import 'package:scratchjoy/SJTool/sj_mp3_player.dart';
import 'package:scratchjoy/SJTool/sj_numberBHelper.dart' hide SJ3x3Result;
import 'package:scratchjoy/SJTool/sj_stroke_text.dart';
import 'package:scratchjoy/main.dart';
import '../SJTool/sj_GradientNumber.dart';
import '../SJTool/sj_LocalProvider.dart';
import '../SJTool/sj_img.dart';
import '../SJTool/sj_scratch_card_image_prize.dart';
import '../SJTool/sj_text.dart';
import 'SJCash.dart';
import 'SJDiceRollWidget.dart';
import 'SJHome.dart';
import 'SJScratchB.dart';
import 'SJScratchRatio.dart';

enum sj_scratchtype {
  extea_bonus,
  gold_rush,
  blowout,
  secret_stash,
  super_muliple,
  fortune_rush,
  sweet_time,
}

// 定义目标组件的 Key
final GlobalKey targetimageKey = GlobalKey();

class SJScratchA extends StatefulWidget {
  final int type;
  SJScratchA({super.key, required this.type});
  @override
  State<SJScratchA> createState() => _SJScratchAState();
}

class _SJScratchAState extends State<SJScratchA> {

  @override
  void initState() {
    // TODO: implement initState
    '${262.h}'.log();
    super.initState();
    // 当前帧构建完成后
    WidgetsBinding.instance.addPostFrameCallback((_) {
      // 在这里执行需要更新UI的操作
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    SJAudioUtils().stopAllTempAudio();
    SJAudioUtils().playBGM();
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
            SizedBox(width: 0.width(context), height: 0.height(context) - 118 - 60, child: SJScratchContentAWidget(type: widget.type),),
            ),
            Column(
              children: [
                SJDetailsBarWidget(isCash: false),
                Spacer(),
                SJBottomDetailsBarWidget(),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class SJScratchContentAWidget extends StatefulWidget {
  final int type;
  SJScratchContentAWidget({super.key, required this.type});
  @override
  State<SJScratchContentAWidget> createState() => _SJScratchContentAWidgetState();
}

class _SJScratchContentAWidgetState extends State<SJScratchContentAWidget> {

  late double scratch_h = 0.height(context) - 118 - 60;

  bool shai_anim = false;

  bool star_awarad = false;

  bool is_100ratio = false;

  SJPlayJoyResult extra_bonusResult = SJNumberAHelper().generateextra_bonusNumbers(forceWin: SJLocalProvider.instance.sj_card_a_number <= 0);

  SJ3x3Result goldRushResult = SJNumberAHelper().generate3x3NumbersWithPrizeAndDice(forceWin: SJLocalProvider.instance.sj_card_a_number <= 0);

  SJPlayJoyResult lucku_momentResult = SJNumberAHelper().generatelucku_momentNumbers(forceWin: SJLocalProvider.instance.sj_card_a_number <= 0);

  SJsecret_stashResult  secret_stashResult = SJNumberAHelper().generatesecret_stashStash(forceWin: SJLocalProvider.instance.sj_card_a_number <= 0);

  SJsuperMultipleResult superMultipleResult = SJNumberAHelper().generateSuperMultiple(forceWin: SJLocalProvider.instance.sj_card_a_number <= 0);

  SJfortuneRushResult fortuneRushResult = SJNumberAHelper().generateFortuneRush(forceWin: SJLocalProvider.instance.sj_card_a_number <= 0);

  SJSweetTimeResult sweetTimeResult = SJNumberAHelper().generateSweetTime(forceWin: SJLocalProvider.instance.sj_card_a_number <= 0);

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    SJLocalProvider.instance.updateBool(SJLocalProvider.instance.is_end_ScratchName, true);
    // 100% 中奖处理，只保留当前的记录退出不算
    SJScratchProbabilityUpNotificationService.stream.listen((value) async {
      if (widget.type == 0){
        setState(() {
          extra_bonusResult = SJNumberAHelper().generateextra_bonusNumbers(forceWin: true);
          SJScratchUpdateNotificationService.sendToDomandNumberNotification(0);
        });
      } else if (widget.type == 1){
        setState(() {
          goldRushResult = SJNumberAHelper().generate3x3NumbersWithPrizeAndDice(forceWin: true);
          SJScratchUpdateNotificationService.sendToDomandNumberNotification(0);
        });
      } else if (widget.type == 2){
        setState(() {
          lucku_momentResult = SJNumberAHelper().generatelucku_momentNumbers(forceWin: true);
          SJScratchUpdateNotificationService.sendToDomandNumberNotification(0);
        });
      } else if (widget.type == 3){
        setState(() {
          secret_stashResult = SJNumberAHelper().generatesecret_stashStash(forceWin: true);
          SJScratchUpdateNotificationService.sendToDomandNumberNotification(0);
        });
      } else if (widget.type == 4){
        setState(() {
          superMultipleResult = SJNumberAHelper().generateSuperMultiple(forceWin: true);
          SJScratchUpdateNotificationService.sendToDomandNumberNotification(0);
        });
      } else if (widget.type == 5){
        setState(() {
          fortuneRushResult = SJNumberAHelper().generateFortuneRush(forceWin: true);
          SJScratchUpdateNotificationService.sendToDomandNumberNotification(0);
        });
      } else if (widget.type == 6){
        setState(() {
          sweetTimeResult = SJNumberAHelper().generateSweetTime(forceWin: true);
          SJScratchUpdateNotificationService.sendToDomandNumberNotification(0);
        });
      }
    });
    // 100% 中奖处理，只保留当前的记录退出不算
    SJScratchProbabilityUpNotificationService.stream.listen((value) async {
      // 当前帧构建完成后
      WidgetsBinding.instance.addPostFrameCallback((_) {
        updateBaifenbai();
      });
    });
  }

  Future<void> updateBaifenbai() async {
    await Future.delayed(Duration(milliseconds: 50)); // 重要：等待 overlay 完全 detach
    if (widget.type == 0){
      setState(() {
        extra_bonusResult = SJNumberAHelper().generateextra_bonusNumbers(forceWin: true);
        SJScratchUpdateNotificationService.sendToDomandNumberNotification(0);
      });
    } else if (widget.type == 1){
      setState(() {
        goldRushResult = SJNumberAHelper().generate3x3NumbersWithPrizeAndDice(forceWin: true);
        SJScratchUpdateNotificationService.sendToDomandNumberNotification(0);
      });
    } else if (widget.type == 2){
      setState(() {
        lucku_momentResult = SJNumberAHelper().generatelucku_momentNumbers(forceWin: true);
        SJScratchUpdateNotificationService.sendToDomandNumberNotification(0);
      });
    } else if (widget.type == 3){
      setState(() {
        secret_stashResult = SJNumberAHelper().generatesecret_stashStash(forceWin: true);
        SJScratchUpdateNotificationService.sendToDomandNumberNotification(0);
      });
    } else if (widget.type == 4){
      setState(() {
        superMultipleResult = SJNumberAHelper().generateSuperMultiple(forceWin: true);
        SJScratchUpdateNotificationService.sendToDomandNumberNotification(0);
      });
    } else if (widget.type == 5){
      setState(() {
        fortuneRushResult = SJNumberAHelper().generateFortuneRush(forceWin: true);
        SJScratchUpdateNotificationService.sendToDomandNumberNotification(0);
      });
    } else if (widget.type == 6){
      setState(() {
        sweetTimeResult = SJNumberAHelper().generateSweetTime(forceWin: true);
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
          SJLocalImageScratchCard(autoStartY: 235.h,coverImagePath: 'sj_scratch_content_0'.image(), contentW: 0.width(context), contentH: scratch_h, onScratchEnd: () async {
           setState(() {
             shai_anim = true;
             star_awarad = true;
           });
           Future.delayed(Duration(seconds: 2), () async {
             if (!mounted) return; // ✅ 页面已经被销毁就直接返回
             SJLocalProvider.instance.updateint(SJLocalProvider.instance.sj_Level_inedxName, SJLocalProvider.instance.sj_Level_inedx + 1);
             SJLocalProvider.instance.updateint(SJLocalProvider.instance.sj_card_a_numberName, SJLocalProvider.instance.sj_card_a_number + 1);
             if (extra_bonusResult.diceHit){
               SJLocalProvider.instance.updateint(SJLocalProvider.instance.sj_dice_numberName, SJLocalProvider.instance.sj_dice_number + 1);
             }
             if (extra_bonusResult.isWin) {
               var code = await context.tipShow(SJPopYouWinADialog(
                   award: extra_bonusResult.winMatchNumbers[extra_bonusResult
                       .winIndex].toInt(), is_dice: false));
               if (code >= 0) {
                 setState(() {
                   shai_anim = false;
                   star_awarad = false;
                   extra_bonusResult =
                       SJNumberAHelper().generateextra_bonusNumbers();
                 });
                 SJScratchUpdateNotificationService
                     .sendToDomandNumberNotification(0);
                 SJLocalProvider.instance.updateint(SJLocalProvider.instance.sj_scrach_end_number_0Name, SJLocalProvider.instance.sj_scrach_end_number_0 + 1);
                 if (SJLocalProvider.instance.sj_scrach_end_number_0 >= 9){
                   await SJLocalProvider.instance.updateString(SJLocalProvider.instance.sj_Scratch_timeKey_0Name,DateTime.now().toIso8601String());
                   popToNextScratch();
                 }
                 if (SJLocalProvider.instance.sj_Level_inedx >= 5){
                   await SJLocalProvider.instance.updateint(SJLocalProvider.instance.sj_Level_inedxName, 0);
                   await SJLocalProvider.instance.updateint(SJLocalProvider.instance.sj_Level_numberName, SJLocalProvider.instance.sj_Level_number + 1);
                   showLevelDialog();
                 }
               }
             } else {
               var code = await context.tipShow(SJPopUnAwardDialog());
               if(code >= 0){
                 setState(() {
                   shai_anim = false;
                   star_awarad = false;
                   extra_bonusResult =
                       SJNumberAHelper().generateextra_bonusNumbers();
                 });
                 SJScratchUpdateNotificationService
                     .sendToDomandNumberNotification(0);
                 SJLocalProvider.instance.updateint(SJLocalProvider.instance.sj_scrach_end_number_0Name, SJLocalProvider.instance.sj_scrach_end_number_0 + 1);
                 if (SJLocalProvider.instance.sj_scrach_end_number_0 >= 9){
                   await SJLocalProvider.instance.updateString(SJLocalProvider.instance.sj_Scratch_timeKey_0Name,DateTime.now().toIso8601String());
                   popToNextScratch();
                 }
                 if (SJLocalProvider.instance.sj_Level_inedx >= 5){
                   await SJLocalProvider.instance.updateint(SJLocalProvider.instance.sj_Level_inedxName, 0);
                   await SJLocalProvider.instance.updateint(SJLocalProvider.instance.sj_Level_numberName, SJLocalProvider.instance.sj_Level_number + 1);
                   showLevelDialog();
                 }
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
                        width: 56,
                        height: 56,
                        child: Stack(
                            children: [
                              if(extra_bonusResult.displayNumbers[index] == -2)
                                SJAnimatedImageMove(imageUrl: 'sj_shaizi_icon', isAnimationEnabled: shai_anim, ws: 56, hs: 56, targetKey: targetimageKey),
                              if(extra_bonusResult.displayNumbers[index] != -2)
                               Positioned(width: 56,child: SJBouncyText(text: '${extra_bonusResult.displayNumbers[index]}', fontSize: 36, color: '#3A3025'.color(), enableAnimation: (extra_bonusResult.winNumbers.contains(extra_bonusResult.displayNumbers[index]) && star_awarad == true))),
                              if(extra_bonusResult.displayNumbers[index] != -2)
                               Positioned(top: 32,width: 56,child: SJBouncyText(text: '${extra_bonusResult.winMatchNumbers[index].toInt()}', fontSize: 24, color: '#62594E'.color(), enableAnimation: (extra_bonusResult.winNumbers.contains(extra_bonusResult.displayNumbers[index]) && star_awarad == true))),
                            ]
                        )
                    );
                  },
                )
              ],
            ),
          )),
          Positioned(left: (0.width(context) - 304) * 0.5, top: 72.h,child: Container(
            width: 304,
            height: 80,
            decoration: BoxDecoration(
                image: SJDImg('sj_scratch_top_0')
            ),
            child: Stack(
              children: [
                Positioned(left: 180, top: 12, child: SJGradientNumberRoller(
                  value: 1000,
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
          SJLocalImageScratchCard(autoStartY: 220.h,coverImagePath: 'sj_scratch_content_1'.image(), contentW: 0.width(context), contentH: scratch_h,  onScratchEnd: (){
            setState(() {
              shai_anim = true;
              star_awarad = true;
            });
            Future.delayed(Duration(seconds: 2), () async {
              if (!mounted) return; // ✅ 页面已经被销毁就直接返回
              SJLocalProvider.instance.updateint(SJLocalProvider.instance.sj_Level_inedxName, SJLocalProvider.instance.sj_Level_inedx + 1);
              SJLocalProvider.instance.updateint(SJLocalProvider.instance.sj_card_a_numberName, SJLocalProvider.instance.sj_card_a_number + 1);
              if (goldRushResult.diceHit){
                SJLocalProvider.instance.updateint(SJLocalProvider.instance.sj_dice_numberName, SJLocalProvider.instance.sj_dice_number + 1);
              }
              if (goldRushResult.isWin) {
                var code = await context.tipShow(SJPopYouWinADialog(
                    award: goldRushResult.prize, is_dice: false));
                if (code == 0 || code == 1) {
                  setState(() {
                    shai_anim = false;
                    star_awarad = false;
                    goldRushResult =
                        SJNumberAHelper().generate3x3NumbersWithPrizeAndDice();
                  });
                  SJScratchUpdateNotificationService
                      .sendToDomandNumberNotification(0);
                  SJLocalProvider.instance.updateint(SJLocalProvider.instance.sj_scrach_end_number_1Name, SJLocalProvider.instance.sj_scrach_end_number_1 + 1);
                  if (SJLocalProvider.instance.sj_scrach_end_number_1 >= 9){
                    await SJLocalProvider.instance.updateString(SJLocalProvider.instance.sj_Scratch_timeKey_1Name,DateTime.now().toIso8601String());
                    popToNextScratch();
                  }
                  if (SJLocalProvider.instance.sj_Level_inedx >= 5){
                    await SJLocalProvider.instance.updateint(SJLocalProvider.instance.sj_Level_inedxName, 0);
                    await SJLocalProvider.instance.updateint(SJLocalProvider.instance.sj_Level_numberName, SJLocalProvider.instance.sj_Level_number + 1);
                    showLevelDialog();
                  }
                }
              } else {
                var code = await context.tipShow(SJPopUnAwardDialog());
                if(code >= 0){
                  setState(() {
                    shai_anim = false;
                    star_awarad = false;
                    goldRushResult =
                        SJNumberAHelper().generate3x3NumbersWithPrizeAndDice();
                  });
                  SJScratchUpdateNotificationService
                      .sendToDomandNumberNotification(0);
                  SJLocalProvider.instance.updateint(SJLocalProvider.instance.sj_scrach_end_number_1Name, SJLocalProvider.instance.sj_scrach_end_number_1 + 1);
                  if (SJLocalProvider.instance.sj_scrach_end_number_1 >= 9){
                    await SJLocalProvider.instance.updateString(SJLocalProvider.instance.sj_Scratch_timeKey_1Name,DateTime.now().toIso8601String());
                    popToNextScratch();
                  }
                  if (SJLocalProvider.instance.sj_Level_inedx >= 5){
                    await SJLocalProvider.instance.updateint(SJLocalProvider.instance.sj_Level_inedxName, 0);
                    await SJLocalProvider.instance.updateint(SJLocalProvider.instance.sj_Level_numberName, SJLocalProvider.instance.sj_Level_number + 1);
                    showLevelDialog();
                  }
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
                    SJText(text: '${goldRushResult.prize}', size: 40, color: '#25211D'.color(), weight: FontWeight.w900),
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
          )),
          Positioned(right: 32.w, top: 84.h,child: Container(
              width: 218,
              height: 66,
              decoration: BoxDecoration(
                  image: SJDImg('sj_scratch_top_1')
              ),
              child: Stack(
                children: [
                  Positioned(left: 118, top: 10, child: SJGradientNumberRoller(
                    value: 2000,
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
          SJLocalImageScratchCard(autoStartY: 230.h,coverImagePath: SJLocalProvider.instance.sj_login_status ? 'sj_scratch_content_2' : 'sj_scratch_content_2s'.image(), contentW: 0.width(context), contentH: scratch_h, onScratchEnd: (){
            setState(() {
              shai_anim = true;
              star_awarad = true;
            });
            Future.delayed(Duration(seconds: 2), () async {
              if (!mounted) return; // ✅ 页面已经被销毁就直接返回
              SJLocalProvider.instance.updateint(SJLocalProvider.instance.sj_Level_inedxName, SJLocalProvider.instance.sj_Level_inedx + 1);
              SJLocalProvider.instance.updateint(SJLocalProvider.instance.sj_card_a_numberName, SJLocalProvider.instance.sj_card_a_number + 1);
              if (lucku_momentResult.diceHit){
                SJLocalProvider.instance.updateint(SJLocalProvider.instance.sj_dice_numberName, SJLocalProvider.instance.sj_dice_number + 1);
              }
              if (lucku_momentResult.isWin) {
                var code = await context.tipShow(SJPopYouWinADialog(
                    award: lucku_momentResult.winMatchNumbers.first.toInt(), is_dice: false));
                if (code == 0 || code == 1) {
                  setState(() {
                    shai_anim = false;
                    star_awarad = false;
                    lucku_momentResult = SJNumberAHelper().generatelucku_momentNumbers();
                    'lucku_momentResult.winIndex=${lucku_momentResult.winIndex}'.log();
                  });
                  SJScratchUpdateNotificationService
                      .sendToDomandNumberNotification(0);
                  SJLocalProvider.instance.updateint(SJLocalProvider.instance.sj_scrach_end_number_2Name, SJLocalProvider.instance.sj_scrach_end_number_2 + 1);
                  if (SJLocalProvider.instance.sj_scrach_end_number_2 >= 9){
                    await SJLocalProvider.instance.updateString(SJLocalProvider.instance.sj_Scratch_timeKey_2Name,DateTime.now().toIso8601String());
                    popToNextScratch();
                  }
                  if (SJLocalProvider.instance.sj_Level_inedx >= 5){
                    await SJLocalProvider.instance.updateint(SJLocalProvider.instance.sj_Level_inedxName, 0);
                    await SJLocalProvider.instance.updateint(SJLocalProvider.instance.sj_Level_numberName, SJLocalProvider.instance.sj_Level_number + 1);
                    showLevelDialog();
                  }
                }
              } else {
                var code = await context.tipShow(SJPopUnAwardDialog());
                if(code >= 0){
                  setState(() {
                    shai_anim = false;
                    star_awarad = false;
                    lucku_momentResult = SJNumberAHelper().generatelucku_momentNumbers();
                    'lucku_momentResult.winIndex=${lucku_momentResult.winIndex}'.log();
                  });
                  SJScratchUpdateNotificationService
                      .sendToDomandNumberNotification(0);
                  SJLocalProvider.instance.updateint(SJLocalProvider.instance.sj_scrach_end_number_2Name, SJLocalProvider.instance.sj_scrach_end_number_2 + 1);
                  if (SJLocalProvider.instance.sj_scrach_end_number_2 >= 9){
                    await SJLocalProvider.instance.updateString(SJLocalProvider.instance.sj_Scratch_timeKey_2Name,DateTime.now().toIso8601String());
                    popToNextScratch();
                  }
                  if (SJLocalProvider.instance.sj_Level_inedx >= 5){
                    await SJLocalProvider.instance.updateint(SJLocalProvider.instance.sj_Level_inedxName, 0);
                    await SJLocalProvider.instance.updateint(SJLocalProvider.instance.sj_Level_numberName, SJLocalProvider.instance.sj_Level_number + 1);
                    showLevelDialog();
                  }
                }
              }
            });
          }, child: Container(
            width: 0.width(context),
            height: scratch_h,
            decoration: BoxDecoration(
              image: SJDImg(SJLocalProvider.instance.sj_login_status ? 'sj_scratch_bg_2' : 'sj_scratch_bg_2s')
            ),
            child: Column(
              children: [
                SizedBox(height: 217.h,),
                Row(
                  children: [
                    SizedBox(width: 55.w,),
                    if(lucku_momentResult.winIndex == 0)
                      SizedBox(width: 50, height: 30,child: SJStrokeText(text: '${lucku_momentResult.winMatchNumbers.first.toInt()}', size: 24, color: '#FBE600'.color(), weight: FontWeight.w900, skWidth: 2, skColor: '#23362B'.color())),
                    if(lucku_momentResult.winIndex != 0)
                      SJImg(name: 'sj_scratch_icon_2_0', width: 50, height: 30,),
                    SizedBox(width: 70.w,),
                    if(lucku_momentResult.winIndex == 1)
                      SizedBox(width: 50, height: 30,child: SJStrokeText(text: '${lucku_momentResult.winMatchNumbers.first.toInt()}', size: 24, color: '#FBE600'.color(), weight: FontWeight.w900, skWidth: 2, skColor: '#23362B'.color())),
                    if(lucku_momentResult.winIndex != 1)
                      SJImg(name: 'sj_scratch_icon_2_0', width: 50, height: 30,),
                    Spacer(),
                    if(lucku_momentResult.winIndex == 2)
                      SizedBox(width: 50, height: 30,child: SJStrokeText(text: '${lucku_momentResult.winMatchNumbers.first.toInt()}', size: 24, color: '#FBE600'.color(), weight: FontWeight.w900, skWidth: 2, skColor: '#23362B'.color())),
                    if(lucku_momentResult.winIndex != 2)
                      SJImg(name: 'sj_scratch_icon_2_0', width: 50, height: 30,),
                    SizedBox(width: 55.w,),
                  ],
                ),
                SizedBox(height: 45.h,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    SJText(text: '${lucku_momentResult.winNumbers.first}', size: 40, color: '#25211D'.color(), weight: FontWeight.w900),
                    SJText(text: '${lucku_momentResult.winNumbers[1]}', size: 40, color: '#25211D'.color(), weight: FontWeight.w900),
                    SJText(text: '${lucku_momentResult.winNumbers[2]}', size: 40, color: '#25211D'.color(), weight: FontWeight.w900),
                    SJText(text: '${lucku_momentResult.winNumbers.last}', size: 40, color: '#25211D'.color(), weight: FontWeight.w900),
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
                                if(lucku_momentResult.displayNumbers[index] == -2)
                                  SJAnimatedImageMove(imageUrl: 'sj_shaizi_icon', isAnimationEnabled: shai_anim, ws: 50, hs: 50, targetKey: targetimageKey),
                                if(lucku_momentResult.displayNumbers[index] != -2)
                                  Positioned(width: 56,child: SJBouncyText(text: '${lucku_momentResult.displayNumbers[index]}', fontSize: 32, color: lucku_momentResult.winNumbers.contains(lucku_momentResult.displayNumbers[index]) && star_awarad == true ? '#FBE600'.color() : '#23362B'.color(), enableAnimation: (lucku_momentResult.winNumbers.contains(lucku_momentResult.displayNumbers[index]) && star_awarad == true))),
                              ]
                          )
                      );
                    },
                  ),
                )
              ],
            ),
          )),
          Positioned(right: (0.width(context) - 301) * 0.5, top: 86.h,child: Container(
              width: 301,
              height: 48,
              decoration: BoxDecoration(
                  image: SJDImg('sj_scratch_top_2')
              ),
              child: Stack(
                children: [
                  Positioned(left: 180, top: -1, child: SJGradientNumberRoller(
                    value: 3000,
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
              onTap: (){

              }, child: BouncySJImg())),
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
          SJLocalImageScratchCard(autoStartY: 210.h,coverImagePath: 'sj_scratch_content_3'.image(), contentW: 0.width(context), contentH: scratch_h, onScratchEnd: (){
            setState(() {
              shai_anim = true;
              star_awarad = true;
            });
            Future.delayed(Duration(seconds: 2), () async {
              if (!mounted) return; // ✅ 页面已经被销毁就直接返回
              SJLocalProvider.instance.updateint(SJLocalProvider.instance.sj_Level_inedxName, SJLocalProvider.instance.sj_Level_inedx + 1);
              SJLocalProvider.instance.updateint(SJLocalProvider.instance.sj_card_a_numberName, SJLocalProvider.instance.sj_card_a_number + 1);
              if (secret_stashResult.diceHit){
                SJLocalProvider.instance.updateint(SJLocalProvider.instance.sj_dice_numberName, SJLocalProvider.instance.sj_dice_number + 1);
              }
              if (secret_stashResult.isWin) {
                var code = await context.tipShow(SJPopYouWinADialog(
                    award: (secret_stashResult.prizeValues[secret_stashResult.winIndex] * secret_stashResult.multiplier).toInt(), is_dice: false));
                if (code == 0 || code == 1) {
                  setState(() {
                    shai_anim = false;
                    star_awarad = false;
                    secret_stashResult = SJNumberAHelper().generatesecret_stashStash();
                  });
                  SJScratchUpdateNotificationService
                      .sendToDomandNumberNotification(0);
                  SJLocalProvider.instance.updateint(SJLocalProvider.instance.sj_scrach_end_number_3Name, SJLocalProvider.instance.sj_scrach_end_number_3 + 1);
                  if (SJLocalProvider.instance.sj_scrach_end_number_3 >= 9){
                    await SJLocalProvider.instance.updateString(SJLocalProvider.instance.sj_Scratch_timeKey_3Name,DateTime.now().toIso8601String());
                    popToNextScratch();
                  }
                  if (SJLocalProvider.instance.sj_Level_inedx >= 5){
                    await SJLocalProvider.instance.updateint(SJLocalProvider.instance.sj_Level_inedxName, 0);
                    await SJLocalProvider.instance.updateint(SJLocalProvider.instance.sj_Level_numberName, SJLocalProvider.instance.sj_Level_number + 1);
                    showLevelDialog();
                  }
                }
              } else {
                var code = await context.tipShow(SJPopUnAwardDialog());
                if(code >= 0){
                  setState(() {
                    shai_anim = false;
                    star_awarad = false;
                    secret_stashResult = SJNumberAHelper().generatesecret_stashStash();
                  });
                  SJScratchUpdateNotificationService
                      .sendToDomandNumberNotification(0);
                  SJLocalProvider.instance.updateint(SJLocalProvider.instance.sj_scrach_end_number_3Name, SJLocalProvider.instance.sj_scrach_end_number_3 + 1);
                  if (SJLocalProvider.instance.sj_scrach_end_number_3 >= 9){
                    await SJLocalProvider.instance.updateString(SJLocalProvider.instance.sj_Scratch_timeKey_3Name,DateTime.now().toIso8601String());
                    popToNextScratch();
                  }
                  if (SJLocalProvider.instance.sj_Level_inedx >= 5){
                    await SJLocalProvider.instance.updateint(SJLocalProvider.instance.sj_Level_inedxName, 0);
                    await SJLocalProvider.instance.updateint(SJLocalProvider.instance.sj_Level_numberName, SJLocalProvider.instance.sj_Level_number + 1);
                    showLevelDialog();
                  }
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
                                      Positioned(width: 53,top: 38.h,child: SJBouncyText(text: '${secret_stashResult.prizeValues[index].toInt()}', fontSize: 20, color: '#30190A'.color(), enableAnimation: (secret_stashResult.winNumbers.contains(secret_stashResult.numbers[index]) && star_awarad == true))),
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
          )),
          Positioned(right: (0.width(context) - 279) * 0.5, top: 72.h,child: Container(
              width: 279,
              height: 100,
              decoration: BoxDecoration(
                  image: SJDImg('sj_scratch_top_3')
              ),
              child: Stack(
                children: [
                  Positioned(left: 142, top: 30, child: SJGradientNumberRoller(
                    value: 4000,
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
          SJLocalImageScratchCard(autoStartY: 265.h,coverImagePath: 'sj_scratch_content_4'.image(), contentW: 0.width(context), contentH: scratch_h, onScratchEnd: (){
            setState(() {
              shai_anim = true;
              star_awarad = true;
            });
            Future.delayed(Duration(seconds: 2), () async {
              if (!mounted) return; // ✅ 页面已经被销毁就直接返回
              SJLocalProvider.instance.updateint(SJLocalProvider.instance.sj_Level_inedxName, SJLocalProvider.instance.sj_Level_inedx + 1);
              SJLocalProvider.instance.updateint(SJLocalProvider.instance.sj_card_a_numberName, SJLocalProvider.instance.sj_card_a_number + 1);
              if (superMultipleResult.diceHit){
                SJLocalProvider.instance.updateint(SJLocalProvider.instance.sj_dice_numberName, SJLocalProvider.instance.sj_dice_number + 1);
              }
              if (superMultipleResult.isWin) {
                var code = await context.tipShow(SJPopYouWinADialog(
                    award: (superMultipleResult.prizeValues[superMultipleResult.winIndex] * superMultipleResult.multiplier).toInt(), is_dice: false));
                if (code == 0 || code == 1) {
                  setState(() {
                    shai_anim = false;
                    star_awarad = false;
                    superMultipleResult = SJNumberAHelper().generateSuperMultiple();
                  });
                  SJScratchUpdateNotificationService
                      .sendToDomandNumberNotification(0);
                  SJLocalProvider.instance.updateint(SJLocalProvider.instance.sj_scrach_end_number_4Name, SJLocalProvider.instance.sj_scrach_end_number_4 + 1);
                  if (SJLocalProvider.instance.sj_scrach_end_number_4 >= 9){
                    await SJLocalProvider.instance.updateString(SJLocalProvider.instance.sj_Scratch_timeKey_4Name,DateTime.now().toIso8601String());
                    popToNextScratch();
                  }
                  if (SJLocalProvider.instance.sj_Level_inedx >= 5){
                    await SJLocalProvider.instance.updateint(SJLocalProvider.instance.sj_Level_inedxName, 0);
                    await SJLocalProvider.instance.updateint(SJLocalProvider.instance.sj_Level_numberName, SJLocalProvider.instance.sj_Level_number + 1);
                    showLevelDialog();
                  }
                }
              } else {
                var code = await context.tipShow(SJPopUnAwardDialog());
                if(code >= 0){
                  setState(() {
                    shai_anim = false;
                    star_awarad = false;
                    superMultipleResult = SJNumberAHelper().generateSuperMultiple();
                  });
                  SJScratchUpdateNotificationService
                      .sendToDomandNumberNotification(0);
                  SJLocalProvider.instance.updateint(SJLocalProvider.instance.sj_scrach_end_number_4Name, SJLocalProvider.instance.sj_scrach_end_number_4 + 1);
                  if (SJLocalProvider.instance.sj_scrach_end_number_4 >= 9){
                    await SJLocalProvider.instance.updateString(SJLocalProvider.instance.sj_Scratch_timeKey_4Name,DateTime.now().toIso8601String());
                    popToNextScratch();
                  }
                  if (SJLocalProvider.instance.sj_Level_inedx >= 5){
                    await SJLocalProvider.instance.updateint(SJLocalProvider.instance.sj_Level_inedxName, 0);
                    await SJLocalProvider.instance.updateint(SJLocalProvider.instance.sj_Level_numberName, SJLocalProvider.instance.sj_Level_number + 1);
                    showLevelDialog();
                  }
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
                                  Positioned(width: 53,top: 38.h,child: SJBouncyText(text: '${superMultipleResult.prizeValues[index].toInt()}', fontSize: 16, color: '#22292E'.color(), enableAnimation: (superMultipleResult.numbers[index] < 0 && star_awarad == true))),
                              ]
                          )
                      );
                    },
                  ),
                )
              ],
            ),
          )),
          Positioned(right: (0.width(context) - 112) * 0.25, top: 180.h,child: SizedBox(
              width: 112,
              height: 50,
              child: Stack(
                children: [
                  Positioned(left: 0, top: 0, child: SJGradientNumberRoller(
                    value: 5000,
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
          SJLocalImageScratchCard(autoStartY: 220.h,coverImagePath: 'sj_scratch_content_5'.image(), contentW: 0.width(context), contentH: scratch_h, onScratchEnd: (){
            setState(() {
              shai_anim = true;
              star_awarad = true;
            });
            Future.delayed(Duration(seconds: 2), () async {
              if (!mounted) return; // ✅ 页面已经被销毁就直接返回
              SJLocalProvider.instance.updateint(SJLocalProvider.instance.sj_Level_inedxName, SJLocalProvider.instance.sj_Level_inedx + 1);
              SJLocalProvider.instance.updateint(SJLocalProvider.instance.sj_card_a_numberName, SJLocalProvider.instance.sj_card_a_number + 1);
              if (fortuneRushResult.diceHit){
                SJLocalProvider.instance.updateint(SJLocalProvider.instance.sj_dice_numberName, SJLocalProvider.instance.sj_dice_number + 1);
              }
              if (fortuneRushResult.isWin) {
                var code = await context.tipShow(SJPopYouWinADialog(
                    award: fortuneRushResult.prizeValues[fortuneRushResult.winRow], is_dice: false));
                if (code == 0 || code == 1) {
                  setState(() {
                    shai_anim = false;
                    star_awarad = false;
                    fortuneRushResult = SJNumberAHelper().generateFortuneRush();
                  });
                  SJScratchUpdateNotificationService
                      .sendToDomandNumberNotification(0);
                  SJLocalProvider.instance.updateint(SJLocalProvider.instance.sj_scrach_end_number_5Name, SJLocalProvider.instance.sj_scrach_end_number_5 + 1);
                  if (SJLocalProvider.instance.sj_scrach_end_number_5 >= 9){
                    await SJLocalProvider.instance.updateString(SJLocalProvider.instance.sj_Scratch_timeKey_5Name,DateTime.now().toIso8601String());
                    popToNextScratch();
                  }
                  if (SJLocalProvider.instance.sj_Level_inedx >= 5){
                    await SJLocalProvider.instance.updateint(SJLocalProvider.instance.sj_Level_inedxName, 0);
                    await SJLocalProvider.instance.updateint(SJLocalProvider.instance.sj_Level_numberName, SJLocalProvider.instance.sj_Level_number + 1);
                    showLevelDialog();
                  }
                }
              } else {
                var code = await context.tipShow(SJPopUnAwardDialog());
                if(code >= 0){
                  setState(() {
                    shai_anim = false;
                    star_awarad = false;
                    fortuneRushResult = SJNumberAHelper().generateFortuneRush();
                  });
                  SJScratchUpdateNotificationService
                      .sendToDomandNumberNotification(0);
                  SJLocalProvider.instance.updateint(SJLocalProvider.instance.sj_scrach_end_number_5Name, SJLocalProvider.instance.sj_scrach_end_number_5 + 1);
                  if (SJLocalProvider.instance.sj_scrach_end_number_5 >= 9){
                    await SJLocalProvider.instance.updateString(SJLocalProvider.instance.sj_Scratch_timeKey_5Name,DateTime.now().toIso8601String());
                    popToNextScratch();
                  }
                  if (SJLocalProvider.instance.sj_Level_inedx >= 5){
                    await SJLocalProvider.instance.updateint(SJLocalProvider.instance.sj_Level_inedxName, 0);
                    await SJLocalProvider.instance.updateint(SJLocalProvider.instance.sj_Level_numberName, SJLocalProvider.instance.sj_Level_number + 1);
                    showLevelDialog();
                  }

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
                                          Positioned(left: 10.w,child: SJAnimatedImageMove(imageUrl: 'sj_shaizi_icon', isAnimationEnabled: shai_anim, ws: 40, hs: 40, targetKey: targetimageKey)),
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
                              SizedBox(height: 18.h,),
                              SJStrokeText(text: '${fortuneRushResult.prizeValues.first}', size: 32.spMin, color: '#FFDF23'.color(), weight: FontWeight.w400, skWidth: 2, skColor: '#00332E'.color()),
                              SizedBox(height: 22.h,),
                              SJStrokeText(text: '${fortuneRushResult.prizeValues[1]}', size: 32.spMin, color: '#FFDF23'.color(), weight: FontWeight.w400, skWidth: 2, skColor: '#00332E'.color()),
                              SizedBox(height: 22.h,),
                              SJStrokeText(text: '${fortuneRushResult.prizeValues[2]}', size: 32.spMin, color: '#FFDF23'.color(), weight: FontWeight.w400, skWidth: 2, skColor: '#00332E'.color()),
                              SizedBox(height: 22.h,),
                              SJStrokeText(text: '${fortuneRushResult.prizeValues[3]}', size: 32.spMin, color: '#FFDF23'.color(), weight: FontWeight.w400, skWidth: 2, skColor: '#00332E'.color()),
                              SizedBox(height: 22.h,),
                              SJStrokeText(text: '${fortuneRushResult.prizeValues.last}', size: 32.spMin, color: '#FFDF23'.color(), weight: FontWeight.w400, skWidth: 2, skColor: '#00332E'.color()),
                            ],
                          ),
                        )
                      ],
                    )
                  ],
                ),
                Positioned(left: 43.w, top: 218.h, child: SizedBox(width: 81, height:81, child: Center(child: SJText(text: '${fortuneRushResult.winNumber}', size: 64, color: '#191A1A'.color(), weight: FontWeight.w400, align: TextAlign.center,))))
              ],
            ),
          )),
          Positioned(right: (0.width(context) - 259) * 0.5, top: 70.h,child: Container(
              width: 259,
              height: 95,
              decoration: BoxDecoration(
                  image: SJDImg('sj_scratch_top_3')
              ),
              child: Stack(
                children: [
                  Positioned(left: 130, top: 28, child: SJGradientNumberRoller(
                    value: 6000,
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
          SJLocalImageScratchCard(autoStartY: 288.h,coverImagePath: 'sj_scratch_content_6'.image(), contentW: 0.width(context), contentH: scratch_h, onScratchEnd: (){
            setState(() {
              shai_anim = true;
              star_awarad = true;
            });
            Future.delayed(Duration(seconds: 2), () async {
              if (!mounted) return; // ✅ 页面已经被销毁就直接返回
              SJLocalProvider.instance.updateint(SJLocalProvider.instance.sj_Level_inedxName, SJLocalProvider.instance.sj_Level_inedx + 1);
              SJLocalProvider.instance.updateint(SJLocalProvider.instance.sj_card_a_numberName, SJLocalProvider.instance.sj_card_a_number + 1);
              if (sweetTimeResult.diceHit){
                SJLocalProvider.instance.updateint(SJLocalProvider.instance.sj_dice_numberName, SJLocalProvider.instance.sj_dice_number + 1);
              }
              if (sweetTimeResult.isWin) {
                var code = await context.tipShow(SJPopYouWinADialog(
                    award: sweetTimeResult.prizeValues[sweetTimeResult.winningRow], is_dice: false));
                if (code == 0 || code == 1) {
                  setState(() {
                    shai_anim = false;
                    star_awarad = false;
                    sweetTimeResult = SJNumberAHelper().generateSweetTime();
                  });
                  SJScratchUpdateNotificationService
                      .sendToDomandNumberNotification(0);
                  SJLocalProvider.instance.updateint(SJLocalProvider.instance.sj_scrach_end_number_6Name, SJLocalProvider.instance.sj_scrach_end_number_6 + 1);
                  if (SJLocalProvider.instance.sj_scrach_end_number_6 >= 9){
                    await SJLocalProvider.instance.updateString(SJLocalProvider.instance.sj_Scratch_timeKey_6Name,DateTime.now().toIso8601String());
                    popToNextScratch();
                  }
                  if (SJLocalProvider.instance.sj_Level_inedx >= 5){
                    await SJLocalProvider.instance.updateint(SJLocalProvider.instance.sj_Level_inedxName, 0);
                    await SJLocalProvider.instance.updateint(SJLocalProvider.instance.sj_Level_numberName, SJLocalProvider.instance.sj_Level_number + 1);
                    showLevelDialog();
                  }
                }
              } else {
                var code = await context.tipShow(SJPopUnAwardDialog());
                if(code >= 0){
                  setState(() {
                    shai_anim = false;
                    star_awarad = false;
                    sweetTimeResult = SJNumberAHelper().generateSweetTime();
                  });
                  SJScratchUpdateNotificationService
                      .sendToDomandNumberNotification(0);
                  SJLocalProvider.instance.updateint(SJLocalProvider.instance.sj_scrach_end_number_6Name, SJLocalProvider.instance.sj_scrach_end_number_6 + 1);
                  if (SJLocalProvider.instance.sj_scrach_end_number_6 >= 9){
                    await SJLocalProvider.instance.updateString(SJLocalProvider.instance.sj_Scratch_timeKey_6Name,DateTime.now().toIso8601String());
                    popToNextScratch();
                  }
                  if (SJLocalProvider.instance.sj_Level_inedx >= 5){
                    await SJLocalProvider.instance.updateint(SJLocalProvider.instance.sj_Level_inedxName, 0);
                    await SJLocalProvider.instance.updateint(SJLocalProvider.instance.sj_Level_numberName, SJLocalProvider.instance.sj_Level_number + 1);
                    showLevelDialog();
                  }
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
                          SizedBox(width: 120.w, height: 53, child: SJText(text: '${sweetTimeResult.prizeValues.first}', size: 44, color: '#7C183C'.color(), weight: FontWeight.w500, align: TextAlign.center,)),
                          SizedBox(height: 38.h,),
                          SizedBox(width: 120.w, height: 53, child: SJText(text: '${sweetTimeResult.prizeValues[1]}', size: 44, color: '#7C183C'.color(), weight: FontWeight.w500, align: TextAlign.center,)),
                          SizedBox(height: 32.h,),
                          SizedBox(width: 120.w, height: 53, child: SJText(text: '${sweetTimeResult.prizeValues.last}', size: 44, color: '#7C183C'.color(), weight: FontWeight.w500, align: TextAlign.center,)),
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
          )),
          Positioned(right: (0.width(context) - 281) * 0.5, top: 188.h,child: Container(
              width: 281,
              height: 71,
              decoration: BoxDecoration(
                  image: SJDImg('sj_scratch_top_6')
              ),
              child: Stack(
                children: [
                  Positioned(left: 160, top: 10, child: SJGradientNumberRoller(
                    value: 7000,
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
          Positioned(left: (0.width(context) - 320) * 0.5, bottom:24, width: 320, height: 30, child: RichText(
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
          )),
        ],
      );
    }
    return SizedBox();
  }
  void showLevelDialog(){
    context.tipShow(SJPopLevelADialog());
  }
  // 进入下一个主题
  void popToNextScratch(){
    if (SJLocalProvider.instance.sj_Scratch_timeKey_0.length == 0){
      Navigator.pop(context);
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (builder) {
            return SJScratchA(
                type: 0);
          },
        ),
      );
    } else if (SJLocalProvider.instance.sj_Scratch_timeKey_1.length == 0){
      Navigator.pop(context);
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (builder) {
            return SJScratchA(
                type: 1);
          },
        ),
      );
    } else if (SJLocalProvider.instance.sj_Scratch_timeKey_2.length == 0){
      Navigator.pop(context);
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (builder) {
            return SJScratchA(
                type: 2);
          },
        ),
      );
    } else if (SJLocalProvider.instance.sj_Scratch_timeKey_3.length == 0){
      Navigator.pop(context);
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (builder) {
            return SJScratchA(
                type: 3);
          },
        ),
      );
    } else if (SJLocalProvider.instance.sj_Scratch_timeKey_4.length == 0){
      Navigator.pop(context);
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (builder) {
            return SJScratchA(
                type: 4);
          },
        ),
      );
    } else if (SJLocalProvider.instance.sj_Scratch_timeKey_5.length == 0){
      Navigator.pop(context);
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (builder) {
            return SJScratchA(
                type: 5);
          },
        ),
      );
    } else if (SJLocalProvider.instance.sj_Scratch_timeKey_6.length == 0){
      Navigator.pop(context);
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (builder) {
            return SJScratchA(
                type: 6);
          },
        ),
      );
    } else {
      Navigator.pop(context);
    }
  }
}
