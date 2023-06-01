//
//  InterstatialAd.swift
//  MotiQ
//
//  Created by Darie-Nistor Nicolae on 01.06.2023.
//

import Foundation
import SwiftUI
import GoogleMobileAds

class InterstitialAd: NSObject, GADFullScreenContentDelegate {
    private var interstitial: GADInterstitialAd?

    override init() {
        super.init()
        loadInterstitial()
    }

    func loadInterstitial() {
        let request = GADRequest()
        GADInterstitialAd.load(withAdUnitID: "ca-app-pub-8739348674271989/3414955962", request: request) { [self] ad, error in
            if let error = error {
                print("Failed to load interstitial ad with error: \(error.localizedDescription)")
                return
            }
            interstitial = ad
            interstitial?.fullScreenContentDelegate = self
        }
    }

    func showInterstitial(viewController: UIViewController) {
        if let ad = interstitial {
            ad.present(fromRootViewController: viewController)
        } else {
            print("Ad wasn't ready")
        }
    }

    // MARK: - GADFullScreenContentDelegate

    func adDidDismissFullScreenContent(_ ad: GADFullScreenPresentingAd) {
        print("Interstitial ad did dismiss full screen content.")
        loadInterstitial() // Load a new interstitial after it is dismissed
    }

    func ad(_ ad: GADFullScreenPresentingAd, didFailToPresentFullScreenContentWithError error: Error) {
        print("Interstitial ad failed to present full screen content with error: \(error.localizedDescription)")
    }
}
