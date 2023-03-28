//
//  MotiqApp.swift
//  Motiq
//
//  Created by Darie-Nistor Nicolae on 28.03.2023.
//

import SwiftUI

@main
struct MotiQApp: App {
    var body: some Scene {
        WindowGroup {
            HomeScreenView(viewModel: MotivationalViewModel())
        }
    }
}
