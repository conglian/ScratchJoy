import Foundation
import StoreKit
import Flutter
import UIKit
import CoreTelephony

public class ScratchJoyPlugin: NSObject, FlutterPlugin,FlutterStreamHandler {

     private var scratchJoyEventChannel: FlutterEventChannel?

     public var scratchJoyEventSink: FlutterEventSink?

    public static func register(with registrar: FlutterPluginRegistrar) {
        let channel = FlutterMethodChannel(name: "Scratch_joy_channel", binaryMessenger: registrar.messenger())
        let instance = ScratchJoyPlugin()
        registrar.addMethodCallDelegate(instance, channel: channel)
    }
    
    public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        switch call.method {
        case "requestNotificationAuthoiration":
            ScratchJoyTool.requestNotificationAuthoiration { authoiration in
                let authored = authoiration
                if authored {
                    result(true)
                } else {
                    result(false)
                }
            }
        case "resetRedNumber":
            ScratchJoyTool.resetRedNumber()
        case "isAdControllerPresented":
            var presented = false
            let adsControllers = ["ALAppLovinVideoViewController"]
            if let keyWindow = UIApplication.shared.windows.first(where: { $0.isKeyWindow }) {
                if let presentedController = keyWindow.rootViewController?.presentedViewController {
                    let presentedName = String(describing: type(of: presentedController))
                    if adsControllers.contains(presentedName) {
                        presented = true
                    }
                }
            }
            result(presented)
        case "showAppReview":
            DispatchQueue.main.async {
                SKStoreReviewController.requestReview()
            }
            result(true)
        case "createNotification":
            if let body = call.arguments as? [String:Any] {
                ScratchJoyTool.requestNotificationAuthoiration { authoiration in
                    if authoiration {

                        let notificationHeader = body["notificationHeader"] as? String ?? "ScratchJoy Notification"
                        let notificationContent = body["notificationContent"] as? String ?? "ScratchJoy Notification"
                        let notificationSeconds = body["notificationSeconds"] ?? 3000
                        let notificationId = body["notificationId"] as? String ?? "ScratchJoyNotificationId"
                                                
                        let requestContent = UNMutableNotificationContent()
                        requestContent.title = notificationHeader
                        requestContent.body = notificationContent
                        requestContent.badge = 1
                        
                        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: notificationSeconds as! TimeInterval, repeats: true)
                        let request = UNNotificationRequest(identifier: notificationId, content: requestContent, trigger: trigger)
                        
                        UNUserNotificationCenter.current().add(request) { err in
                            print("new notification created - \(err?.localizedDescription) \(notificationHeader) \(notificationContent) \(trigger.timeInterval) \(notificationId)")
                            err != nil ? result(false) : result(true)
                        }
                    } else {
                        result(false)
                    }
                }
            } else {
                result(false)
            }
        case "resetNotidication":
            if let body = call.arguments as? [String:Any] {
                if let notificationIds = body["notificationIds"] as? [String] {
                    print("reset notification action - \(notificationIds)")
                    UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: notificationIds)
                }
            }
            result(false)
            
        default:
            result(FlutterMethodNotImplemented)
        }
    }
    
    public func addNotificationListener(with controller:FlutterViewController) {
        scratchJoyEventChannel = FlutterEventChannel(name: "SJ_notificationClicker", binaryMessenger: controller.binaryMessenger)
        scratchJoyEventChannel?.setStreamHandler(self)
    }

    public func onListen(withArguments arguments: Any?, eventSink: @escaping FlutterEventSink) -> FlutterError? {
        self.scratchJoyEventSink = eventSink
        return nil
    }

    public func onCancel(withArguments arguments: Any?) -> FlutterError? {
        return nil
    }
}
