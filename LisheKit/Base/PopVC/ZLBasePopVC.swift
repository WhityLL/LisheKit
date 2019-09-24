//
//  ZLBasePopVC.swift
//  Paihuo_Swift
//
//  Created by LiuLei on 2018/4/2.
//  Copyright © 2018年 LiuLei. All rights reserved.
//

import UIKit

class ZLBasePopVC: UIViewController {

    var backgroundViewTapClosure : (() -> ())?
    var touchBackgroundClose : Bool = false
    var animationDuration = 0.01
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        self.transitioningDelegate = self
        self.modalPresentationStyle = .overFullScreen
        view.backgroundColor = UIColor.clear
        view.tag = 100012

    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch : UITouch = (touches as NSSet).anyObject() as! UITouch
        let touchView = touch.view
        if touchView?.tag == 100012 && touchBackgroundClose == true {
            backgroundViewTapClosure?()
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

// MARK: ========= UIViewControllerTransitioningDelegate ==========
extension ZLBasePopVC : UIViewControllerTransitioningDelegate{
    
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        let config : ZLAnimationConfig = ZLAnimationConfig()
        config.animationDuration = CGFloat(animationDuration);
        config.modelType = .ZLAnimationModelTypePresent
        config.alpha_bgBiew = 0.6
        config.viewHeight = self.view.frame.size.height
        return ZLAnimationModel.animationModelWithAnimationConfig(config: config)
    }
    
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        let config : ZLAnimationConfig = ZLAnimationConfig()
        config.animationDuration = CGFloat(animationDuration);
        config.modelType = .ZLAnimationModelTypeDismiss;
        config.alpha_bgBiew = 0.6;
        config.viewHeight = self.view.frame.size.height;
        return ZLAnimationModel.animationModelWithAnimationConfig(config: config)

    }
    
}
