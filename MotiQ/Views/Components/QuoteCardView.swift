import Foundation
import SwiftUI

struct QuoteCardView: View {
  @AppStorage("isDarkMode") private var isDarkMode: Bool = false
  let quote: String
  let author: String

  var body: some View {
    HStack {
      VStack(alignment: .leading) {
        Text(quote)
          .padding(.bottom, 8)
        HStack {
          Text(author)
            .foregroundColor(.secondary)
          Spacer()
          Button(action: {
            shareQuote()
          }) {
            Image(systemName: "square.and.arrow.up")
              .font(.system(size: 20))
          }
          .foregroundColor(.primary)
        }
      }
      .padding()
      .cornerRadius(10)
      .preferredColorScheme(isDarkMode ? .dark : .light)
    }
    .padding(.vertical, 4)
  }

  private func shareQuote() {
    let appName = "Motiq"
    let link = "https://apps.apple.com/us/app/motiq-quotes-mindfulness/id6447770639"
    let quoteText = "\"\(quote)\"\n\n\(author)\n\nShared from \(appName)\n\n\(link)"
    let activityViewController = UIActivityViewController(activityItems: [quoteText], applicationActivities: nil)
    
    UIApplication.shared.windows.first?.rootViewController?.present(activityViewController, animated: true, completion: nil)
  }
}
