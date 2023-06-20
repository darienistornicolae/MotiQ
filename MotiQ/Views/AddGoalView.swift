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
        NavigationView {
            VStack(spacing: 25) {
                Form{
                Text("Title")
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.horizontal)
                    .font(.custom("Avenir Bold", size: 22))
                
                SecondResponderTextField(input: $viewModel.title, placeholder: "")
                    .frame(height: 40)
                    .font(.custom("Avenir Bold", size: 26))
                    .padding(.horizontal)
                    .background(
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(Color.gray, lineWidth: 2)
                    )
                
                Text("Description")
                    .font(.custom("Avenir Bold", size: 22))
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.horizontal)
                
                SecondResponderTextField(input: $viewModel.description, placeholder: "Enter description")
                    .frame(height: 100)
                    .font(.custom("Avenir Bold", size: 26))
                    .padding(.horizontal)
                    .background(
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(Color.gray, lineWidth: 2)
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
                        .foregroundColor(.blue)
                        .fontWeight(.bold)
                }
                .padding(.top, 20)
                .padding(.leading, 70)
                
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
            }}
            .padding()
        }
        
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

struct SecondResponderTextField: UIViewRepresentable {
    
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
