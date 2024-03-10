import Foundation
import AppTrackingTransparency
import AdSupport

class TrackingCenter: ObservableObject {

  static func requestPermission() {
    ATTrackingManager.requestTrackingAuthorization { status in
      switch status {
      case .authorized:
        print("Authorized")
        print(ASIdentifierManager.shared().advertisingIdentifier)
        print(ASIdentifierManager.shared().advertisingIdentifier)
      case .denied:
        print("Denied")
      case .notDetermined:
        print("Not Determined")
      case .restricted:
        print("Restricted")
      @unknown default:
        print("Unknown")
      }
    }
  }
}
