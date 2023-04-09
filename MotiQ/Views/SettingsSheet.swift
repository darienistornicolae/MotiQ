//
//  SettingsSheet.swift
//  MotiQ
//
//  Created by Darie-Nistor Nicolae on 28.03.2023.
//

import SwiftUI
import WebKit

struct SettingsSheet: View {
    
    //MARK: Properties
    @AppStorage("isDarkMode") private var isDarkMode: Bool = false
    @State var selectedDate: Date = Date()
    @ObservedObject var viewModel = NotificationCenter()
    @State private var payWall: Bool = false //Revenue Cat
    
    
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
                    
                    premiumContent
                    restorePurchase
                    darkMode
                    savedQuotes
                    notifications
                    newsLetter
                    bannerAds
                    
                }
                .navigationBarTitle("MotiQ", displayMode: .inline)
                
            }
            .onAppear {
                viewModel.requestAuthorization()
                viewModel.requestPermission()
            }
            
            
        }
        .preferredColorScheme(isDarkMode ? .dark : .light)
    }
}

struct SettingsSheet_Previews: PreviewProvider {
    static var previews: some View {
        SettingsSheet()
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

fileprivate extension SettingsSheet {
    
    var premiumContent: some View {
        Section(header: Text("Premium access")) {
            NavigationLink("Buy Me") {
                PayWallView()
            }
        }
    }
    
    var restorePurchase: some View {
        Section() {
            Button {
                //TODO: Revenue Cat
            } label: {
                Text("Restore purchase")
                    .font(.headline)
            }
        }
    }
    
    var darkMode: some View {
        Section(header: Text("Display"), footer: Text("Here you can modify the display mode")) {
            Toggle(isOn: $isDarkMode) {
                Text("Dark mode")
            }
        }
    }
    
    var savedQuotes: some View {
        Section(header: Text("Quotes"), footer: Text("Modify your saved quotes")) {
            NavigationLink("Your Quotes") {
                QuotesListView(viewModel: CoreDataViewModel())
            }
        }
    }
    
    var notifications: some View {
        Section(header: Text("Push Notifications"), footer: Text("Daily reminder to check the app for quotes 😊. When you set up the date and time, it'll automatically update")) {
            
            DatePicker("Remind Me", selection: $selectedDate, in: startingDate...endingDate, displayedComponents: [.date, .hourAndMinute])
                .datePickerStyle(CompactDatePickerStyle())
                .onChange(of: selectedDate) { date in
                    viewModel.scheduleUserNotification(at: date)
                }
        }
    }
    
    var newsLetter: some View {
        Section(header: Text("Newsletter Form"), footer: Text("Here you'll insert the email you want to recive the Newsletter")) {
            NavigationLink("Premium") {
                WebView()
            }
        }
    }
    
    var bannerAds: some View {
        BannerAd(unitID: "ca-app-pub-3940256099942544/2934735716")
            .frame(width: 500, height: 250)
    }
}
