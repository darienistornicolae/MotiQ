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
    @StateObject var userViewModel = UserViewModel()
    @State private var isSaved: Bool = false
    @State private var offset: CGFloat = 0.0
    @State private var swipeCount = 0
    
    @ObservedObject var networkManager = NetworkManager()
    
    private let adSense = InterstitialAd()
    
    @GestureState private var dragState = DragState.inactive
    
    
    init(viewModel: MotivationalViewModel) {
        self._viewModel = StateObject(wrappedValue: viewModel)
    }
    
    var body: some View {
        quotesView
            .onAppear {
                viewModel.apiService.getQuotes()
            }
            .font(.custom("Avenir", size: 24))
            .frame(maxWidth: 350)
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
                
                swipeCount += 1
                if !userViewModel.isSubscribeActive {
                    if swipeCount % 5 == 0 {
                        adSense.showInterstitial(viewController: (UIApplication.shared.windows.first?.rootViewController)!)
                    }
                }
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

fileprivate extension QuotesContainerView {
    
    private var frameWidth: CGFloat {
        if UIScreen.main.bounds.width >= 390 { // Adjust the width based on your requirements
            return 350
        } else {
            return 300
        }
    }
    
    private var frameHeight: CGFloat {
        if UIScreen.main.bounds.height >= 840 { // Adjust the height based on your requirements
            return 650
        } else {
            return 500
        }
    }
    
    private func shareQuote() {
        let appName = "Motiq"
        let link =  "https://apps.apple.com/us/app/motiq-quotes-mindfulness/id6447770639"
        let quoteText = "\"\(viewModel.q)\"\n\n\(viewModel.a)\n\nShared from \(appName)\n\n\(link)"
        let activityViewController = UIActivityViewController(activityItems: [quoteText], applicationActivities: nil)
        UIApplication.shared.windows.first?.rootViewController?.present(activityViewController, animated: true, completion: nil)
    }
    
     enum Constants {
        static let smallFontSize: CGFloat = 25
        static let largeFontSize: CGFloat = 34
    }
    
    private var fontSize: CGFloat {
        return UIScreen.main.bounds.width >= 390 ? Constants.largeFontSize : Constants.smallFontSize
    }
    
    var quotesView: some View {
        VStack(alignment: .center, spacing: 30) {
            VStack(spacing: 10) {
                if networkManager.isConnected {
                    Text("\"\(viewModel.q)\"")
                        .multilineTextAlignment(.center)
                        .font(.custom("Avenir", size: fontSize))
                        .foregroundColor(colorScheme == .dark ? .white : .black)
                        .padding()
                    
                    Text(viewModel.a)
                        .font(.custom("Avenir", size: fontSize - 4))
                        .foregroundColor(colorScheme == .dark ? .white : .gray)
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
            .frame(width: frameWidth, height: frameHeight)
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
                            .font(.system(size: fontSize))
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
                                .font(.system(size: fontSize))
                        } else {
                            Image(systemName: "heart")
                                .foregroundColor(.buttonColor)
                                .font(.system(size: fontSize))
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
    }
}
