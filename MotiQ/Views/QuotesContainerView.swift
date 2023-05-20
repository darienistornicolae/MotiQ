//
//  QuotesContainerView.swift
//  MotiQ
//
//  Created by Darie-Nistor Nicolae on 20.05.2023.
//

import SwiftUI

struct QuotesContainerView: View {
    @StateObject var viewModel = MotivationalViewModel()
    @State private var info: AlertInfo?
    
    @GestureState private var dragState = DragState.inactive
    @State private var offset: CGFloat = 0.0
    
    init(viewModel: MotivationalViewModel) {
        self._viewModel = StateObject(wrappedValue: viewModel)
    }
    
    var body: some View {
        VStack(alignment: .center, spacing: 30) {
            Text("\"\(viewModel.q)\"")
            Text(viewModel.a)
        }
        .onLongPressGesture {
            viewModel.saveQuote()
            info = AlertInfo(id: .two, title: "Quote Saved!", message: "", dismissButton: .default(Text("OK")))
            
        }
        .onAppear {
            viewModel.apiService.getQuotes()
        }
        .font(.custom("Avenir", size: 24))
        .multilineTextAlignment(.center)
        .frame(maxWidth: 350)
        .animation(.linear)
        .alert(item: $info) { info in
            Alert(title: Text(info.title).font(.custom("Avenir", size: 24)), message: Text(info.message), dismissButton: .default(Text("OK")))
        }
        
        .gesture(
            DragGesture()
                .updating($dragState) { value, dragState, _ in
                    dragState = .dragging(translation: value.translation.width)
                }
                .onEnded { value in
                    if value.translation.width < -100 {
                        viewModel.nextQuote()
                    } else if value.translation.width > 100 {
                        viewModel.previousQuote()
                    }
                }
        )
        .offset(x: offset)
        .animation(.spring())
        .onChange(of: viewModel.q) { _ in
            offset = 0.0
        }
    }
}


enum DragState {
    case inactive
    case dragging(translation: CGFloat)
}

struct QuotesContainerView_Previews: PreviewProvider {
    static var previews: some View {
        QuotesContainerView(viewModel: MotivationalViewModel())
    }
}
