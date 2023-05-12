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
    @AppStorage("isDarkMode") private var isDarkMode: Bool = false
    @Environment(\.scenePhase) private var phase
    init() {
        GADMobileAds.sharedInstance().start(completionHandler: nil)
        Purchases.logLevel = .debug
        Purchases.configure(withAPIKey: "appl_jWKLVAnpkjXeJobUQlyOrzLRkkn")
        
    }
    var body: some Scene {
        WindowGroup {
            HomeScreenView(viewModel: MotivationalViewModel())
                .preferredColorScheme(isDarkMode ? .dark : .light)
                .onChange(of: phase) { newPhase in
                    switch newPhase {
                    case .background: scheduleAppRefresh()
                    default: break
                    }
                }
            
        }
    }
}

func scheduleAppRefresh() {
    let backgroundTask = BGAppRefreshTaskRequest(identifier: "refresh")
    backgroundTask.earliestBeginDate = .distantFuture.addingTimeInterval(120)
    try? BGTaskScheduler.shared.submit(backgroundTask)
}
