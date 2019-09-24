//
//  ZL_ShareModel.swift
//  LiShePlus
//
//  Created by lishe on 2019/5/8.
//  Copyright © 2019 lishe. All rights reserved.
//

import UIKit

// 分享UI视图模型
struct ZLSharePlatformItemModel {
    var icon: String = ""
    var title: String = ""
    var platform: UMSocialPlatformType = .unKnown
}

enum UMS_SHARE_TYPE : Int{
    case UMS_SHARE_TYPE_TEXT = 0
    case UMS_SHARE_TYPE_IMAGE
    case UMS_SHARE_TYPE_IMAGE_URL
    case UMS_SHARE_TYPE_TEXT_IMAGE
    case UMS_SHARE_TYPE_WEB_LINK
    case UMS_SHARE_TYPE_MUSIC_LINK
    case UMS_SHARE_TYPE_MUSIC
    case UMS_SHARE_TYPE_VIDEO_LINK
    case UMS_SHARE_TYPE_VIDEO
    case UMS_SHARE_TYPE_EMOTION
    case UMS_SHARE_TYPE_FILE
    case UMS_SHARE_TYPE_MINI_PROGRAM
}

// 分享数据模型
class ZLShareModel: NSObject {
    
    var shareType: UMS_SHARE_TYPE = UMS_SHARE_TYPE.UMS_SHARE_TYPE_WEB_LINK
    /// 分享标题
    var title: String = ""
    /// 分享说明内容
    var text: String = ""
    /// 分享的链接
    var web_link: String = ""
    /// 小图标
    var thumb_image: Any = ""
    //  分享图片地址
    var shareImage: Any = ""
    //  分享图片链接地址
    var shareImageLinkURL: String = "https://mobile.umeng.com/images/pic/home/social/img-1.png"
    
    /// 小程序标题
    var miniProgramTitle: String = "礼舍商城小程序"
    var webpageUrl: String = ""
    var userName: String = ""
    var path: String = ""
    
    
    override init() {
        super.init()
        self.title = "礼舍"
       
        self.text = "我在礼舍发现了好商品，快来看看吧"
        self.web_link = "https://www.lishe.cn"
        self.thumb_image = UIImage.init(named: "icon") ?? ""
        self.shareImage = UIImage.init(named: "icon") ?? ""
        
        self.miniProgramTitle = "礼舍商城小程序"
        self.webpageUrl = "http://sdk.umsns.com/download/demo/"
        self.userName = "gh_3ac2059ac66f"
        self.path = "pages/page10007/page10007"
    }
}

// 分享结果
enum ShareResult{
    case UMShareResultSuccess
    case UMShareResultFailed
    case UMShareResultUnKnown
}
