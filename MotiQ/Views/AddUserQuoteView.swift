//
//  AddUserQuoteView.swift
//  MotiQ
//
//  Created by Darie-Nistor Nicolae on 30.03.2023.
//

import SwiftUI

struct AddUserQuoteView: View {
    
    //MARK: PROPERTIES
    @StateObject var viewModel = UserCoreDataViewModel()
    @StateObject var userViewModel = UserViewModel()
    @State var userQuote: String = "Patience, persistence and perspiration make an unbeatable combination for success"
    @State var userAuthor: String = "Napoleon Hill"
    @State private var isPressed: Bool = false
    @Environment(\.presentationMode) var presentationMode
    init(viewModel: UserCoreDataViewModel) {
        self._viewModel = StateObject(wrappedValue: viewModel)
    }
    
    var body: some View {
        addUserQuoteContainer
    }
}

struct AddUserQuoteView_Previews: PreviewProvider {
    static var previews: some View {
        AddUserQuoteView(viewModel: UserCoreDataViewModel())
    }
}

fileprivate extension AddUserQuoteView {
    var addUserQuoteContainer: some View {
        NavigationView {
            VStack() {
                Form {
                    Section(header: Text("Add Quote"), footer: Text("")) {
                        FirstResponderTextField(input: $userQuote, placeholder: "Write your quote...")
                            .frame(height: 100)
                            .multilineTextAlignment(.leading)
                        FirstResponderTextField(input: $userAuthor, placeholder: "Author")
                        Button {
                            guard !userQuote.isEmpty else { return }
                            viewModel.addUserQuote(quote: userQuote, author: userAuthor)
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
                    if !userViewModel.isSubscribeActive {
                        bannerAdd
                    }
                }
            }
        }
    }
    
    var bannerAdd: some View {
        BannerAd(unitID: "ca-app-pub-8739348674271989/8823793414")
            .frame(width: 400, height: 300)
    }
}

struct FirstResponderTextField: UIViewRepresentable {
    
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

