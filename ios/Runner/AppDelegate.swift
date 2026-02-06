import Flutter
import UIKit
import AdSupport
import AppTrackingTransparency

@main
@objc class AppDelegate: FlutterAppDelegate {
  private let scratchJoy_Plugin = ScratchJoyPlugin()
  private var enterDate : Date?
  private var idfaStr : String = ""
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
      if let controller = window?.rootViewController as? FlutterViewController,
         let register = self.registrar(forPlugin: "ScratchJoyPlugin"){
          ScratchJoyPlugin.register(with: register)
          scratchJoy_Plugin.addNotificationListener(with: controller)
      }
    sj_addNotifcationsDelegate()
    GeneratedPluginRegistrant.register(with: self)
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
    
    private func sj_addNotifcationsDelegate() {
       UNUserNotificationCenter.current().delegate = self
    }
}
extension AppDelegate {
    override func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        guard let trigger = notification.request.trigger else { return; }
        if trigger.isKind(of: UNTimeIntervalNotificationTrigger.classForCoder()) {
            NSLog("ScratchJoy UNTimeIntervalNotificationTrigger Notification Receive From Active!!!")
        } else if trigger.isKind(of: UNCalendarNotificationTrigger.classForCoder()) {
            NSLog("ScratchJoy UNCalendarNotificationTrigger Notification Receive From Active!!!")
        }
        if (scratchJoy_Plugin.scratchJoyEventSink == nil) {
            NSLog("ScratchJoy Error - EventSink is nil - Active !!")
        }
        let notificationId = notification.request.identifier
        scratchJoy_Plugin.scratchJoyEventSink?("active," + notificationId)
    }

    override func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        guard let trigger = response.notification.request.trigger else { return; }
        if trigger.isKind(of: UNTimeIntervalNotificationTrigger.classForCoder()) {
            NSLog("ScratchJoy UNTimeIntervalNotificationTrigger Notification Receive From Background!!!")
        } else if trigger.isKind(of: UNCalendarNotificationTrigger.classForCoder()) {
            NSLog("ScratchJoy UNCalendarNotificationTrigger Notification Receive From Background!!!")
        }

        if (scratchJoy_Plugin.scratchJoyEventSink == nil) {
            NSLog("ScratchJoy Error - EventSink is nil - Background !!")
        }
        scratchJoy_Plugin.scratchJoyEventSink?("background," + response.notification.request.identifier)
    }


    override func applicationDidBecomeActive(_ application: UIApplication) {
        if let date = enterDate {

            if isDifferenceGreaterThanOrEqualThreeSeconds(date1: date, date2: Date()) {
                enterDate = nil
                scratchJoy_Plugin.scratchJoyEventSink?("showOpenAd")
            }
        }
        scratchJoy_Plugin.scratchJoyEventSink?("session")
        if #available(iOS 14, *) {
            ATTrackingManager.requestTrackingAuthorization(completionHandler: { status in
                print("idfa \(ASIdentifierManager.shared().advertisingIdentifier)");
                self.idfaStr = "\(ASIdentifierManager.shared().advertisingIdentifier)";
            })
        } else {
            // Fallback on earlier versions
        }
    }


    override func applicationDidEnterBackground(_ application: UIApplication) {
        enterDate = Date();
        scratchJoy_Plugin.scratchJoyEventSink?("background")
    }

    func isDifferenceGreaterThanOrEqualThreeSeconds(date1: Date, date2: Date) -> Bool {
        let calendar = Calendar.current

        let components = calendar.dateComponents([.second], from: date1, to: date2)

        if let seconds = components.second {
            return seconds >= 3
        } else {
            return false
        }
    }
}
