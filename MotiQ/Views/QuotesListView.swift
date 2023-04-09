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
                Text(item.quotes ?? "No name")
                    .font(.custom("Avenir Next", size: 20))
                Text(item.author ?? "")
                
            }
            .onDelete(perform: viewModel.deleteQuote)
        }
        .navigationTitle("Quotes")
    }
}
