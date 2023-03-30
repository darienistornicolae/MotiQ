//
//  HomeScreenView.swift
//  MotiQ
//
//  Created by Darie-Nistor Nicolae on 20.03.2023.
//

import SwiftUI

struct HomeScreenView: View {
    
    //MARK: Properties
    @State private var showingSheet: Bool = false
    @State var currentIndex = 0
    @StateObject var viewModel: MotivationalViewModel
    
    init(viewModel: MotivationalViewModel) {
        self._viewModel = StateObject(wrappedValue: viewModel)
        viewModel.apiService.getQuotes()
        viewModel.requestAuthorization()
    }
    
    var body: some View {
        ZStack {
            NavigationView {
                HStack(alignment: .center) {
                    quotesContainer
                        .font(.custom("Avenir Next", size: 20))
                        .multilineTextAlignment(.center)
                        .frame(maxWidth: 350)
                        .animation(.linear)
                    
                }
                .onAppear {
                    startTimer()
                }
                .onTapGesture {
                    refreshTimer()
                    
                }
            }
            menuButton
            addText
        }
    }
}

struct HomeScreenView_Previews: PreviewProvider {
    static var previews: some View {
        HomeScreenView(viewModel: MotivationalViewModel())
    }
}


fileprivate extension HomeScreenView {
    
    var menuButton: some View {
        VStack() {
            Spacer()
            Circle()
                .foregroundColor(.buttonColor)
                .frame(width: 50, height: 50)
                .overlay(
                    Button(action: {
                        print("Sheet")
                        showingSheet.toggle()
                    }, label: {
                        Image(systemName: "line.3.horizontal")
                            .foregroundColor(.iconColor)
                    })
                    .sheet(isPresented: $showingSheet, content: {
                        SettingsSheet()
                    })
                )
                .onTapGesture {
                    showingSheet.toggle()
                }
        }
        .padding(.trailing, 280)
        .padding()
    }
    
    var addText: some View {
        VStack() {
            Spacer()
            Circle()
                .foregroundColor(.buttonColor)
                .frame(width: 50, height: 50)
                .overlay(
                    Button(action: {
                        print("Add")
                    }, label: {
                        Image(systemName: "plus")
                            .foregroundColor(.iconColor)
                    })
                )
        }
        .padding(.leading, 280)
        .padding()
        
    }
    
    var quotesContainer: some View {
        VStack(alignment: .center, spacing: 30) {
            
            if let currentQuote =
                viewModel.apiService.quotes.indices.contains(currentIndex) ? viewModel.apiService.quotes[currentIndex] : nil {
                Text("\"\(currentQuote.q)\"")
                Text(currentQuote.a)
                
            }
        }
    }
    
    private func refreshTimer() {
        currentIndex += 1
        if currentIndex >= viewModel.apiService.quotes.count {
            currentIndex = 0
        }
        
    }
    
    private func startTimer() {
        Timer.scheduledTimer(withTimeInterval: 5, repeats: true) { _ in
            currentIndex += 1
            if currentIndex >= viewModel.apiService.quotes.count {
                currentIndex = 0
            }
        }
    }
}


