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
    @State private var isSaved: Bool = false
    @ObservedObject var networkManager = NetworkManager()
    
    @GestureState private var dragState = DragState.inactive
    @State private var offset: CGFloat = 0.0
    
    init(viewModel: MotivationalViewModel) {
        self._viewModel = StateObject(wrappedValue: viewModel)
    }
    
    var body: some View {
        VStack(alignment: .center, spacing: 30) {
            VStack(spacing: 10) {
                if networkManager.isConnected {
                    Text("\"\(viewModel.q)\"")
                        .multilineTextAlignment(.center)
                        .foregroundColor(colorScheme == .dark ? .white : .black)
                        .padding()
                    
                    Text(viewModel.a)
                        .foregroundColor(colorScheme == .dark ? .white : .gray)
                        .font(.headline)
                        .multilineTextAlignment(.center)
                        
                        .padding()
                } else {
                    Text("No Internet Connection")
                        .multilineTextAlignment(.center)
                        .foregroundColor(colorScheme == .dark ? .white : .gray)
                        .padding()
                    
                    Text("WIFI/Mobile Data")
                        .multilineTextAlignment(.center)
                        .foregroundColor(colorScheme == .dark ? .white : .gray)
                        .padding()
                }
                
                
            }
            .frame(width: 300, height: 500)
            .background(
                RoundedRectangle(cornerRadius: 10)
                    .fill(colorScheme == .dark ? Color.black : Color.white)
                    .shadow(color: colorScheme == .dark ? Color.white.opacity(0.3) : Color.gray.opacity(0.4), radius: 5, x: 0, y: 2)
            )
            .overlay(
                HStack {
                    Spacer()
                    
                    Button(action: {
                        shareQuote()
                    }) {
                        Image(systemName: "square.and.arrow.up")
                            .font(.system(size: 25))
                            .foregroundColor(colorScheme == .dark ? .white : .black)
                            .padding(8)
                    }
                    .padding(.bottom, 8)
                    .foregroundColor(.primary)
                    
                    Button(action: {
                        if isSaved {
                            viewModel.deleteQuote()
                            isSaved = false
                        } else {
                            viewModel.saveQuote()
                            isSaved = true
                        }
                    }) {
                        if isSaved {
                            Image(systemName: "heart.fill")
                                .foregroundColor(.buttonColor)
                        } else {
                            Image(systemName: "heart")
                                .foregroundColor(.buttonColor)
                        }
                    }

                    .padding(.bottom, 8)
                    .foregroundColor(.primary)
                    
                    Spacer()
                }
                .frame(maxWidth: .infinity, alignment: .center),
                alignment: .bottom
            )
            .gesture(dragGesture)
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
    
    private var dragGesture: some Gesture {
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
    }
    
    private func shareQuote() {
        let appName = "Motiq"
        let quoteText = "\"\(viewModel.q)\"\n\n\(viewModel.a)\n\nShared from \(appName)"
        let activityViewController = UIActivityViewController(activityItems: [quoteText], applicationActivities: nil)
        UIApplication.shared.windows.first?.rootViewController?.present(activityViewController, animated: true, completion: nil)
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

