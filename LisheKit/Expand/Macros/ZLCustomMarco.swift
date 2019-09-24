//
//  ZLCustomMarco.swift
//  LisheKit
//
//  Created by lishe on 2019/9/24.
//  Copyright © 2019 lishe. All rights reserved.
//

import Foundation
import UIKit


// MARK: - ========= 第三方key secret ==========
///友盟分享
let USHARE_APPKEY = "5965e97999f0c73e83000482"


//QQ
let kTencent_APPkey   = "1109903750"
let kTencent_APPSecret = "LuPx0dBOm5eyiK7W"


//WeChat
//测试、开发、演示环境
let kWX_APPID              = "wxdbb1fa00db32fb89"
let kWX_AppSecret          = "2be2ab6b1fa855d77ba7bf2a96cb0c53"
//生产环境
let kWX_APPID_PRODUCT      = "wxdbb1fa00db32fb89"
let kWX_AppSecret_PRODUCT  = "2be2ab6b1fa855d77ba7bf2a96cb0c53"


///激光推送
let JpushAppKey = ""
let JpushChanel = "AppStore"

/// kAppId
let kAppId      = "1476807293"

// MARK: ========= 占位图 ==========
let PlaceHolder_Media       = UIImage(named: "earnings_imag_media")
let PlaceHolder_StoreLog    = UIImage(named: "image_store_40")
let PlaceHolder_40          = UIImage(named: "image_40")
let PlaceHolder_50          = UIImage(named: "image_50")
let PlaceHolder_60          = UIImage(named: "image_60")
let PlaceHolder_80          = UIImage(named: "image_80")
let PlaceHolder_100         = UIImage(named: "image_100")
let PlaceHolder_173         = UIImage(named: "image_173")
let PlaceHolder_375         = UIImage(named: "image_375")
let PlaceHolder_130_100     = UIImage(named: "image_130x100")
let PlaceHolder_172_95      = UIImage(named: "image_172x95")
let PlaceHolder_172_200     = UIImage(named: "image_172x200")
let PlaceHolder_270_90      = UIImage(named: "image_270x90")
let PlaceHolder_355_146     = UIImage(named: "image_355x146")
let PlaceHolder_355_166     = UIImage(named: "image_355x166")
let PlaceHolder_Header      = UIImage(named: "profile_imag_default")



// MARK: ========= 主要颜色 ==========
/// 背景颜色
func ZLBgColor() -> UIColor {
    return RGBAColor(r:245, g: 245, b: 245, a: 1)
}

/// 主色调
func ZLMainColor() -> UIColor {
    return RGBAColor(r:255, g: 78, b: 66, a: 1)
}

/// 主要字体黑色色
func ZLBlackTextColor() -> UIColor {
    return RGBAColor(r:51, g: 51, b: 51, a: 1)
}

/// 主要字体灰色
func ZLDarkGrayTextColor() -> UIColor {
    return RGBAColor(r:102, g: 102, b: 102, a: 1)
}

/// 主要字体灰色
func ZLGrayTextColor() -> UIColor {
    return RGBAColor(r:153, g: 153, b: 153, a: 1)
}

/// 主要字体颜色
func ZLSeperateColor() -> UIColor {
    return RGBAColor(r:240, g: 240, b: 240, a: 1)
}

func ZLGlobalRedColor() -> UIColor {
    return RGBAColor(r:196, g: 73, b: 67, a: 1)
}

func ZLBlueFontColor() -> UIColor {
    return RGBAColor(r: 72, g: 100, b: 149, a: 1)
}


