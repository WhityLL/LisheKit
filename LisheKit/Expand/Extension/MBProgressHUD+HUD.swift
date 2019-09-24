//
//  MBProgressHUD+HUD.swift
//  LiShePlus
//
//  Created by lishe on 2019/5/7.
//  Copyright © 2019 lishe. All rights reserved.
//

import Foundation
import MBProgressHUD
import Kingfisher

extension MBProgressHUD {
    
   // MARK: - ====== Toast ======
    
    static func showBusy(message: String){
        MBProgressHUD .showMessage(message: message, mode: .indeterminate)
    }
    
    /// showMessage
    ///
    /// - Parameters:
    ///   - message:  messageInfo
    ///   - iconNeme: 图片名
    ///   - duration: 时间 默认2s
    ///   - toView:   要显示在那个View 上
    static func showMessage(message: String , iconNeme: String? = nil , duration: TimeInterval? = nil , toView: UIView? = nil, mode: MBProgressHUDMode? = nil) {
        
        var blockView = toView
        if blockView == nil {
            blockView = UIApplication.shared.delegate?.window!
        }
        
        DispatchQueue.main.async {
            // 1、隐藏以前的
            MBProgressHUD.hideAllHUDs(for: blockView!, animated: false)
            // 2、显示
            let hud: MBProgressHUD = MBProgressHUD.showAdded(to: blockView!, animated: true)
            if iconNeme == nil {
                hud.mode = MBProgressHUDMode.text
            }else{
                hud.customView = UIImageView.init(image: UIImage.init(named: iconNeme!))
                hud.mode = MBProgressHUDMode.customView
            }
            hud.minSize = CGSize.init(width: 100, height: 40)
            hud.backgroundView.alpha = 0.3
            hud.backgroundView.backgroundColor = UIColor.black
            hud.bezelView.style = .solidColor;
            hud.bezelView.backgroundColor = UIColor.init(white: 0, alpha: 0.7)
            
            hud.label.text = message
            hud.label.numberOfLines = 0
            hud.label.font = UIFont.systemFont(ofSize: 14)
            hud.label.textColor = UIColor.white
            
            hud.removeFromSuperViewOnHide = true
            hud.animationType = .fade
            hud.hide(animated: true, afterDelay: duration ?? 2)
            
            if(mode != nil){
                hud.mode = mode!
                hud.activityIndicatorColor = UIColor.white
                hud.minSize = CGSize.init(width: 100, height: 100)
                hud.label.textColor = UIColor.white
            }
        }
    }
    
    
    // MARK: - ====== Loading ======
    /// 加载视图（转菊花）
    static func showLoading(message: String? = nil , toView: UIView? = nil) {
        var blockView = toView
        if blockView == nil {
            blockView = UIApplication.shared.delegate?.window!
        }
        
        DispatchQueue.main.async {
            // 1、隐藏以前的
            MBProgressHUD.hideAllHUDs(for: blockView!, animated: false)
            // 2、显示
            let hud: MBProgressHUD = MBProgressHUD.showAdded(to: blockView!, animated: true)
            hud.mode = .indeterminate
            hud.minSize = CGSize.init(width: 100, height: 100)
            hud.backgroundView.style = .solidColor;
            hud.backgroundView.alpha = 0.3
            hud.backgroundView.backgroundColor = UIColor.black
            hud.bezelView.style = .solidColor;
            hud.bezelView.backgroundColor = UIColor.init(white: 0, alpha: 0.7)
            hud.activityIndicatorColor = UIColor.white
            
            if message != nil {
                hud.label.text = message
                hud.label.numberOfLines = 0
                hud.label.font = UIFont.systemFont(ofSize: 14)
                hud.label.textColor = UIColor.white
            }
            
            hud.removeFromSuperViewOnHide = true
            hud.animationType = .fade
        }
    }
    
    // MARK: - ====== CustomLoading ======

    ///  MBProgressHUD 显示加载Gif
    ///
    /// - parameter view:               hud where to show
    /// - parameter userInterface:      hud userInerface enable  default = true
    /// - parameter animated:           hud show with animation  default = true
    ///
    /// - returns: nil
    static func showGif(to view: UIView? = nil, userInterface:Bool = true, animated:Bool = true) {
        var blockView = view
        if blockView == nil {
            blockView = UIApplication.shared.delegate?.window!
        }
        
        DispatchQueue.main.async {
            // 1、隐藏以前的
            MBProgressHUD.hideAllHUDs(for: blockView!, animated: false)
            // 2、显示
            //如果是gif可以使用sdwebImage的方法加载本地gif
            //let image = UIImage.sd_animatedGIFNamed("loading")
            //如果是apng图片的话，使用YYKit框架中的YYImage加载apng动图
            //        let image = YYImage(named: "loading")
            //        let giftImgView =  YYAnimatedImageView(frame: CGRect(x: 0, y: 0, width: 80, height: 80))
            //        giftImgView.image = image
            let path = Bundle.main.path(forResource:"loading", ofType:"gif")
            let giftImgView = MBProgressHUD_GifView.init(frame: CGRect.init(x: 0, y: 0, width: 150, height: 150))
            giftImgView.kf.setImage(with:ImageResource(downloadURL:URL(fileURLWithPath: path!)))
            let hud = MBProgressHUD.showAdded(to: blockView!, animated: animated)
            hud.bezelView.style = .solidColor
            hud.bezelView.color = .clear
            hud.mode = .customView
            hud.isUserInteractionEnabled = userInterface
            hud.customView = giftImgView
        }
    }
    
    /// 隐藏hideHUD
    ///
    /// - Parameter parentView: parentView
    static func hideHUD(parentView: UIView? = nil) {
        var blockView = parentView
        if blockView == nil {
            blockView = UIApplication.shared.delegate?.window!
        }
        OperationQueue.main.addOperation {
            MBProgressHUD.hide(for: blockView!, animated: true)
        }
    }
    
    /// 隐藏hideHUD
    static func hideHUD() {
        MBProgressHUD.hideHUD(parentView: nil)
    }
    
}


class MBProgressHUD_GifView: UIImageView {
    // 重写intrinsicContentSize 修改尺寸
    override var intrinsicContentSize: CGSize{
        return CGSize.init(width: 150, height: 150)
    }
    
}
