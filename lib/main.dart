import 'dart:ui';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
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
import 'SJTool/sj_ad_help.dart';
import 'SJTool/sj_numberBHelper.dart';
import 'SJTool/sj_number_helper.dart';

final trigger = SJThresholdTrigger();


Future<void> main() async {
  // 初始化Flutter绑定（确保async操作在runApp前执行）
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  FirebaseCrashlytics.instance.setCrashlyticsCollectionEnabled(true);
  // 捕获 Flutter 框架错误
  FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterFatalError;
// 捕获 async / isolate 全局错误
  PlatformDispatcher.instance.onError = (error, stack) {
    bool isFatal = false;
    // 严重错误：fatal
    if (error is OutOfMemoryError ||
        error is StackOverflowError ||
        error is FlutterError ||
        error is AssertionError) {
      isFatal = true;
    }
    // 上报到 Crashlytics
    FirebaseCrashlytics.instance.recordError(error, stack, fatal: isFatal);
    return true;
  };
  await initSpineFlutter(enableMemoryDebugging: false);
  // 1. 创建LocalStorageProvider实例并初始化（加载本地数据）
  final localStorageProvider = SJLocalProvider.instance;
  await localStorageProvider.init();
  await trigger.init();

  // 2. 注入Provider，包裹MyApp
  runApp(
    ChangeNotifierProvider(
      create: (context) => localStorageProvider, // 传入已初始化的实例
      child: const MyApp(),
    ),
  );
}

final RouteObserver<PageRoute> routeObserver =
RouteObserver<PageRoute>();

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
    SJNumberBHelper().init();
    SJNumberHelpers().initNumberModel();
    SJAudioUtils().initTempQueue();
    // 背景音乐
    if (SJLocalProvider.instance.sj_bg_music) {
      SJAudioUtils().playBGM();
    } else {
      SJAudioUtils().pauseBGM();
    }
    SJAudioUtils().stopAllTempAudio();
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
          navigatorObservers: [routeObserver],
          theme: ThemeData(
          splashColor: Colors.transparent,
          highlightColor: Colors.transparent,
          hoverColor: Colors.transparent,
          focusColor: Colors.transparent,
          splashFactory: NoSplash.splashFactory, // 彻底取消水波纹
          ),
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