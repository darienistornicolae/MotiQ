//
//  AddUserQuoteView.swift
//  MotiQ
//
//  Created by Darie-Nistor Nicolae on 30.03.2023.
//

import SwiftUI

struct AddUserQuoteView: View {
    
    @ObservedObject var viewModel = AddUserQuotesViewModel()
    @Environment(\.presentationMode) var presentationMode
    @State var alertTitle: String = ""
    @State var showAlert: Bool = false
    @State var userQuote: String = ""
    
    var body: some View {
        NavigationView {
            VStack() {
                Form {
                    Section(header: Text("Add Quote"), footer: Text("Here you can add your quote")) {
                        FirstResponderTextField(input: $userQuote, placeholder: "Write your quote...")
                        Button {
                            save()
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
                }
            }
            .navigationBarTitle("MotiQ", displayMode: .inline)
            .alert(isPresented: $showAlert) {
                getAlert()
            }
        }
    }
    
    func save() {
        if checkText() {
            
            viewModel.addItem(q: userQuote)
            presentationMode.wrappedValue.dismiss()
        }
    }
    
    func checkText() -> Bool {
        if userQuote.count < 3 {
            alertTitle = "Introduce at least 3 charts🖋"
            showAlert.toggle()
            return false
        }
        return true
    }
    
    func getAlert() -> Alert {
        return Alert(title: Text(alertTitle))
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

struct AddUserQuoteView_Previews: PreviewProvider {
    static var previews: some View {
        AddUserQuoteView()
    }
}
