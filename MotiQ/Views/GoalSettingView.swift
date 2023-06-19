//
//  GoalSettingView.swift
//  MotiQ
//
//  Created by Darie-Nistor Nicolae on 15.06.2023.
//

import SwiftUI

struct GoalSettingView: View {
    var body: some View {
        NavigationView {
            
            VStack {
                CardView()
                    .padding(.top)
                Spacer()
            }
            
        }
        .navigationTitle("Goals")
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarItems(trailing: NavigationLink(destination: {
            AddGoalView(viewModel: GoalSettingViewModel())
        }, label: {
            Image(systemName: "plus")
                .foregroundColor(.buttonColor)
        }))
    }
}

struct GoalSettingView_Previews: PreviewProvider {
    static var previews: some View {
        AddGoalView(viewModel: GoalSettingViewModel())
    }
}

private struct CardView: View {
    var body: some View {
        VStack{
            Text("Title")
                .foregroundColor(.white)
            Text("Description")
                .foregroundColor(.white)
        }
        .frame(width: 300, height: 80)
        .background(Color.gray)
        .cornerRadius(10)
        
    }
}



