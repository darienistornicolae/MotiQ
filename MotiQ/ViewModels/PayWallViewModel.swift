//
//  PayWallViewModel.swift
//  MotiQ
//
//  Created by Darie-Nistor Nicolae on 24.04.2023.
//

import Foundation
import SwiftUI
import RevenueCat

class UserViewModel: ObservableObject {
    
    @Published var isSubscribeActive = false
    
    init() {
        Purchases.shared.getCustomerInfo { customerInfo, error in
            if customerInfo?.entitlements.all["Premium MotiQ"]?.isActive == true {
                self.isSubscribeActive = true
            }
        }
    }
}
