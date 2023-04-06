//
//  AddUserQuoteView.swift
//  MotiQ
//
//  Created by Darie-Nistor Nicolae on 30.03.2023.
//

import SwiftUI

struct AddUserQuoteView: View {
    
    //MARK: PROPERTIES
    @StateObject var viewModel = CoreDataViewModel()
    @State var userQuote: String = ""
    @State private var isPressed: Bool = false
    @Environment(\.presentationMode) var presentationMode
    init(viewModel: CoreDataViewModel) {
        self._viewModel = StateObject(wrappedValue: viewModel)
    }
    
    var body: some View {
        NavigationView {
            VStack() {
                Form {
                    Section(header: Text("Add Quote"), footer: Text("Here you can add your quote")) {
                        FirstResponderTextField(input: $userQuote, placeholder: "Write your quote...")
                        Button {
                            guard !userQuote.isEmpty else { return }
                            viewModel.addQuote(quote: userQuote, author: "Your Quote")
                            userQuote = ""
                            presentationMode.wrappedValue.dismiss()
                            withAnimation {
                                isPressed = true
                            }
                        } label: {
                            Text("Save")
                                .foregroundColor(.iconColor)
                                .font(.headline)
                                .frame(height:55)
                                .frame(maxWidth: .infinity)
                                .background(Color.buttonColor)
                                .cornerRadius(10)
                                .alert(isPresented: $isPressed) {
                                    Alert(title: Text("Quote Saved!").font(.custom("Avenir", size: 24)), message: nil, dismissButton: .default(Text("OK")))
                                    
                                }
                            
                        }
                        
                        
                    }
                }
            }
            .navigationBarTitle("MotiQ", displayMode: .inline)
        }
    }
}

struct AddUserQuoteView_Previews: PreviewProvider {
    static var previews: some View {
        AddUserQuoteView(viewModel: CoreDataViewModel())
    }
}

struct FirstResponderTextField: UIViewRepresentable {
    
    @Binding var input: String
    let placeholder: String
    
    class Coordinator:NSObject, UITextFieldDelegate {
        @Binding var input: String
        var becameFirstResponder = false
        
        init(input: Binding<String> ) {
            self._input = input
        }
        
        func textFieldDidChangeSelection(_ textField: UITextField) {
            input = textField.text ?? ""
        }
    }
    
    func makeCoordinator() -> Coordinator {
        return Coordinator(input: $input)
    }
    
    func makeUIView(context: Context) -> some UIView {
        let textField = UITextField()
        textField.delegate = context.coordinator
        textField.placeholder = placeholder
        return textField
        
    }
    
    func updateUIView(_ uiView: UIViewType, context: Context) {
        if !context.coordinator.becameFirstResponder {
            uiView.becomeFirstResponder()
            context.coordinator.becameFirstResponder = true
        }
    }
}
