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
    @State private var isAlertShown: Bool = false

    
    var body: some View {
        
        TabView(selection: .constant(0)) {
            
            SettingsView()
                .tabItem {
                    Image(systemName: "gearshape")
                    Text("Settings")
                }
                .tag(1)
            
            QuotesContainerView(userViewModel: UserViewModel())
                .tabItem {
                    Image(systemName: "quote.bubble")
                    Text("Quotes")
                }
                .tag(0)
                .onAppear {
                    if !isAlertShown {
                        info = AlertInfo(id: .one, title: "Useful Tip", message: "Swipe left to go to the next quote!", dismissButton: .default(Text("Great!")))
                        isAlertShown = true
                    }
                }
                .alert(item: $info) { info in
                    Alert(title: Text(info.title), message: Text(info.message), dismissButton: info.dismissButton)
                }
            AddUserQuoteView(viewModel: UserCoreDataViewModel())
                .tabItem {
                    Image(systemName: "plus")
                    Text("Add Quote")
                }
                .tag(2)
        }
        .accentColor(.buttonColor)
    }
}




struct HomeScreenView_Previews: PreviewProvider {
    static var previews: some View {
        HomeScreenView()
    }
}


fileprivate extension HomeScreenView {
    
    
    var menuButton: some View {
        VStack() {
            Spacer()
            Button(action: {
                print("Sheet")
                settingsSheet.toggle()
            }, label: {
                Image(systemName: "gearshape")
                    .foregroundColor(.buttonColor)
                    .font(.title)
            })
            .sheet(isPresented: $settingsSheet, content: {
                SettingsView()
            })
            
        }
        .padding(.trailing, 280)
        .padding()
    }
    
    var addText: some View {
        VStack() {
            Spacer()
            Button(action: {
                addUserQuoteSheet.toggle()
            }, label: {
                Image(systemName: "plus")
                    .foregroundColor(.buttonColor)
                    .font(.title)
            })
            .sheet(isPresented: $addUserQuoteSheet, content: {
                AddUserQuoteView(viewModel: UserCoreDataViewModel())
            })
            
            .onTapGesture {
                addUserQuoteSheet.toggle()
            }
        }
        .padding(.leading, 280)
        .padding()
        
    }
}



