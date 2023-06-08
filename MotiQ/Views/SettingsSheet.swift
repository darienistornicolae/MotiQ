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

struct SettingsSheet: View {
    
    //MARK: Properties
    @AppStorage("isDarkMode") private var isDarkMode: Bool = false
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
            VStack() {
                Form {
                    notifications
                    darkMode
                    favoriteQuotes
                    userAddedQuotes
                    if !userViewModel.isSubscribeActive {
                        premiumContent
                    } else {
                        if !isSubscribed {
                            newsLetter
                        } else {
                            EmptyView()
                        }
                    }
                    review
                    restorePurchase
                    if !userViewModel.isSubscribeActive {
                        bannerAds
                    }
                    Text("The api is provided by Zen Api")
                    
                }
                .navigationBarTitle("Motiq", displayMode: .inline)
                
            }
            .onAppear {
                viewModel.requestAuthorization()
                viewModel.requestPermission()
            }
            .environmentObject(UserViewModel())
        }
        .preferredColorScheme(isDarkMode ? .dark : .light)
    }
}

struct SettingsSheet_Previews: PreviewProvider {
    static var previews: some View {
        SettingsSheet()
    }
}

fileprivate extension SettingsSheet {
    
    var premiumContent: some View {
        Section(header: Text("Premium access")) {
            
            NavigationLink("Premium Motiq") {
                PayWallView()
                    .environmentObject(UserViewModel())
            }
            
//            Button {
//                payWall.toggle()
//            } label: {
//                Text("Premium MotiQ")
//                    .foregroundColor(.buttonColor)
//            }
//            .sheet(isPresented: $payWall) {
//                PayWallView()
//                    .environmentObject(UserViewModel())
//            }
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
                        showAlert()
                    }
                }
            } label: {
                Text("Restore purchase")
                    .font(.headline)
            }
        }
    }

    func showAlert() {
        let alert = UIAlertController(title: "Subscription Restored",
                                      message: "Your subscription has been successfully restored.",
                                      preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        
       
    }

    
    var darkMode: some View {
        Section(header: Text("Display"), footer: Text("Here you can modify the display mode")) {
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
                UserAddedQuotesList(viewModel: UserCoreDataViewModel())
            }
        }
    }
     
    var notifications: some View {
        Section(header: Text("Push Notifications"), footer: Text("Reminder to check the app for quotes 😊. When you set up the date and time, it'll automatically update")) {
            
            DatePicker("Remind Me", selection: $selectedDate, in: startingDate...endingDate, displayedComponents: [.date, .hourAndMinute])
                .datePickerStyle(CompactDatePickerStyle())
                .onChange(of: selectedDate) { date in
                    viewModel.scheduleUserNotification(at: date)
                }
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
