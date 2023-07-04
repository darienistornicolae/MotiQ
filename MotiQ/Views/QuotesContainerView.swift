//
//  QuotesContainerView.swift
//  MotiQ
//
//  Created by Darie-Nistor Nicolae on 20.05.2023.
//

import SwiftUI

struct QuotesContainerView: View {
    
    // MARK: PROPERTIES
    @Environment(\.colorScheme) var colorScheme
    @ObservedObject var networkManager = NetworkManager()
    @StateObject private var viewModel = MotivationalViewModel()
    @StateObject private var userViewModel = UserViewModel()
    @StateObject private var textToSpeech = TextToSpeech()
    @State var clickCount: Int = 0
    
    @GestureState private var dragState = DragState.inactive
    @State private var offset: CGFloat = 0.0
    @State private var swipeCount = 0
    private var hasFetchedQuotes: Bool = false
    private let adSense = InterstitialAd()
    
    
    init(viewModel: MotivationalViewModel) {
        self._viewModel = StateObject(wrappedValue: viewModel)
    }
    
    init(userViewModel: UserViewModel) {
        self._userViewModel = StateObject(wrappedValue: userViewModel)
    }
    
    var body: some View {
        quotesView
            .font(.custom("Avenir", size: 24))
            .frame(maxWidth: 350)
            .onAppear {
                userViewModel.checkSubscriptionStatus()
            }
    }
    
}


struct QuotesContainerView_Previews: PreviewProvider {
    static var previews: some View {
        QuotesContainerView(userViewModel: UserViewModel())
    }
}



fileprivate extension QuotesContainerView {
    enum DragState {
        case inactive
        case dragging(translation: CGFloat)
    }
    
    enum Constants {
        static let smallFontSize: CGFloat = 25
        static let largeFontSize: CGFloat = 34
    }
    
    var dragGesture: some Gesture {
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
    
    var frameWidth: CGFloat {
        if UIScreen.main.bounds.width >= 390 { // Adjust the width based on your requirements
            return 350
        } else {
            return 300
        }
    }
    
    var frameHeight: CGFloat {
        if UIScreen.main.bounds.height >= 840 { // Adjust the height based on your requirements
            return 650
        } else {
            return 500
        }
    }
    
    func shareQuote() {
        let appName = "Motiq"
        let link =  "https://apps.apple.com/us/app/motiq-quotes-mindfulness/id6447770639"
        let quoteText = "\"\(viewModel.q)\"\n\n\(viewModel.a)\n\nShared from \(appName)\n\n\(link)"
        let activityViewController = UIActivityViewController(activityItems: [quoteText], applicationActivities: nil)
        UIApplication.shared.windows.first?.rootViewController?.present(activityViewController, animated: true, completion: nil)
    }
    
    var fontSize: CGFloat {
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
                    Spacer()
                    
                    Button(action: {
                        clickCount += 1
                        if !userViewModel.isSubscribeActive {
                            if clickCount % 2 == 0 {
                                adSense.showInterstitial(viewController: (UIApplication.shared.windows.first?.rootViewController)!)
                            }
                        }
                        
                        textToSpeech.speak(text: "\(viewModel.q) by \(viewModel.a)") {
                        
                        }
                    }) {
                        Image(systemName: "speaker.wave.2")
                            .font(.system(size: fontSize))
                            .foregroundColor(colorScheme == .dark ? .white : .black)
                            .padding(8)
                    }
                    .padding(.bottom, 8)
                    .foregroundColor(.primary)
                    
                    Spacer()
                    Button(action: {
                        viewModel.toggleSaveQuote()
                    }) {
                        if viewModel.isSaved {
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
                viewModel.isSaved = false
            }
        }
    }
}
