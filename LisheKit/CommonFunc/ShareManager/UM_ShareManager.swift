//
//  UM_ShareManager.swift
//  LiShePlus
//
//  Created by lishe on 2019/4/16.
//  Copyright © 2019 lishe. All rights reserved.
//

import UIKit

class UM_ShareManager: NSObject {
    
    static let sharedManager = UM_ShareManager()
    var shareResultClosure: ((_ reslut: ShareResult) -> ())?
    private var parentVC: UIViewController?
    private var shareModel: ZLShareModel?
    
    override init() {
        super.init()
    }
    
    func configUShare() {
        // 初始化
        UMConfigure.initWithAppkey(USHARE_APPKEY, channel: "App Store")
        #if DEBUG
            UMSocialManager.default()?.openLog(true)
        #else
            UMSocialManager.default()?.openLog(false)
        #endif
        
        //设置分享平台
        UMSocialManager.default()?.setPlaform(UMSocialPlatformType.wechatSession, appKey: kWX_APPID, appSecret: kWX_AppSecret, redirectURL: nil)
        UMSocialManager.default()?.setPlaform(UMSocialPlatformType.wechatTimeLine, appKey: kWX_APPID, appSecret: kWX_AppSecret, redirectURL: nil)
        UMSocialManager.default()?.setPlaform(UMSocialPlatformType.QQ, appKey: kTencent_APPkey, appSecret: kTencent_APPSecret, redirectURL: nil)
        UMSocialManager.default()?.setPlaform(UMSocialPlatformType.qzone, appKey: kTencent_APPkey, appSecret: kTencent_APPSecret, redirectURL: nil)

    }
    
    
}

extension UM_ShareManager{
    
    /// 第三方登陆
    ///
    /// - Parameters:
    ///   - platForm: 登陆平台
    ///   - reponsCallBack: 返回信息
    public func getLoginInfo(_ platForm : UMSocialPlatformType , reponsCallBack: @escaping ((_ response : UMSocialUserInfoResponse) -> ())) {
        UMSocialManager.default()?.getUserInfo(with: platForm, currentViewController: nil, completion: { (result, error) in
            if (error == nil) {
                reponsCallBack(result as! UMSocialUserInfoResponse)
            }else{
                print(error.debugDescription)
            }
        })
    }
    
    /// 分享到平台
    ///
    /// - Parameters:
    ///   - platformType: 分享到的平台
    ///   - parentVC: 父级VC
    ///   - shareModel: 分享的内容
    public func showShareVC(parentVC: UIViewController, shareModel: ZLShareModel? = nil, shareCallBack: ((_ shareResultModel: ShareResult) -> ())? = nil ) {
        self.parentVC = parentVC
        self.shareModel = shareModel
        self.shareResultClosure = shareCallBack
        
        let vc = ZL_SharePopVC()
        parentVC.present(vc, animated: true, completion: nil)
        
        //点击分享
        vc.shareWithPlatformClosure = { platform in
            self.shareToPlatformType(platformType: platform)
        }
    }
    
    /// 分享到各个平台
    private func shareToPlatformType(platformType: UMSocialPlatformType) {
        
        // 赋值链接
        if platformType.rawValue == UMSocialPlatformType.userDefine_Begin.rawValue + 1 {
            let pasteboard = UIPasteboard.general
            pasteboard.string = self.shareModel?.web_link ?? "http://a.lishe.cn"
            MBProgressHUD.showMessage(message: "复制链接成功")
            return
        }
        
        UMSocialManager.default()?.share(to: platformType, messageObject: creatShareModel(), currentViewController: self.parentVC, completion: { (data, error) in
            if error != nil {
                let err: NSError = error! as NSError
                if (err.code == 2009) {
                    MBProgressHUD.showMessage(message: "取消分享")
                }else if (err.code == 2010){
                    MBProgressHUD.showMessage(message: "网络异常")
                }else if (err.code == 2000){
                    MBProgressHUD.showMessage(message: "未知错误")
                }else{
                    MBProgressHUD.showMessage(message: "分享失败")
                }
            }else{
                MBProgressHUD.showMessage(message: "分享成功")
                // 可以写一个回调给外界
                self.shareResultClosure?(ShareResult.UMShareResultSuccess)
            }
        })
        
    }
    
    func creatShareModel() -> UMSocialMessageObject{
        // 分享到其他平台
        // 组装分享的数据 (区分分享类型)
        let shareMessageModel = UMSocialMessageObject()
        if self.shareModel == nil {
            self.shareModel = ZLShareModel()
        }
        
        let type = self.shareModel!.shareType
        switch type {
            
        case .UMS_SHARE_TYPE_TEXT: break
            
        case .UMS_SHARE_TYPE_TEXT_IMAGE:
            /// 分享图片和文字
            shareMessageModel.text = self.shareModel?.text
            let object = UMShareImageObject()
            object.descr = self.shareModel?.text
            object.shareImage = self.shareModel?.shareImage
            object.thumbImage = self.shareModel?.thumb_image
            shareMessageModel.shareObject = object
            break
            
        case .UMS_SHARE_TYPE_IMAGE:
            // 图片
            
            break
            
        case .UMS_SHARE_TYPE_IMAGE_URL:
            /// 图片链接
            let object = UMShareImageObject()
            object.shareImage = self.shareModel?.shareImage
            object.thumbImage = self.shareModel?.thumb_image
            shareMessageModel.shareObject = object
            break
            
        case .UMS_SHARE_TYPE_WEB_LINK:
            /// 网页分享
            let object = UMShareWebpageObject.shareObject(withTitle: self.shareModel?.title, descr: self.shareModel?.text, thumImage: self.shareModel?.shareImage)
            //设置网页地址
            object?.webpageUrl = self.shareModel?.web_link
            shareMessageModel.shareObject = object
            break
            
        case .UMS_SHARE_TYPE_MUSIC_LINK: break
            
        case .UMS_SHARE_TYPE_MUSIC: break
            
        case .UMS_SHARE_TYPE_VIDEO_LINK: break
            
        case .UMS_SHARE_TYPE_VIDEO: break
            
        case .UMS_SHARE_TYPE_EMOTION: break
            
        case .UMS_SHARE_TYPE_FILE: break
            
        case .UMS_SHARE_TYPE_MINI_PROGRAM:
            /// 小程序分享
            let object : UMShareMiniProgramObject = UMShareMiniProgramObject.shareObject(withTitle: self.shareModel?.miniProgramTitle, descr: self.shareModel?.text, thumImage: self.shareModel?.thumb_image) as! UMShareMiniProgramObject
            object.webpageUrl = self.shareModel?.webpageUrl
            object.userName = self.shareModel?.userName
            object.path = self.shareModel?.path
            shareMessageModel.shareObject = object
            
            break
        
        }
        return shareMessageModel
    }
    
}


