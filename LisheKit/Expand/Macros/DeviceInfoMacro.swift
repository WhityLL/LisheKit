//
//  DeviceMacro.swift
//  TodayNew_Swift
//
//  Created by LiuLei on 2018/10/8.
//  Copyright © 2018年 LiuLei. All rights reserved.
//

import Foundation
import UIKit

// MARK: ========= DeviceInfo ==========
/// 屏幕的宽
let SCREEN_WIDTH = UIScreen.main.bounds.size.width
/// 屏幕的高
let SCREEN_HEIGHT = UIScreen.main.bounds.size.height

/// iPhone4
let isIphone4 = SCREEN_HEIGHT  < 568 ? true : false
/// iPhone 5
let isIphone5 = SCREEN_HEIGHT  == 568 ? true : false
/// iPhone 6
let isIphone6 = SCREEN_HEIGHT  == 667 ? true : false
/// iphone 6P
let isIphone6P = SCREEN_HEIGHT == 736 ? true : false
/// iphone X_XS
let isIphoneX_XS = SCREEN_HEIGHT == 812 ? true : false
/// iphone XR_XSMax
let isIphoneXR_XSMax = SCREEN_HEIGHT == 896 ? true : false
/// 全面屏
let isFullScreen = (isIphoneX_XS || isIphoneXR_XSMax)

let kStatusBarHeight : CGFloat = isFullScreen ? 44 : 20
let kNavigationBarHeight : CGFloat =  44
let kStatusBarAndNavigationBarHeight : CGFloat = isFullScreen ? 88 : 64
let kBottomSafeMargin : CGFloat = isFullScreen ? 34 : 0
let kTabbarHeight : CGFloat = isFullScreen ? 49 + 34 : 49

// MARK: ========= 屏幕适配 ==========
let  kScaleX : Float = Float(SCREEN_WIDTH / 375.0)
let  kScaleY : Float = Float(SCREEN_HEIGHT / 667.0)
///适配后的宽度
func AdaptedWidth(w : Float) -> Float {
    return ceilf(w * kScaleX)
}
///适配后的高度
func AdaptedHeight(h : Float) -> Float {
    return ceilf(h * kScaleY)
}

// MARK: ========= app信息 ==========
struct AppInfo {
    
    static let infoDictionary = Bundle.main.infoDictionary
    
    static let appDisplayName: String = Bundle.main.infoDictionary!["CFBundleDisplayName"] as! String //App 名称
    
    static let bundleIdentifier:String = Bundle.main.bundleIdentifier! // Bundle Identifier
    
    static let appVersion:String = Bundle.main.infoDictionary! ["CFBundleShortVersionString"] as! String// App 版本号
    
    static let buildVersion : String = Bundle.main.infoDictionary! ["CFBundleVersion"] as! String //Bulid 版本号
    
    static let iOSVersion:String = UIDevice.current.systemVersion //ios 版本
    
    static let identifierNumber = UIDevice.current.identifierForVendor //设备 udid
    
    static let systemName = UIDevice.current.systemName //系统名称  e.g. @"iOS"
    
    static let model = UIDevice.current.model //设备名称 e.g. @"iPhone", @"iPod touch"
    
    static let localizedModel = UIDevice.current.localizedModel  //设备区域化型号
}

let CurrentLanguage = NSLocale.preferredLanguages[0]

/// 获取启动图
func getProjectLaunchImage() -> UIImage? {
    let viewSize = UIScreen.main.bounds.size
    var viewOrientation: String = ""
    if UIApplication.shared.statusBarOrientation == .portraitUpsideDown || UIApplication.shared.statusBarOrientation == .portrait {
        viewOrientation = "Portrait"
    } else {
        viewOrientation = "Landscape"
    }
    

    guard let tmpLaunchImages = Bundle.main.infoDictionary!["UILaunchImages"] as? [Any]  else {
        return nil
    }

    var launchImageName = ""
    for dict in tmpLaunchImages {
        if let someDict = dict as? [String: Any] {
            let imageSize = NSCoder.cgSize(for: someDict["UILaunchImageSize"] as! String)
            if __CGSizeEqualToSize(viewSize, imageSize) && viewOrientation == someDict["UILaunchImageOrientation"] as! String {
                launchImageName = someDict["UILaunchImageName"] as! String
            }
        }
    }
    return UIImage(named: launchImageName)!
}
