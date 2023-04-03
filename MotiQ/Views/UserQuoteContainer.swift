//
//  UserQuoteContainer.swift
//  MotiQ
//
//  Created by Darie-Nistor Nicolae on 03.04.2023.
//

import SwiftUI

struct UserQuoteContainer: View {
    
    let viewModel: CoreDataViewModel
    
    init(viewModel: CoreDataViewModel) {
        self.viewModel = viewModel
        
    }
    var body: some View {
        ZStack(alignment: .topLeading) {
            RoundedRectangle(cornerRadius: 20)
                .frame(width: 350, height: 130)
            ForEach(viewModel.savedEntities, id: \.self) { quote in
                Text(quote.quotes ?? "")
                        .foregroundColor(.blue)
                        .padding()
                
            }
            .onDelete(perform: viewModel.deleteQuote)
            
        }
    }
}

struct UserQuoteContainer_Previews: PreviewProvider {
    static var previews: some View {
        UserQuoteContainer(viewModel: CoreDataViewModel())
            .previewLayout(.sizeThatFits)
    }
}
