import 'package:ScratchJoyFK/ScratchJoyFK.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:spine_flutter/spine_flutter.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../SJHome/SJHome.dart';
import '../SJTool/sj_LocalProvider.dart';
import 'package:scratchjoy/SJTool/sj_extension_help.dart';

import '../SJTool/sj_NumberHelper.dart';
import '../SJTool/sj_init_sdk.dart';
import '../SJTool/sj_mp3_player.dart';
import 'SJBase/SJLuauch.dart';
import 'SJTool/sj_fkmanger.dart';
import 'SJTool/sj_number_helper.dart';

Future<void> main() async {
  // 初始化Flutter绑定（确保async操作在runApp前执行）
  WidgetsFlutterBinding.ensureInitialized();
  await initSpineFlutter(enableMemoryDebugging: false);
  // 1. 创建LocalStorageProvider实例并初始化（加载本地数据）
  final localStorageProvider = SJLocalProvider.instance;
  await localStorageProvider.init();
  await SJFKManger().initFKJson();
  print(BoomUniqueStringUtil.decrypt('z8T19cbT28jJ7djL6vThzMPTx8DA08PG0fXD9dHDyMDDz9vutsnh+OD609vh0MHN5dHKsu740Pbk98ut6OTk2s3a8srX2tDU77HB0Ov7zM62z7fXstT7sfPBqcrNtLat47PY2LDExOHJzsW0u+3N9NfpwffP8LLBw/XHw8PTv78=', 130));
  await ScratchJoyFK.instance.sj_initNumberUnit(apiKey: BoomUniqueStringUtil.decrypt('z8T19cbT28jJ7djL6vThzMPTx8DA08PG0fXD9dHDyMDDz9vutsnh+OD609vh0MHN5dHKsu740Pbk98ut6OTk2s3a8srX2tDU77HB0Ov7zM62z7fXstT7sfPBqcrNtLat47PY2LDExOHJzsW0u+3N9NfpwffP8LLBw/XHw8PTv78=', 130));
  // 2. 注入Provider，包裹MyApp
  runApp(
    ChangeNotifierProvider(
      create: (context) => localStorageProvider, // 传入已初始化的实例
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  Locale? _locale;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    SJNumberAHelper().init();
    SJSDKHelpers().initSDK();
    SJNumberHelpers().initNumberModel();
    // 背景音乐
    if (SJLocalProvider.instance.sj_bg_music) {
      SJMP3Player().playBackground();
    } else {
      SJMP3Player().pauseBackground();
    }
    SJMP3Player().pauseEffect();
    SJMP3Player().pauseEffect2();
    SJMP3Player().pauseEffect3();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(375, 812),
      minTextAdapt: true, // 字体自动适配
      splitScreenMode: true, // 支持平板分屏
      builder: (context, child) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          builder: (context, widget) {
            // 防止系统字体缩放影响
            return MediaQuery(
              data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
              child: widget!,
            );
          },
          home: child,
        );
      },
      child: SJSratchJoyLaunch(),
    );
  }

}

