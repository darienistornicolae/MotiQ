//
//  SettingsSheet.swift
//  MotiQ
//
//  Created by Darie-Nistor Nicolae on 28.03.2023.
//

import SwiftUI

struct SettingsSheet: View {
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        Text("Thank you for using our App!")
            .font(.title)
            .foregroundColor(.blue)
    }
}

struct SettingsSheet_Previews: PreviewProvider {
    static var previews: some View {
        SettingsSheet()
    }
}
