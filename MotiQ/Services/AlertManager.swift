import Foundation
import Combine
import SwiftUI

class AlertManager: ObservableObject {
  @Published var isPresented: Bool = false
  static let shared = AlertManager()
  private var titleText: Text = Text("")
  private var messageText: Text?
  private var dismissButton: Alert.Button?

  private func presentAlert(title: String,
                            message: String?,
                            dismissButton: Alert.Button?) {
    self.titleText = Text(title)
    if let message = message {
      self.messageText = Text(message)
    } else {
      self.messageText = nil
    }
    self.dismissButton = dismissButton
    isPresented = true
  }
}

struct AlertInfo: Identifiable {

  enum AlertType {
    case one
    case two
  }

  let id: AlertType
  let title: String
  let message: String
  let dismissButton: Alert.Button
}
