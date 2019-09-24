//
//  ZLAnimationConfig.swift
//  Paihuo_Swift
//
//  Created by LiuLei on 2018/4/2.
//  Copyright © 2018年 LiuLei. All rights reserved.
//

import UIKit

enum ZLAnimationModelType : Int{
    case ZLAnimationModelTypeNone = 0
    case ZLAnimationModelTypePresent = 1
    case ZLAnimationModelTypeDismiss = 2
}

class ZLAnimationConfig: NSObject {
    /// 动画时长
    var _animationDuration : CGFloat = 0.35
    /// 背景视图高度
    var _viewHeight : CGFloat = SCREEN_HEIGHT
    /// 背景视图alpha
    var _alpha_bgBiew : CGFloat = 0.6
    /// 动画类型（present ／ dismiss）
    var _modelType : ZLAnimationModelType = .ZLAnimationModelTypeNone
    
    var animationDuration : CGFloat{
        get{
            return _animationDuration
        }
        set(newValue){
            _animationDuration = newValue
        }
    }
    
    var viewHeight : CGFloat{
        get{
            return _viewHeight
        }
        set(newValue){
            _viewHeight = newValue
        }
    }
    
    var alpha_bgBiew : CGFloat{
        get{
            return _alpha_bgBiew
        }
        set(newValue){
            _alpha_bgBiew = newValue
        }
    }
    
    var modelType : ZLAnimationModelType{
        get{
            return _modelType
        }
        set(newValue){
            _modelType = newValue
        }
    }
    
}
