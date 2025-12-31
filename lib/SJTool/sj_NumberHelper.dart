import 'dart:convert';
import 'dart:math';

import 'package:flutter/services.dart';
import 'package:scratchjoy/SJTool/sj_extension_help.dart';

import '../SJModel/SJPlayJoyModel.dart';
import '../SJModel/SJbonus_config.dart';

class SJNumberAHelper {
  static final SJNumberAHelper _instance = SJNumberAHelper._internal();

  factory SJNumberAHelper() => _instance;

  SJNumberAHelper._internal();

  SJPlayJoyModel numberEntity = SJPlayJoyModel();

  Future<void> init() async {
    await _loadNumberDataFromLocate();
  }

  Future<void> _loadNumberDataFromLocate() async {
    String jsonString = await rootBundle.loadString("palyjoy_number".jsons());
    Map<String, dynamic> jsonMap = json.decode(jsonString);
    numberEntity = SJPlayJoyModel.fromJson(jsonMap);
    'numberEntity.boxReward=${numberEntity.boxReward}'.log();
  }

  /// 🎲 生成 extra_bonus 模式结果
  SJPlayJoyResult generateextra_bonusNumbers({
    bool forceWin = false,
  }) {
    final _rand = Random();
    final mode = numberEntity.extraBonus;

    // 1️⃣ 生成4个不重复的中奖数字 (10~99)
    List<int> allNumbers = List.generate(90, (i) => i + 10);
    allNumbers.shuffle(_rand);
    List<int> winNumbers = allNumbers.take(4).toList();

    // 2️⃣ 生成12个显示数字 (初始为普通随机数 10~99)
    List<int> displayNumbers = List.generate(12, (_) => _rand.nextInt(90) + 10);

    // 3️⃣ 每个显示数字对应的中奖值
    List<double> winMatchNumbers = [];
    if (mode.prize.isNotEmpty) {
      int minPrize = mode.prize.first;
      int maxPrize = mode.prize.last;

      winMatchNumbers = List.generate(12, (_) {
        double raw = _rand.nextDouble() * (maxPrize - minPrize) + minPrize;
        return 0.to2Double(raw);
      });
    } else {
      winMatchNumbers = List.generate(12, (_) => _rand.nextInt(90) + 10);
    }

    // 4️⃣ 判断是否中奖
    double pointRate = mode.point.clamp(0.0, 1.0);
    bool isWin = forceWin || (_rand.nextDouble() < pointRate);

    // 5️⃣ 若中奖，只替换一个位置为 winNumbers 中的一个
    int winIndex = -1;
    if (isWin) {
      winIndex = _rand.nextInt(displayNumbers.length);
      int winNumber = winNumbers[_rand.nextInt(winNumbers.length)];
      displayNumbers[winIndex] = winNumber;
    }

    // 6️⃣ 骰子命中逻辑
    bool diceHit = _rand.nextDouble() < mode.diceProbability;
    if (diceHit) {
      int diceIdx = _rand.nextInt(displayNumbers.length);
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

  /// 🎲 生成 lucku_moment 模式结果
  SJPlayJoyResult generatelucku_momentNumbers({
    bool forceWin = false,
  }) {
    final _rand = Random();
    final mode = numberEntity.luckuMoment;

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
    if (mode.prize.isNotEmpty) {
      int minPrize = mode.prize.first;
      int maxPrize = mode.prize.last;
      winMatchNumbers = List.generate(
          12, (_) => 0.to2Double(_rand.nextInt(maxPrize - minPrize + 1) + minPrize));
    } else {
      winMatchNumbers = List.generate(12, (_) => 0.to2Double(_rand.nextInt(90) + 10));
    }

    // 4️⃣ 判断是否中奖
    double pointRate = mode.point1x.clamp(0.0, 1.0);
    bool isWin = forceWin || (_rand.nextDouble() < pointRate);

    // 5️⃣ 若中奖，只替换一个位置为 winNumbers 中的一个
    int winIndex = 0;
    if (isWin) {
      winIndex = _rand.nextInt(3);
      int winNumber = winNumbers[_rand.nextInt(winNumbers.length)];
      displayNumbers[winIndex] = winNumber;
    }

    // 6️⃣ 骰子命中逻辑
    bool diceHit = _rand.nextDouble() < mode.diceProbability;
    if (diceHit) {
      int diceIdx = _rand.nextInt(displayNumbers.length);
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

    // 🎯 Step 1: 确定中奖倍数（根据概率）
    int multiplier = 0;
    double roll = _rand.nextDouble();
    final mode = numberEntity.secretStash;
    if (forceWin) {
      multiplier = [1, 2, 5][_rand.nextInt(3)];
    } else {
      if (roll < mode.point1x) multiplier = 1;
      else if (roll < mode.point1x + mode.point2x) multiplier = 2;
      else if (roll < mode.point1x + mode.point2x + mode.point5x) multiplier = 5;
      else multiplier = 0; // 不中奖
    }

    bool isWin = multiplier > 0;

    // 🎯 Step 2: 生成两个中奖数字（0~4，不重复）
    List<int> winNumbers = [
      _rand.nextInt(5),
      _rand.nextInt(5),
    ];
    while (winNumbers[0] == winNumbers[1]) {
      winNumbers[1] = _rand.nextInt(5);
    }

    // 🎰 Step 3: 生成9个数（0~4）
    List<int> numbers = List.generate(9, (_) => _rand.nextInt(5));
    int winIndex = -1;
    List<int> winIndexes = []; // ✅ 新增

    if (isWin) {
      // 根据倍数决定中奖的“纵向列”（0, 1, 2）
      int columnIndex = multiplier == 1 ? 0 : (multiplier == 2 ? 1 : 2);

      // 该列的下标分别是： [columnIndex, columnIndex + 3, columnIndex + 6]
      List<int> columnIndexes = [
        columnIndex,
        columnIndex + 3,
        columnIndex + 6,
      ];

      // 随机选一行
      winIndex = columnIndexes[_rand.nextInt(3)];
      winIndexes.add(winIndex); // ✅ 保存中奖下标列表

      // 中奖格赋中奖数字（从两个中奖数里挑一个）
      int luckyNumber = winNumbers[_rand.nextInt(2)];
      numbers[winIndex] = luckyNumber;

      // 其他格避免包含中奖数字
      for (int i = 0; i < 9; i++) {
        if (i == winIndex) continue;
        while (winNumbers.contains(numbers[i])) {
          numbers[i] = _rand.nextInt(5);
        }
      }
    } else {
      // 不中奖：所有格都不能包含中奖数字
      for (int i = 0; i < 9; i++) {
        while (winNumbers.contains(numbers[i])) {
          numbers[i] = _rand.nextInt(5);
        }
      }
    }

    // 🎲 Step 4: 骰子逻辑
    bool diceHit = false;
    if (_rand.nextDouble() < mode.diceProbability) {
      diceHit = true;
      int diceIndex;
      do {
        diceIndex = _rand.nextInt(9);
      } while (diceIndex == winIndex); // 骰子不能覆盖中奖格
      numbers[diceIndex] = -2;
    }

    // 💰 Step 5: 奖励值生成（按 prize 范围）
    int minPrize = mode.prize.first;
    int maxPrize = mode.prize.last;
    List<double> prizeValues = List.generate(
      9,
          (_) => _rand.nextDouble() * (maxPrize - minPrize + 1) + minPrize,
    );

    // ✅ Step 6: 返回结果
    return SJsecret_stashResult(
      numbers: numbers,
      winNumbers: winNumbers,
      isWin: isWin,
      winIndex: winIndex,
      winIndexes: winIndexes, // ✅ 新增
      diceHit: diceHit,
      prizeValues: prizeValues,
      multiplier: multiplier,
      awards_value: prizeValues[winIndex],
    );
  }
  // SuperMultiple
  SJsuperMultipleResult generateSuperMultiple({bool forceWin = false}) {
    final _rand = Random();
    final mode = numberEntity.superMultiple;

    // Step 1: 确定中奖倍数
    int multiplier = 0;
    double roll = _rand.nextDouble();
    if (forceWin) {
      multiplier = [20, 30, 50][_rand.nextInt(3)];
    } else {
      if (roll < mode.point20x) multiplier = 20;
      else if (roll < mode.point20x + mode.point30x) multiplier = 30;
      else if (roll < mode.point20x + mode.point30x + mode.point50x) multiplier = 50;
      else multiplier = 0;
    }

    bool isWin = multiplier > 0;

    // Step 2: 生成10个数字（1~5）
    List<int> numbers = List.generate(10, (_) => _rand.nextInt(5) + 1);
    int winIndex = -1;

    if (isWin) {
      // 中奖数字只出现一个
      winIndex = _rand.nextInt(10);
      if (multiplier == 20) numbers[winIndex] = -1;
      else if (multiplier == 30) numbers[winIndex] = -2;
      else if (multiplier == 50) numbers[winIndex] = -3;

      // 其余数字不能重复中奖数字
      for (int i = 0; i < 10; i++) {
        if (i == winIndex) continue;
        while (numbers[i] < 0) numbers[i] = _rand.nextInt(5) + 1;
      }
    } else {
      for (int i = 0; i < 10; i++) {
        while (numbers[i] < 0) numbers[i] = _rand.nextInt(5) + 1;
      }
    }

    // Step 3: 骰子逻辑
    bool diceHit = false;
    if (_rand.nextDouble() < mode.diceProbability) {
      diceHit = true;
      int diceIndex;
      do {
        diceIndex = _rand.nextInt(10);
      } while (numbers[diceIndex] < 0); // 骰子不能覆盖中奖数字
      numbers[diceIndex] = -5;
    }

    // Step 4: 奖励值
    double minPrize = mode.prize.first.toDouble();
    double maxPrize = mode.prize.last.toDouble();
    List<double> prizeValues = List.generate(
      10,
          (_) => _rand.nextDouble() * (maxPrize - minPrize + 1) + minPrize,
    );

    return SJsuperMultipleResult(
      numbers: numbers,
      isWin: isWin,
      multiplier: multiplier,
      diceHit: diceHit,
      prizeValues: prizeValues,
      winIndex: winIndex,
      award_value: prizeValues[winIndex],
    );
  }
  // FortuneRush
  SJfortuneRushResult generateFortuneRush({bool forceWin = false}) {
    final _rand = Random();
    final mode = numberEntity.fortuneRush;

    // Step 1: 确定是否中奖
    bool isWin = forceWin || (_rand.nextDouble() < mode.point);

    // Step 2: 生成中奖数字
    int winNumber = _rand.nextInt(90 - 10 + 1) + 10; // 10~99
    int winRow = -1;

    // Step 3: 生成25个数字，前两个固定0
    List<int> numbers = List.generate(25, (_) => _rand.nextInt(90 - 10 + 1) + 10);
    numbers[0] = 0;
    numbers[1] = 0;

    if (isWin) {
      // 随机选择一个位置为中奖数字（只能一个）
      int winIndex = _rand.nextInt(23) + 2; // 2~24
      numbers[winIndex] = winNumber;
      winRow = winIndex ~/ 5; // 每排5个数字
    } else {
      // 保证没有中奖数字
      for (int i = 2; i < 25; i++) {
        while (numbers[i] == winNumber) {
          numbers[i] = _rand.nextInt(90 - 10 + 1) + 10;
        }
      }
    }

    // Step 4: 骰子逻辑
    bool diceHit = false;
    if (_rand.nextDouble() < mode.diceProbability) {
      diceHit = true;
      int diceIndex;
      do {
        diceIndex = _rand.nextInt(25);
      } while (numbers[diceIndex] == winNumber); // 骰子不能覆盖中奖数字
      numbers[diceIndex] = -1;
    }

    // Step 5: 奖励值生成（5个对应奖励值）
    int minPrize = mode.prize.first;
    int maxPrize = mode.prize.last;
    List<int> prizeValues = List.generate(
      5,
          (_) => _rand.nextInt(maxPrize - minPrize + 1) + minPrize,
    );

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
    final mode = numberEntity.sweetTime;

    // Step 1: 判断是否中奖
    bool isWin = forceWin || (_rand.nextDouble() < mode.point);

    // 初始化9个格子随机数字 0~2
    List<int> numbers = List.generate(9, (_) => _rand.nextInt(3));

    int winningNumber = -2; // 默认不中奖
    int winningRow = -1;
    List<int> winningRowIndexes = [];
    int multiplier = isWin ? 1 : 0;

    // Step 2: 中奖逻辑
    if (isWin) {
      winningRow = _rand.nextInt(3); // 随机中奖行 0-2
      winningNumber = _rand.nextInt(3); // 中奖数字 0-2

      // 设置中奖行全部为中奖数字
      for (int i = 0; i < 3; i++) {
        numbers[winningRow * 3 + i] = winningNumber;
      }
      winningRowIndexes = [
        winningRow * 3,
        winningRow * 3 + 1,
        winningRow * 3 + 2,
      ];

      // 其他行避免出现中奖数字
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
    } else {
      // 不中奖：确保没有整行三个相同数字
      for (int r = 0; r < 3; r++) {
        List<int> row = numbers.sublist(r * 3, r * 3 + 3);
        // 如果三个相同，重新生成
        while (row[0] == row[1] && row[1] == row[2]) {
          for (int i = 0; i < 3; i++) {
            row[i] = _rand.nextInt(3);
          }
        }
        for (int i = 0; i < 3; i++) {
          numbers[r * 3 + i] = row[i];
        }
      }
      winningNumber = -2;
      winningRow = -1;
      winningRowIndexes = [];
    }

    // Step 3: 骰子逻辑
    bool diceHit = false;
    if (_rand.nextDouble() < mode.diceProbability) {
      diceHit = true;
      int diceIndex;
      do {
        diceIndex = _rand.nextInt(9);
      } while (winningRowIndexes.contains(diceIndex));
      numbers[diceIndex] = -1;
    }

    // Step 4: 奖励值生成
    int minPrize = mode.prize.first;
    int maxPrize = mode.prize.last;
    List<int> prizeValues = List.generate(
        3, (_) => _rand.nextInt(maxPrize - minPrize + 1) + minPrize);

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

/// 🎯 抽奖结果模型
class SJPlayJoyResult {
  final List<int> winNumbers; // 中奖数字（4个）
  final List<int> displayNumbers; // 显示的12个数字
  final List<double> winMatchNumbers; // 每个数字对应的中奖值（12个）
  final bool isWin; // 是否中奖
  final bool diceHit; // 是否骰子命中
  final int winIndex; // 若中奖，对应在 displayNumbers 中的下标，未中奖则为 -1

  SJPlayJoyResult({
    required this.winNumbers,
    required this.displayNumbers,
    required this.winMatchNumbers,
    required this.isWin,
    required this.diceHit,
    required this.winIndex,
  });

  factory SJPlayJoyResult.fromJson(Map<String, dynamic> json) {
    return SJPlayJoyResult(
      winNumbers: List<int>.from(json['win_numbers']),
      displayNumbers: List<int>.from(json['display_numbers']),
      winMatchNumbers: List<double>.from(json['win_match_numbers']),
      isWin: json['isWin'],
      diceHit: json['diceHit'],
      winIndex: json['winIndex'] ?? -1,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "win_numbers": winNumbers,
      "display_numbers": displayNumbers,
      "win_match_numbers": winMatchNumbers,
      "isWin": isWin,
      "diceHit": diceHit,
      "winIndex": winIndex,
    };
  }

  String toJsonString() => jsonEncode(toJson());

  @override
  String toString() => toJsonString();
}

/// 🎯 3x3 抽奖结果模型（带骰子、奖励值）
class SJ3x3Result {
  final List<int> numbers; // 3x3格子数字，-2表示骰子
  final bool isWin; // 是否中奖
  final List<int> winIndexes; // 若中奖，连线格子下标
  final int prize; // 若中奖，奖励值
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

extension SJNumberAHelper3x3WithDice on SJNumberAHelper {
  SJ3x3Result generate3x3NumbersWithPrizeAndDice({
    bool forceWin = false,
  }) {
    final mode = numberEntity.goldRush;
    final _rand = Random();

    final double rate = (mode.point ?? 0.8).clamp(0.0, 1.0);
    bool isWin = forceWin || (_rand.nextDouble() < rate);
    List<int> grid = List.filled(9, 0);
    List<int> winIndexes = [-1, -1, -1];
    bool diceHit = false;
    int prize = 33;

    // ---------------------
    // 🎯 Case 1: 中奖
    // ---------------------
    if (isWin) {
      int lineType = _rand.nextInt(3); // 0横 1竖 2斜
      int lineIndex = _rand.nextInt(3);
      int winNumber = _rand.nextInt(3);
      prize = mode.prize.isNotEmpty
          ? _rand.nextInt(mode.prize.last - mode.prize.first + 1) + mode.prize.first
          : 33;

      // 先填中奖线
      switch (lineType) {
        case 0:
          winIndexes = List.generate(3, (i) => lineIndex * 3 + i);
          break;
        case 1:
          winIndexes = List.generate(3, (i) => lineIndex + i * 3);
          break;
        case 2:
          if (_rand.nextBool()) {
            winIndexes = [0, 4, 8];
          } else {
            winIndexes = [2, 4, 6];
          }
          break;
      }

      for (int idx in winIndexes) {
        grid[idx] = winNumber;
      }

      // 随机填充其他格子，但避免形成额外中奖线（最多尝试10次）
      for (int i = 0; i < 9; i++) {
        if (winIndexes.contains(i)) continue;

        int attempts = 0;
        int val;
        do {
          val = _rand.nextInt(3);
          grid[i] = val;
          attempts++;
        } while (_checkHasAnyLine(grid) && attempts < 10);
      }

      // 🎲 骰子逻辑（不在中奖线中出现）
      if (_rand.nextDouble() < (mode.diceProbability ?? 0.0)) {
        List<int> availableIndexes = List.generate(9, (i) => i)
          ..removeWhere((i) => winIndexes.contains(i));
        if (availableIndexes.isNotEmpty) {
          diceHit = true;
          int diceIdx = availableIndexes[_rand.nextInt(availableIndexes.length)];
          grid[diceIdx] = -2;
        }
      }
    }

    // ---------------------
    // ❌ Case 2: 不中奖
    // ---------------------
    else {
      bool valid = false;
      int attempts = 0;
      while (!valid && attempts < 500) {
        attempts++;
        grid = List.generate(9, (_) => _rand.nextInt(3));
        valid = !_checkHasAnyLine(grid);
      }

      if (_rand.nextDouble() < (mode.diceProbability ?? 0.0)) {
        diceHit = true;
        int diceIdx = _rand.nextInt(9);
        grid[diceIdx] = -2;
      }

      prize = 33;
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

  /// 检查当前 grid 是否有任意中奖线
  bool _checkHasAnyLine(List<int> g) {
    for (int i = 0; i < 3; i++) {
      if (g[i * 3] == g[i * 3 + 1] && g[i * 3] == g[i * 3 + 2]) return true;
      if (g[i] == g[i + 3] && g[i] == g[i + 6]) return true;
    }
    if ((g[0] == g[4] && g[0] == g[8]) ||
        (g[2] == g[4] && g[2] == g[6])) return true;
    return false;
  }
}

class SJsecret_stashResult {
  final List<int> numbers;       // 九个格子的数字
  final List<int> winNumbers;    // 两个中奖数
  final bool isWin;              // 是否中奖
  final int winIndex;            // 中奖格下标
  final List<int> winIndexes;    // 中奖格下标列表 ✅ 新增
  final bool diceHit;            // 是否包含骰子
  final List<double> prizeValues;   // 每格奖励值
  final int multiplier;          // 倍数（1、2、5 或 0）
  final double awards_value;

  SJsecret_stashResult({
    required this.numbers,
    required this.winNumbers,
    required this.isWin,
    required this.winIndex,
    required this.winIndexes,
    required this.diceHit,
    required this.prizeValues,
    required this.multiplier,
    required this.awards_value,
  });

  Map<String, dynamic> toJson() => {
    "numbers": numbers,
    "winNumbers": winNumbers,
    "isWin": isWin,
    "winIndex": winIndex,
    "winIndexes": winIndexes, // ✅ 新增
    "diceHit": diceHit,
    "prizeValues": prizeValues,
    "multiplier": multiplier,
    "awards_value": awards_value,
  };

  @override
  String toString() => toJson().toString();
}

class SecretStashMode {
  final double point1x;
  final double point2x;
  final double point5x;
  final double nullRate;
  final double diceProbability;
  final List<int> prize;

  SecretStashMode({
    required this.point1x,
    required this.point2x,
    required this.point5x,
    required this.nullRate,
    required this.diceProbability,
    required this.prize,
  });
}

class SJsuperMultipleResult {
  final List<int> numbers;      // 10个格子数字
  final bool isWin;             // 是否中奖
  final int multiplier;         // 中奖倍数：20/30/50 或 0
  final bool diceHit;           // 骰子是否命中
  final List<double> prizeValues;  // 每格奖励值
  final int winIndex;           // 中奖数字下标 (-1/-2/-3的下标)
  final double award_value;

  SJsuperMultipleResult({
    required this.numbers,
    required this.isWin,
    required this.multiplier,
    required this.diceHit,
    required this.prizeValues,
    required this.winIndex,
    required this.award_value,
  });

  Map<String, dynamic> toJson() => {
    "numbers": numbers,
    "isWin": isWin,
    "multiplier": multiplier,
    "diceHit": diceHit,
    "prizeValues": prizeValues,
    "winIndex": winIndex,
    "award_value": award_value,
  };

  @override
  String toString() => toJson().toString();
}

class SJfortuneRushResult {
  final List<int> numbers;        // 25个格子数字（前两个固定0，真实数字23个）
  final int winNumber;            // 中奖数字（10~99）
  final bool isWin;               // 是否中奖
  final int winRow;               // 中奖所在排 0~4，没有中奖返回 -1
  final bool diceHit;             // 骰子是否命中
  final List<int> prizeValues;    // 5个对应奖励值

  SJfortuneRushResult({
    required this.numbers,
    required this.winNumber,
    required this.isWin,
    required this.winRow,
    required this.diceHit,
    required this.prizeValues,
  });

  Map<String, dynamic> toJson() => {
    "numbers": numbers,
    "winNumber": winNumber,
    "isWin": isWin,
    "winRow": winRow,
    "diceHit": diceHit,
    "prizeValues": prizeValues,
  };

  @override
  String toString() => toJson().toString();
}
class SJSweetTimeResult {
  final List<int> numbers;         // 9个格子数字
  final bool isWin;                // 是否中奖
  final int winningNumber;         // 中奖数字 (0/1/2)，不中奖返回 -2
  final int winningRow;            // 中奖行下标 0~2，不中奖返回 -1
  final List<int> winningRowIndexes; // 中奖行的三个格子下标
  final bool diceHit;              // 是否骰子
  final List<int> prizeValues;     // 每格奖励值
  final int multiplier;            // 奖励倍数

  SJSweetTimeResult({
    required this.numbers,
    required this.isWin,
    required this.winningNumber,
    required this.winningRow,
    required this.winningRowIndexes,
    required this.diceHit,
    required this.prizeValues,
    required this.multiplier,
  });

  Map<String, dynamic> toJson() => {
    "numbers": numbers,
    "isWin": isWin,
    "winningNumber": winningNumber,
    "winningRow": winningRow,
    "winningRowIndexes": winningRowIndexes,
    "diceHit": diceHit,
    "prizeValues": prizeValues,
    "multiplier": multiplier,
  };
  @override
  String toString() => toJson().toString();
}