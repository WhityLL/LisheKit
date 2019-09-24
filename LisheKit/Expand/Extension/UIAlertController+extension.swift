//
//  UIAlertController+extension.swift
//  LiShePlus
//
//  Created by lishe on 2019/5/10.
//  Copyright © 2019 lishe. All rights reserved.
//

import UIKit
//对UIAlertController进行扩展((UIAlertAction) -> Void)? = nil
extension UIAlertController{
    //创建样式
    static func showAlert(title: String? = nil,
                          messgae:String? = nil,
                          in viewController: UIViewController? = nil,
                          confirmTitle: String? = nil ,
                          cancelTitle : String? = nil , confirmBlock: ((UIAlertAction) -> Void)? = nil) {
        
        let alert = UIAlertController(title: title, message: messgae, preferredStyle: .alert)
        if ( cancelTitle != nil ){
            alert.addAction(UIAlertAction(title: cancelTitle, style: .default, handler: nil))
        }
        alert.addAction(UIAlertAction(title: (confirmTitle != nil) ? confirmTitle : "确定", style: .default, handler: confirmBlock))
        
        let parentVC = (viewController != nil) ? viewController : UIApplication.shared.keyWindow?.rootViewController
        
        parentVC!.present(alert, animated: true, completion: nil)
    }
}

