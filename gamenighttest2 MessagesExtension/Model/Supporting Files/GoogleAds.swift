//
//  GoogleAds.swift
//  It's Game Night App
//
//  Created by Daimen Ambers on 1/6/25.
//

import GoogleMobileAds

struct GoogleAdsManager {
    // Test ads
    let testBanner = "ca-app-pub-3940256099942544/2435281174"
    let testInterstitial = "ca-app-pub-3940256099942544/4411468910"
    
    // Productions Google Ads
    // Add your Google Ad IDs
//    let appID = "<appID>"
//    let banner = "<banner>"
//    let interstitial = "<interstitial>"
    
    var controller: UIViewController
    private var view: UIView {
        controller.view
    }
    
    private var viewWidth: CGFloat? {
        return view.frame.inset(by: view.safeAreaInsets).width
    }
    
    private var adaptiveSize: GADAdSize {
        if let viewWidth = self.viewWidth {
            return GADCurrentOrientationAnchoredAdaptiveBannerAdSizeWithWidth(viewWidth)
        } else {
            return GADAdSize(size: CGSize(width: 350, height: 50), flags: 0)
        }
    }
    
    func createBannerAd() -> GADBannerView {
        var bannerView = GADBannerView()
        bannerView = GADBannerView(adSize: adaptiveSize)
        bannerView.adUnitID = self.testBanner
        return bannerView
    }
}

extension UIViewController {
    func addBannerViewToView(_ bannerView: GADBannerView) {
        bannerView.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(bannerView)
        // This example doesn't give width or height constraints, as the provided
        // ad size gives the banner an intrinsic content size to size the view.
        self.view.addConstraints(
            [NSLayoutConstraint(item: bannerView,
                                attribute: .bottom,
                                relatedBy: .equal,
                                toItem: view.safeAreaLayoutGuide,
                                attribute: .bottom,
                                multiplier: 1,
                                constant: 0),
             NSLayoutConstraint(item: bannerView,
                                attribute: .centerX,
                                relatedBy: .equal,
                                toItem: view,
                                attribute: .centerX,
                                multiplier: 1,
                                constant: 0)
            ])
    }
}
