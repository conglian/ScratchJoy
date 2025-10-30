import 'dart:async';
import 'dart:math';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:scratchjoy/SJTool/sj_GradientText.dart';
import 'package:scratchjoy/SJTool/sj_LocalProvider.dart';
import 'package:scratchjoy/SJTool/sj_NumberHelper.dart';
import 'package:scratchjoy/SJTool/sj_extension_help.dart';
import 'package:scratchjoy/SJTool/sj_text.dart';
import '../SJDilaog/SJDialog.dart';
import '../SJTool/sj_img.dart';
import 'SJScratchA.dart';

class SJDiceRollWidget extends StatefulWidget {
  const SJDiceRollWidget({super.key});

  @override
  State<SJDiceRollWidget> createState() => _SJDiceRollWidgetState();
}

class _SJDiceRollWidgetState extends State<SJDiceRollWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  Timer? _timer;

  int _currentFace = 1;
  int _finalFace = 1;
  bool _isRolling = false;

  // 跑马灯相关
  int _currentNumberIndex = SJLocalProvider.instance.sj_currentNumberIndex;
  Timer? _marqueeTimer;
  bool _isMarqueeRunning = false;

  final Map<int, double> _probability = {
    1: 0.1,
    2: 0.1,
    3: 0.2,
    4: 0.2,
    5: 0.2,
    6: 0.2,
  };

  final int totalNumbers = 12; // 周边数字总数严格 12 个

  final double numberSize = 82;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 3000),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    _timer?.cancel();
    _marqueeTimer?.cancel();
    super.dispose();
  }

  int _getFaceByProbability() {
    final r = Random().nextDouble();
    double cumulative = 0;
    for (var entry in _probability.entries) {
      cumulative += entry.value;
      if (r < cumulative) return entry.key;
    }
    return 6;
  }

  void _rollDice() {
    if (SJLocalProvider.instance.sj_dice_number <= 0){
      context.tipShow(SJPopNotdiceDialog());
      return;
    }
    if (_isRolling) return;
    SJLocalProvider.instance.updateint(SJLocalProvider.instance.sj_dice_numberName, SJLocalProvider.instance.sj_dice_number - 1);
    _isRolling = true;
    _finalFace = _getFaceByProbability();
    _controller.forward(from: 0);
    _timer?.cancel();

    const total = 3000;
    int elapsed = 0;

    _timer = Timer.periodic(const Duration(milliseconds: 16), (timer) {
      elapsed += 16;
      if (elapsed >= total) {
        timer.cancel();
        setState(() {
          _currentFace = _finalFace;
        });
        _startMarquee(); // 骰子结束后启动跑马灯
        return;
      }

      if (elapsed < 1200) {
        if (elapsed % 40 < 16) {
          setState(() {
            _currentFace = Random().nextInt(6) + 1;
          });
        }
      } else if (elapsed < 2000) {
        if (elapsed % 120 < 16) {
          setState(() {
            _currentFace = _finalFace;
          });
        }
      } else {
        if (_currentFace != _finalFace) {
          setState(() {
            _currentFace = _finalFace;
          });
        }
      }
    });
  }


  void _startMarquee() {
    if (_isMarqueeRunning) return;
    _isMarqueeRunning = true;

    int steps = _finalFace; // 跑马灯走的步数
    int elapsedSteps = 0;
    double interval = 150; // 初始间隔改大，原来是 50ms

    _marqueeTimer?.cancel();
    _marqueeTimer = Timer.periodic(Duration(milliseconds: interval.toInt()), (timer) {
      setState(() {
        _currentNumberIndex = (_currentNumberIndex + 1) % totalNumbers;
        SJLocalProvider.instance.updateint(SJLocalProvider.instance.sj_currentNumberIndexName, _currentNumberIndex);
      });

      elapsedSteps++;

      // 逐渐变慢，最大间隔 400ms
      interval = min(400, 150 + elapsedSteps * 40).toDouble();

      // 重新设置定时器间隔
      timer.cancel();
      if (elapsedSteps < steps) {
        _marqueeTimer = Timer.periodic(Duration(milliseconds: interval.toInt()), (t) => _startMarqueeStep(t, elapsedSteps, steps));
      } else {
        _isMarqueeRunning = false;
        _isRolling = false;
        if (SJNumberAHelper().numberEntity.diceNumeric[_currentNumberIndex] > 0){
            context.tipShow(SJPopYouWinADialog(award: SJNumberAHelper().numberEntity.diceNumeric[_currentNumberIndex]));
        }
      }
    });
  }

// 辅助函数实现步进
  void _startMarqueeStep(Timer timer, int elapsedSteps, int steps) {
    setState(() {
      _currentNumberIndex = (_currentNumberIndex + 1) % totalNumbers;
      SJLocalProvider.instance.updateint(SJLocalProvider.instance.sj_currentNumberIndexName, _currentNumberIndex);
    });
    elapsedSteps++;
    double interval = min(400, 150 + elapsedSteps * 40).toDouble();
    timer.cancel();
    if (elapsedSteps < steps) {
      _marqueeTimer = Timer.periodic(Duration(milliseconds: interval.toInt()), (t) => _startMarqueeStep(t, elapsedSteps, steps));
    } else {
      _isMarqueeRunning = false;
      _isRolling = false;
      if (SJNumberAHelper().numberEntity.diceNumeric[_currentNumberIndex] > 0){
        context.tipShow(SJPopYouWinADialog(award: SJNumberAHelper().numberEntity.diceNumeric[_currentNumberIndex]));
      }
    }
  }


  /// 返回每个数字相对于中心骰子的偏移，正方形顺时针布局 12 个
  Offset _getSquarePosition(int index) {
    double spacing = (0.width(context) - (82 * 4)) / 5;
    // 正方形边长 = (numberSize + spacing) * 3
    double sideLength = (numberSize + spacing) * 3;

    switch (index) {
    // 上边 0~3 左到右
      case 0:
        return Offset(-sideLength / 2, -sideLength / 2);
      case 1:
        return Offset(-sideLength / 6, -sideLength / 2);
      case 2:
        return Offset(sideLength / 6, -sideLength / 2);
      case 3:
        return Offset(sideLength / 2, -sideLength / 2);

    // 右边 4~6 上到下
      case 4:
        return Offset(sideLength / 2, -sideLength / 6);
      case 5:
        return Offset(sideLength / 2, sideLength / 6);
      case 6:
        return Offset(sideLength / 2, sideLength / 2);

    // 下边 7~9 右到左
      case 7:
        return Offset(sideLength / 6, sideLength / 2);
      case 8:
        return Offset(-sideLength / 6, sideLength / 2);
      case 9:
        return Offset(-sideLength / 2, sideLength / 2);

    // 左边 10~11 下到上
      case 10:
        return Offset(-sideLength / 2, sideLength / 6);
      case 11:
        return Offset(-sideLength / 2, -sideLength / 6);

      default:
        return Offset.zero;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: 0.width(context),
        height: 0.height(context),
        decoration: BoxDecoration(image: SJDImg('sj_shai_bg')),
        child: Column(
          children: [
            SJDetailsBarWidget(),
            Container(
              width: 375.w,
              height: 502.h,
              decoration: BoxDecoration(image: SJDImg('sj_shai_center')),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  // 中心骰子
                  Center(
                    child: Padding(
                      padding: EdgeInsets.only(top: 80.h),
                      child: Container(
                        width: 125,
                        height: 125,
                        decoration: BoxDecoration(image: SJDImg('sj_shai_cenrer_bg')),
                        child: Column(
                          children: [
                            SizedBox(height: 15),
                            SizedBox(
                              width: 87,
                              height: 87,
                              child: GestureDetector(
                                onTap: _rollDice,
                                child: AnimatedBuilder(
                                  animation: _controller,
                                  builder: (context, child) {
                                    final progress = _controller.value;
                                    double turns;
                                    if (progress < 0.4) {
                                      turns = lerpDouble(
                                          0, 5, Curves.easeOutQuad.transform(progress / 0.4))!;
                                    } else if (progress < 0.66) {
                                      final t = (progress - 0.4) / 0.26;
                                      turns = lerpDouble(5, 8, Curves.linear.transform(t))!;
                                    } else {
                                      final t = (progress - 0.66) / 0.34;
                                      turns = lerpDouble(8, 9, Curves.easeOutSine.transform(t))!;
                                    }

                                    double rotationZ = turns * 2 * pi;

                                    double tiltFactor;
                                    if (progress < 0.4) {
                                      tiltFactor = 0.12;
                                    } else if (progress < 0.66) {
                                      tiltFactor = lerpDouble(0.12, 0.05, (progress - 0.4) / 0.26)!;
                                    } else {
                                      tiltFactor = lerpDouble(0.05, 0.0, (progress - 0.66) / 0.34)!;
                                    }

                                    double shakeAmp = (1 - progress) * 0.04;
                                    double shake = sin(progress * pi * 6) * shakeAmp;

                                    double scale = 1.0;
                                    if (progress > 0.9) {
                                      double t2 = (progress - 0.9) / 0.1;
                                      scale = 1.0 + sin(t2 * pi) * 0.03 * (1 - t2);
                                    }

                                    final Matrix4 transform = Matrix4.identity()
                                      ..scale(scale)
                                      ..rotateX(tiltFactor * 0.7 + shake)
                                      ..rotateY(tiltFactor * 0.5 - shake / 2)
                                      ..rotateZ(rotationZ);

                                    return Transform(
                                      alignment: Alignment.center,
                                      transform: transform,
                                      child: SJImg(
                                          name: 'dice_$_currentFace', width: 87, height: 87),
                                    );
                                  },
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  // 周边数字 12 个
                  for (int i = 0; i < totalNumbers; i++)
                    Positioned(
                      left: 152.w + _getSquarePosition(i).dx,
                      top: 258.h + _getSquarePosition(i).dy,
                      child: Container(
                        width: numberSize,
                        height: numberSize,
                        decoration: BoxDecoration(
                          image: SJDImg(i == _currentNumberIndex ? 'sj_numbers_s' : 'sj_numbers_n')
                        ),
                        child: Column(
                          children: [
                            SizedBox(height: 54,),
                            Center(child: SizedBox(width: 40, height:20,child: SJGradientStrokeText(text: '${SJNumberAHelper().numberEntity.diceNumeric[i] == 0 ? '  0' : SJNumberAHelper().numberEntity.diceNumeric[i]}', gradientColors: ['#FFFDE0'.color(), '#F8FF20'.color()], fontSize: 16, strokeWidth: 1, strokeColor: '#010442'.color(),width: 82, height: 20,)))
                          ],
                        ),
                      )
                    ),
                ],
              ),
            ),
            Container(
              width: 140,
              height: 50,
              decoration: BoxDecoration(
                image: SJDImg('sj_shai_number_bg')
              ),
              child: Consumer<SJLocalProvider>(
                builder: (context, provider, child) {
                  return Row(
                    children: [
                      SizedBox(width: 82,),
                      SJText(text: '${provider.sj_dice_number}', size: 24, color: '#FFFFFF'.color(), weight: FontWeight.w400)
                    ],
                  );
                },
              ),
            ),
            SizedBox(height: 10.h,),
            InkWell(
              onTap: _rollDice,
              child: SJImg(name: 'sj_throw_btn', width: 260, height: 74,),
            )
          ],
        ),
      ),
    );
  }
}
