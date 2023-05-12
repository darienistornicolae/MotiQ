//
//  PayWallView.swift
//  MotiQ
//
//  Created by Darie-Nistor Nicolae on 08.04.2023.
//

import SwiftUI
import RevenueCat

struct PayWallView: View {
    
    @AppStorage("isDarkMode") private var isDarkMode: Bool = false
    @State var animate: Bool = false
    @State private var selectedOption: String = ""
    @State var currentOffering: Offering?
    @EnvironmentObject var userViewModel: UserViewModel
    @Environment(\.presentationMode) var presentationMode
    var body: some View {
        ScrollView {
            
            VStack() {
                Spacer()
                newsletterWhy
                features
                    .padding(.bottom)
                subscribeButton
                legalActs
                    .padding()
            }
            
        }
        .preferredColorScheme(isDarkMode ? .dark : .light)
        .onAppear {
            Purchases.shared.getOfferings { offerings, error in
                if let offer = offerings?.current, error == nil {
                    currentOffering = offer
                }
            }

        }
    }
}

struct PayWallView_Previews: PreviewProvider {
    static var previews: some View {
        PayWallView()
    }
}


fileprivate extension PayWallView {
    
    var subscribeButton: some View {
        VStack {
            if currentOffering != nil {
                ForEach(currentOffering!.availablePackages) { pkg in
 
                    Button(action: {
                        Purchases.shared.purchase(package: pkg) { transaction, customerInfo, error, userCancelled in
                            if customerInfo?.entitlements.all["Premium MotiQ"]?.isActive == true {
                                userViewModel.isSubscribeActive = true
                                presentationMode.wrappedValue.dismiss()
                            }
                        }
                    }, label: {
                        Text("Subscribe for only \(pkg.storeProduct.localizedPriceString)/\(pkg.storeProduct.subscriptionPeriod!.periodTitle) ")
                            .foregroundColor(.white)
                            .font(.headline)
                            .frame(height:55)
                            .frame(maxWidth: 350)
                            .background(Color.blue)
                            .cornerRadius(20)
                    })
                }
            }
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
            
            Text("Terms & Conditions")
                .underline()
                .foregroundColor(.blue)
                .onTapGesture {
                    if let url = URL(string: "https://motiq.org/terms") {
                        UIApplication.shared.open(url)
                    }
                }
        }
    }
}

