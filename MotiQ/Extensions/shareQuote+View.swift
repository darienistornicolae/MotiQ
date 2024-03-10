import SwiftUI

extension View {
  func shareQuote(quote: String, author: String) {
    let appName = "Motiq"
    let link = "https://apps.apple.com/us/app/motiq-quotes-mindfulness/id6447770639"
    let quoteText = "\"\(quote)\"\n\n\(author)\n\nShared from \(appName)\n\n\(link)"
    let activityViewController = UIActivityViewController(activityItems: [quoteText], applicationActivities: nil)
    UIApplication.shared.windows.first?.rootViewController?.present(activityViewController, animated: true, completion: nil)
  }
}
