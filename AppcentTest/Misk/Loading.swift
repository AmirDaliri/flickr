//
//  Loading.swift
//  AppcentTest
//
//  Created by Amir Daliri on 5/9/20.
//  Copyright © 2020 Amir Daliri. All rights reserved.
//

import UIKit
import ACProgressHUD_Swift

class Loading: NSObject {
    
    class func show() {
        let progressView = ACProgressHUD.shared
        progressView.progressText = ""
        progressView.indicatorColor = .white
        //        progressView.backgroundColor = .clear
        progressView.hudBackgroundColor = .clear
        progressView.enableBackground = true
        progressView.backgroundColorAlpha = CGFloat(0.6)
        progressView.showHUD()
//        UIApplication.shared.isNetworkActivityIndicatorVisible = true
    }
    
    class func hide() {
        ACProgressHUD.shared.hideHUD()
//        UIApplication.shared.isNetworkActivityIndicatorVisible = false
    }
}

