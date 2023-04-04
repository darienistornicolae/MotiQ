//
//  NotificationCenter.swift
//  MotiQ
//
//  Created by Darie-Nistor Nicolae on 30.03.2023.
//

import Foundation
import UserNotifications

class NotificationCenter: ObservableObject {

    func requestAuthorization() {
        let options: UNAuthorizationOptions = [.alert, .sound]
        UNUserNotificationCenter.current().requestAuthorization(options: options) { success, error in
            if let error = error {
                print("There is an error: \(error)")
            } else {
                print("Succesfully set up notifications!")
            }
        }
    }
    
    func scheduleUserNotification(at date: Date) {
        let content = UNMutableNotificationContent()
        content.title = "MotiQ"
        content.subtitle = "Your daily quote is waiting for you"
        content.sound = .default

        let calendar = Calendar.current
        let components = calendar.dateComponents([.year, .month, .day, .hour, .minute], from: date)
        let trigger = UNCalendarNotificationTrigger(dateMatching: components, repeats: false)

        let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
        UNUserNotificationCenter.current().add(request)
    }
}
