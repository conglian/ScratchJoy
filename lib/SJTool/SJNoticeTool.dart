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
      // NavigationService().navigatorKey.currentContext?.tipShow(SPPopNoticeStatusWidget());
    }
    "nf has permission".log();
    _initLifecycleListener();
    _repeatNotification1();
    _repeatNotification2();
    _repeatNotification3();
    _repeatNotification4();
    _subscribeFcmTopic();
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
    final int id = 1542;
    final randomMotivation = StepMotivationManager.getRandomMotivation();
    final String title = randomMotivation.title;
    final String body = randomMotivation.body;
    AndroidNotificationDetails details = AndroidNotificationDetails(
      '122notice',
      'ScractchPlayLand',
      styleInformation: BeautyStyleInformation(
        title,
        body,
        'sj_notice_big',
        'Go Earn',
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

  Future<void> _repeatNotification2() async {
    //自定义通知ID
    final int id = 1562;
    final randomMotivation = StepMotivationManager.getRandomMotivation();
    final String title = randomMotivation.title;
    final String body = randomMotivation.body;
    AndroidNotificationDetails details = AndroidNotificationDetails(
      '122notice2',
      'ScractchPlayLand2',
      styleInformation: BeautyStyleInformation(
        title,
        body,
        'sj_notice_big',
        'Go Earn',
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
        const Duration(minutes: 60),
        notificationDetails: details,
        scheduleMode: AndroidScheduleMode.inexactAllowWhileIdle,
        payload: "fix"
    );
  }

  Future<void> _repeatNotification3() async {
    //自定义通知ID
    final int id = 1552;
    final randomMotivation = StepMotivationManager.getRandomMotivation();
    final String title = randomMotivation.title;
    final String body = randomMotivation.body;
    AndroidNotificationDetails details = AndroidNotificationDetails(
      '122notice3',
      'ScractchPlayLand3',
      styleInformation: BeautyStyleInformation(
        title,
        body,
        'sj_notice_big',
        'Go Earn',
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
        const Duration(minutes: 90),
        notificationDetails: details,
        scheduleMode: AndroidScheduleMode.inexactAllowWhileIdle,
        payload: "fix"
    );
  }

  Future<void> _repeatNotification4() async {
    //自定义通知ID
    final int id = 175;
    final randomMotivation = StepMotivationManager.getRandomMotivation();
    final String title = randomMotivation.title;
    final String body = randomMotivation.body;
    AndroidNotificationDetails details = AndroidNotificationDetails(
      '122notice4',
      'ScractchPlayLand4',
      styleInformation: BeautyStyleInformation(
        title,
        body,
        'sj_notice_big',
        'Go Earn',
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
        const Duration(minutes: 120),
        notificationDetails: details,
        scheduleMode: AndroidScheduleMode.inexactAllowWhileIdle,
        payload: "fix"
    );
  }

  Future<void> _subscribeFcmTopic() async {
    await AndroidFlutterLocalNotificationsPlugin().subscribeToTopic(
      'c122fcm_card',
       AndroidNotificationDetails(
        'fcm_step122',
        'ScractchPlayLand',
        styleInformation: BeautyStyleInformation(
          '',
          '',
          '',
          'Go Earn',
          'sj_logo',
        ),
        priority: Priority.high,
        importance: Importance.high,
      ),
    );
  }

  Future<void> _showUnlockNotification() async {
    //自定义通知ID
    final int ids = 2689;
    final randomMotivation = StepMotivationManager.getRandomMotivation();
    StepMotivation randomMotivation2 = StepMotivationManager.getRandomMotivation();;
    await AndroidFlutterLocalNotificationsPlugin().showBroadcastNotification(
      ids,
      randomMotivation.title,
      randomMotivation.body,
      //两次发送解锁通知的间隔，根据需求设置
      const Duration(seconds: 15),
    'android.intent.action.USER_PRESENT',
       AndroidNotificationDetails(
        '114ScractchPlayLand',
        'ScractchPlayLand',
        priority: Priority.high,
        importance: Importance.high,
        icon: 'sj_logo',
        styleInformation: BeautyStyleInformation(
          randomMotivation2.title,
          randomMotivation2.body,
          'sj_notice_big',
          'Go Earn',
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
      title: "💵Scratch & Cash Out Now!♂️",
      body: 'Your scratch card revealed \$72.50. Tap to withdraw now!',
    ),
    StepMotivation(
      title: "Real payout unlocked 💵",
      body: "You’re just one scratch away from your next cashout. Don’t miss your chance to win BIG!",
    ),
    StepMotivation(
      title: "⏰ Limited Scratch – Real Cash Inside!",
      body: "Hurry! Special scratch cards with instant cash prizes are available for a limited time.",
    ),
    StepMotivation(
      title: "Daily Cash Scratch is live!",
      body: "Scratch today’s card and win real rewards instantly.",
    ),
    StepMotivation(
      title: "It’s cash o’clock!",
      body: "Today’s scratch bonus is waiting for you—don’t miss it!",
    ),
    StepMotivation(
      title: "🎉 Your Cash Card Is Unlocked!",
      body: "Scratch the special card now and reveal your surprise payout. Real cash is waiting inside!",
    ),
  ];

  /// 随机获取一条激励文案
  static StepMotivation getRandomMotivation() {
    final random = DateTime.now().microsecond % _motivations.length;
    return _motivations[random];
  }

}