//
//  WXApiManager.swift
//  LiShePlus
//
//  Created by lishe on 2019/5/10.
//  Copyright © 2019 lishe. All rights reserved.
//

import UIKit

//微信appid
let WX_APPID = ""
//AppSecret
let WX_SECRET   = ""

class WXApiManager: NSObject {
    static let shared = WXApiManager()
    // 用于弹出警报视图，显示成功或失败的信息()
    private weak var sender: UIViewController! //(UIViewController)
    // 支付成功的闭包
    private var paySuccessClosure: (() -> Void)?
    // 支付失败的闭包
    private var payFailClosure: (() -> Void)?
    //登录成功
    private var loginSuccessClosure:((_ code:String) -> Void)?
    //登录失败
    private var loginFailClosure:(() -> Void)?
    
    /// 调起微信支付
    func payAlertController(_ sender: UIViewController,
                            request:PayReq,
                            paySuccess: @escaping () -> Void,
                            payFail:@escaping () -> Void) {
        // sender 是调用这个方法的控制器，
        // 用于提示用户微信支付结果，可以根据自己需求是否要此参数。
        self.sender = sender
        self.paySuccessClosure = paySuccess
        self.payFailClosure = payFail
        if checkWXInstallAndSupport(){//检查用户是否安装微信
            WXApi.send(request)
        }
    }
    
    // 调起微信登录
    func login(_ sender: UIViewController, loginSuccess: @escaping ( _ code:String) -> Void,
               loginFail:@escaping () -> Void){
        // sender 是调用这个方法的控制器，
        // 用于提示用户微信支付结果，可以根据自己需求是否要此参数。
        self.sender = sender
        self.loginSuccessClosure = loginSuccess
        self.loginFailClosure = loginFail
        if checkWXInstallAndSupport(){
            let req = SendAuthReq()
            req.scope="snsapi_userinfo"
            req.state="app"
            WXApi.send(req)
        }
    }
    
}
extension WXApiManager: WXApiDelegate {
    /*
     
     ErrCode    ERR_OK = 0(用户允许)
     ERR_AUTH_DENIED = -4（用户拒绝授权）
     ERR_USER_CANCEL = -2（用户取消）
     code    用户换取access_token的code，仅在ErrCode为0时有效
     state    第三方程序发送时用来标识其请求的唯一性的标志，由第三方程序调用sendReq时传入。由微信终端回传。state字符串长度不能超过1K
     lang    微信client当前语言
     country    微信用户当前国家信息
     */
    func onResp(_ resp: BaseResp) {
        if resp is PayResp {//支付
            // var strMsg: String
            if resp.errCode == 0 {
               // strMsg = "支付成功"
                self.paySuccessClosure?()
            }else{
               // strMsg = "支付失败"
                self.payFailClosure?()
            }
            
            // UIAlertController.showAlert(title: "支付结果", messgae: strMsg)
            
        }else if resp is SendAuthResp{//登录结果
            let authResp = resp as! SendAuthResp
            var strMsg: String
            if authResp.errCode == 0{
                strMsg="微信授权成功"
            }else{
                switch authResp.errCode{
                case -4:
                    strMsg="您拒绝使用微信登录"
                    break
                case -2:
                    strMsg="您取消了微信登录"
                    break
                default:
                    strMsg="微信登录失败"
                    break
                }
            }
            
            UIAlertController.showAlert(title: "授权结果", messgae: strMsg) { (action) in
                if authResp.errCode == 0 {
                    self.loginSuccessClosure?(authResp.code!)
                }else{
                    self.loginFailClosure?()
                }
            }
        }
    }
}

extension WXApiManager {
    // 检查用户是否已经安装微信并且有支付功能
    private func checkWXInstallAndSupport() -> Bool {
        if !WXApi.isWXAppInstalled() {
            ///这里的弹窗是我写的扩展方法
            UIAlertController.showAlert(title: nil, messgae: "微信未安装")
            return false
        }
        if !WXApi.isWXAppSupport() {
            ///这里的弹窗是我写的扩展方法
            UIAlertController.showAlert(title: nil, messgae: "当前微信版本不支持支付")
            return false
        }
        return true
    }
}
