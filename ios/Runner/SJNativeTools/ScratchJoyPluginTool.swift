import Foundation
import CoreTelephony
import AdSupport
import AppTrackingTransparency
import WebKit

class ScratchJoyTool : NSObject {

    static func requestNotificationAuthoiration(complete:@escaping (Bool) ->Void) {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { (status, err) in
            if err != nil || !status {
                complete(false)
                return;
            }
            complete(true)
        }
    }
    
    static func openIosSetting() {
        guard let url = URL(string: UIApplication.openSettingsURLString) else { return }
        if UIApplication.shared.canOpenURL(url) {
            UIApplication.shared.open(url, completionHandler: nil)
        }
    }
    
    static func resetRedNumber() {
        UIApplication.shared.applicationIconBadgeNumber = 0
    }
}
