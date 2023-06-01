//
//  RewardAds.swift
//  MotiQ
//
//  Created by Darie-Nistor Nicolae on 31.05.2023.
//

import Foundation

import GoogleMobileAds

class RewardAd: NSObject, GADFullScreenContentDelegate {
    private var rewardedAds: GADRewardedAd?
    
    override init() {
            super.init()
            loadRequest()
        }
    
    func loadRequest() {
        let request = GADRequest()
        GADRewardedAd.load(withAdUnitID: "ca-app-pub-8739348674271989/9789078033", request: request) { [self] ad, error in
            if let error = error  {
                print("Failed to print ad: \(error.localizedDescription)")
                return
            }
            rewardedAds = ad
            rewardedAds?.fullScreenContentDelegate = self
        }
        func adDismissFullScreenContent(_ ad: GADFullScreenPresentingAd) {
            loadRequest()
        }
        
        func showRequest(viewController: UIViewController) {
            if rewardedAds != nil {
                rewardedAds?.present(fromRootViewController: viewController, userDidEarnRewardHandler: {
                    let reward = self.rewardedAds?.adReward
                    print("\(reward!.amount) \(reward!.type )")
                })
            }
        }
    }
    
    func show(viewController: UIViewController) {
        if let ad = rewardedAds {
            ad.present(fromRootViewController: viewController) {
                let reward = ad.adReward
                print("Reward received with currency \(reward.amount), amount \(reward.amount.doubleValue)")
                // TODO: Reward the user.
            }
        } else {
            print("Ad wasn't ready")
        }
    }

    
    /// Tells the delegate that the ad failed to present full screen content.
      func ad(_ ad: GADFullScreenPresentingAd, didFailToPresentFullScreenContentWithError error: Error) {
        print("Ad did fail to present full screen content.")
      }

      /// Tells the delegate that the ad will present full screen content.
      func adWillPresentFullScreenContent(_ ad: GADFullScreenPresentingAd) {
        print("Ad will present full screen content.")
      }

      /// Tells the delegate that the ad dismissed full screen content.
      func adDidDismissFullScreenContent(_ ad: GADFullScreenPresentingAd) {
        print("Ad did dismiss full screen content.")
      }
    
    
}
