import SwiftUI
import RevenueCat

struct AddUserQuoteView: View {

  @StateObject private var viewModel = UserCoreDataViewModel()
  @StateObject private var userViewModel = UserViewModel()
  @State private var userQuote: String = "Patience, persistence and perspiration make an unbeatable combination for success"
  @State private var userAuthor: String = "Napoleon Hill"
  @State private var isPressed: Bool = false
  @Environment(\.presentationMode) private var presentationMode

  init(viewModel: @autoclosure @escaping () ->  UserCoreDataViewModel,
       userViewModel: @autoclosure @escaping () ->  UserViewModel) {
    self._viewModel = StateObject(wrappedValue: viewModel())
    self._userViewModel = StateObject(wrappedValue: userViewModel())
  }

  var body: some View {
    addUserQuoteContainer
  }
}

struct AddUserQuoteView_Previews: PreviewProvider {
  static var previews: some View {
    AddUserQuoteView(viewModel: UserCoreDataViewModel(), userViewModel: UserViewModel())
  }
}

fileprivate extension AddUserQuoteView {
  var addUserQuoteContainer: some View {
    NavigationView {
      VStack() {
        Form {
          Section(header: Text("Add Quote"), footer: Text("")) {
            CustomTextFieldComponent(input: $userQuote, placeholder: "Write your quote...")
              .frame(height: 100)
              .multilineTextAlignment(.leading)
            CustomTextFieldComponent(input: $userAuthor, placeholder: "Author")
            Button {
              guard !userQuote.isEmpty else { return }
              viewModel.addUserQuote(quote: userQuote, author: userAuthor)
              userQuote = "Your Quote"
              userAuthor = "Author"
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
                  Alert(title: Text("Quote Saved!").font(.custom("Avenir", size: 24)),
                        message: nil,
                        dismissButton: .default(Text("OK")))
                }
            }
          }
          .onAppear {
            userViewModel.checkSubscriptionStatus()
          }
          if !userViewModel.isSubscribeActive {
            bannerAdd
          }
        }
      }
      .navigationBarTitle("Add Quote", displayMode: .inline)
    }
  }

  var bannerAdd: some View {
    BannerAd(unitID: "ca-app-pub-8739348674271989/8823793414")
      .frame(width: 400, height: 300)
  }
}
