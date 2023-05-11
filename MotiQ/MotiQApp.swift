//
//  MotiqApp.swift
//  Motiq
//
//  Created by Darie-Nistor Nicolae on 28.03.2023.
//

import SwiftUI
import GoogleMobileAds
import RevenueCat

@main


struct MotiQApp: App {
    @AppStorage("isDarkMode") private var isDarkMode: Bool = false
    
    init() {
        GADMobileAds.sharedInstance().start(completionHandler: nil)
        Purchases.logLevel = .debug
        Purchases.configure(withAPIKey: "appl_jWKLVAnpkjXeJobUQlyOrzLRkkn")
        
    }
    var body: some Scene {
        WindowGroup {
            HomeScreenView(viewModel: MotivationalViewModel())
                .preferredColorScheme(isDarkMode ? .dark : .light)
        }
    }
}

