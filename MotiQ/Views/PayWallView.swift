import SwiftUI
import RevenueCat

struct PayWallView: View {

  @AppStorage("isDarkMode") private var isDarkMode: Bool = false
  @State private var animate: Bool = false
  @State private var currentOffering: Offering?
  @State private var selectedPackageIdentifier: String?
  @State private var showAlert: Bool = false
  @EnvironmentObject private var userViewModel: UserViewModel
  @Environment(\.presentationMode) private var presentationMode

  var body: some View {
    VStack {

      ScrollView() {
        Spacer()
        newsletterWhy
        features
          .padding(.bottom)
        packageSelection
          .padding()
        subscribeButton
          .alert(isPresented: $showAlert, content: {
            Alert(title: Text("Thank you!"),
                  message: Text("Please, close the app from background and reopen it again, for the new content to start again ☺️"),
                  dismissButton: .default(Text("Ok")))
          })
        legalActs
          .padding()
      }
    }
    .navigationTitle("Premium Motiq")
    .navigationBarTitleDisplayMode(.inline)
    .preferredColorScheme(isDarkMode ? .dark : .light)
    .onAppear {
      makePayment()
    }
  }
}

struct PayWallView_Previews: PreviewProvider {
  static var previews: some View {
    PayWallView()
  }
}

fileprivate extension PayWallView {

  func makePayment() {
    Purchases.shared.getOfferings { offerings, error in
      if let offer = offerings?.current, error == nil {
        currentOffering = offer
      }
    }
  }

  var packageSelection: some View {
    HStack {
      if let offering = currentOffering {
        ForEach(offering.availablePackages) { pkg in
          Button(action: {
            selectedPackageIdentifier = pkg.identifier
          }) {
            VStack {
              if selectedPackageIdentifier == pkg.identifier {
                Image(systemName: "checkmark.circle.fill")
                  .foregroundColor(.white)
                  .font(.system(size: 30))
                  .padding(.bottom, 8)
              } else {
                Image(systemName: "circle")
                  .foregroundColor(.white)
                  .font(.system(size: 30))
                  .padding(.bottom, 8)
              }
              Text("\(pkg.storeProduct.localizedPriceString)/\(pkg.storeProduct.subscriptionPeriod!.periodTitle) ")
                .foregroundColor(Color.white)
                .font(.headline)
                .padding(.bottom, 4)
            }
            .frame(width: 120)
            .padding()
            .background(selectedPackageIdentifier == pkg.identifier ? Color.blue : Color.blue)
            .cornerRadius(10)
            .overlay(
              RoundedRectangle(cornerRadius: 10)
                .stroke(selectedPackageIdentifier == pkg.identifier ? Color.clear : Color.clear, lineWidth: 2)
            )
            .foregroundColor(.white)
            .padding(.bottom)
          }
        }
      }
    }
  }

  var subscribeButton: some View {
    Button(action: {
      if let identifier = selectedPackageIdentifier,
         let package = currentOffering?.availablePackages.first(where: { $0.identifier == identifier }) {
        Purchases.shared.purchase(package: package) { transaction, customerInfo, error, userCancelled in
          if customerInfo?.entitlements.all["Premium MotiQ"]?.isActive == true {
            userViewModel.isSubscribeActive = true
            UserDefaults.standard.set(true, forKey: "isPaywallShown")
            showAlert = true
          }
          presentationMode.wrappedValue.dismiss()
        }
      }
    }) {
      Text("Subscribe")
        .foregroundColor(.white)
        .font(.headline)
        .frame(height: 55)
        .frame(maxWidth: 300)
        .background(Color.blue)
        .cornerRadius(20)
    }
  }

  func addAnimation() {
    guard !animate else { return }
    DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
      withAnimation(
        Animation
          .easeInOut(duration: 1.5)
          .repeatForever()
      ) {
        animate.toggle()
      }
    }
  }

  var features: some View {
    VStack(alignment:.leading , spacing: 25) {
      Text("\(Image(systemName: "checkmark.seal")) No Ads 😇")
      Text("\(Image(systemName: "checkmark.seal")) Support the developer ❤️")
      Text("\(Image(systemName: "checkmark.seal")) Access to the newest features!")
      Text("\(Image(systemName: "checkmark.seal")) Custom Widgets (Soon) 👀")
      Text("\(Image(systemName: "checkmark.seal")) And many more!")
    }
    .padding(.top)
    .font(.title3)
  }

  var newsletterWhy: some View {
    ZStack {
      RoundedRectangle(cornerRadius: 20)
        .foregroundColor(Color.blue)
        .padding()
      
      VStack(alignment: .center) {
        Text("Exclusive Newsletter!")
          .fontWeight(.bold)
          .font(.title)
          .padding()
          .foregroundColor(.white)

        Text("Subscribe to our newsletter and take the first step towards a happier, healthier mind. Get expert insights and resources on mental health and psychology. Sign up today to start your journey towards greater self-awareness, emotional well-being, and personal growth.")
          .multilineTextAlignment(.leading)
          .font(.headline)
          .foregroundColor(.white)
        Spacer()
      }
      .padding(30)
    }
  }

  var legalActs: some View {
    HStack(alignment: .bottom, spacing: 40) {
      Text("Privacy Policy")
        .underline()
        .foregroundColor(.blue)
        .onTapGesture {
          if let url = URL(string: "https://motiq.org") {
            UIApplication.shared.open(url)
          }
        }

      Text("Terms")
        .underline()
        .foregroundColor(.blue)
        .onTapGesture {
          if let url = URL(string: "https://motiq.org/terms") {
            UIApplication.shared.open(url)
          }
        }

      Text("Eula")
        .underline()
        .foregroundColor(.blue)
        .onTapGesture {
          if let url = URL(string: "https://motiq.org/eula") {
            UIApplication.shared.open(url)
          }
        }
    }
  }
}

