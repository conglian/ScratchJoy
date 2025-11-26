import 'dart:convert';
import 'dart:math';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

extension ScratchJoyExtension on String {
void log() {
  assert(() {
    print("<Scratch Joy Debug> ============: $this");
    return true;
  }());
}

String image() {
  return "assets/images/$this.png";
}

String files() {
  return "assets/File/$this";
}
String mp3files() {
  return "File/$this.mp3";
}

String jsons() {
  return "assets/File/$this.json";
}

Color color({double opacity = 1.0}) {
  final hexCode = this.replaceAll('#', '');
  return Color(int.parse('0x$hexCode')).withOpacity(opacity);
}

Color tocolor({double opacity = 1.0}) {
  final hexCode = this.replaceAll('#', '');
  return Color(int.parse('0x$hexCode')).withOpacity(opacity);
}

}

extension ScreenExtension on int {
  double width(BuildContext context) {
    return MediaQuery.of(context).size.width;
  }

  double height(BuildContext context) {
    return MediaQuery.of(context).size.height;
  }

  double safeTop(BuildContext context) {
    return MediaQuery.of(context).padding.top;
  }

  double safeBottom(BuildContext context) {
    return MediaQuery.of(context).padding.top;
  }
  String to2SelfString() {
    double doubleNumber = this.toDouble();
    return doubleNumber.toStringAsFixed(1);
  }

  String to2String(int number) {
    double doubleNumber = number.toDouble();
    return doubleNumber.toStringAsFixed(2);
  }

  double roundToFourDecimals(double value) {
    var multiplier = 100;
    if (value >= 999.00){
      multiplier = 10000;
    }
    return (value * multiplier).round() / multiplier;
  }

  /// 生成1到20之间的随机整数（包含1和20）
  int getRandomNumberBetween1And20() {
    // 创建随机数生成器实例
    final random = Random();

    // 生成0-19的随机数，然后加1得到1-20
    return random.nextInt(20) + 1;
  }

  /// 生成1到10之间的随机整数（包含1和20）
  int getRandomNumberBetween1And10() {
    // 创建随机数生成器实例
    final random = Random();

    // 生成0-19的随机数，然后加1得到1-20
    return random.nextInt(10) + 1;
  }

  /// 计算里程数
  /// [gender] 性别，传入 '0' 表示男性，'1' 表示女性
  /// [height] 身高，单位为厘米(cm)
  /// [steps] 步数，整数
  /// 返回值：里程数，单位为公里(km)，保留一位小数
  double calculateMileage({
    required int gender,
    required double height,
    required int steps,
  }) {
    // 1. 确定步幅系数
    double strideCoefficient;

    if (gender == 0) {
      // 男性步幅系数判断
      if (height <= 160) {
        strideCoefficient = 0.415;
      } else if (height <= 170) {
        strideCoefficient = 0.445;
      } else {
        strideCoefficient = 0.475;
      }
    } else if (gender == 1) {
      // 女性步幅系数判断
      if (height <= 150) {
        strideCoefficient = 0.413;
      } else if (height <= 160) {
        strideCoefficient = 0.43;
      } else {
        strideCoefficient = 0.453;
      }
    } else {
      // 未知性别返回0
      return 0.0;
    }

    // 2. 计算步长(cm)：身高 * 步幅系数
    final double stepLength = height * strideCoefficient;

    // 3. 计算里程(km)：(步数 * 步长) / 100000（转换单位为km）
    final double mileage = (steps * stepLength) / 100000;

    // 4. 保留一位小数并返回
    return double.parse(mileage.toStringAsFixed(2));
  }

}

extension ScreenPadding on double {

  // 封装传入 double 返回数字带逗号类型的函数，保留四位小数
  String formatNumberWithCommas(double number, int Fixed) {
    final numberStr = number.toStringAsFixed(Fixed);
    final parts = numberStr.split('.');
    final integerPart = parts[0];
    final decimalPart = parts.length > 1 ? parts[1] : '';

    final buffer = StringBuffer();
    int counter = 0;
    for (int i = integerPart.length - 1; i >= 0; i--) {
      buffer.write(integerPart[i]);
      counter++;
      if (counter % 3 == 0 && i != 0) {
        buffer.write(',');
      }
    }
    final formattedInteger = buffer.toString().split('').reversed.join();

    return decimalPart.isNotEmpty
        ? '$formattedInteger.$decimalPart'
        : formattedInteger;
  }

  EdgeInsets top(double value) {
    return EdgeInsets.only(top: value);
  }

  EdgeInsets left(double value) {
    return EdgeInsets.only(left: value);
  }

  EdgeInsets bottom(double value) {
    return EdgeInsets.only(bottom: value);
  }

  EdgeInsets right(double value) {
    return EdgeInsets.only(right: value);
  }

  EdgeInsets only(
      double value,
      double value1,
      double value2,
      double value3,
      ) {
    return EdgeInsets.only(
      top: value,
      left: value1,
      bottom: value2,
      right: value3,
    );
  }

  EdgeInsets all(
      double value,
      ) {
    return EdgeInsets.all(value);
  }
}

extension OtherExtension on int {
  String today() {
    DateTime now = DateTime.now();

    String formattedDate =
        '${now.year}/${_twoDigits(now.month)}/${_twoDigits(now.day)}';

    return formattedDate;
  }

  String _twoDigits(int n) {
    if (n >= 10) {
      return '$n';
    }
    return '0$n';
  }
}

extension IterableExtension<E> on Iterable<E> {
  Iterable<T> mapIndexed<T>(T Function(int index, E element) toElement) sync* {
    int index = 0;
    for (final element in this) {
      yield toElement(index++, element);
    }
  }
}

extension TipShow on BuildContext {
  Future tipShow(Widget v, {Color? bc}) {
    return showGeneralDialog(
        context: this,
        barrierDismissible: false,
        barrierColor: bc ?? Colors.black.withOpacity(0.7),
        transitionDuration: const Duration(milliseconds: 150),
        transitionBuilder: (ctx, animation, sAnimation, child) {
          final curvedAnimation = CurvedAnimation(
            parent: animation,
            curve: Curves.easeOut,
          );
          final reverseCurvedAnimation = CurvedAnimation(
            parent: sAnimation,
            curve: Curves.easeIn,
          );

          return ScaleTransition(
            scale: Tween<double>(begin: 0.4, end: 1).animate(curvedAnimation),
            child: FadeTransition(
              opacity: Tween<double>(begin: 0.3, end: 1).animate(curvedAnimation),
              child: ScaleTransition(
                scale: Tween<double>(begin: 1, end: 0.3).animate(reverseCurvedAnimation),
                child: FadeTransition(
                  opacity: Tween<double>(begin: 1, end: 0.2).animate(reverseCurvedAnimation),
                  child: child,
                ),
              ),
            ),
          );
        },
        pageBuilder: (context, animation, sAnimation) {
          return PopScope(
              canPop: false,
              child: Dialog(
                insetPadding: EdgeInsets.zero,
                backgroundColor: Colors.transparent,
                child: v,
              ));
        });
  }
}
class BoomUniqueStringUtil {
  BoomUniqueStringUtil._internal();

  //加密：“data”：原始字符串；“code”：需求文档标题前的项目编号
  static String encrypt(String data, int code) {
    final dataBytes = utf8.encode(data);
    List<int> xorList = [];
    for (int i = 0; i < dataBytes.length; i++) {
      xorList.add(dataBytes[i] ^ code);
    }
    return base64.encode(xorList);
  }

  //解密：“data”：加密字符串；“code”：需求文档标题前的项目编号
  static String decrypt(String data, int code) {
    final decode = base64.decode(data);
    final decode2 = decode.toList();
    List<int> xorList = [];
    for (int i = 0; i < decode2.length; i++) {
      xorList.add(decode2[i] ^ code);
    }
    return utf8.decode(xorList);
  }
}

// 记录cash数值100倍数不重复
class SJThresholdTrigger {
  static const String _key = "sj_triggered_levels";
  Set<int> _triggered = {};

  /// 初始化，从本地加载
  Future<void> init() async {
    final prefs = await SharedPreferences.getInstance();
    _triggered = (prefs.getStringList(_key)?.map(int.parse).toSet()) ?? {};
  }

  /// 检查是否触发
  Future<void> check(
      int value, {
        int step = 100,
        required Function(int level) onTrigger,
      }) async {
    int level = (value ~/ step) * step;

    if (level < step) return;

    // 已经触发过，则不再触发
    if (_triggered.contains(level)) return;

    // 触发
    onTrigger(level);

    // 标记触发并保存到本地
    _triggered.add(level);
    await _save();
  }

  /// 保存到本地
  Future<void> _save() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList(
      _key,
      _triggered.map((e) => e.toString()).toList(),
    );
  }
}
