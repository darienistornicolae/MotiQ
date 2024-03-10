import SwiftUI
import UIKit

struct CustomTextFieldComponent: UIViewRepresentable {
  
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
