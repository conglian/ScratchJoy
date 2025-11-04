import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:scratchjoy/SJTool/sj_extension_help.dart';
import 'package:scratchjoy/SJTool/sj_img.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart';
import '../SJHome/SJHome.dart';


class SJSratchJoyLaunch extends StatefulWidget {
  SJSratchJoyLaunch({super.key});
  @override
  State<SJSratchJoyLaunch> createState() => SJSratchJoyLaunchState();
}

class SJSratchJoyLaunchState extends State<SJSratchJoyLaunch>  with SingleTickerProviderStateMixin {

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack (
        fit: StackFit.expand,
        children: [
          SJImg(name: 'sj_luach_bg', width: 0.width(context), height: 0.height(context)),
          Column(
            children: [
              SizedBox(height: 97.h,),
              SJImg(name: 'sj_luach_top', width: 240, height: 168,),
              Spacer(),
              SJGradientProgressBar(onCompleted: (){
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (builder) {
                      return SJHome();
                    },
                  ),
                );
              },),
              SizedBox(height: 195.h,)
            ],
          ),
        ],
      ),
    );
  }

}
class SJGradientProgressBar extends StatefulWidget {
  final VoidCallback? onCompleted; // ✅ 动画完成后的回调

  const SJGradientProgressBar({super.key, this.onCompleted});

  @override
  State<SJGradientProgressBar> createState() => _SJGradientProgressBarState();
}

class _SJGradientProgressBarState extends State<SJGradientProgressBar>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  final double barWidth = 307;
  final double barHeight = 22;
  final double progressHeight = 18;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      duration: const Duration(seconds: 3),
      vsync: this,
    );

    _animation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );

    // ✅ 动画完成回调
    _controller.addStatusListener((status) {
      if (status == AnimationStatus.completed && widget.onCompleted != null) {
        widget.onCompleted!();
      }
    });

    // 启动动画
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: barWidth,
      height: barHeight,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // 背景图片
          Positioned.fill(
            child: SJImg(name: 'sj_luach_pro_bg'),
          ),

          // 进度条
          AnimatedBuilder(
            animation: _animation,
            builder: (context, child) {
              final progressWidth = barWidth * _animation.value;
              final progressPercent = (_animation.value * 100).clamp(0, 100).toInt();

              return Stack(
                alignment: Alignment.center,
                children: [
                  // 渐变进度条
                  Positioned(
                    left: 2,
                    top: (barHeight - progressHeight) / 2,
                    child: Container(
                      width: max(0, progressWidth - 4),
                      height: progressHeight,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            '#E8C70C'.color(),
                            '#FFE659'.color(),
                            '#B47405'.color(),
                          ],
                        ),
                        borderRadius: BorderRadius.circular(9),
                      ),
                    ),
                  ),

                  // ✅ 居中显示百分比文字
                  Center(
                    child: Text(
                      '$progressPercent%',
                      style: TextStyle(
                        fontFamily: 'Barlow_Black',
                        color: Colors.white,
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w700,
                        shadows: [
                          Shadow(
                            offset: const Offset(1, 1),
                            blurRadius: 2,
                            color: Colors.black.withOpacity(0.4),
                          ),
                        ],
                      ),
                    ),
                  ),

                  // 进度前端跟随图片
                  Positioned(
                    left: (progressWidth - 20).clamp(0, barWidth - 20),
                    top: -3,
                    child: SJImg(name: 'sj_luach_xing', width: 30, height: 30),
                  ),
                ],
              );
            },
          ),
        ],
      ),
    );
  }
}