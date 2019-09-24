//
//  LocationUtil.swift
//  LiShePlus
//
//  Created by lishe on 2019/4/17.
//  Copyright © 2019 lishe. All rights reserved.
//

/*
 //使用示例代码
 LocationUtil.shareInstance.getCurrentLocation(isOnce: true) { (loc, errorMsg) -> () in
 if errorMsg == nil {
 print(loc?.administrativeArea ?? "")
 }
 }
 */
import Foundation
import CoreLocation

typealias LocationResultBlock      = (_ loc: CLPlacemark?, _ errorMsg: String?) -> ()
typealias LocationPointResultBlock = (_ loc: CLLocation?, _ errorMsg: String?) -> ()

class LocationUtil: NSObject {
    static let share = LocationUtil()
    
    /// 是否只获取一次
    var isOnce: Bool = false
    var resultBlock: LocationResultBlock?
    var resultPointBlock: LocationPointResultBlock?
    
    lazy var locationM: CLLocationManager = {
        let locationM = CLLocationManager()
        locationM.requestAlwaysAuthorization()
        //设备使用电池供电时最高的精度
        locationM.desiredAccuracy = kCLLocationAccuracyBest
        //精确度
        locationM.distanceFilter = kCLLocationAccuracyBest
        locationM.delegate = self
        return locationM
    }()
    
    /// 获取位置信息
    func getCurrentLocation(isOnce: Bool,resultBlock: @escaping LocationResultBlock) -> () {
        self.isOnce = isOnce
        self.resultBlock = resultBlock
        
        // 2. 请求权限
        self.locationAuth()
    }
    
    /// 仅获取经纬度
    func getCurrentPointLocation(isOnce: Bool,resultPointBlock: @escaping LocationPointResultBlock) -> () {
        self.isOnce = isOnce
        self.resultPointBlock = resultPointBlock
        
        // 2. 请求权限
        self.locationAuth()
    }
    
    private func locationAuth() {
        AuthorizeUtils.zl_checkLocation { (isLocationAuth) in
            if (isLocationAuth){
                if self.isOnce == true {
                    // 单次定位请求
                    // 必须实现代理的定位失败方法
                    // 不能与startUpdatingLocation方法同时使用
                    if #available(iOS 9.0, *) {
                        self.locationM.requestLocation()
                    } else {
                        self.locationM.startUpdatingLocation()
                    }
                }else{
                    self.locationM.startUpdatingLocation()
                }
            }else{
                print("错误提示: 不要紧张 在ios8.0以后,想要使用用户位置, 你应该先在info.plist 配置NSLocationWhenInUseUsageDescription 或者 NSLocationAlwaysUsageDescription")
                if self.resultBlock != nil {
                    self.resultBlock!(nil, "当前没有开启定位服务")
                }
                if self.resultPointBlock != nil {
                    self.resultPointBlock!(nil, "当前没有开启定位服务")
                }
            }
        }
    }
}

extension LocationUtil: CLLocationManagerDelegate {
    
    // 成功delegete
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        guard let loc = locations.last else {
            if resultBlock != nil {
                resultBlock!(nil, "没有获取到位置信息")
            }
            if resultPointBlock != nil {
                resultPointBlock!(nil, "没有获取到位置信息")
            }
            return
        }
        
        if resultPointBlock != nil {
            resultPointBlock!(loc, nil)
        }
        
        if resultBlock != nil {
            let geoCoder = CLGeocoder()
            geoCoder.reverseGeocodeLocation(loc, completionHandler: {(placemarks, error)->Void in
                var placemark:CLPlacemark!
                if error == nil && (placemarks?.count)! > 0 {
                    placemark = (placemarks?[0])! as CLPlacemark
                    self.resultBlock!(placemark, nil)
                }
            })
        }
        
        if isOnce {
            manager.stopUpdatingLocation()
        }
    }
    
    // 失败delegate
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        
    }
    
    private func locationManager(manager: CLLocationManager, didChangeAuthorizationStatus status: CLAuthorizationStatus) {
        
        guard let resultBlock2 = resultBlock else {return}

        switch status {
        case .denied:        resultBlock2(nil, "当前被拒绝")
        case .restricted:    resultBlock2(nil, "当前受限制")
        case .notDetermined: resultBlock2(nil, "用户没有决定")
        default: print("nono")
        }
    }
}
