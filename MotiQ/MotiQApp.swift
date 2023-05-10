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
   // @StateObject private var alertManager = AlertManager()
    
    init() {
        GADMobileAds.sharedInstance().start(completionHandler: nil)
        Purchases.logLevel = .debug
        Purchases.configure(withAPIKey: "appl_jWKLVAnpkjXeJobUQlyOrzLRkkn")
        
    }
    var body: some Scene {
        WindowGroup {
            HomeScreenView()
                .preferredColorScheme(isDarkMode ? .dark : .light)
//                .onAppear {
//                    self.alertManager.presentAlert(title: "Useful Tip~", message: "If you long press on the quote, that quote will be saved!", dismissButton: .cancel())
//                }
//                .alert(isPresented: $alertManager.isPresented) {
//                    self.alertManager.alert
//                }
        }
    }
}

