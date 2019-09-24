//
//  ZLQRCodeViewController.swift
//  LiShePlus
//
//  Created by LiuLei on 2019/4/16.
//  Copyright © 2019 lishe. All rights reserved.
//

import UIKit
import AVFoundation

class ZLQRCodeViewController: UIViewController {
    
    var scanResultClosure : ((_ codeStr: String) -> ())?
    
    var config = ZLQRCodeCompat()
    private let session = AVCaptureSession()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = ZLQRCodeHelper.zl_navigationItemTitle(type: self.config.scannerType)
        
        NotificationCenter.default.addObserver(self, selector: #selector(appDidBecomeActive), name: UIApplication.didBecomeActiveNotification, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(appWillResignActive), name: UIApplication.willResignActiveNotification, object: nil)
        
        _setupUI();
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        _resumeScanning()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // 关闭并隐藏手电筒
        scannerView.zl_setFlashlight(on: false)
        scannerView.zl_hideFlashlight(animated: true)
    }
    
    private func _setupUI() {
        view.backgroundColor = .black
        
        let albumItem = UIBarButtonItem(title: "相册", style: .plain, target: self, action: #selector(showAlbum))
        albumItem.tintColor = .black
        navigationItem.rightBarButtonItem = albumItem;
        
        view.addSubview(scannerView)
        
        // 校验相机权限
        AuthorizeUtils.zl_checkCamera { (granted) in
            if granted {
                DispatchQueue.main.async {
                    self._setupScanner()
                }
            }
        }
    }
    
    /** 创建扫描器 */
    private func _setupScanner() {
        
        guard let device = AVCaptureDevice.default(for: .video) else {
            return
        }
        
        if let deviceInput = try? AVCaptureDeviceInput(device: device) {
            
            let metadataOutput = AVCaptureMetadataOutput()
            metadataOutput.setMetadataObjectsDelegate(self, queue: .main)
            
            if config.scannerArea == .def {
                metadataOutput.rectOfInterest = CGRect(x: scannerView.scanner_y/view.frame.size.height, y: scannerView.scanner_x/view.frame.size.width, width: scannerView.scanner_width/view.frame.size.height, height: scannerView.scanner_width/view.frame.size.width)
            }
            
            let videoDataOutput = AVCaptureVideoDataOutput()
            //光线判断
            videoDataOutput.setSampleBufferDelegate(self, queue: .main)
            
            session.canSetSessionPreset(.high)
            if session.canAddInput(deviceInput) { session.addInput(deviceInput) }
            if session.canAddOutput(metadataOutput) { session.addOutput(metadataOutput) }
            if session.canAddOutput(videoDataOutput) { session.addOutput(videoDataOutput) }
            
            metadataOutput.metadataObjectTypes = ZLQRCodeHelper.zl_metadataObjectTypes(type: config.scannerType)
            
            let videoPreviewLayer = AVCaptureVideoPreviewLayer(session: session)
            videoPreviewLayer.videoGravity = .resizeAspectFill
            videoPreviewLayer.frame = view.layer.bounds
            view.layer.insertSublayer(videoPreviewLayer, at: 0)
            
            session.startRunning()
        }
    }
    
    @objc func showAlbum() {
        AuthorizeUtils.zl_checkAlbum { (granted) in
            if granted {
                self.imagePicker()
            }
        }
    }
    
    // MARK: - 跳转相册
    private func imagePicker() {
        let imagePicker = UIImagePickerController()
        imagePicker.sourceType = .photoLibrary
        imagePicker.delegate = self
        present(imagePicker, animated: true, completion: nil)
    }
    
    /// 从后台进入前台
    @objc func appDidBecomeActive() {
        _resumeScanning()
    }
    
    /// 从前台进入后台
    @objc func appWillResignActive() {
        _pauseScanning()
    }
    
    lazy var scannerView:ZLScannerView = {
        let tempScannerView = ZLScannerView(frame: view.bounds, config: config)
        return tempScannerView
    }()
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}

// MARK: - 扫一扫Api
extension ZLQRCodeViewController {
    
    /// 处理扫一扫结果
    ///
    /// - Parameter value: 扫描结果
    func zl_handle(value: String) {
        print("zl_handle === \(value)")
        self.scanResultClosure?(value)
        self.navigationController?.popViewController(animated: true)
    }
    
    /// 相册选取图片无法读取数据
    func zl_didReadFromAlbumFailed() {
        MBProgressHUD.showMessage(message: "扫描失败")
        print("zl_didReadFromAlbumFailed")
    }
}

// MARK: - 扫描结果处理
extension ZLQRCodeViewController: AVCaptureMetadataOutputObjectsDelegate {
    
    func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {
        
        if metadataObjects.count > 0 {
            _pauseScanning()
            
            if let metadataObject = metadataObjects[0] as? AVMetadataMachineReadableCodeObject {
                if let stringValue = metadataObject.stringValue {
                    zl_handle(value: stringValue)
                }
            }
        }
    }
}

// MARK: - 监听光线亮度
extension ZLQRCodeViewController: AVCaptureVideoDataOutputSampleBufferDelegate {
    
    func captureOutput(_ output: AVCaptureOutput, didOutput sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {
        let metadataDict = CMCopyDictionaryOfAttachments(allocator: nil, target: sampleBuffer, attachmentMode: kCMAttachmentMode_ShouldPropagate)
        
        if let metadata = metadataDict as? [AnyHashable: Any] {
            if let exifMetadata = metadata[kCGImagePropertyExifDictionary as String] as? [AnyHashable: Any] {
                if let brightness = exifMetadata[kCGImagePropertyExifBrightnessValue as String] as? NSNumber {
                    // 亮度值
                    let brightnessValue = brightness.floatValue
                    if !scannerView.zl_setFlashlightOn() {
                        if brightnessValue < -4.0 {
                            scannerView.zl_showFlashlight(animated: true)
                        }
                        else {
                            scannerView.zl_hideFlashlight(animated: true)
                        }
                    }
                }
            }
        }
    }
}

// MARK: - 识别选择图片Delegate
extension ZLQRCodeViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true) {
            if !self.handlePickInfo(info) {
                self.zl_didReadFromAlbumFailed()
            }
        }
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true) {
            self.zl_didReadFromAlbumFailed()
        }
    }
    
    /// 识别二维码并返回识别结果
    private func handlePickInfo(_ info: [UIImagePickerController.InfoKey : Any]) -> Bool {
        if let pickImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            let ciImage = CIImage(cgImage: pickImage.cgImage!)
            
            let detector = CIDetector(ofType: CIDetectorTypeQRCode, context: nil, options: [CIDetectorAccuracy:CIDetectorAccuracyHigh])

            if let features = detector?.features(in: ciImage),
                let firstFeature = features.first as? CIQRCodeFeature{

                if let stringValue = firstFeature.messageString {
                    zl_handle(value: stringValue)
                    return true
                }
                return false
            }
        }
        return false
    }
}

// MARK: - 恢复/暂停扫一扫功能
extension ZLQRCodeViewController {
    
    /// 恢复扫一扫功能
    private func _resumeScanning() {
        session.startRunning()
        scannerView.zl_addScannerLineAnimation()
    }
    
    /// 暂停扫一扫功能
    private func _pauseScanning() {
        session.stopRunning()
        scannerView.zl_pauseScannerLineAnimation()
    }
}
