//
//  QuotesList.swift
//  MotiQ
//
//  Created by Darie-Nistor Nicolae on 03.04.2023.
//

import SwiftUI

struct QuotesListView: View {
    
    //MARK: PROPERTIES
    @StateObject var viewModel = CoreDataViewModel()
    
    init(viewModel: CoreDataViewModel) {
        self._viewModel = StateObject(wrappedValue: viewModel)
    }
    
    var body: some View {
        userQuotes
    }
}

struct QuotesList_Previews: PreviewProvider {
    static var previews: some View {
        QuotesListView(viewModel: CoreDataViewModel())
    }
}

fileprivate extension QuotesListView {
    var userQuotes: some View {
        List {
            ForEach(viewModel.savedEntities, id: \.self) { item in
                QuoteCardView(quote: item.quotes ?? "No name", author: item.author ?? "")
                    .font(.custom("Avenir", size: 20))
                    .cornerRadius(10)
                    
            }
            .onDelete(perform: viewModel.deleteQuote)
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
