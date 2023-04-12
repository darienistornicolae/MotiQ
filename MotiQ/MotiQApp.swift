//
//  MotiqApp.swift
//  Motiq
//
//  Created by Darie-Nistor Nicolae on 28.03.2023.
//

import SwiftUI
import GoogleMobileAds


@main


struct MotiQApp: App {
    @AppStorage("isDarkMode") private var isDarkMode: Bool = false
    @AppStorage("FirstTime") var isPresented: Bool = true
    
    init() {
        GADMobileAds.sharedInstance().start(completionHandler: nil)
        
    }
    var body: some Scene {
        WindowGroup {
            HomeScreenView(viewModel: MotivationalViewModel())
                .preferredColorScheme(isDarkMode ? .dark : .light)
                .alert(isPresented: $isPresented) {
                    Alert(
                        title: Text("Useful Tip!"),
                        message: Text("Long Press on the quote that you like and you'll see it on Saved Quotes!"),
                        dismissButton: .cancel(Text("Confirm"), action: {
                            isPresented = false
                        }))
                }
        }
    }
    
}



