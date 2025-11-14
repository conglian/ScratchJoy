import 'package:flutter_lifecycle_detector/flutter_lifecycle_detector.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:scratchjoy/SJTool/sj_LocalProvider.dart';
import 'package:scratchjoy/SJTool/sj_extension_help.dart';
import 'package:scratchjoy/SJTool/sj_fkmanger.dart';

import 'SJAdManager.dart';
import 'SJTBAInfoTool.dart';


class SJNoticeHelp {

  static final SJNoticeHelp _instance = SJNoticeHelp._internal();

  factory SJNoticeHelp() {
    return _instance;
  }

  SJNoticeHelp._internal();

  Future<void> initNotice() async {
    FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
    const AndroidInitializationSettings initializationSettingsAndroid =
    AndroidInitializationSettings('sj_logo'); // 不加 .png

    const InitializationSettings initializationSettings = InitializationSettings(
      android: initializationSettingsAndroid,
    );

    await flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: (response) {
        'nf click response:${response}'.log();
        final String? payload = response.payload;
        sj_event_fire('inform_c', {'type': payload ?? ''});
        if(payload == null)return;
      },
    );

    NotificationAppLaunchDetails? notificationAppLaunchDetails =
    await AndroidFlutterLocalNotificationsPlugin()
        .getNotificationAppLaunchDetails();
    '=initNotification====getNotificationAppLaunchDetails==notificationAppLaunchDetails:$notificationAppLaunchDetails='.log();

    if (notificationAppLaunchDetails != null) {
      NotificationResponse? notificationResponse =
          notificationAppLaunchDetails.notificationResponse;
      bool didNotificationLaunchApp =
          notificationAppLaunchDetails.didNotificationLaunchApp ?? false;
      if (didNotificationLaunchApp) {
        sj_event_fire('inform_c', {'type': notificationResponse?.payload ?? ''});
      }
    }

    var nfPermission = await flutterLocalNotificationsPlugin.resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()?.requestNotificationsPermission();
    if(nfPermission??false){
      sj_event_fire('push_status', {});
    }else{
      "nf no permission".log();
      // NavigationService().navigatorKey.currentContext?.tipShow(SJPopNoticeDialog());
    }
    "nf has permission".log();
    _initLifecycleListener();
    _repeatNotification1();
    _repeatNotification2();
    _repeatNotification3();
    _repeatNotification4();
    _subscribeFcmTopic();
    _subscribeFcmTopic2();
    _showUnlockNotification();
    _spinitNotificationCount();
  }

  _spinitNotificationCount() async {
    try {
      int locals = await AndroidFlutterLocalNotificationsPlugin()
          .extractMessageReceivedNum("fix");
      "==initNotificationCount==localcount:$locals==".log();
      if (locals > 0) {
        for (int i = 0; i < locals; i++) {
          sj_event_fire('inform_p', {'type' : "fix"});
        }
      }

      int fcms = await AndroidFlutterLocalNotificationsPlugin()
          .extractMessageReceivedNum("fcm");
      "==initNotificationCount==localcount:$fcms==".log();
      if (fcms > 0) {
        for (int i = 0; i < fcms; i++) {
          sj_event_fire('inform_p', {'type' : "fcm"});
        }
      }

      int unlocks = await AndroidFlutterLocalNotificationsPlugin()
          .extractMessageReceivedNum("unlock");
      "==initNotificationCount==localcount:$unlocks==".log();
      if (unlocks > 0) {
        for (int i = 0; i < unlocks; i++) {
          sj_event_fire('inform_p', {'type' : "unlock"});
        }
      }
    } catch (e) {
      "===initNotificationCount==error:$e=".log();
    }
  }

  Future<void> setNoticeStatus() async {

    FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
    var nfPermission = await flutterLocalNotificationsPlugin.resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()?.requestNotificationsPermission();
    if(nfPermission??false){
      sj_event_fire('push_status', {});
    }else{
      "nf no permission".log();
    }

  }

  Future<void> _repeatNotification1() async {
    //自定义通知ID
    final int id = 5220;
    final randomMotivation = StepMotivationManager.getRandomMotivation();
    final String title = randomMotivation.title;
    final String body = randomMotivation.body;
    AndroidNotificationDetails details = AndroidNotificationDetails(
      '130notice1',
      'Scractchjoy1',
      styleInformation: BeautyStyleInformation(
        title,
        body,
        'sj_notice_big',
        'Claim',
        'sj_logo',
      ),
      priority: Priority.high,
      importance: Importance.high,
      icon: 'sj_logo',
      //“groupKey”：防止通知被系统折叠
      groupKey: "$id",
    );
    await AndroidFlutterLocalNotificationsPlugin().periodicallyShowWithDuration(
        id,
        title,
        body,
        //间隔时长根据需求设置
        const Duration(minutes: 23),
        notificationDetails: details,
        scheduleMode: AndroidScheduleMode.inexactAllowWhileIdle,
        payload: "fix"
    );
  }

  Future<void> _repeatNotification2() async {
    //自定义通知ID
    final int id = 9562;
    final randomMotivation = StepMotivationManager.getRandomMotivation();
    final String title = randomMotivation.title;
    final String body = randomMotivation.body;
    AndroidNotificationDetails details = AndroidNotificationDetails(
      '130notice2',
      'Scractchjoy2',
      styleInformation: BeautyStyleInformation(
        title,
        body,
        'sj_notice_big',
        'Claim',
        'sj_logo',
      ),
      priority: Priority.high,
      importance: Importance.high,
      icon: 'sj_logo',
      //“groupKey”：防止通知被系统折叠
      groupKey: "$id",
    );
    await AndroidFlutterLocalNotificationsPlugin().periodicallyShowWithDuration(
        id,
        title,
        body,
        //间隔时长根据需求设置
        const Duration(minutes: 49),
        notificationDetails: details,
        scheduleMode: AndroidScheduleMode.inexactAllowWhileIdle,
        payload: "fix"
    );
  }

  Future<void> _repeatNotification3() async {
    //自定义通知ID
    final int id = 7552;
    final randomMotivation = StepMotivationManager.getRandomMotivation();
    final String title = randomMotivation.title;
    final String body = randomMotivation.body;
    AndroidNotificationDetails details = AndroidNotificationDetails(
      '130notice3',
      'Scractchjoy3',
      styleInformation: BeautyStyleInformation(
        title,
        body,
        'sj_notice_big',
        'Claim',
        'sj_logo',
      ),
      priority: Priority.high,
      importance: Importance.high,
      icon: 'sj_logo',
      //“groupKey”：防止通知被系统折叠
      groupKey: "$id",
    );
    await AndroidFlutterLocalNotificationsPlugin().periodicallyShowWithDuration(
        id,
        title,
        body,
        //间隔时长根据需求设置
        const Duration(minutes: 61),
        notificationDetails: details,
        scheduleMode: AndroidScheduleMode.inexactAllowWhileIdle,
        payload: "fix"
    );
  }

  Future<void> _repeatNotification4() async {
    //自定义通知ID
    final int id = 4175;
    final randomMotivation = StepMotivationManager.getRandomMotivation();
    final String title = randomMotivation.title;
    final String body = randomMotivation.body;
    AndroidNotificationDetails details = AndroidNotificationDetails(
      '130notice4',
      'Scractchjoy4',
      styleInformation: BeautyStyleInformation(
        title,
        body,
        'sj_notice_big',
        'Claim',
        'sj_logo',
      ),
      priority: Priority.high,
      importance: Importance.high,
      icon: 'sj_logo',
      //“groupKey”：防止通知被系统折叠
      groupKey: "$id",
    );
    await AndroidFlutterLocalNotificationsPlugin().periodicallyShowWithDuration(
        id,
        title,
        body,
        //间隔时长根据需求设置
        const Duration(minutes: 30),
        notificationDetails: details,
        scheduleMode: AndroidScheduleMode.inexactAllowWhileIdle,
        payload: "fix"
    );
  }

  Future<void> _subscribeFcmTopic() async {
    await AndroidFlutterLocalNotificationsPlugin().subscribeToTopic(
      'C130_us_data_fcm',
       AndroidNotificationDetails(
        '130_us_data_fcm',
        'ScractchJoy',
        styleInformation: BeautyStyleInformation(
          '',
          '',
          '',
          'Claim',
          'sj_logo',
        ),
        priority: Priority.high,
        importance: Importance.high,
      ),
    );
  }

  Future<void> _subscribeFcmTopic2() async {
    await AndroidFlutterLocalNotificationsPlugin().subscribeToTopic(
      'C130_us_normal_fcm',
      AndroidNotificationDetails(
        '130_us_normal_fcm',
        'ScractchJoy2',
        styleInformation: BeautyStyleInformation(
          '',
          '',
          '',
          'Claim',
          'sj_logo',
        ),
        priority: Priority.high,
        importance: Importance.high,
      ),
    );
  }

  Future<void> _showUnlockNotification() async {
    //自定义通知ID
    final int ids = 6829;
    final randomMotivation = StepMotivationManager.getRandomMotivation();
    StepMotivation randomMotivation2 = StepMotivationManager.getRandomMotivation();;
    await AndroidFlutterLocalNotificationsPlugin().showBroadcastNotification(
      ids,
      randomMotivation.title,
      randomMotivation.body,
      //两次发送解锁通知的间隔，根据需求设置
      const Duration(seconds: 30),
    'android.intent.action.USER_PRESENT',
       AndroidNotificationDetails(
        '130Scractchjoys',
        'Scractchjoys',
        priority: Priority.high,
        importance: Importance.high,
        icon: 'sj_logo',
        styleInformation: BeautyStyleInformation(
          randomMotivation2.title,
          randomMotivation2.body,
          'sj_notice_big',
          'Claim',
          'sj_logo',
        ),
        //“groupKey”：防止通知被系统折叠
        groupKey: "$ids",
      ),
      'unlock',
    );
  }


  Future<void> _initLifecycleListener() async {

    FlutterLifecycleDetector().onBackgroundChange.listen((isBackground) async {
      /// `isBackground` is true => background
      /// `isBackground` is false => foreground
      print('Status background $isBackground');
      if (isBackground == true) {
        print('App进入后台');
        SJFKManger().sj_add_tabsession_custom();
        // 执行后台逻辑
        sj_session_fire();
        sj_event_fire('session_back_get', {'"pak_version' : SJLocalProvider.instance.sj_login_status ? 1 : 0});
      } else {
        print('App进入前台');
        SJFKManger().sj_add_tabsession_custom();
        sj_event_fire('session_front_get', {'"pak_version' : SJLocalProvider.instance.sj_login_status ? 1 : 0});
        // 执行前台逻辑
        sj_session_fire();
        if (!SJAdManager().is_ad_play) {
          // SJAdManager().sj_showAd(true, 'kmrol_launch', NavigationService().bottomNavKey.currentContext!, (hasCache){
          //   if (!hasCache) {
          //
          //   }
          // }, (finished){
          //
          // });
        }
      }
    });
  }

}
/// 步行激励文案数据模型
class StepMotivation {
  final String title;
  final String body;

  StepMotivation({
    required this.title,
    required this.body,
  });
}

/// 步行激励文案工具类
class StepMotivationManager {
  // 文案数据列表
  static final List<StepMotivation> _motivations = [
    StepMotivation(
      title: "Last Chance! \$800 Vanish in 60 Mins!",
      body: 'Your cash bonus disappears at midnight! Tap NOW to rescue it!',
    ),
    StepMotivation(
      title: "Swipe to Unlock \$800!",
      body: "Your magic move: Slide right → Claim cash instantly!",
    ),
    StepMotivation(
      title: "1 More Step = \$800 Cash!",
      body: "Complete ANY task now - Boom! Money lands in wallet.",
    ),
    StepMotivation(
      title: "Beat the Clock: 90s= \$800!",
      body: "Tap faster → Higher cash! The timer starts NOW!",
    ),
    StepMotivation(
      title: "Your Exclusive Cash Drop! 🔐",
      body: "This \$800 offer disappears in 2 hrs. Yours only.",
    ),
    StepMotivation(
      title: "Congrats! You've Earned a lot! 🎉",
      body: "Another \$ 500 cash in your pocket! Keep playing for more!",
    ),
    StepMotivation(
      title: "Feeling Lucky Today? 🍀",
      body: "Come and try your luck, win a fortune!",
    ),
    StepMotivation(
      title: "Pending withdraw amount💰",
      body: "\$500 has arrived in your account",
    ),
    StepMotivation(
      title: "Your Next Cash Reward is Ready! 👉",
      body: "Just a few more games to claim your \$800 cash!",
    ),
    StepMotivation(
      title: "\$1,000,000 Spectacular",
      body: "🎰 Congrats! Your \$1,000,000 Spectacular ticket is activated!",
    ),
    StepMotivation(
      title: "💥Fast \$50s – Speed Boost Activated!",
      body: "💸 Your Fast \$50s ticket is ready!",
    ),
    StepMotivation(
      title: "💰Multiplier Rewards Available!",
      body: "24-hour special: Next multiplier DOUBLED!",
    ),
  ];

  /// 随机获取一条激励文案
  static StepMotivation getRandomMotivation() {
    final random = DateTime.now().microsecond % _motivations.length;
    return _motivations[random];
  }

}