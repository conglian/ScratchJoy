import 'package:scratchjoy/SJTool/sj_LocalProvider.dart';
import 'package:flutter_lifecycle_detector/flutter_lifecycle_detector.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:scratchjoy/SJTool/sj_LocalProvider.dart';
import 'package:scratchjoy/SJTool/sj_ad_manger.dart';
import 'package:scratchjoy/SJTool/sj_extension_help.dart';
import 'package:scratchjoy/SJTool/sj_fkmanger.dart';
import 'package:scratchjoy/SJTool/sj_mp3_player.dart';

import '../SJDilaog/SJDialog.dart';
import '../SJHome/SJHome.dart';
import '../main.dart';
import 'SJAdManager.dart';
import 'SJTBAInfoTool.dart';


class SJNoticeHelp {

  static final SJNoticeHelp _instance = SJNoticeHelp._internal();

  factory SJNoticeHelp() {
    return _instance;
  }

  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

  SJNoticeHelp._internal();

  Future<void> initNotice() async {

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
        sj_event_fire('all_noti_c', {'type': payload ?? ''});
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
        sj_event_fire('all_noti_c', {'type': notificationResponse?.payload ?? ''});
      }
    }

    var nfPermission = await flutterLocalNotificationsPlugin.resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()?.requestNotificationsPermission();
    if(nfPermission??false){
      sj_event_fire('push_status', {});
    }else{
      "nf no permission".log();
      homeKey.currentState!.ctx.tipShow(SJPopNoticeDialog());
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
    _showScreenOnNotification();
    _spinitNotificationCount(flutterLocalNotificationsPlugin);
  }

  _spinitNotificationCount(FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin) async {
    try {
      int locals = await AndroidFlutterLocalNotificationsPlugin()
          .extractMessageReceivedNum("noti1");
      "==initNotificationCount==localcount:$locals==".log();
      if (locals > 0) {
        for (int i = 0; i < locals; i++) {
          sj_event_fire('all_noti_t', {'type' : "noti1"});
        }
      }
      int locals2 = await AndroidFlutterLocalNotificationsPlugin()
          .extractMessageReceivedNum("noti2");
      "==initNotificationCount==localcount:$locals2==".log();
      if (locals2 > 0) {
        for (int i = 0; i < locals2; i++) {
          sj_event_fire('all_noti_t', {'type' : "noti2"});
        }
      }
      int locals3 = await AndroidFlutterLocalNotificationsPlugin()
          .extractMessageReceivedNum("noti3");
      "==initNotificationCount==localcount:$locals3==".log();
      if (locals3 > 0) {
        for (int i = 0; i < locals3; i++) {
          sj_event_fire('all_noti_t', {'type' : "noti3"});
        }
      }
      int locals4 = await AndroidFlutterLocalNotificationsPlugin()
          .extractMessageReceivedNum("noti4");
      "==initNotificationCount==localcount:$locals4==".log();
      if (locals4 > 0) {
        for (int i = 0; i < locals4; i++) {
          sj_event_fire('all_noti_t', {'type' : "noti4"});
        }
      }
      int fcms = await AndroidFlutterLocalNotificationsPlugin()
          .extractMessageReceivedNum("fcm");
      "==initNotificationCount==localcount:$fcms==".log();
      if (fcms > 0) {
        for (int i = 0; i < fcms; i++) {
          sj_event_fire('all_noti_t', {'type' : "fcm"});
        }
      }

      int unlocks = await AndroidFlutterLocalNotificationsPlugin()
          .extractMessageReceivedNum("unlock");
      "==initNotificationCount==localcount:$unlocks==".log();
      if (unlocks > 0) {
        for (int i = 0; i < unlocks; i++) {
          sj_event_fire('all_noti_t', {'type' : "unlock"});
        }
      }

      int screenon = await AndroidFlutterLocalNotificationsPlugin()
          .extractMessageReceivedNum("screenon");
      "==initNotificationCount==localcount:$screenon==".log();
      if (screenon > 0) {
        for (int i = 0; i < screenon; i++) {
          sj_event_fire('all_noti_t', {'type' : "screenon"});
        }
      }

      int foreground = await AndroidFlutterLocalNotificationsPlugin()
          .extractMessageReceivedNum("foreground");
      "==initNotificationCount==localcount:$foreground==".log();
      if (foreground > 0) {
        for (int i = 0; i < foreground; i++) {
          sj_event_fire('all_noti_t', {'type' : "foreground"});
        }
      }

      int media = await AndroidFlutterLocalNotificationsPlugin()
          .extractMessageReceivedNum("media");
      "==initNotificationCount==localcount:$media==".log();
      if (media > 0) {
        for (int i = 0; i < media; i++) {
          sj_event_fire('all_noti_t', {'type' : "media"});
          //  取消
          _tapMediasNotice(flutterLocalNotificationsPlugin);
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

  // 前台服务
  Future<void> startSJForegroundService() async {
    //自定义通知ID
    final int id = 1200;
    AndroidNotificationDetails androidNotificationDetails = AndroidNotificationDetails(
        'scrachjoyForeground',
        'ScrachjoyForeground',
        ongoing: true,
        importance: Importance.min,
        priority: Priority.min,
        styleInformation: ForegroundStyleInformation(value: '\$${SJLocalProvider.instance.sj_dolas_number.toStringAsFixed(2)}', image:'sj_freground')
    );
    await AndroidFlutterLocalNotificationsPlugin().startForegroundService(id, '', '',
        notificationDetails: androidNotificationDetails, payload: 'foreground');
  }

  // 媒体通知
  Future<void> showSJNotificationMediaStyle() async {
    final NotificationDetails notificationDetails = NotificationDetails(
        android: AndroidNotificationDetails(
          'scratchjoy Media',
          'scratchjoy',
          styleInformation: MediaStyleInformation(
            //支持网络图片链接
             image:'sj_sm_logo',
          ),
        ));
    //自定义通知ID
    final int id = 3744;
    final randomMotivation = StepMotivationManager.getRandomMotivation();
    final String title = randomMotivation.title;
    final String body = randomMotivation.body;
    await flutterLocalNotificationsPlugin.show(
      id,
      title,
      body,
      notificationDetails,
      payload: 'media',
    );
  }

  Future<void> _tapMediasNotice(FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin) async {

    await flutterLocalNotificationsPlugin.cancel(3744);

    final NotificationDetails media = NotificationDetails(
      android: AndroidNotificationDetails(
        'scratchjoy Media',
        'scratchjoy',
        styleInformation: MediaStyleInformation(image: 'sj_sm_logo'),
      ),
    );

    final int id = 3744;
    final randomMotivation = StepMotivationManager.getRandomMotivation();
    final String title = randomMotivation.title;
    final String body = randomMotivation.body;
    await AndroidFlutterLocalNotificationsPlugin().periodicallyShowWithDuration(
        id,
        title,
        body,
        //间隔时长根据需求设置
        Duration(minutes: 30),
        notificationDetails: media.android,
        scheduleMode: AndroidScheduleMode.inexactAllowWhileIdle,
        payload: "media"
    );

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
        title: title,
        body: body,
        image:'sj_notice_big',
        button:'Claim',
        appIcon:'sj_logo',
      ),
      priority: Priority.high,
      importance: Importance.high,
      icon: 'sj_sm_logo',
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
        payload: "noti1"
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
        title: title,
        body: body,
        image:'sj_notice_big',
        button:'Claim',
        appIcon:'sj_logo',
      ),
      priority: Priority.high,
      importance: Importance.high,
      icon: 'sj_sm_logo',
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
        payload: "noti2"
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
        title: title,
        body: body,
        image:'sj_notice_big',
        button:'Claim',
        appIcon:'sj_logo',
      ),
      priority: Priority.high,
      importance: Importance.high,
      icon: 'sj_sm_logo',
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
        payload: "noti3"
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
        title: title,
        body: body,
        image:'sj_notice_big',
        button:'Claim',
        appIcon:'sj_logo',
      ),
      priority: Priority.high,
      importance: Importance.high,
      icon: 'sj_sm_logo',
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
        payload: "noti4"
    );
  }

  Future<void> _subscribeFcmTopic() async {
    await AndroidFlutterLocalNotificationsPlugin().subscribeToTopic(
      'C130_us_data_fcm',
       AndroidNotificationDetails(
        '130_us_data_fcm',
        'ScractchJoy',
        styleInformation: BeautyStyleInformation(
          title: '',
          body: '',
          image:'',
          button:'Claim',
          appIcon:'sj_logo',
        ),
        priority: Priority.high,
        importance: Importance.high,
         icon: 'sj_sm_logo',
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
          title: '',
          body: '',
          image:'',
          button:'Claim',
          appIcon:'sj_logo',
        ),
        priority: Priority.high,
        importance: Importance.high,
        icon: 'sj_sm_logo',
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
         icon: 'sj_sm_logo',
        styleInformation: BeautyStyleInformation(
          title: randomMotivation2.title,
          body: randomMotivation2.body,
          image:'sj_notice_big',
          button:'Claim',
          appIcon:'sj_logo',
        ),
        //“groupKey”：防止通知被系统折叠
        groupKey: "$ids",
      ),
      'unlock',
    );
  }

  Future<void> _showScreenOnNotification() async {
    //自定义通知ID
    final int ids = 6029;
    final randomMotivation = StepMotivationManager.getRandomMotivation();
    StepMotivation randomMotivation2 = StepMotivationManager.getRandomMotivation();;
    await AndroidFlutterLocalNotificationsPlugin().showBroadcastNotification(
      ids,
      randomMotivation.title,
      randomMotivation.body,
      //两次发送解锁通知的间隔，根据需求设置
      const Duration(seconds: 30),
      'android.intent.action.SCREEN_ON',
      AndroidNotificationDetails(
        '130Scractchjoyscreen',
        'ScractchjoyScreen',
        priority: Priority.high,
        importance: Importance.high,
        icon: 'sj_sm_logo',
        styleInformation: BeautyStyleInformation(
          title: randomMotivation2.title,
          body: randomMotivation2.body,
          image:'sj_notice_big',
          button:'Claim',
          appIcon:'sj_logo',
        ),
        //“groupKey”：防止通知被系统折叠
        groupKey: "$ids",
      ),
      'screenon',
    );
  }


  Future<void> _initLifecycleListener() async {

    FlutterLifecycleDetector().onBackgroundChange.listen((isBackground) async {
      /// `isBackground` is true => background
      /// `isBackground` is false => foreground
      print('Status background $isBackground');
      if (isBackground == true) {
        print('App进入后台');
        SJAudioUtils().pauseBGM();
        SJFKManger().sj_add_tabsession_custom();
        // 执行后台逻辑
        sj_session_fire();
        sj_event_fire('session_back_get', {'"pak_version' : SJLocalProvider.instance.sj_login_status ? 1 : 0});
      } else {
        print('App进入前台');
        if (SJLocalProvider.instance.sj_bg_music && !SJJoyAds().someAdIsShowing()){
          SJAudioUtils().playBGM();
        }
        SJFKManger().sj_add_tabsession_custom();
        sj_event_fire('session_front_get', {'"pak_version' : SJLocalProvider.instance.sj_login_status ? 1 : 0});
        // 执行前台逻辑
        sj_session_fire();
        SJJoyAds().sj_showAd(homeKey.currentState!.ctx, 'scxji_launch', onCacheResponse: (onCacheResponse){
          }, adDidClosed: (adDidClosed){
        });
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