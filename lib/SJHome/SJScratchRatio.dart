import 'dart:math';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:scratchjoy/SJTool/SJAdManager.dart';
import 'package:scratchjoy/SJTool/SJTBAInfoTool.dart';
import 'package:scratchjoy/SJTool/sj_LocalProvider.dart';
import 'package:scratchjoy/SJTool/sj_extension_help.dart';
import 'package:scratchjoy/SJTool/sj_img.dart';
import 'package:scratchjoy/SJTool/sj_text.dart';

import '../SJDilaog/SJDialog.dart';
import '../SJTool/SJAdAHelp.dart';
import '../SJTool/sj_number_helper.dart';
import 'SJHome.dart';
import 'SJScratchA.dart';
import 'SJScratchB.dart';

class CardShuffleAnimation extends StatefulWidget {
  final bool is_start;
  final String souce_fromat;
  const CardShuffleAnimation({super.key, required this.is_start, required this.souce_fromat});
  @override
  _CardShuffleAnimationState createState() => _CardShuffleAnimationState();
}

class _CardShuffleAnimationState extends State<CardShuffleAnimation>
    with TickerProviderStateMixin {
  late AnimationController _moveController;
  late AnimationController _flipController;
  late AnimationController _scaleController;
  late AnimationController _slideController;
  late Animation<double> _slideAnimation;
  late AnimationController _centerFadeController;
  late Animation<double> _centerFadeAnimation;

  bool _isShuffling = false;
  bool _isFlipped = false;

  double _leftX = -60, _centerX = 0, _rightX = 60;
  double _leftRotation = -20, _rightRotation = 20;

  List<double> _cardPositions = [-60, 60, 0];
  int _middleCardIndex = 2;

  int _targetWinIndex = 0; // ✅ 最终要中奖的卡索引

  @override
  void initState() {
    super.initState();

    sj_event_fire('probability_pop', {'open_type' :  widget.is_start ? 0 : 1, 'from_type' : widget.souce_fromat});

    _moveController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 550),
    );

    _flipController =
        AnimationController(vsync: this, duration: const Duration(milliseconds: 500));
    _scaleController =
        AnimationController(vsync: this, duration: const Duration(milliseconds: 500));

    _slideController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    );

    _slideAnimation = Tween<double>(begin: -358, end: 45.h)
        .animate(CurvedAnimation(parent: _slideController, curve: Curves.easeOut));

    _centerFadeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );
    _centerFadeAnimation = CurvedAnimation(
      parent: _centerFadeController,
      curve: Curves.easeInOut,
    );

    _slideController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        _centerFadeController.forward();
      }
    });

    _slideController.forward();

    _moveController.addListener(() {
      double t = _moveController.value;
      _leftRotation = lerpDouble(-20, 0, t)!;
      _rightRotation = lerpDouble(20, 0, t)!;

      final screenWidth = MediaQuery.of(context).size.width;
      final cardWidth = 132.w;

      _cardPositions[0] =
      lerpDouble(-60, -screenWidth / 2 + 25 + cardWidth / 2, t)!;
      _cardPositions[1] =
      lerpDouble(60, screenWidth / 2 - 25 - cardWidth / 2, t)!;
      _cardPositions[2] = 0;

      _leftX = _cardPositions[0];
      _rightX = _cardPositions[1];
      _centerX = _cardPositions[2];

      setState(() {});
    });

    _moveController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        _startShuffleAnimation();
      }
    });

    // 当前帧构建完成后
    WidgetsBinding.instance.addPostFrameCallback((_) {
      // 在这里执行需要更新UI的操作
      if (widget.is_start){
        _startShuffle();
      }
    });
  }

  void _startShuffleAnimation() {
    int steps = 8;
    int currentStep = 0;
    Duration stepDuration = Duration(milliseconds: 150);

    void doStep() {
      if (currentStep >= steps) {
        double minDistance = double.infinity;
        for (int i = 0; i < _cardPositions.length; i++) {
          double dist = (_cardPositions[i] - 0).abs();
          if (dist < minDistance) {
            minDistance = dist;
            if (!SJLocalProvider.instance.sj_new_guide){
              _middleCardIndex = 0;
            } else {
              _middleCardIndex = i;
            }
          }
        }
        if (!SJLocalProvider.instance.sj_new_guide) {
          // 根据中奖卡重新排列位置，让它在中间
          for (int i = 0; i < 3; i++) {
            if (i == _middleCardIndex) {
              _cardPositions[i] = 0; // 中间位置
            } else if (i == 0) {
              _cardPositions[i] = -120; // 左边
            } else {
              _cardPositions[i] = 520;  // 右边
            }
          }
          // 更新左右卡旋转角度
          _leftRotation = -20;
          _rightRotation = 20;
        }
        setState(() {});
        _startFlip();
        return;
      }
      currentStep++;

      List<int> indices = [0, 1, 2]..shuffle();
      int i = indices[0];
      int j = indices[1];

      double startI = _cardPositions[i];
      double startJ = _cardPositions[j];

      AnimationController stepController = AnimationController(
        vsync: this,
        duration: stepDuration,
      );

      Animation<double> animI = Tween(begin: startI, end: startJ).animate(
          CurvedAnimation(parent: stepController, curve: Curves.easeInOut));
      Animation<double> animJ = Tween(begin: startJ, end: startI).animate(
          CurvedAnimation(parent: stepController, curve: Curves.easeInOut));

      stepController.addListener(() {
        _cardPositions[i] = animI.value;
        _cardPositions[j] = animJ.value;

        _leftX = _cardPositions[0];
        _rightX = _cardPositions[1];
        _centerX = _cardPositions[2];

        setState(() {});
      });

      stepController.addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          stepController.dispose();
          doStep();
        }
      });

      stepController.forward();
    }

    doStep();
  }

  @override
  void dispose() {
    _centerFadeController.dispose();
    _slideController.dispose();
    _moveController.dispose();
    _flipController.dispose();
    _scaleController.dispose();
    super.dispose();
  }

  void _startShuffle() {
    if (_isShuffling) return;
    _targetWinIndex = 0;
    _isShuffling = true;
    _isFlipped = false;

    _moveController.forward(from: 0);
  }

  Future<void> _startFlip() async {
    setState(() {
      _isFlipped = true;
    });

    await _flipController.forward(from: 0);
    await _scaleController.forward(from: 0);
    await _scaleController.animateTo(0.25,
        duration: const Duration(milliseconds: 100)); // 缩小到 1.1 倍
    if (_middleCardIndex == 0){
      await SJLocalProvider.instance.updateString(SJLocalProvider.instance.sj_ratio_strName, '100');
    } else if (_middleCardIndex == 1) {
      await SJLocalProvider.instance.updateString(SJLocalProvider.instance.sj_ratio_strName, '99');
    } else if (_middleCardIndex == 2) {
      await SJLocalProvider.instance.updateString(SJLocalProvider.instance.sj_ratio_strName, '90');
    }
    await SJLocalProvider.instance.updateint(SJLocalProvider.instance.sj_tx_probability_indexName, SJLocalProvider.instance.sj_tx_probability_index + 1);
    setState(() {});
    await showOneTxTask();
    await showTwoTxTask();
  }

  // 第一段任务提醒
  Future<void> showOneTxTask() async {// 判断第一段任务是否完成
    if (SJLocalProvider.instance.sj_login_index >= SJNumberHelpers().taskModel!.task.last.first.num && SJLocalProvider.instance.sj_tx_probability_index >= SJNumberHelpers().taskModel!.task.last.last.num) {
      await SJLocalProvider.instance.updateBool(SJLocalProvider.instance.sj_tx_first_statusName, true);
      await SJLocalProvider.instance.updateint(SJLocalProvider.instance.sj_tx_probability_indexName, 0);
      await SJLocalProvider.instance.updateint(SJLocalProvider.instance.sj_tx_box_indexName, 0);
      await SJLocalProvider.instance.updateint(SJLocalProvider.instance.sj_tx_dice_indexName, 0);
      await SJLocalProvider.instance.updateint(SJLocalProvider.instance.sj_login_indexName, 0);
      if (!mounted) return;
      context.tipShow(SJPopTask3Dialog());
    }
  }

  // 第二段任务完成
  Future<void> showTwoTxTask() async {// 判断第一段任务是否完成
    if (SJLocalProvider.instance.sj_tx_dice_index >= SJNumberHelpers().last_taskModel!.task.last.first.num && SJLocalProvider.instance.sj_tx_probability_index >= SJNumberHelpers().last_taskModel!.task.last.last.num && SJLocalProvider.instance.sj_tx_first_status == true) {
      await SJLocalProvider.instance.updateBool(SJLocalProvider.instance.sj_tx_last_statusName, true);
      sj_event_fire('cash_queue', {});
    }
  }

  Widget _buildCard(String frontImage, String backImage,
      {required double x,
        double rotation = 0,
        bool flipped = false,
        bool isMiddle = false}) {
    return AnimatedBuilder(
      animation: Listenable.merge([_flipController, _scaleController]),
      builder: (context, child) {
        double angle = flipped ? _flipController.value * pi : 0.0;
        double scale = isMiddle ? 1.0 + _scaleController.value * 0.8 : 1.0;
        double yOffset = isMiddle ? -130 * _scaleController.value : 0.0;

        bool showFront = angle >= pi / 2;
        double displayAngle = showFront ? angle - pi : angle;

        return Transform.translate(
          offset: Offset(x, yOffset),
          child: Transform(
            alignment: Alignment.center,
            transform: Matrix4.identity()
              ..rotateZ(rotation * pi / 180)
              ..setEntry(3, 2, 0.0015)
              ..rotateY(displayAngle)
              ..scale(scale),
            child: Container(
              width: 132.w,
              height: 189.h,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage(showFront ? frontImage : backImage),
                  fit: BoxFit.cover,
                ),
                borderRadius: BorderRadius.circular(8),
                boxShadow: isMiddle && _isFlipped
                    ? [
                  BoxShadow(
                    color: Colors.yellow.withOpacity(1), // 黄色浓
                    blurRadius: 20, // 发光范围大
                    spreadRadius: 1,
                  )
                ]
                    : const [
                  BoxShadow(
                      color: Colors.black38,
                      blurRadius: 4,
                      offset: Offset(5, 5))
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> cards = [];

    for (int i = 0; i < 3; i++) {
      if (i != _middleCardIndex) {
        cards.add(_buildCard('sj_shuff_front$i'.image(), 'sj_shuff_bg'.image(),
            x: _cardPositions[i],
            rotation: i == 0 ? _leftRotation : _rightRotation,
            flipped: _isFlipped,
            isMiddle: false));
      }
    }

    cards.add(_buildCard('sj_shuff_front${_middleCardIndex}'.image(), 'sj_shuff_bg'.image(),
        x: _cardPositions[_middleCardIndex],
        flipped: _isFlipped,
        isMiddle: true));

    return Stack(
      children: [
        Positioned(
          top: 208.h,
          child: FadeTransition(
              opacity: _centerFadeAnimation,
              child: SJImg(name: 'sj_xing_center', width: 375, height: 375)),
        ),
          Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (_isFlipped)
              SJImg(name:'sj_100top2_icon', width: 323, height: 158),
            if (!_isFlipped)
             SJImg(name: !SJLocalProvider.instance.sj_new_guide ? 'sj_newtips_icon' :  'sj_hide100_top', width: 273, height: 182),
            SizedBox(height: 52.h),
            GestureDetector(
              onTap: _startShuffle,
              child: SizedBox(
                width: 0.width(context),
                height: 250,
                child: Stack(alignment: Alignment.center, children: cards),
              ),
            ),
            if(_isFlipped && _middleCardIndex != 0)
              SJImg(name: 'sj_100_bottoms', width: 350, height: 147,),
            if(_isFlipped && _middleCardIndex != 0)
              SizedBox(height: 12.h),
            if(_isFlipped && _middleCardIndex == 0)
              SizedBox(height: 70.h),
            if(!_isFlipped)
              InkWell(
               onTap: (){
                 if (!SJLocalProvider.instance.sj_new_guide){
                   _startShuffle();
                 } else {
                   sj_event_fire('probability_pop_up', {});
                     // 看ad-重新刷新
                     SJAdManager().sj_showAd(false, 'scxji_olduser_rv', context, (hasCache){}, (finished){
                       _startShuffle();
                     });
                 }
               },
               child: SJImg(name: !SJLocalProvider.instance.sj_new_guide ? 'sj_allin_btn' : 'sj_up_btn', width: 260, height: 74),
              ),
            if(_isFlipped)
              InkWell(
                onTap: () async {
                  if (_middleCardIndex == 0){
                    sj_event_fire('probability_pop_play_now', {});
                    Navigator.pop(context, 1);
                    if (!SJLocalProvider.instance.sj_new_guide) {
                      SJLocalProvider.instance.updateBool(SJLocalProvider.instance.sj_new_guideName, true);
                      history_index = 0;
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (builder) {
                            return SJScratchB(
                                type: history_index);
                          },
                        ),
                      );
                    }
                  } else {
                    sj_event_fire('probability_pop_continue_up', {});
                    // 看ad-重新刷新
                    SJAdManager().sj_showAd(false, 'scxji_olduser_rv', context, (hasCache){}, (finished) async {
                      Navigator.pop(context);
                      var code = await context.tipShow(CardShuffleAnimation(is_start: true, souce_fromat: 'card',));
                      if (code == 1){
                        SJScratchProbabilityUpNotificationService.sendToDomandNumberNotification(0);
                      }
                    });
                  }
                },
                child: SJImg(name: _middleCardIndex == 0 ? 'sj_playnow_btn' : 'sj_continueup_btn', width: 260, height: 74),
              ),
            SizedBox(height: 20.h),
            if(!_isFlipped && _middleCardIndex != 0)
              SizedBox(
              width: 200,
              height: 38,
              child: InkWell(
                onTap: () {
                  if (_isShuffling == true){
                    return;
                  }
                  if (SJNumberHelpers().checkProbability()){
                    SJAdManager().sj_showAd(true, 'scxji_olduser_int', context, (hasCache){
                      Navigator.pop(context);
                    }, (finished){
                      Navigator.pop(context);
                    });
                  } else {
                    Navigator.pop(context);
                  }
                },
                child: Center(
                  child: SJImg(name: 'sj_nothanks_btn', width: 124, height: 20),
                ),
              ),
            ),
            if(_isFlipped && _middleCardIndex != 0)
              SizedBox(
                width: 200,
                height: 38,
                child: InkWell(
                  onTap: () {
                    Navigator.pop(context, 0);
                  },
                  child: Center(
                    child: SJUnderlineTextButton(text: 'Play Now', gradientColors: ['#BE982A'.color(),'#FFE9A3'.color(),'#FFF6D7'.color(),'#FFF0B4'.color(),], underlineColor: '#C5A213'.color(),fontSize: 20,),
                  ),
                ),
              ),
          ],
        ),
        if(_isFlipped && _middleCardIndex != 0)
          Positioned(
            top: _isFlipped && _middleCardIndex != 0 ? 600.h : 559.h,
            right: 60.w,
            child: InkWell(
              onTap: (){
                // 看ad-重新刷新
                SJAdManager().sj_showAd(false, 'scxji_olduser_rv', context, (hasCache){}, (finished) async {
                  Navigator.pop(context);
                  var code = await context.tipShow(CardShuffleAnimation(is_start: true, souce_fromat: 'card',));
                  if (code == 1){
                    SJScratchProbabilityUpNotificationService.sendToDomandNumberNotification(0);
                  }
                });
              },
                child: SJImg(name: 'sj_rv_icon', width: 70, height: 70,)),
          ),
        if(!_isFlipped)
          Positioned(
            top: 555.h,
            right: 60.w,
            child: Visibility(
              visible: SJLocalProvider.instance.sj_new_guide,
              child: InkWell(
                  onTap: (){
                    // 看ad-重新刷新
                    SJAdManager().sj_showAd(false, 'scxji_olduser_rv', context, (hasCache){}, (finished){
                      _startShuffle();
                    });
                  },
                  child: SJImg(name: 'sj_rv_icon', width: 70, height: 70,)),
            ),
          ),
        AnimatedBuilder(
          animation: _slideAnimation,
          builder: (context, child) {
            return Positioned(
              top: _slideAnimation.value,
              left: 0,
              right: 0,
              child: child!,
            );
          },
          child: SJImg(name: 'sj_xing_top', width: 375, height: 358),
        ),
      ],
    );
  }
}
