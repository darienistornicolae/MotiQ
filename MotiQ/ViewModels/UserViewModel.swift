//
//  PayWallViewModel.swift
//  MotiQ
//
//  Created by Darie-Nistor Nicolae on 24.04.2023.
//

import SwiftUI
import RevenueCat

class UserViewModel: ObservableObject {
    
    @Published var isSubscribeActive = false

    init() {
        checkSubscriptionStatus()
    }

     func checkSubscriptionStatus() {
        Purchases.shared.getCustomerInfo { [weak self] purchaserInfo, error in
            guard let self = self else { return }
            if let entitlements = purchaserInfo?.entitlements, let isSubscribed = entitlements["Premium MotiQ"]?.isActive {
                self.isSubscribeActive = isSubscribed
            }
        }
    }
}

