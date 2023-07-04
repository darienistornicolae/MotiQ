//
//  UserAddedQuotes.swift
//  MotiQ
//
//  Created by Darie-Nistor Nicolae on 27.05.2023.
//

import SwiftUI

struct UserAddedQuotesListView: View {
    
    //MARK: PROPERTIES
    @StateObject var viewModel = UserCoreDataViewModel()
    @State private var searchText = ""
   
    
    var body: some View {
        searchBar
        userQuotes
            .onAppear(perform: viewModel.fetchUserQuotes)
    }
}

struct UserAddedQuotes_Previews: PreviewProvider {
    static var previews: some View {
        UserAddedQuotesListView()
    }
}

fileprivate extension UserAddedQuotesListView {
    
    var searchBar: some View {
        HStack {
            Image(systemName: "magnifyingglass").foregroundColor(.gray)
            TextField("Search quote or author...", text: $searchText)
        }
        .frame(maxWidth: 350)
        .padding(10)
        .background(Color(.systemGray5))
        .cornerRadius(20)
    }
    
    var userQuotes: some View {
        List {
            ForEach(viewModel.filteredUserQuotes(searchText: searchText), id: \.self) { item in
                QuoteCardView(quote: item.quotes ?? "No Quote", author: item.author ?? "Your Quote")
                    .font(.custom("Avenir", size: 20))
            }
            .onDelete(perform: viewModel.deleteUserQuote)
            
        }
        .navigationTitle("Quotes")
    }
    
    struct QuoteCardView: View {
        let quote: String
        let author: String
        
        @AppStorage("isDarkMode") private var isDarkMode: Bool = false
        
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
}
