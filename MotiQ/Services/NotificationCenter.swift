import Foundation
import UserNotifications

class NotificationCenter: ObservableObject {
  @Published var notificationsEnabled: Bool = false
  @Published var authorizationStatus: UNAuthorizationStatus = .notDetermined

  func cancelUserNotification() {
    UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
  }

  func requestAuthorization() {
    let options: UNAuthorizationOptions = [.alert, .sound]
    UNUserNotificationCenter.current().requestAuthorization(options: options) { success, error in
      if let error = error {
        print("There is an error: \(error)")
      } else {
        DispatchQueue.main.async {
          self.authorizationStatus = .authorized
        }
      }
    }
  }

  func scheduleUserNotification(at date: Date) {
    let content = UNMutableNotificationContent()
    content.title = "MotiQ"
    content.subtitle = "Your daily quote is waiting for you!"
    content.sound = .default

    let calendar = Calendar.current
    let components = calendar.dateComponents([.year, .month, .day, .hour, .minute], from: date)
    let trigger = UNCalendarNotificationTrigger(dateMatching: components, repeats: false)

    let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
    UNUserNotificationCenter.current().add(request)
  }
}
