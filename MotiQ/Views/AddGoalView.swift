//
//  AddGoal.swift
//  MotiQ
//
//  Created by Darie-Nistor Nicolae on 19.06.2023.
//

import SwiftUI

struct AddGoalView: View {
@StateObject var viewModel = GoalSettingViewModel()
@State private var sliderValue: Double = 0.5

init(viewModel: GoalSettingViewModel) {
    self._viewModel = StateObject(wrappedValue: viewModel)
}

var body: some View {
    addGoal
        .navigationBarTitle("Goals", displayMode: .inline)
}


}
struct AddGoalView_Previews: PreviewProvider {
    static var previews: some View {
        AddGoalView(viewModel: GoalSettingViewModel())
    }
}

extension AddGoalView {
    var addGoal: some View {
        VStack(spacing: 20) {
            
            Text("Title")
                .font(.custom("Avenir Bold", size: 26))
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.horizontal)

            TextField("Enter title", text: $viewModel.title)
                .accentColor(.black)
                .font(.custom("Avenir Bold", size: 26))
                .frame(height: 40)
                .padding(.horizontal)
                .background(
                    RoundedRectangle(cornerRadius: 20)
                        .stroke(Color.black, lineWidth: 2)
                )

            Text("Description")
                .font(.custom("Avenir Bold", size: 26))
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.horizontal)

            TextField("Enter description", text: $viewModel.description)
                .accentColor(.black)
                .font(.custom("Avenir Bold", size: 26))
                .frame(height: 40)
                .padding(.horizontal)
                .background(
                    RoundedRectangle(cornerRadius: 20)
                        .stroke(Color.black, lineWidth: 2)
                )

            Text("Completion")
                .font(.custom("Avenir Bold", size: 26))
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.horizontal)
                .padding(.top)

            ZStack {

                Circle()
                    .trim(from: 0, to: CGFloat(sliderValue))
                    .stroke(getProgressCircleColor(), style: StrokeStyle(lineWidth: 20, lineCap:
                            .round, lineJoin: .round))
                    .frame(width: 150, height: 150)
                    .rotationEffect(.degrees(-90))
                    .animation(.easeIn)

                Text("\(Int(sliderValue * 100))%")
                    .font(.title)
                    .foregroundColor(.blue)
                    .fontWeight(.bold)
            }
            .padding(.top, 20)

            Slider(value: Binding(get: { sliderValue }, set: { sliderValue = $0 }))
                .padding(.horizontal)

            Spacer()
            Button {
                print("ds")
            } label: {
                Text("Save")
                    .foregroundColor(.iconColor)
                    .font(.headline)
                    .frame(height:55)
                    .frame(maxWidth: .infinity)
                    .background(Color.buttonColor)
                    .cornerRadius(10)
            }
        }
        .padding()
    }
    
    private func getProgressCircleColor() -> Color {
        let progress = sliderValue
        if progress < 0.15 {
            return .white
        } else if progress < 0.5 {
            return .gray
        } else if progress < 0.75 {
            return Color(.darkGray)
        } else {
            return .black
        }
    }
}
