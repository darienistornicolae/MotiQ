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
    @State private var offset: CGSize = .zero
    
    var body: some View {
        ZStack {
            title
            
            HStack(alignment: .center) {
                QuotesContainerView(viewModel: MotivationalViewModel())
                
            }
            .onAppear {
                info = AlertInfo(id: .one, title: "Usefull Tip", message: "Swipe left to go to the next quote!", dismissButton: .default(Text("Great!")))
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
        HomeScreenView()
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
            Button(action: {
                print("Sheet")
                settingsSheet.toggle()
            }, label: {
                Image(systemName: "gearshape")
                    .foregroundColor(.buttonColor)
                    .font(.title)
            })
            .sheet(isPresented: $settingsSheet, content: {
                SettingsSheet()
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



