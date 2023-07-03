//
//  SettingsSheet.swift
//  MotiQ
//
//  Created by Darie-Nistor Nicolae on 28.03.2023.
//

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
    @State var selectedDate: Date = Date()
    @State private var isSubscribed = false
    @ObservedObject var viewModel = NotificationCenter()
    @StateObject var userViewModel = UserViewModel()
    
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
                    goalSetting
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
            
            .environmentObject(UserViewModel())
        }
        .preferredColorScheme(isDarkMode ? .dark : .light)
        .onChange(of: isDarkMode) { newValue in
            updateColorScheme()
        }
        
    }
    
    private func updateColorScheme() {
        UIApplication.shared.windows.first?.overrideUserInterfaceStyle = isDarkMode ? .dark : .light
        UserDefaults.standard.set(isDarkMode, forKey: "isDarkMode")
    }
    
}

struct SettingsSheet_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
    }
}


fileprivate extension SettingsView {
    
    var goalSetting: some View {
        Section(header: Text("Goal Setting")) {
            NavigationLink("Goal Setting", destination: GoalSettingView(viewModel: UserGoalCoreDataViewModel()))
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
                            info = AlertInfo(id: .two, title: "Subscription Restored", message: "Your subscription has been successfully restored.", dismissButton: .default(Text("Great!")))
                            showAlert = true 
                        }
                    }
                }
            } label: {
                Text("Restore purchase")
                    .font(.headline)
            }
            .alert(item: $info) { info in
                Alert(title: Text(info.title), message: Text(info.message), dismissButton: info.dismissButton)
            }
        }
    }

    var darkMode: some View {
        Section(header: Text("Display"), footer: Text("By default is based on the system settings. You can modify it after as you wish!")) {
            Toggle(isOn: $isDarkMode) {
                Text("Dark mode")
            }
        }
    }
    
    var favoriteQuotes: some View {
        Section(header: Text("Favorites Quotes"), footer: Text("See your favorite quotes")) {
            NavigationLink("Favorite Quotes") {
                QuotesListView(viewModel: CoreDataViewModel())
            }
        }
    }
    
    var userAddedQuotes: some View {
        Section(header: Text("Your Quotes"), footer: Text("See your added quotes")) {
            NavigationLink("Your Quotes") {
                UserAddedQuotesListView(viewModel: UserCoreDataViewModel())
            }
        }
    }
     
    var notifications: some View {
        Section(header: Text("Push Notifications")) {
            Toggle(isOn: $viewModel.notificationsEnabled) {
                Text("Enable Notifications")
            }
            .onChange(of: viewModel.notificationsEnabled) { enabled in
                UserDefaults.standard.set(enabled, forKey: "notificationsEnabled")
                if enabled {
                    viewModel.requestAuthorization()
                    if enabled {
                        viewModel.scheduleUserNotification(at: selectedDate)
                    }
                } else {
                    viewModel.cancelUserNotification()
                    redirectToNotificationSettings()
                }
            }
            if viewModel.notificationsEnabled {
                        DatePicker("Remind Me", selection: $selectedDate, in: startingDate...endingDate, displayedComponents: [.date, .hourAndMinute])
                            .datePickerStyle(CompactDatePickerStyle())
                            .onChange(of: selectedDate) { date in
                                viewModel.scheduleUserNotification(at: date)
                            }
                    }
        }
        .onAppear {
            viewModel.notificationsEnabled = UserDefaults.standard.bool(forKey: "notificationsEnabled")
            
        }
    }

    private func redirectToNotificationSettings() {
        guard let settingsUrl = URL(string: UIApplication.openSettingsURLString) else { return }
        if UIApplication.shared.canOpenURL(settingsUrl) {
            UIApplication.shared.open(settingsUrl)
        }
    }

    
    var newsLetter: some View {
        Section(header: Text("Newsletter Form"), footer: Text("Here is the newsletter form to complete to recive the Weekly Newsletter!☺️")) {
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

extension SKStoreReviewController {
    public static func requestReviewInCurrentScene() {
        if let scene = UIApplication.shared.connectedScenes.first(where: { $0.activationState == .foregroundActive }) as? UIWindowScene {
            DispatchQueue.main.async {
                requestReview(in: scene)
            }
        }
    }
}

struct WebView: UIViewRepresentable {
    
    func makeUIView(context: UIViewRepresentableContext<WebView>) -> WebView.UIViewType {
        WKWebView(frame: .zero)
    }
    
    func updateUIView(_ uiView: WKWebView, context: UIViewRepresentableContext<WebView>) {
        let formUrl = "https://36838a2b.sibforms.com/serve/MUIEAI4kVJVjBuZCD_M5bH77lS5L92HgPKg5uhPWMUGc2jhsME527CIMpF4aS5zABf7j_LwblPuJNEicRme1yrooCt3NiqCuzDkf6dAVcxu_4aYMrbGBkUp5BQ9KzcYB7fFh94NefpsVVEj_YAdK_Dw8Vz7WjXN3rL-5ZM_ilnD-1kBWlHuELFfEz-G5TCNNhtJKDpaMLCPP5Az5"
        let request = URLRequest(url: URL(string: formUrl)!)
        uiView.load(request)
    }
    
}
