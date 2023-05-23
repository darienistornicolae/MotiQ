//
//  QuotesContainerView.swift
//  MotiQ
//
//  Created by Darie-Nistor Nicolae on 20.05.2023.
//

import SwiftUI

struct QuotesContainerView: View {
    @Environment(\.colorScheme) var colorScheme
    @StateObject var viewModel = MotivationalViewModel()
    @State private var info: AlertInfo?
    @State private var isSaved: Bool = false
    
    @GestureState private var dragState = DragState.inactive
    @State private var offset: CGFloat = 0.0
    
    init(viewModel: MotivationalViewModel) {
        self._viewModel = StateObject(wrappedValue: viewModel)
    }
    
    var body: some View {
        
        VStack(alignment: .center, spacing: 30) {
            VStack(spacing: 10) {
                Text("\"\(viewModel.q)\"")
                   // .font(.headline)
                    .multilineTextAlignment(.center)
                    .foregroundColor(colorScheme == .dark ? .white : .black)
                
                Text(viewModel.a)
                    .font(.headline)
                    .multilineTextAlignment(.center)
                    .foregroundColor(colorScheme == .dark ? .white : .gray)
            }
            .padding()
            .background(
                RoundedRectangle(cornerRadius: 10)
                    .fill(colorScheme == .dark ? Color.black : Color.white)
                    .shadow(color: Color.gray.opacity(0.3), radius: 5, x: 0, y: 2)
            )
            .overlay(
                HStack {
                    Spacer()
                    Button(action: {
                        viewModel.saveQuote()
                        isSaved = true
                    }) {
                        Image(systemName: isSaved ? "heart.fill" : "heart")
                            .font(.system(size: 20))
                            .foregroundColor(.red)
                            .padding(8)
                           
                    }
                }
                .padding([.top, .trailing], 8)
                .foregroundColor(.primary)
                , alignment: .bottomTrailing
            )
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
            .animation(Animation.default)
            .onChange(of: viewModel.q) { _ in
                offset = 0.0
                isSaved = false
            }
        }
        .onAppear {
            viewModel.apiService.getQuotes()
        }
        .font(.custom("Avenir", size: 24))
        .frame(maxWidth: 350)
        .animation(.linear)
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
