//
//  HomeScreenView.swift
//  MotiQ
//
//  Created by Darie-Nistor Nicolae on 20.03.2023.
//

import SwiftUI

//Just the commit of the day to look good

struct HomeScreenView: View {
    
    //MARK: Properties
    @State private var settingsSheet: Bool = false
    @State private var addUserQuoteSheet: Bool = false
    @ObservedObject var networkManager = NetworkManager()
    
    var body: some View {
        ZStack {
            googleAds
            HStack(alignment: .center) {
                
                if networkManager.isConnected {
                    QuotesContainerView(viewModel: MotivationalViewModel())
                        .font(.custom("Avenir", size: 24))
                        .multilineTextAlignment(.center)
                        .frame(maxWidth: 350)
                        .animation(.linear)
                    
                    
                } else {
                    Text("No Internet Connection :((")
                }
            }
            menuButton
            addText
        }
    }
}

struct HomeScreenView_Previews: PreviewProvider {
    static var previews: some View {
        HomeScreenView()
    }
}


fileprivate extension HomeScreenView {
    
    var googleAds: some View {
        VStack(){
            BannerAd(unitID: "ca-app-pub-8739348674271989/8823793414")
                .frame(height: 150)
            Spacer()
        }
        
    }
    
    var menuButton: some View {
        VStack() {
            Spacer()
            Circle()
                .foregroundColor(.buttonColor)
                .frame(width: 60, height: 60)
                .overlay(
                    Button(action: {
                        print("Sheet")
                        settingsSheet.toggle()
                    }, label: {
                        Image(systemName: "gearshape")
                            .foregroundColor(.iconColor)
                            .font(.title)
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
                .frame(width: 60, height: 60)
                .overlay(
                    Button(action: {
                        addUserQuoteSheet.toggle()
                    }, label: {
                        Image(systemName: "plus")
                            .foregroundColor(.iconColor)
                            .font(.title)
                    })
                    .sheet(isPresented: $addUserQuoteSheet, content: {
                        AddUserQuoteView(viewModel: CoreDataViewModel())
                    })
                )
                .onTapGesture {
                    addUserQuoteSheet.toggle()
                }
        }
        .padding(.leading, 280)
        .padding()
        
    }
}



