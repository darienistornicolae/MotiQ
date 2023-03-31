//
//  SettingsSheet.swift
//  MotiQ
//
//  Created by Darie-Nistor Nicolae on 28.03.2023.
//

import SwiftUI

struct SettingsSheet: View {
    @Environment(\.presentationMode) var presentationMode
    @AppStorage("isDarkMode") private var isDarkMode: Bool = false
    @State var selectedDate: Date = Date()
    @ObservedObject var viewModel = NotificationCenter()
    
    var startingDate: Date = Date()
    var endingDate: Date = Calendar.current.date(from: DateComponents (year: 2026)) ?? Date ()
    
    var dateFormatter: DateFormatter {
        let formatter = DateFormatter ()
        formatter.dateStyle = .medium
        return formatter
    }
    
    var body: some View {
        NavigationView {
            VStack() {
                Form {
                    Section(header: Text("Display"), footer: Text("Here you can modify the display mode")) {
                        Toggle(isOn: $isDarkMode) {
                            Text("Dark mode")
                        }
                    }
                    Section(header: Text("Quotes"), footer: Text("Modify your saved quotes")) {
                        
                    }
                    
                    Section(header: Text("Push Notifications"), footer: Text("Here you can modify how often you want to recive a quote through a notification")) {
                        
                        DatePicker("Select a time", selection: $selectedDate, in: startingDate...endingDate, displayedComponents: [.date, .hourAndMinute])
                            .datePickerStyle(CompactDatePickerStyle())
                            .onChange(of: selectedDate) { date in
                                viewModel.scheduleUserNotification(at: date)
                            }
                        
                        
                    }
                    
                }
                .navigationBarTitle("MotiQ", displayMode: .inline)
                
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
