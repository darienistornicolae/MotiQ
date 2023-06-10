//
//  MotiqApp.swift
//  Motiq
//
//  Created by Darie-Nistor Nicolae on 28.03.2023.
//

import SwiftUI
import GoogleMobileAds
import RevenueCat
import BackgroundTasks

@main
struct MotiQApp: App {
    
    @AppStorage("isDarkMode") private var isDarkMode: Bool = {
        let systemColorScheme: Bool
        if #available(iOS 13.0, *) {
            systemColorScheme = UITraitCollection.current.userInterfaceStyle == .dark
        } else {
            systemColorScheme = false
        }
        
        let storedValue = UserDefaults.standard.bool(forKey: "isDarkMode")
        return storedValue ? storedValue : systemColorScheme
    }()
    
    @Environment(\.scenePhase) private var phase
    @AppStorage("isPaywallShown") private var isPaywallShown: Bool = false
    @Environment(\.presentationMode) var presentationMode
    
    init() {
        GADMobileAds.sharedInstance().start(completionHandler: nil)
        Purchases.logLevel = .debug
        Purchases.configure(withAPIKey: "appl_jWKLVAnpkjXeJobUQlyOrzLRkkn")
        checkInitialLaunch() // Check the initial launch status
    }
    
    var body: some Scene {
        WindowGroup {
            if isPaywallShown {
                HomeScreenView()
                    .preferredColorScheme(isDarkMode ? .dark : .light)
                    .onChange(of: phase) { newPhase in
                        switch newPhase {
                        case .background: scheduleAppRefresh()
                        default: break
                        }
                    }
            } else {
                PayWallOpeningView()
                    .preferredColorScheme(isDarkMode ? .dark : .light)
                    .environmentObject(UserViewModel())
            }
        }
    }
    
    private func checkInitialLaunch() {
        let hasLaunchedBefore = UserDefaults.standard.bool(forKey: "hasLaunchedBefore")
        if !hasLaunchedBefore {
            isPaywallShown = false // Show the paywall on the first launch
            UserDefaults.standard.set(true, forKey: "hasLaunchedBefore")
        } else {
            isPaywallShown = true // Paywall has been shown before, so skip it
        }
    }
    
    // ...
}



func scheduleAppRefresh() {
    let backgroundTask = BGAppRefreshTaskRequest(identifier: "refresh")
    backgroundTask.earliestBeginDate = .distantFuture.addingTimeInterval(300)
    try? BGTaskScheduler.shared.submit(backgroundTask)
}
