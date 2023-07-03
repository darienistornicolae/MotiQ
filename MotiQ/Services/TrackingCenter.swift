//
//  TrackingCenter.swift
//  MotiQ
//
//  Created by Darie-Nistor Nicolae on 03.07.2023.
//

import Foundation
import AppTrackingTransparency
import AdSupport

class TrackingCenter: ObservableObject {
    
  static func requestPermission() {
        ATTrackingManager.requestTrackingAuthorization { status in
            switch status {
            case .authorized:
                // Tracking authorization dialog was shown
                // and we are authorized
                print("Authorized")
                print(ASIdentifierManager.shared().advertisingIdentifier)
                // Now that we are authorized we can get the IDFA
                print(ASIdentifierManager.shared().advertisingIdentifier)
            case .denied:
                // Tracking authorization dialog was
                // shown and permission is denied
                print("Denied")
            case .notDetermined:
                // Tracking authorization dialog has not been shown
                print("Not Determined")
            case .restricted:
                print("Restricted")
            @unknown default:
                print("Unknown")
            }
        }
        
    }
}
