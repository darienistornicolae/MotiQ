//
//  UserAddedQuotes.swift
//  MotiQ
//
//  Created by Darie-Nistor Nicolae on 27.05.2023.
//

import SwiftUI

struct UserAddedQuotes: View {
    
    //MARK: PROPERTIES
    @StateObject var viewModel = UserCoreDataViewModel()
    
    init(viewModel: UserCoreDataViewModel) {
        self._viewModel = StateObject(wrappedValue: viewModel)
    }
    
    var body: some View {
        userQuotes
    }
}

struct UserAddedQuotes_Previews: PreviewProvider {
    static var previews: some View {
        UserAddedQuotes(viewModel: UserCoreDataViewModel())
    }
}

fileprivate extension UserAddedQuotes {
    var userQuotes: some View {
        List {
            ForEach(viewModel.userQuotesEntity, id: \.self) { item in
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
            VStack(alignment: .leading) {
                Text(quote)
                    .padding(.bottom, 8)
                Text(author)
                    .foregroundColor(.secondary)
            }
            .padding()
            .cornerRadius(10)
            .padding(.vertical, 4)
            .preferredColorScheme(isDarkMode ? .dark : .light)
            
        }
    }
}
