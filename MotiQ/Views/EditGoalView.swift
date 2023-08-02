//
//  EditGoalView.swift
//  MotiQ
//
//  Created by Darie-Nistor Nicolae on 04.07.2023.
//

import SwiftUI

struct EditGoalView: View {
    @Environment(\.presentationMode) private var presentationMode
    @Environment(\.colorScheme) private var colorScheme
    @StateObject private var viewModel: UserGoalCoreDataViewModel
    @ObservedObject private var goal: UserGoalEntity
    @State private var userGoalTitle: String
    @State private var userGoalDescription: String
    @State private var sliderValue: Double

    init(goal: UserGoalEntity, viewModel: @autoclosure @escaping () -> UserGoalCoreDataViewModel ) {
        _viewModel = StateObject(wrappedValue: viewModel())
        _goal = ObservedObject(wrappedValue: goal)
        _userGoalTitle = State(wrappedValue: goal.goalTitle ?? "")
        _userGoalDescription = State(wrappedValue: goal.goalDescription ?? "")
        _sliderValue = State(wrappedValue: goal.goalProgress)
    }

    var body: some View {
        addGoal
            .navigationBarTitle("Edit Goal", displayMode: .inline)
    }
}

private extension EditGoalView {
    var addGoal: some View {
        ScrollView {
            VStack(spacing: 25) {
                Text("Title")
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.horizontal)
                    .font(.custom("Avenir Bold", size: 22))
                
                SecondResponderTextField(input: $userGoalTitle, placeholder: "")
                    .frame(height: 40)
                    .font(.custom("Avenir Bold", size: 26))
                    .padding(.horizontal)
                    .background(
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(Color.gray, lineWidth: 2)
                            .cornerRadius(10)
                    )
                
                Text("Description")
                    .font(.custom("Avenir Bold", size: 22))
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.horizontal)
                
                SecondResponderTextField(input: $userGoalDescription, placeholder: "Enter description")
                    .frame(height: 100)
                    .font(.custom("Avenir Bold", size: 26))
                    .padding(.horizontal)
                    .background(
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(Color.gray, lineWidth: 2)
                            .cornerRadius(10)
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
                        .frame(width: 150, height: 150, alignment: .center)
                        .rotationEffect(.degrees(-90))
                        .animation(.easeIn)
                    
                    Text("\(Int(sliderValue * 100))%")
                        .font(.title)
                        .fontWeight(.bold)
                }
                .padding(.top, 20)
                
                Slider(value: $sliderValue)
                    .padding(.horizontal)
                
                Spacer()
                Button(action: {
                    viewModel.updateUserGoal(
                        goal: goal,
                        newTitle: userGoalTitle,
                        newDescription: userGoalDescription,
                        newProgress: sliderValue
                    )
                    presentationMode.wrappedValue.dismiss()
                }, label: {
                    Text("Save")
                        .foregroundColor(.iconColor)
                        .font(.headline)
                        .frame(height: 55)
                        .frame(maxWidth: .infinity)
                        .background(Color.buttonColor)
                        .cornerRadius(10)
                })
            }
            .padding()
        }
    }

    private func getProgressCircleColor() -> Color {
        let progress = sliderValue
        if progress < 0.05 {
            return colorScheme == .dark ? .black : .white
        } else if progress < 0.5 {
            return colorScheme == .dark ? Color("darkGray") : .gray
        } else if progress < 0.75 {
            return colorScheme == .dark ? .gray : Color(.darkGray)
        } else {
            return colorScheme == .dark ? .white : .black
        }
    }
}


struct EditGoalView_Previews: PreviewProvider {
    static var previews: some View {
        EditGoalView(goal: UserGoalEntity(), viewModel: UserGoalCoreDataViewModel())
    }
}

private struct SecondResponderTextField: UIViewRepresentable {
    
    @Binding var input: String
    let placeholder: String
    
    class Coordinator: NSObject, UITextViewDelegate{
        @Binding var input: String
        
        init(input: Binding<String>) {
            self._input = input
        }
        
        func textViewDidChange(_ textView: UITextView) {
            input = textView.text
        }
    }
    
    func makeCoordinator() -> Coordinator {
        return Coordinator(input: $input)
    }
    
    func makeUIView(context: Context) -> UITextView {
        let textView = UITextView()
        textView.delegate = context.coordinator
        textView.text = input
        textView.font = UIFont.preferredFont(forTextStyle: .body)
        textView.isScrollEnabled = true
        textView.isEditable = true
        textView.backgroundColor = .clear
        return textView
    }
    
    func updateUIView(_ uiView: UITextView, context: Context) {
        if uiView.text != input {
            uiView.text = input
        }
    }
}
