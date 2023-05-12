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
    @State private var info: AlertInfo?
    @ObservedObject var networkManager = NetworkManager()
    @StateObject var viewModel = MotivationalViewModel()
    @StateObject var userViewModel = UserViewModel()
    init(viewModel: MotivationalViewModel) {
        self._viewModel = StateObject(wrappedValue: viewModel)
    }
    var body: some View {
        ZStack {
            VStack {
                if !userViewModel.isSubscribeActive {
                    googleAds
                } else {
                    Text("MotiQ")
                        .font(.custom("Avenir", size: 45))
                        .padding(.top)
                        .foregroundColor(.buttonColor)
                    
                    Spacer()
                }
                
            }
            HStack(alignment: .center) {
                
                if networkManager.isConnected {
                    quotesContainer
                        .font(.custom("Avenir", size: 24))
                        .multilineTextAlignment(.center)
                        .frame(maxWidth: 350)
                        .animation(.linear)
                        .alert(item: $info) { info in
                            Alert(title: Text(info.title).font(.custom("Avenir", size: 24)), message: Text(info.message), dismissButton: .default(Text("OK")))
                        }
                        .onLongPressGesture {
                            info = AlertInfo(id: .two, title: "Quote Saved!", message: "", dismissButton: .default(Text("OK")))
                            viewModel.saveQuote()
                        }
                    
                } else {
                    Text("No Internet Connection :((")
                }
            }
            .onAppear {
                info = AlertInfo(id: .one, title: "Usefull Tip!", message: "If you long press on a quote, It'll be saved!", dismissButton: .default(Text("Great!")))
            }
            .alert(item: $info) { info in
                Alert(title: Text(info.title), message: Text(info.message), dismissButton: info.dismissButton)
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
    
    var quotesContainer: some View {
        VStack(alignment: .center, spacing: 30) {
            Text("\"\(viewModel.q)\"")
            Text(viewModel.a)
        }
        .onTapGesture {
            viewModel.nextQuote()
        }
    }
}



