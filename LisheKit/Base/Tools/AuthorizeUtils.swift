//
//  AuthorrizeUtils.swift
//  LiShePlus
//
//  Created by LiuLei on 2019/4/18.
//  Copyright © 2019 lishe. All rights reserved.
//

import Foundation
import Photos
import AssetsLibrary
import CoreLocation
import MediaPlayer
import CoreTelephony
import AVFoundation
import HealthKit
import Contacts

struct AuthorizeUtils {
    
    /** 校验是否有相机权限 */
    static func zl_checkCamera(completion: @escaping (_ granted: Bool) -> Void) {
        let videoAuthStatus = AVCaptureDevice.authorizationStatus(for: .video)
        
        switch videoAuthStatus {
        // 已授权
        case .authorized:
            completion(true)
        // 未询问用户是否授权
        case .notDetermined:
            AVCaptureDevice.requestAccess(for: .video, completionHandler: { (granted) in
                completion(granted)
            })
        // 用户拒绝授权或权限受限
        case .denied, .restricted:
            UIAlertController.showAlert(title: "请在”设置-隐私-相机”选项中，允许访问你的相机")
            completion(false)
        @unknown default: break
            
        }
    }
    
    /** 校验是否有相册权限 */
    static func zl_checkAlbum(completion: @escaping (_ granted: Bool) -> Void) {
        let photoAuthStatus = PHPhotoLibrary.authorizationStatus()
        
        switch photoAuthStatus {
            // 已授权
            case .authorized:
                completion(true)
            // 未询问用户是否授权
            case .notDetermined:
                PHPhotoLibrary.requestAuthorization({ (status) in
                    completion(status == .authorized)
                })
            // 用户拒绝授权或权限受限
            case .denied, .restricted:
                UIAlertController.showAlert(title: "请在”设置-隐私-相机”选项中，允许访问你的相册")
                completion(false)
            @unknown default: break
        }
    }
    
    /** 校验是否有相册权限 */
    static func zl_checkLocation(completion: @escaping (_ granted: Bool) -> Void) {
        if CLLocationManager.locationServicesEnabled() && CLLocationManager.authorizationStatus() != .denied {
            completion(true)
        }else{
            UIAlertController.showAlert(title: "请在”设置-隐私-定位服务”选项中，允许访问你的位置")
            completion(false)
        }
    }
    
    static func zl_authorizeHealthKit(completion: @escaping (_ granted: Bool) -> Void) {
        
        //1. Check to see if HealthKit Is Available on this device
        guard HKHealthStore.isHealthDataAvailable() else {
            UIAlertController.showAlert(title: "设备不支持健康数据")
            completion(false)
            return
        }
        
        
        let typestoRead = Set([HKObjectType.quantityType(forIdentifier: .stepCount)!])  //步数
                
        //4. Request Authorization
        HKHealthStore().requestAuthorization(toShare: nil, read: typestoRead) { (success, error) in
            if success {
                completion(true)
            }else{
                UIAlertController.showAlert(title: "请在”设置-隐私-健康”选项中，允许访问你的健康数据")
                completion(false)
            }
        }
    }
    
    
    /** 校验是否有通讯录权限 */
    static func zl_authorizeContact(completion: @escaping (_ granted: Bool) -> Void) {
        let status = CNContactStore.authorizationStatus(for: .contacts)
        
        switch status {
        // 已授权
        case .authorized:
                completion(true)
        // 未询问用户是否授权
        case .notDetermined:
            CNContactStore.init().requestAccess(for: .contacts) { (granted, error) in
                    completion(granted)
                }
        // 用户拒绝授权或权限受限
        case .denied, .restricted:
            UIAlertController.showAlert(title: "请在”设置-隐私-通讯录”选项中，允许访问你的通讯录")
                completion(false)
        @unknown default: break
        }
    }
}
