//
//  ZLQRCodeConfig.swift
//  LiShePlus
//
//  Created by LiuLei on 2019/4/16.
//  Copyright © 2019 lishe. All rights reserved.
//

import UIKit

/// 扫描器类型
///
/// - qr: 仅支持二维码
/// - bar: 仅支持条码
/// - both: 支持二维码以及条码
enum ZLScannerType {
    case qr
    case bar
    case both
}

/// 扫描区域
///
/// - def: 扫描框内
/// - fullscreen: 全屏
enum ZLScannerArea {
    case def
    case fullscreen
}

struct ZLQRCodeCompat {
    /// 扫描器类型 默认支持二维码以及条码
    var scannerType: ZLScannerType = .both
    /// 扫描区域
    var scannerArea: ZLScannerArea = .def
    
    /// 棱角颜色 默认RGB色值 r:63 g:187 b:54 a:1.0
    var scannerCornerColor: UIColor = UIColor(red: 63/255.0, green: 187/255.0, blue: 54/255.0, alpha: 1.0)
    
    /// 边框颜色 默认白色
    var scannerBorderColor: UIColor = .white
    
    /// 指示器风格
    var indicatorViewStyle: UIActivityIndicatorView.Style = .whiteLarge
}
