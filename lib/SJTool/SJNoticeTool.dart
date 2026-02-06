import 'dart:math';
import 'package:flutter/services.dart';
import 'package:scratchjoy/SJHome/SJHome.dart';
import 'package:scratchjoy/SJTool/sj_ad_manger.dart';
import 'package:scratchjoy/SJTool/sj_extension_help.dart';
import 'SJTBAInfoTool.dart';

class SJLocatilNoticeHelper {
  static final SJLocatilNoticeHelper _instance = SJLocatilNoticeHelper._internal();
  static const MethodChannel _nativeHelper = MethodChannel('Scratch_joy_channel');
  final _eventChannel = const EventChannel('SJ_notificationClicker');
  static int notificationTime1 = 1380;
  static int notificationTime2 = 3540;
  static int notificationTime3 = 5820;
  static int notificationTime4 = 8220;
  static int notificationTime5 = 10380;

  factory SJLocatilNoticeHelper() {
    return _instance;
  }

  SJLocatilNoticeHelper._internal();

  void initSJNotifications() async {
    bool r =
    await _nativeHelper.invokeMethod("requestNotificationAuthoiration");
    if (r == true) {
      sj_event_fire("push_status", {"status": "open"});
      _createOneNotification();
      _createTwoNotification();
      _createThreeNotification();
      _createFourNotification();
      _createFiveNotification();
    } else {
      sj_event_fire("push_status", {"status": "reject"});
    }
    _initLife();
  }

  _initLife() {

    "message from native inited".log();
    _eventChannel.receiveBroadcastStream().listen((value) async {
      "message from native ${value}".log();
      if (value == "session") {
        sj_session_fire();
      }
      if (value == "background") {
        sj_session_fire();
      }
      if (value == "showOpenAd") {
        if (await _nativeHelper.invokeMethod("isAdControllerPresented") ==
            false) {
          SJJoyAds().sj_showAd(homeKey.currentState!.ctx, 'scxji_launch', onCacheResponse: (onCacheResponse){

          }, adDidClosed: (adDidClosed){

          });
        }
      }

      final lists = value.toString().split(",");
      if (lists.length == 2) {
        "flutter receive native notification ${lists}".log();
        if (lists[0] == "background") {
          if (lists[1] == "notificationIdentiferOne") {
            sj_event_fire("inform_c", {'inform_from': 'fix'});
          } else if (lists[1] == "notificationIdentiferTwo") {
            sj_event_fire("inform_c", {'inform_from': 'sign'});
          } else if (lists[1] == "notificationIdentiferThree") {
            sj_event_fire("inform_c", {'inform_from': 'card'});
          } else if (lists[1] == "notificationIdentiferFour") {
            sj_event_fire("inform_c", {'inform_from': 'cash'});
          }
        } else if (lists[0] == "active") {
          if (lists[1] == "notificationIdentiferOne") {
            sj_event_fire("inform_c", {'inform_from': 'fix'});
          } else if (lists[1] == "notificationIdentiferTwo") {
            sj_event_fire("inform_c", {'inform_from': 'sign'});
          } else if (lists[1] == "notificationIdentiferThree") {
            sj_event_fire("inform_c", {'inform_from': 'card'});
          } else if (lists[1] == "notificationIdentiferFour") {
            sj_event_fire("inform_c", {'inform_from': 'cash'});
          }
        }
      }
    });
  }

  void _createOneNotification() async {
    sj_event_fire('push_received', {'push_type' : 'time'});
    List<String> contents = [
      "Your reward is just one swipe away",
      "Your scratch triggered extra cash",
      "Your activity unlocked a bonus",
    ];
    List<String> titles = [
      "Daily Scratch Opened💰",
      "Lucky Bonus \$120💵",
      "Surprise \$100 Cash",
    ];
    final random = Random();
    final index = random.nextInt(contents.length);
    await _nativeHelper.invokeMethod(
      "createNotification",
      {
        "notificationHeader": titles[index],
        "notificationContent": contents[index],
        "notificationSeconds": notificationTime1,
        "notificationId": "notificationIdentiferOne",
      },
    );
  }


  void _createTwoNotification() async {
    sj_event_fire('push_received', {'push_type' : 'time'});
    List<String> contents = [
      "Your biggest payout is near",
      "More tasks mean more money today",
      "\$800 is hidden inside, scratch it now!",
    ];
    List<String> titles = [
      "Close to \$800 Cash Out",
      "New Task Unlocked",
      "Free Scratch Card",
    ];

    final random = Random();
    final index = random.nextInt(contents.length);
    await _nativeHelper.invokeMethod(
      "createNotification",
      {
        "notificationHeader": titles[index],
        "notificationContent": contents[index],
        "notificationSeconds": notificationTime2,
        "notificationId": "notificationIdentiferTwo",
      },
    );
  }

  void _createThreeNotification() async {
    sj_event_fire('push_received', {'push_type' : 'time'});
    List<String> contents = [
      "Tap faster → Higher cash! The timer starts NOW!",
      "Scratch now and finish unlocking it",
      "This surprise reward is waiting for you",
    ];
    List<String> titles = [
      "Beat the Clock: 90s= \$800!",
      "You’re Near \$800 Cashout",
      "\$300 Surprise Drop",
    ];

    final random = Random();
    final index = random.nextInt(contents.length);
    await _nativeHelper.invokeMethod(
      "createNotification",
      {
        "notificationHeader": titles[index],
        "notificationContent":
        contents[index],
        "notificationSeconds": notificationTime3,
        "notificationId": "notificationIdentiferThree",
      },
    );
  }

  void _createFourNotification() async {
    sj_event_fire('push_received', {'push_type' : 'time'});
    List<String> contents = [
      "Your cash bonus disappears at midnight! Tap NOW to rescue it!",
      "Scratch and secure your earnings",
      "A bonus just landed—scratch to claim it",
    ];
    List<String> titles = [
      "Last Chance! \$800 Vanish in 60 Mins!",
      "Close to \$800 Payout",
      "Surprise \$260 Reward",
    ];

    final random = Random();
    final index = random.nextInt(contents.length);
    await _nativeHelper.invokeMethod(
      "createNotification",

      {
        "notificationHeader": titles[index],
        "notificationContent":
        contents[index],
        "notificationSeconds": notificationTime4,
        "notificationId": "notificationIdentiferFour",
      },
    );
  }

  void _createFiveNotification() async {
    sj_event_fire('push_received', {'push_type' : 'time'});
    List<String> contents = [
      "A surprise reward was added today",
      "\$500 has arrived in your account",
      "Scratch it and see the result",
    ];
    List<String> titles = [
      "You Got \$240 Extra",
      "Pending withdraw amount💰",
      "A Fresh Card Appeared 👉",
    ];

    final random = Random();
    final index = random.nextInt(contents.length);
    await _nativeHelper.invokeMethod(
      "createNotification",
      {
        "notificationHeader": titles[index],
        "notificationContent":
        contents[index],
        "notificationSeconds": notificationTime5,
        "notificationId": "notificationIdentiferFive",
      },
    );
  }

}