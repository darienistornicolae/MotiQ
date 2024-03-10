import SwiftUI
import GoogleMobileAds
import RevenueCat
import BackgroundTasks
import FirebaseCore

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
    FirebaseApp.configure()
    GADMobileAds.sharedInstance().start(completionHandler: nil)
    Purchases.logLevel = .debug
    Purchases.configure(withAPIKey: "appl_jWKLVAnpkjXeJobUQlyOrzLRkkn")
    checkInitialLaunch()
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
      isPaywallShown = false
      UserDefaults.standard.set(true, forKey: "hasLaunchedBefore")
    } else {
      isPaywallShown = true
    }
  }

  private func scheduleAppRefresh() {
    let backgroundTask = BGAppRefreshTaskRequest(identifier: "refresh")
    backgroundTask.earliestBeginDate = .distantFuture.addingTimeInterval(60)
    try? BGTaskScheduler.shared.submit(backgroundTask)
  }
}
