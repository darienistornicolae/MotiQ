//
//  QuotesList.swift
//  MotiQ
//
//  Created by Darie-Nistor Nicolae on 03.04.2023.
//

import SwiftUI

struct QuotesListtView: View {
    
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
            QuotesListtView(viewModel: CoreDataViewModel())
        }
    }

fileprivate extension QuotesListtView {
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

//link: https://36838a2b.sibforms.com/serve/MUIEAP8EsQYfhQqCSEeXd4D4uTtVWkZIcAFcpuDHlGS9lUjGadRBqSzboOXWiVP39-jp3pba4uDigdp2ZqX1wW_-PKuIf9l7uAudGzrlQMf3Bb1aPcROMuKaD3fHkKTRSgCnsMktASQEI2ElbUpTbt99O9bSile2SAe1FRVo8g3GwRQ5QYktSa8YHlNlcJIc3PaNvT_NU5myRDWz
