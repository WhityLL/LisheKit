//
//  ZLAnimationModel.swift
//  Paihuo_Swift
//
//  Created by LiuLei on 2018/4/2.
//  Copyright © 2018年 LiuLei. All rights reserved.
//

import UIKit

class ZLAnimationModel: NSObject {

    /// 动画时长
    var duration : CGFloat = 0.01
    /// 背景视图高度
    var bgHeight : CGFloat = 200
    /// 背景视图alpha
    var alpha : CGFloat = 0.3
    /// 动画类型（present ／ dismiss）
    var modelType : ZLAnimationModelType = .ZLAnimationModelTypeNone
    
    override init() {
        super.init()
    }
    
    class func animationModelWithAnimationConfig(config : ZLAnimationConfig) -> ZLAnimationModel {
        
        let model : ZLAnimationModel = ZLAnimationModel.init()
    
        model.bgHeight = config.viewHeight
        model.alpha = config.alpha_bgBiew
        model.duration  = config.animationDuration

        //动画类型
        if (config.modelType.rawValue > 0) {
            model.modelType = ZLAnimationModelType(rawValue: config.modelType.rawValue)!
        }else{
            print("ZLAnimationModel modelType（present ／ dismiss）必须设置" )
            exit(0)
        }
        
        return model
    }
    
}

extension ZLAnimationModel : UIViewControllerAnimatedTransitioning{
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return TimeInterval(duration)
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        if modelType == .ZLAnimationModelTypePresent {
            present(transitionContext: transitionContext)
        }else{
            dismiss(transitionContext: transitionContext)
        }
    }
    
    func dismiss(transitionContext : UIViewControllerContextTransitioning) {
     
        let fromView : UIView = transitionContext.view(forKey: .from)!
        let containerView : UIView = transitionContext.containerView
        let toView : UIView = containerView.subviews.first!
        
        containerView.addSubview(toView)
        containerView.addSubview(fromView)
        
        fromView.frame = CGRect.init(x: 0, y: containerView.frame.size.height - bgHeight, width: containerView.frame.size.width, height: bgHeight)
        
        // 缩小（仿射变换）
        var transform3d : CATransform3D = CATransform3DIdentity
        transform3d.m34 = 1.0 / -900
        transform3d = CATransform3DScale(transform3d, 0.95, 0.95, 1)
        
        // 还原
        var transform3D : CATransform3D = CATransform3DIdentity
        transform3D.m34 = transform3d.m34;
        transform3D = CATransform3DRotate(transform3D, 0, 1, 0, 0);
        transform3D = CATransform3DScale(transform3D, 1, 1, 1);
        transform3D = CATransform3DTranslate(transform3D, 0, 0, 0);
        
        UIView.animate(withDuration: TimeInterval(duration), animations: {
            
            fromView.frame = CGRect.init(x: 0, y: containerView.frame.size.height, width: containerView.frame.size.width, height: self.bgHeight)
            
        }) { (finished) in
            transitionContext.completeTransition(true)
            
            transitionContext.view(forKey: .to)?.isHidden = false
            
            toView.removeFromSuperview()
        }
        
        UIView.animate(withDuration: TimeInterval(duration / 2), animations: {
            
//            toView.layer.transform = transform3d;
            toView.alpha = 1
        }) { (finished) in
            UIView.animate(withDuration: TimeInterval(self.duration / 2), animations: {
                
//                toView.layer.transform = transform3D;
                
            })
        }
        
    }
    
    func present(transitionContext : UIViewControllerContextTransitioning) {
        
        let fromView : UIView = transitionContext.view(forKey: .from)!
        let toView : UIView = transitionContext.view(forKey: .to)!
        let containerView : UIView = transitionContext.containerView
        
        let fromViewTemp : UIImageView = imageFromView(snapView: fromView)
        fromView.isHidden = true
        
        containerView.addSubview(fromViewTemp)
        containerView.addSubview(toView)
    
        toView.frame = CGRect.init(x: 0, y: containerView.frame.size.height, width: containerView.frame.size.width, height: self.bgHeight)
        fromViewTemp.frame = containerView.frame
        
        
        //（仿射变换）
        var transform3D : CATransform3D = CATransform3DIdentity
        transform3D.m34 = 1.0 / -4000
        transform3D = CATransform3DScale(transform3D, 0.95, 0.95, 1)
        transform3D = CATransform3DRotate(transform3D, CGFloat(15*Double.pi/180), 1, 0, 0)
        
        var transform3d : CATransform3D = CATransform3DIdentity
        transform3d.m34 = transform3D.m34;
        transform3d = CATransform3DTranslate(transform3d, 0, -0.08*containerView.frame.size.height, 0);
        transform3d = CATransform3DScale(transform3d, 0.9, 0.9, 1);
        
        fromViewTemp.layer.anchorPoint = CGPoint.init(x: 0.5, y: 1)
        fromViewTemp.layer.position = CGPoint.init(x: containerView.frame.midX, y: containerView.frame.maxY)
        /*当shouldRasterize设成true时，layer被渲染成一个bitmap，并缓存起来，等下次使用时不会再重新去渲染了。实现圆角本身就是在做颜色混合（blending），如果每次页面出来时都blending，消耗太大，这时shouldRasterize = yes，下次就只是简单的从渲染引擎的cache里读取那张bitmap，节约系统资源。*/
        fromViewTemp.layer.shouldRasterize = true;

        fromViewTemp.layer.anchorPoint = CGPoint.init(x: 0.5, y: 1)
        fromViewTemp.layer.position = CGPoint.init(x: containerView.frame.midX, y: containerView.frame.maxY)
        
        UIView.animate(withDuration: TimeInterval(duration), animations: {
            
            containerView.backgroundColor = UIColor.black
            toView.frame = CGRect.init(x: 0, y: containerView.frame.size.height - self.bgHeight, width: containerView.frame.size.width, height: self.bgHeight)
            
        }) { (finished) in
            
            transitionContext.completeTransition(true)

        }
        
        //截屏缩小
        UIView.animate(withDuration: TimeInterval(duration / 2), animations: {
            
//            fromViewTemp.layer.transform = transform3D;
            
            fromViewTemp.alpha = self.alpha;
            
        }) { (finished) in
            UIView.animate(withDuration: TimeInterval(self.duration / 2), animations: {
                
//                fromViewTemp.layer.transform = transform3d;
                
            })
        }
        
    }
    
    /// 截屏
    func imageFromView(snapView : UIView) -> UIImageView {
        
        UIGraphicsBeginImageContextWithOptions(snapView.frame.size, false, 0)
        
        let context : CGContext = UIGraphicsGetCurrentContext()!
        
        snapView.layer.render(in: context)
        
        let image : UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        
        UIGraphicsEndImageContext()
        
        let imageView : UIImageView = UIImageView.init(image: image)
        
        imageView.frame = snapView.frame
        
        return imageView

    }
}
