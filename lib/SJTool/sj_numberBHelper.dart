import 'dart:convert';
import 'dart:math';

import 'package:flutter/services.dart';
import 'package:scratchjoy/SJTool/sj_LocalProvider.dart';
import 'package:scratchjoy/SJTool/sj_NumberHelper.dart';
import 'package:scratchjoy/SJTool/sj_extension_help.dart';

import '../SJModel/SJPlayJoyModel.dart';
import '../SJModel/SJbonus_config.dart';

class SJNumberBHelper {
  static final SJNumberBHelper _instance = SJNumberBHelper._internal();

  factory SJNumberBHelper() => _instance;

  SJNumberBHelper._internal();

  BonusConfig? numberEntity;

  Future<void> init() async {
    await _loadNumberDataFromLocate();
  }

  Future<void> _loadNumberDataFromLocate() async {
    String jsonString = await rootBundle.loadString("winup_number".jsons());
    Map<String, dynamic> jsonMap = json.decode(jsonString);
    numberEntity = BonusConfig.fromJson(jsonMap);
    'numberEntity.boxReward=${numberEntity!.diceNumeric}'.log();
  }

  /// 🎲 生成 extra_bonus 模式结果
  SJPlayJoyResult generateextra_bonusNumbers({
    bool forceWin = false,
  }) {
    final _rand = Random();
    final mode = numberEntity!.extraBonus;

    // 1️⃣ 生成4个不重复的中奖数字 (10~99)
    List<int> allNumbers = List.generate(90, (i) => i + 10);
    allNumbers.shuffle(_rand);
    List<int> winNumbers = allNumbers.take(4).toList();

    List<int> displayNumbers = List.generate(12, (_) => _genSafeRandom(_rand, winNumbers));

    // 3️⃣ 奖金匹配数字（原逻辑保留）
    List<double> winawards =
    getPrizeByValue(SJLocalProvider.instance.sj_dolas_number.toDouble(), mode.prize!);

    List<double> winMatchNumbers;
    if (winawards.isNotEmpty) {
      int minPrize = winawards.first.toInt();
      int maxPrize = winawards.last.toInt();
      winMatchNumbers = List.generate(
        12,
            (_) => 0.to2Double(_rand.nextInt(maxPrize - minPrize + 1) + minPrize),
      );
    } else {
      winMatchNumbers = List.generate(12, (_) => _rand.nextInt(90) + 10);
    }

    // 4️⃣ 判断是否中奖（标准化）
    double pointRate = mode.point!.clamp(0.0, 1.0);
    bool isWin = forceWin ? true : (_rand.nextDouble() < pointRate);

    int winIndex = -1;

    // 5️⃣ 中奖：设置唯一中奖位
    if (isWin) {
      winIndex = _rand.nextInt(displayNumbers.length);

      // 生成 1 个中奖号并放置
      int winNumber = winNumbers[_rand.nextInt(winNumbers.length)];
      displayNumbers[winIndex] = winNumber;

      // ❗ 确保除了 winIndex 外所有位置不可能含中奖号
      for (int i = 0; i < displayNumbers.length; i++) {
        if (i != winIndex && winNumbers.contains(displayNumbers[i])) {
          displayNumbers[i] = _genSafeRandom(_rand, winNumbers); // 安全替换
        }
      }
    }

    // 6️⃣ 不中奖：所有数字必须不是中奖号
    if (!isWin) {
      for (int i = 0; i < displayNumbers.length; i++) {
        if (winNumbers.contains(displayNumbers[i])) {
          displayNumbers[i] = _genSafeRandom(_rand, winNumbers);
        }
      }
    }

    // 7️⃣ 骰子命中逻辑，不覆盖中奖位置
    bool diceHit = _rand.nextDouble() < mode.diceProbability!;
    if (diceHit) {
      int diceIdx;
      do {
        diceIdx = _rand.nextInt(displayNumbers.length);
      } while (diceIdx == winIndex);

      displayNumbers[diceIdx] = -2;
    }

    return SJPlayJoyResult(
      winNumbers: winNumbers,
      displayNumbers: displayNumbers,
      winMatchNumbers: winMatchNumbers,
      isWin: isWin,
      diceHit: diceHit,
      winIndex: winIndex,
    );
  }

  int _genSafeRandom(Random rand, List<int> winNumbers) {
    int v;
    do {
      v = rand.nextInt(90) + 10; // 10~99
    } while (winNumbers.contains(v)); // 不能撞中奖数字
    return v;
  }



  /// 🎲 生成 lucku_moment 模式结果
  SJPlayJoyResult generatelucku_momentNumbers({
    bool forceWin = false,
  }) {
    final _rand = Random();
    final mode = numberEntity!.luckyMoment;

    // 1️⃣ 生成4个不重复的中奖数字 (10~99)
    List<int> allNumbers = List.generate(90, (i) => i + 10);
    allNumbers.shuffle(_rand);
    List<int> winNumbers = allNumbers.take(4).toList();

    // 2️⃣ 生成12个显示数字，确保未中奖时不包含 winNumbers
    List<int> displayNumbers = [];
    while (displayNumbers.length < 12) {
      int n = _rand.nextInt(90) + 10;
      if (!winNumbers.contains(n)) {
        displayNumbers.add(n);
      }
    }

    // 3️⃣ 每个显示数字对应的中奖值
    List<double> winMatchNumbers = [];
    List<double> winawards = getPrizeByValue(SJLocalProvider.instance.sj_dolas_number.toDouble(), mode.prize!);
    if (winawards.isNotEmpty) {
      int minPrize = winawards.first.toInt();
      int maxPrize = winawards.last.toInt();
      winMatchNumbers = List.generate(
          12, (_) => 0.to2Double(_rand.nextInt(maxPrize - minPrize + 1) + minPrize));
    } else {
      winMatchNumbers = List.generate(12, (_) => _rand.nextInt(90) + 10);
    }

    // 4️⃣ 判断是否中奖
    double pointRate = mode.point!.clamp(0.0, 1.0);
    bool isWin = forceWin || (_rand.nextDouble() < pointRate);
    if (forceWin){
      isWin = forceWin;
    }

    // 5️⃣ 若中奖，只替换一个位置为 winNumbers 中的一个
    int winIndex = 0;
    if (isWin) {
      winIndex = _rand.nextInt(3);
      int winNumber = winNumbers[_rand.nextInt(winNumbers.length)];
      displayNumbers[winIndex] = winNumber;
    }


    bool diceHit = _rand.nextDouble() < mode.diceProbability!;
    if (diceHit) {
      int diceIdx;
      do {
        diceIdx = _rand.nextInt(displayNumbers.length);
      } while (diceIdx == winIndex); // ‼️ 不覆盖中奖位置

      displayNumbers[diceIdx] = -2;
    }

    // ✅ 7️⃣ 封装结果返回
    return SJPlayJoyResult(
      winNumbers: winNumbers,
      displayNumbers: displayNumbers,
      winMatchNumbers: winMatchNumbers,
      isWin: isWin,
      diceHit: diceHit,
      winIndex: winIndex,
    );
  }


  SJsecret_stashResult generatesecret_stashStash({bool forceWin = false}) {
    final _rand = Random();
    final mode = numberEntity!.secretStash;

    // 🎯 Step 1: 决定 multiplier（中奖倍数）
    int multiplier;

    if (forceWin) {
      // 🔥 强制中奖：一定给一个倍数（1、2、5）
      multiplier = [1, 2, 5][_rand.nextInt(3)];
    } else {
      double roll = _rand.nextDouble();
      if (roll < mode.point1x!) multiplier = 1;
      else if (roll < mode.point1x! + mode.point2x!) multiplier = 2;
      else if (roll < mode.point1x! + mode.point2x! + mode.point5x!) multiplier = 5;
      else multiplier = 0;
    }

    bool isWin = multiplier > 0;
    if (forceWin){
      isWin = forceWin;
    }

    // 🎯 Step 2: 生成两个不重复中奖数字
    List<int> winNumbers = [_rand.nextInt(5), _rand.nextInt(5)];
    while (winNumbers[0] == winNumbers[1]) {
      winNumbers[1] = _rand.nextInt(5);
    }

    // 🎰 Step 3: 生成 9 个数字（0~4）
    List<int> numbers = List.generate(9, (_) => _rand.nextInt(5));

    int winIndex = -1;
    List<int> winIndexes = [];

    if (isWin) {
      // 🎯 中奖列（按倍率）
      int columnIndex = multiplier == 1 ? 0 : (multiplier == 2 ? 1 : 2);
      List<int> columnIndexes = [columnIndex, columnIndex + 3, columnIndex + 6];

      // 随机选一个中奖格
      winIndex = columnIndexes[_rand.nextInt(3)];
      winIndexes.add(winIndex);

      // 🎯 给中奖格赋中奖数字
      int luckyNumber = winNumbers[_rand.nextInt(2)];
      numbers[winIndex] = luckyNumber;

      // 🚫 其他格禁止出现中奖数字
      for (int i = 0; i < 9; i++) {
        if (i == winIndex) continue;
        while (winNumbers.contains(numbers[i])) {
          numbers[i] = _rand.nextInt(5);
        }
      }
    } else {
      // ❌ 不中奖：所有格禁止出现中奖数字
      for (int i = 0; i < 9; i++) {
        while (winNumbers.contains(numbers[i])) {
          numbers[i] = _rand.nextInt(5);
        }
      }
    }

    // 🎲 Step 4: 骰子（不覆盖中奖格）
    bool diceHit = false;
    if (_rand.nextDouble() < mode.diceProbability!) {
      diceHit = true;
      int diceIndex;
      do {
        diceIndex = _rand.nextInt(9);
      } while (diceIndex == winIndex);
      numbers[diceIndex] = -2;
    }

    // 💰 Step 5: 奖励范围
    List<double> winawards = getPrizeByValue(
        SJLocalProvider.instance.sj_dolas_number.toDouble(),
        mode.prize!
    );
    double minPrize = winawards.first;
    double maxPrize = winawards.last;
    List<double> prizeValues = List.generate(
      9,
          (_) {
        double v = _rand.nextDouble() * (maxPrize - minPrize) + minPrize;
        return double.parse(v.toStringAsFixed(2)); // 保留2小数
      },
    );

    return SJsecret_stashResult(
      numbers: numbers,
      winNumbers: winNumbers,
      isWin: isWin,
      winIndex: winIndex,
      winIndexes: winIndexes,
      diceHit: diceHit,
      prizeValues: prizeValues,
      multiplier: multiplier,
        awards_value: prizeValues[winIndex > 0 ? winIndex : 0]
    );
  }

  // SuperMultiple
  SJsuperMultipleResult generateSuperMultiple({bool forceWin = false}) {
    final _rand = Random();
    final mode = numberEntity!.superMultiple;

    // -----------------------------
    // Step 1: 正确处理 multiplier（中奖倍数）
    // -----------------------------
    int multiplier;

    if (forceWin) {
      // 🔥 强制中奖：从 20 / 30 / 50 随机挑一个
      multiplier = [20, 30, 50][_rand.nextInt(3)];
    } else {
      double roll = _rand.nextDouble();
      if (roll < mode.point20x!) multiplier = 20;
      else if (roll < mode.point20x! + mode.point30x!) multiplier = 30;
      else if (roll < mode.point20x! + mode.point30x! + mode.point50x!) multiplier = 50;
      else multiplier = 0;
    }

    bool isWin = multiplier > 0; // multiplier 决定中奖
    if (forceWin){
      isWin = forceWin;
    }

    // -----------------------------
    // Step 2: 生成10个普通数字（1~5）
    // -----------------------------
    List<int> numbers = List.generate(10, (_) => _rand.nextInt(5) + 1);

    int winIndex = -1;

    if (isWin) {
      // 🎯 中奖格唯一
      winIndex = _rand.nextInt(10);

      // 🎯 根据 multiplier 设置中奖标识
      if (multiplier == 20) numbers[winIndex] = -1;
      else if (multiplier == 30) numbers[winIndex] = -2;
      else if (multiplier == 50) numbers[winIndex] = -3;

      // 🚫 其他格不能出现中奖数字 (-1/-2/-3)
      for (int i = 0; i < 10; i++) {
        if (i == winIndex) continue;
        while (numbers[i] < 0) {
          numbers[i] = _rand.nextInt(5) + 1;
        }
      }
    } else {
      // ❌ 不中奖：所有数字必须为正常值 1~5
      for (int i = 0; i < 10; i++) {
        while (numbers[i] < 0) {
          numbers[i] = _rand.nextInt(5) + 1;
        }
      }
    }

    // -----------------------------
    // Step 3: 骰子逻辑（绝不能覆盖中奖位置）
    // -----------------------------
    bool diceHit = false;
    if (_rand.nextDouble() < mode.diceProbability!) {
      diceHit = true;

      int diceIndex;
      do {
        diceIndex = _rand.nextInt(10);
      } while (diceIndex == winIndex); // 避开中奖格

      numbers[diceIndex] = -5; // 骰子标记
    }

    // -----------------------------
    // Step 4: 奖励值
    // -----------------------------
    List<double> winawards = getPrizeByValue(
      SJLocalProvider.instance.sj_dolas_number.toDouble(),
      mode.prize!,
    );
    double minPrize = winawards.first;
    double maxPrize = winawards.last;

    List<double> prizeValues = List.generate(
      10,
          (_) => _rand.nextDouble() * (maxPrize - minPrize + 1) + minPrize,
    );

    // -----------------------------
    // Step 5: 返回结果
    // -----------------------------
    return SJsuperMultipleResult(
      numbers: numbers,
      isWin: isWin,
      multiplier: multiplier,
      diceHit: diceHit,
      prizeValues: prizeValues,
      winIndex: winIndex,
      award_value: prizeValues[winIndex > 0 ? winIndex : 0]
    );
  }


  // FortuneRush
  SJfortuneRushResult generateFortuneRush({bool forceWin = false}) {
    final _rand = Random();
    final mode = numberEntity!.fortuneRush;

    // Step 1: 是否中奖
    bool isWin = forceWin || (_rand.nextDouble() < mode.point!);
    if (forceWin){
      isWin = forceWin;
    }

    // Step 2: 生成唯一中奖数字
    int winNumber = _rand.nextInt(90 - 10 + 1) + 10; // 10~99
    int winIndex = -1;
    int winRow = -1;

    // Step 3: 初始化 25 个数字（前两个固定 0）
    List<int> numbers = List.filled(25, 0);
    for (int i = 2; i < 25; i++) {
      numbers[i] = _rand.nextInt(90 - 10 + 1) + 10;
    }

    // 防止出现三连排（行保底规则）
    void fixNoTripleInRow() {
      for (int row = 0; row < 5; row++) {
        int start = row * 5;

        while (true) {
          bool changed = false;

          for (int i = 0; i < 3; i++) {
            int a = numbers[start + i];
            int b = numbers[start + i + 1];
            int c = numbers[start + i + 2];

            if (a == b && b == c) {
              numbers[start + i + 1] = _rand.nextInt(90 - 10 + 1) + 10;
              changed = true;
            }
          }

          if (!changed) break;
        }
      }
    }

    // 中奖逻辑
    if (isWin) {
      winIndex = _rand.nextInt(23) + 2; // 保证不能是 0、1
      numbers[winIndex] = winNumber;
      winRow = winIndex ~/ 5;

      // 中奖行禁止出现其他三连排
      fixNoTripleInRow();

    } else {
      // 不中奖 → 数字不能与 winNumber 相同
      for (int i = 2; i < 25; i++) {
        while (numbers[i] == winNumber) {
          numbers[i] = _rand.nextInt(90 - 10 + 1) + 10;
        }
      }

      // 确保每行不出现任意三连排
      fixNoTripleInRow();
    }

    // Step 4: 骰子逻辑
    bool diceHit = false;
    if (_rand.nextDouble() < mode.diceProbability!) {
      diceHit = true;

      int diceIndex;
      do {
        diceIndex = _rand.nextInt(25);
      } while (numbers[diceIndex] == winNumber);

      numbers[diceIndex] = -1;
    }

    // Step 5: 奖励值生成
    List<double> winawards = getPrizeByValue(
        SJLocalProvider.instance.sj_dolas_number.toDouble(),
        mode.prize!
    );
    int minPrize = winawards.first.toInt();
    int maxPrize = winawards.last.toInt();

    List<int> prizeValues =
    List.generate(5, (_) => _rand.nextInt(maxPrize - minPrize + 1) + minPrize);

    return SJfortuneRushResult(
      numbers: numbers,
      winNumber: winNumber,
      isWin: isWin,
      winRow: winRow,
      diceHit: diceHit,
      prizeValues: prizeValues,
    );
  }


  // SweetTime
  SJSweetTimeResult generateSweetTime({bool forceWin = false}) {
    final _rand = Random();
    final mode = numberEntity!.sweetTime;

    // Step 1: 判断是否中奖
    bool isWin = forceWin || (_rand.nextDouble() < mode.point!);
    if (forceWin){
      isWin = forceWin;
    }

    // 初始化9个格子随机数字 0~2
    List<int> numbers = List.generate(9, (_) => _rand.nextInt(3));

    int winningNumber = -2;
    int winningRow = -1;
    List<int> winningRowIndexes = [];
    int multiplier = isWin ? 1 : 0;

    // 用于彻底避免三连
    void fixNoTriple({int skipRow = -1}) {
      for (int r = 0; r < 3; r++) {
        if (r == skipRow) continue; // 跳过中奖行
        int a = numbers[r * 3];
        int b = numbers[r * 3 + 1];
        int c = numbers[r * 3 + 2];

        while (a == b && b == c) {
          numbers[r * 3] = _rand.nextInt(3);
          numbers[r * 3 + 1] = _rand.nextInt(3);
          numbers[r * 3 + 2] = _rand.nextInt(3);

          a = numbers[r * 3];
          b = numbers[r * 3 + 1];
          c = numbers[r * 3 + 2];
        }
      }
    }

    // Step 2: 中奖逻辑
    if (isWin) {
      winningRow = _rand.nextInt(3); // 随机一行中奖
      winningNumber = _rand.nextInt(3); // 中奖数字

      // 设置中奖行为三个相同数字
      for (int i = 0; i < 3; i++) {
        numbers[winningRow * 3 + i] = winningNumber;
      }

      winningRowIndexes = [
        winningRow * 3,
        winningRow * 3 + 1,
        winningRow * 3 + 2,
      ];

      // 其他行不能出现 winningNumber，避免误判
      for (int r = 0; r < 3; r++) {
        if (r == winningRow) continue;

        for (int c = 0; c < 3; c++) {
          int idx = r * 3 + c;
          numbers[idx] = _rand.nextInt(3);
          while (numbers[idx] == winningNumber) {
            numbers[idx] = _rand.nextInt(3);
          }
        }
      }

      // 其他行修复三连
      fixNoTriple(skipRow: winningRow);

    } else {
      // 不中奖：确保没有任意三连
      fixNoTriple();
    }

    // Step 3: 骰子逻辑（不能盖中奖）
    bool diceHit = false;
    if (_rand.nextDouble() < mode.diceProbability!) {
      diceHit = true;

      int diceIndex;
      do {
        diceIndex = _rand.nextInt(9);
      } while (winningRowIndexes.contains(diceIndex));

      numbers[diceIndex] = -1; // 骰子标记
    }

    // Step 4: 奖励生成
    List<double> winawards = getPrizeByValue(
        SJLocalProvider.instance.sj_dolas_number.toDouble(),
        mode.prize!
    );

    int minPrize = winawards.first.toInt();
    int maxPrize = winawards.last.toInt();

    List<int> prizeValues =
    List.generate(3, (_) => _rand.nextInt(maxPrize - minPrize + 1) + minPrize);

    return SJSweetTimeResult(
      numbers: numbers,
      isWin: isWin,
      winningNumber: winningNumber,
      winningRow: winningRow,
      winningRowIndexes: winningRowIndexes,
      diceHit: diceHit,
      prizeValues: prizeValues,
      multiplier: multiplier,
    );
  }


  /// 根据传入的数值，从 PrizeRange 列表中获取对应 prize 区间
  List<double> getPrizeByValue(double value, List<PrizeRange> ranges) {
    if (ranges.isEmpty) return [];

    // 遍历找区间
    for (var r in ranges) {
      if (value >= r.firstNumber && value < r.endNumber) {
        return r.prize ?? [];
      }
    }

    // 数值超出范围 => 返回最后一个 prize
    return ranges.last.prize ?? [];
  }

}

/// 🎯 3x3 抽奖结果模型（带骰子、奖励值）
class SJ3x3Result {
  final List<int> numbers; // 3x3格子数字，-2表示骰子
  final bool isWin; // 是否中奖
  final List<int> winIndexes; // 若中奖，连线格子下标
  final double prize; // 若中奖，奖励值
  final bool diceHit; // 骰子是否命中

  SJ3x3Result({
    required this.numbers,
    required this.isWin,
    required this.winIndexes,
    required this.prize,
    required this.diceHit,
  });

  @override
  String toString() {
    return 'SJ3x3Result(numbers: $numbers, isWin: $isWin, winIndexes: $winIndexes, prize: $prize, diceHit: $diceHit)';
  }
}

extension SJNumberAHelper3x3WithDice on SJNumberBHelper {
  SJ3x3Result generate3x3NumbersWithPrizeAndDice({
    bool forceWin = false,
  }) {
    final mode = numberEntity!.goldRush;
    final _rand = Random();

    final double rate = (mode.point ?? 0.8).clamp(0.0, 1.0);
    bool isWin = forceWin || (_rand.nextDouble() < rate);

    if (forceWin) isWin = true;

    List<int> grid = List.filled(9, 0);
    List<int> winIndexes = [-1, -1, -1];
    bool diceHit = false;
    double prize = 33;

    // 获取奖励区间
    List<double> prizeList =
    getPrizeByValue(SJLocalProvider.instance.sj_dolas_number.toDouble(), mode.prize!);

    int minPrize = prizeList.isNotEmpty ? prizeList.first.toInt() : 33;
    int maxPrize = prizeList.isNotEmpty ? prizeList.last.toInt() : 33;

    // -----------------------------
    // 🎯 Case 1: 中奖（构造唯一中奖线）
    // -----------------------------
    if (isWin) {
      prize = 0.to2Double(_rand.nextInt(maxPrize - minPrize + 1) + minPrize);

      int winNumber = _rand.nextInt(3);

      // 选择线条：0=横 1=竖 2=斜
      int lineType = _rand.nextInt(3);
      int lineIndex = _rand.nextInt(3);

      // 确定 winIndexes
      if (lineType == 0) {
        winIndexes = List.generate(3, (i) => lineIndex * 3 + i);
      } else if (lineType == 1) {
        winIndexes = List.generate(3, (i) => lineIndex + i * 3);
      } else {
        winIndexes = _rand.nextBool() ? [0, 4, 8] : [2, 4, 6];
      }

      // 填中奖线
      for (int i in winIndexes) {
        grid[i] = winNumber;
      }

      // 填其他格子（不能形成任何额外连线）
      for (int i = 0; i < 9; i++) {
        if (winIndexes.contains(i)) continue;

        int val;
        int tries = 0;

        do {
          val = _rand.nextInt(3);
          grid[i] = val;
          tries++;
        } while (_checkHasForbiddenExtraLine(grid, winIndexes) && tries < 50);
      }

      // 骰子：不能盖中奖线
      if (_rand.nextDouble() < (mode.diceProbability ?? 0.0)) {
        diceHit = true;
        List<int> available = List.generate(9, (i) => i)
          ..removeWhere((x) => winIndexes.contains(x));
        if (available.isNotEmpty) {
          int idx = available[_rand.nextInt(available.length)];
          grid[idx] = -2;
        }
      }
    }

    // -----------------------------
    // ❌ Case 2: 不中奖（绝对无三连）
    // -----------------------------
    else {
      bool valid = false;
      int attempts = 0;

      while (!valid && attempts < 500) {
        attempts++;
        grid = List.generate(9, (_) => _rand.nextInt(3));
        valid = !_checkAnyWinningLine(grid);
      }

      // 骰子随便放
      if (_rand.nextDouble() < (mode.diceProbability ?? 0.0)) {
        diceHit = true;
        grid[_rand.nextInt(9)] = -2;
      }

      winIndexes = [-1, -1, -1];
    }

    return SJ3x3Result(
      numbers: grid,
      isWin: isWin,
      winIndexes: winIndexes,
      prize: prize,
      diceHit: diceHit,
    );
  }

  /// ⛔ 检查是否形成额外中奖线（排除 winIndexes 主中奖线）
  bool _checkHasForbiddenExtraLine(List<int> g, List<int> winIndexes) {
    const lines = [
      [0, 1, 2],
      [3, 4, 5],
      [6, 7, 8],
      [0, 3, 6],
      [1, 4, 7],
      [2, 5, 8],
      [0, 4, 8],
      [2, 4, 6],
    ];

    for (var line in lines) {
      // 主中奖线跳过检查
      if (_sameList(line, winIndexes)) continue;

      int a = g[line[0]];
      int b = g[line[1]];
      int c = g[line[2]];

      if (a == b && b == c) return true;
    }
    return false;
  }

  /// 检查是否有任何连线（不区分主线），用于“不中奖”模式
  bool _checkAnyWinningLine(List<int> g) {
    const lines = [
      [0, 1, 2],
      [3, 4, 5],
      [6, 7, 8],
      [0, 3, 6],
      [1, 4, 7],
      [2, 5, 8],
      [0, 4, 8],
      [2, 4, 6],
    ];
    for (var l in lines) {
      if (g[l[0]] == g[l[1]] && g[l[1]] == g[l[2]]) return true;
    }
    return false;
  }

  /// 检查两个列表是否完全相同
  bool _sameList(List<int> a, List<int> b) {
    if (a.length != b.length) return false;
    for (int i = 0; i < a.length; i++) {
      if (a[i] != b[i]) return false;
    }
    return true;
  }

  /// 获取 prize 区间
  List<double> getPrizeByValue(double value, List<PrizeRange> ranges) {
    if (ranges.isEmpty) return [];
    for (var r in ranges) {
      if (value >= r.firstNumber && value < r.endNumber) {
        return r.prize ?? [];
      }
    }
    return ranges.last.prize ?? [];
  }

}
