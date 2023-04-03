//
//  QuotesList.swift
//  MotiQ
//
//  Created by Darie-Nistor Nicolae on 03.04.2023.
//

import SwiftUI

struct QuotesList: View {
    @StateObject var viewModel = CoreDataViewModel()
    var body: some View {
        NavigationView {
            List {
                ForEach(viewModel.savedEntities, id: \.self) { item in
                    Text(item.quotes ?? "No name")
                }
                .onDelete(perform: viewModel.deleteQuote)
                
            }
        }
    }
}
    
    struct QuotesList_Previews: PreviewProvider {
        static var previews: some View {
            QuotesList()
        }
    }

