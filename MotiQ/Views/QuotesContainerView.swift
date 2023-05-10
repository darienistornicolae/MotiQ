//
//  QuotesContainerView.swift
//  MotiQ
//
//  Created by Darie-Nistor Nicolae on 10.05.2023.
//

import SwiftUI

struct QuotesContainerView: View {
    
    @State var showAlert: Bool = false
    @StateObject var viewModel: MotivationalViewModel
    init(viewModel: MotivationalViewModel) {
        self._viewModel = StateObject(wrappedValue: viewModel)
    }
    
    var body: some View {
        VStack(alignment: .center, spacing: 30) {
            Text("\"\(viewModel.q)\"")
            Text(viewModel.a)
        }
        .onTapGesture {
            viewModel.nextQuote()
        }
        .alert(isPresented: $showAlert, content: {
            Alert(title: Text("Quote Saved!").font(.custom("Avenir", size: 24)), message: nil, dismissButton: .default(Text("OK")))
        })
        .onLongPressGesture {
            viewModel.saveQuote()
            withAnimation {
                showAlert = true
            }
        }

    }
}

struct QuotesContainerView_Previews: PreviewProvider {
    static var previews: some View {
        QuotesContainerView(viewModel: MotivationalViewModel())
    }
}
