//
//  PayWallView.swift
//  MotiQ
//
//  Created by Darie-Nistor Nicolae on 08.04.2023.
//

import SwiftUI
import RevenueCat

struct PayWallView: View {
    //TODO: Revenue Cat
    @State var animate: Bool = false
    @State private var selectedOption: String = ""
    @State var currentOffering: Offering?
    var body: some View {
        ScrollView {
            
            VStack() {
                Spacer()
                newsletterWhy
                features
                subscribeButton
                legalActs
            }
            .navigationTitle("Premium MotiQ")
            .navigationBarTitleDisplayMode(.large)
            
        }
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
    
//    func purchases(selectedOption: Binding<String>) -> some View {
//        HStack {
//            Button(action: {
//                selectedOption.wrappedValue = "Annually"
//            }, label: {
//                ZStack {
//                    RoundedRectangle(cornerRadius: 20)
//                        .foregroundColor(Color.blue)
//                        .frame(width: 125, height: 125)
//                    Text("Annually")
//                        .padding(.bottom, 80)
//                    Text("14.99$")
//                        .font(.title)
//                    Text("59.99$")
//                        .strikethrough(true)
//                        .padding(.top,70)
//                }
//                .padding(.trailing)
//                .foregroundColor(.white)
//            })
//
//            Button(action: {
//                selectedOption.wrappedValue = "Monthly"
//            }, label: {
//                ZStack {
//                    RoundedRectangle(cornerRadius: 20)
//                        .foregroundColor(Color.blue)
//                        .frame(width: 125, height: 125)
//                    Text("Monthly")
//                        .padding(.bottom, 80)
//                    Text("2.99$")
//                        .font(.title)
//                    Text("4.99$")
//                        .strikethrough(true)
//                        .padding(.top,70)
//                }
//                .padding(.leading)
//                .foregroundColor(.white)
//            })
//        }
//    }
    
    var subscribeButton: some View {
        VStack {
            if currentOffering != nil {
                ForEach(currentOffering!.availablePackages) { pkg in
 
                    Button(action: {
                        Purchases.shared.purchase(package: pkg) { transaction, customerInfo, error, userCancelled in
                            if customerInfo?.entitlements.all["premium"]?.isActive == true {
                                
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
                    .disabled(selectedOption.isEmpty)
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
            Text("\(Image(systemName: "checkmark.seal")) Offline mode (Soon)")
            Text("\(Image(systemName: "checkmark.seal")) Sync Saved Quotes 🛜 (Soon)")
            Text("\(Image(systemName: "checkmark.seal")) iPad&WatchOS app⌚️ (Soon)")
            
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

