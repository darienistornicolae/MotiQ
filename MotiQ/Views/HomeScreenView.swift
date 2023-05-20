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
    init(viewModel: MotivationalViewModel) {
        self._viewModel = StateObject(wrappedValue: viewModel)
    }
    var body: some View {
        ZStack {
            title
            
            HStack(alignment: .center) {
                
                if networkManager.isConnected {
                   QuotesContainerView(viewModel: MotivationalViewModel())
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
    
    var title: some View {
        VStack(){
            Text("Motiq")
                .font(.custom("Avenir", size: 40))
                .padding(.top)
                .foregroundColor(.buttonColor)
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



