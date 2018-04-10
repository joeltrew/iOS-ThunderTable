//
//  ApplicationLoadingIndicatorManager.swift
//  ThunderRequest
//
//  Created by Simon Mitchell on 13/04/2016.
//  Copyright © 2016 threesidedcube. All rights reserved.
//

import UIKit

@objc public class ApplicationLoadingIndicatorManager: NSObject {
    
    @objc public static let sharedManager = ApplicationLoadingIndicatorManager()
    private var activityCount = 0
        
    @objc public func showActivityIndicator() {
        
        objc_sync_enter(self)
        if activityCount == 0 {
            UIApplication.shared.isNetworkActivityIndicatorVisible = true
        }
        activityCount += 1
        objc_sync_exit(self)
    }
    
    @objc public func hideActivityIndicator() {
        
        objc_sync_enter(self)
        activityCount -= 1
        if activityCount <= 0 {
            UIApplication.shared.isNetworkActivityIndicatorVisible = false
        }
        objc_sync_exit(self)
    }
}
