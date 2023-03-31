//
//  HomeScreenView.swift
//  MotiQ
//
//  Created by Darie-Nistor Nicolae on 20.03.2023.
//

import SwiftUI

struct HomeScreenView: View {
    
    //MARK: Properties
    @State private var settingsSheet: Bool = false
    @State private var addUserQuoteSheet: Bool = false
    @StateObject var viewModel: MotivationalViewModel
    
    init(viewModel: MotivationalViewModel) {
        self._viewModel = StateObject(wrappedValue: viewModel)
        
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
                        settingsSheet.toggle()
                    }, label: {
                        Image(systemName: "line.3.horizontal")
                            .foregroundColor(.iconColor)
                    })
                    .sheet(isPresented: $settingsSheet, content: {
                        SettingsSheet()
                    })
                )
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
                        addUserQuoteSheet.toggle()
                    }, label: {
                        Image(systemName: "plus")
                            .foregroundColor(.iconColor)
                    })
                    .sheet(isPresented: $addUserQuoteSheet, content: {
                        AddUserQuoteView()
                    })
                )
                .onTapGesture {
                    addUserQuoteSheet.toggle()
                }
        }
        .padding(.leading, 280)
        .padding()
        
    }
    
    var quotesContainer: some View {
        VStack(alignment: .center, spacing: 30) {
            
            Text("\"\(viewModel.q)\"")
            Text(viewModel.a)
        }
    }
}


