//
//  PayWallView.swift
//  MotiQ
//
//  Created by Darie-Nistor Nicolae on 08.04.2023.
//

import SwiftUI

struct PayWallView: View {
    
    //TODO: Revenue Cat
    
    @Environment(\.presentationMode) private var presentationMode
    @State var animate: Bool = false
    var body: some View {
        ScrollView {
            
            VStack() {
                newsletterWhy
                features
                purchaseButton
                legalActs
                    .padding()
            }
            
            .navigationTitle("Premium MotiQ")
            .navigationBarTitleDisplayMode(.large)
            .onAppear {
                addAnimation()
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
            Text(" No Ads 😇")
            Text(" Support the developer ❤️")
            Text(" Widgets (future) 👀")
            Text(" Offline mode (future)")
            Text(" Sync Saved Quotes 🛜")
            
        }
        .padding(.top)
        .font(.title3)
    }
    
    var newsletterWhy: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 20)
                .foregroundColor(Color.blue.opacity(0.2))
                .padding()
            
            VStack(alignment: .center) {
                Text("Exclusive Newsletter!")
                    .fontWeight(.bold)
                    .font(.title)
                    .padding()
                Text("Subscribe to our newsletter and take the first step towards a happier, healthier mind. Get expert insights and resources on mental health and psychology. Sign up today to start your journey towards greater self-awareness, emotional well-being, and personal growth.")
                    .multilineTextAlignment(.leading)
                    .font(.headline)
                Spacer()
            }
            .padding(30)
            
        }
    }
    
    var purchaseButton: some View {
        HStack{
            Button {
                print("Confirmed")
            } label: {
                Text("Subscribe for 2.99$/month🥳")
                    .foregroundColor(.white)
                    .font(.headline)
                    .frame(height: 55)
                    .frame(maxWidth: .infinity)
                    .background(animate ? .accentColor : Color.accentColor)
                    .cornerRadius(15)
                    .padding(.top, 40)
            }
            .padding(.horizontal, animate ? 30 : 50)
            
            .scaleEffect(animate ? 1.0 : 1.1)
            .offset(y: animate ? -7 : 0)
            
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

