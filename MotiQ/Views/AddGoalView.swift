//
//  AddGoal.swift
//  MotiQ
//
//  Created by Darie-Nistor Nicolae on 19.06.2023.
//

import SwiftUI

struct AddGoalView: View {
    @StateObject var viewModel = UserGoalCoreDataViewModel()
    @State var sliderValue: Double = 0.5
    @State var userGoalTitle: String = ""
    @State var userGoalDescription: String = ""
    
    @State private var isPressed: Bool = false
    @Environment(\.presentationMode) var presentationMode
    @Environment(\.colorScheme) private var colorScheme
    
    var body: some View {
            addGoal
                .navigationBarTitle("Goals", displayMode: .inline)
        }
}
struct AddGoalView_Previews: PreviewProvider {
    static var previews: some View {
        AddGoalView(viewModel: UserGoalCoreDataViewModel())
    }
}

fileprivate extension AddGoalView {
    
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
                            .background(Color.gray)
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
                            .background(Color.gray)
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
                
                Slider(value: Binding(get: { sliderValue }, set: { sliderValue = $0 }))
                    .padding(.horizontal)
                
                Spacer()
                Button {
                    guard !userGoalDescription.isEmpty else { return }
                    viewModel.addUserGoal(goalTitle: userGoalTitle, goalDescription: userGoalDescription, goalProgress: sliderValue)
                    presentationMode.wrappedValue.dismiss()
                   
                } label: {
                    Text("Save")
                        .foregroundColor(.iconColor)
                        .font(.headline)
                        .frame(height:55)
                        .frame(maxWidth: .infinity)
                        .background(Color.buttonColor)
                        .cornerRadius(10)
                        .alert(isPresented: $isPressed) {
                            Alert(title: Text("Goal Saved!").font(.custom("Avenir", size: 24)), message: nil, dismissButton: .default(Text("OK")))
                            
                        }
                }
            }
            .padding()
        }
        
    }
    
    private func getProgressCircleColor() -> Color {
        let progress = sliderValue
        if progress < 0.05 {
            return colorScheme == .dark ? .black : .white
        } else if progress < 0.5 {
            return colorScheme == .dark ? Color("darkGray"): .gray
        } else if progress < 0.75 {
            return colorScheme == .dark ? .gray : Color(.darkGray)
        } else {
            return colorScheme == .dark ? .white : .black
        }
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
