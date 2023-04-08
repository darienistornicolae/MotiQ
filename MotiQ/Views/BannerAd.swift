//
//  BannerAd.swift
//  MotiQ
//
//  Created by Darie-Nistor Nicolae on 07.04.2023.
//

import SwiftUI
import GoogleMobileAds

struct BannerAd: UIViewRepresentable {

    var unitID: String
    
    func makeCoordinator() -> Coordinator {
        
        return Coordinator()
    }
    
    func makeUIView(context: Context) -> GADBannerView {
        let adView = GADBannerView(adSize: GADAdSizeBanner)
        let request = GADRequest()
        
        request.scene = adView.window?.windowScene
        adView.adUnitID = unitID
        adView.rootViewController = UIApplication.shared.getRootViewController()
        adView.delegate = context.coordinator
        adView.load(request)

        return adView
    }
    
    func updateUIView(_ uiView: GADBannerView, context: Context) {
        
    }
    
    class Coordinator: NSObject, GADBannerViewDelegate { 
        func bannerViewDidReceiveAd(_ bannerView: GADBannerView) {
          bannerView.alpha = 0
          UIView.animate(withDuration: 1, animations: {
            bannerView.alpha = 1
          })
        }

        func bannerView(_ bannerView: GADBannerView, didFailToReceiveAdWithError error: Error) {
          print("bannerView:didFailToReceiveAdWithError: \(error.localizedDescription)")
        }

        func bannerViewDidRecordImpression(_ bannerView: GADBannerView) {
          print("bannerViewDidRecordImpression")
        }

        func bannerViewWillPresentScreen(_ bannerView: GADBannerView) {
          print("bannerViewWillPresentScreen")
        }

        func bannerViewWillDismissScreen(_ bannerView: GADBannerView) {
          print("bannerViewWillDIsmissScreen")
        }

        func bannerViewDidDismissScreen(_ bannerView: GADBannerView) {
          print("bannerViewDidDismissScreen")
        }
    }
}

extension UIApplication {
    func getRootViewController() -> UIViewController {
        guard let screen = self.connectedScenes.first as? UIWindowScene else {
            return.init()
        }
        
        guard let root = screen.windows.first?.rootViewController else {
            return.init()
        }
        return root
    }

}
