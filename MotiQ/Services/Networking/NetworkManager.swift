import Foundation
import Network

class NetworkManager: ObservableObject {
  private let monitor = NWPathMonitor()
  private let queue = DispatchQueue(label: "NetworkManager")
  @Published var isConnected: Bool = true

  init() {
    monitor.pathUpdateHandler = { path in
      DispatchQueue.main.async {
        self.isConnected = path.status == .satisfied
      }
    }
    monitor.start(queue: queue)
  }
}
