import SwiftUI
import WebKit
import RevenueCat
import StoreKit
import UIKit
import MessageUI

struct SettingsView: View {
  
  //MARK: Properties
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
  
  @State private var showAlert: Bool = false
  @State private var info: AlertInfo?
  @State private var selectedDate: Date = Date()
  @State private var isSubscribed = false
  @ObservedObject private var notificationsCenter = NotificationCenter()
  @StateObject private var userViewModel = UserViewModel()
  
  init(userViewModel: @autoclosure @escaping () -> UserViewModel) {
    self._userViewModel = StateObject(wrappedValue: userViewModel())
  }
  var startingDate: Date = Date()
  var endingDate: Date = Calendar.current.date(from: DateComponents (year: 2026)) ?? Date ()
  
  var dateFormatter: DateFormatter {
    let formatter = DateFormatter()
    formatter.dateStyle = .medium
    return formatter
  }
  
  var body: some View {
    NavigationView {
      VStack {
        Form {
          notifications
          darkMode
          if !userViewModel.isSubscribeActive {
            premiumContent
          } else {
            if !isSubscribed {
              newsLetter
            } else {
              EmptyView()
            }
          }
          favoriteQuotes
          userAddedQuotes
          review
          restorePurchase
          if !userViewModel.isSubscribeActive {
            bannerAds
          }
          Text("The api is provided by Zen Api")
        }
        .navigationTitle("Settings")
        .navigationBarTitleDisplayMode(.inline)
      }
      .onAppear {
        userViewModel.checkSubscriptionStatus()
      }
      .environmentObject(UserViewModel())
    }
    .preferredColorScheme(isDarkMode ? .dark : .light)
    .onChange(of: isDarkMode) { newValue in
      updateColorScheme()
    }
  }
}

struct SettingsSheet_Previews: PreviewProvider {
  static var previews: some View {
    SettingsView(userViewModel: UserViewModel())
  }
}

fileprivate extension SettingsView {
  
  private func updateColorScheme() {
    UIApplication.shared.windows.first?.overrideUserInterfaceStyle = isDarkMode ? .dark : .light
    UserDefaults.standard.set(isDarkMode, forKey: "isDarkMode")
  }
  
  var goalSetting: some View {
    Section(header: Text("Goal Setting")) {
      NavigationLink("Goal Setting", destination: GoalsListView(viewModel: UserGoalCoreDataViewModel()))
    }
  }
  
  var premiumContent: some View {
    Section(header: Text("Premium access")) {
      
      NavigationLink("Premium Motiq") {
        PayWallView()
          .environmentObject(UserViewModel())
      }
    }
  }
  
  var review: some View {
    Section(header: Text("Rate us!❤️")) {
      Button {
        SKStoreReviewController.requestReviewInCurrentScene()
        if let windowScene = UIApplication.shared.windows.first?.windowScene { SKStoreReviewController.requestReview(in: windowScene) }
      } label: {
        Text("Rate us!")
      }
    }
  }
  
  var restorePurchase: some View {
    Section {
      Button {
        // TODO: Revenue Cat
        Purchases.shared.restorePurchases { customerInfo, error in
          if let customerInfo = customerInfo,
             customerInfo.entitlements["Premium MotiQ"]?.isActive == true {
            userViewModel.isSubscribeActive = true
            if !showAlert {
              info = AlertInfo(id: .two,
                               title: "Subscription Restored",
                               message: "Your subscription has been successfully restored.",
                               dismissButton: .default(Text("Great!")))
              showAlert = true
            }
          }
        }
      } label: {
        Text("Restore purchase")
          .font(.headline)
      }
      .alert(item: $info) { info in
        Alert(title: Text(info.title),
              message: Text(info.message),
              dismissButton: info.dismissButton)
      }
    }
  }
  
  var darkMode: some View {
    Section(header: Text("Display"),
            footer: Text("By default is based on the system settings. You can modify it after as you wish!")) {
      Toggle(isOn: $isDarkMode) {
        Text("Dark mode")
      }
    }
  }
  
  var favoriteQuotes: some View {
    Section(header: Text("Favorites Quotes"),
            footer: Text("See your favorite quotes")) {
      NavigationLink("Favorite Quotes") {
        SavedQuotesListView(viewModel: CoreDataViewModel())
      }
    }
  }
  
  var userAddedQuotes: some View {
    Section(header: Text("Your Quotes"),
            footer: Text("See your added quotes")) {
      NavigationLink("Your Quotes") {
        UserAddedQuotesListView(viewModel: UserCoreDataViewModel())
      }
    }
  }
  
  var notifications: some View {
    Section(header: Text("Push Notifications")) {
      Toggle(isOn: $notificationsCenter.notificationsEnabled) {
        Text("Enable Notifications")
      }
      .onChange(of: notificationsCenter.notificationsEnabled) { enabled in
        UserDefaults.standard.set(enabled, forKey: "notificationsEnabled")
        if enabled {
          notificationsCenter.requestAuthorization()
          if enabled {
            notificationsCenter.scheduleUserNotification(at: selectedDate)
          }
        } else {
          notificationsCenter.cancelUserNotification()
          redirectToNotificationSettings()
        }
      }
      if notificationsCenter.notificationsEnabled {
        DatePicker("Remind Me",
                   selection: $selectedDate,
                   in: startingDate...endingDate,
                   displayedComponents: [.date, .hourAndMinute])
          .datePickerStyle(CompactDatePickerStyle())
          .onChange(of: selectedDate) { date in
            notificationsCenter.scheduleUserNotification(at: date)
          }
      }
    }
    .onAppear {
      notificationsCenter.notificationsEnabled = UserDefaults.standard.bool(forKey: "notificationsEnabled")
      
    }
  }
  
  func redirectToNotificationSettings() {
    guard let settingsUrl = URL(string: UIApplication.openSettingsURLString) else { return }
    if UIApplication.shared.canOpenURL(settingsUrl) {
      UIApplication.shared.open(settingsUrl)
    }
  }
  
  
  var newsLetter: some View {
    Section(header: Text("Newsletter Form"),
            footer: Text("Here is the newsletter form to complete to recive the Weekly Newsletter!☺️")) {
      NavigationLink("MotiQ Newsletter") {
        WebView()
      }
    }
  }
  
  var bannerAds: some View {
    BannerAd(unitID: "ca-app-pub-8739348674271989/8823793414")
      .frame(width: 400, height: 300)
  }
}


