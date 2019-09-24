//
//  ZL_SharePopVC.swift
//  LiShePlus
//
//  Created by lishe on 2019/5/8.
//  Copyright © 2019 lishe. All rights reserved.
//

import UIKit

class ZL_SharePopVC: ZLBasePopVC {

    var shareWithPlatformClosure: ((_ platform: UMSocialPlatformType) -> ())?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.touchBackgroundClose = true
        self.backgroundViewTapClosure = {
            self.dismiss(animated: true, completion: nil)
        }
        
        let shareView : ZL_ShareContentView = ZL_ShareContentView.init(frame: CGRect.init(x: 0, y: SCREEN_HEIGHT - 200 - kBottomSafeMargin, width: SCREEN_WIDTH, height: 200+kBottomSafeMargin))
        shareView.delegate = self
        self.animationDuration = 0.25
        view.addSubview(shareView)
    }
}

extension ZL_SharePopVC: ShareContentViewDelagate{
    func shareContentViewCancelShare() {
        self.dismiss(animated: true, completion: nil)
    }
    
    func shareContentView(shareToPlatform: UMSocialPlatformType) {
        self.dismiss(animated: true) {
            self.shareWithPlatformClosure?(shareToPlatform)
        }
    }
}
