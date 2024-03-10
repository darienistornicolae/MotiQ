import Foundation
import SwiftUI

struct QuoteCardViewComponent: View {
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
            shareQuote(quote: quote, author: author)
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
}
