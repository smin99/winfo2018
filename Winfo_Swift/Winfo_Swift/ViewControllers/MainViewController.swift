//
//  ViewController.swift
//  Winfo_Swift
//
//  Created by HwangSeungmin on 1/12/19.
//  Copyright © 2019 Min. All rights reserved.
//

import UIKit
import SideMenu
import SwiftMessages
import SkyFloatingLabelTextField
import AVFoundation
import EZLoadingActivity

class MainViewController: UIViewController, AVCaptureMetadataOutputObjectsDelegate, UITextFieldDelegate {

    @IBOutlet weak var messageLabel: UILabel!

    var captureSession:AVCaptureSession?
    var videoPreviewLayer:AVCaptureVideoPreviewLayer?
    var qrCodeFrameView:UIView?
    var video: AVCaptureVideoPreviewLayer?
    var cameraPosition = AVCaptureDevice.Position.back
    
    var isCameraPermission: Bool = false
    
    var checkBarButton: UIBarButtonItem!
    var searchButton: UIBarButtonItem!
    
    private let supportedCodeTypes = [AVMetadataObject.ObjectType.upce,
                                      AVMetadataObject.ObjectType.code39,
                                      AVMetadataObject.ObjectType.code39Mod43,
                                      AVMetadataObject.ObjectType.code93,
                                      AVMetadataObject.ObjectType.code128,
                                      AVMetadataObject.ObjectType.ean8,
                                      AVMetadataObject.ObjectType.ean13,
                                      AVMetadataObject.ObjectType.aztec,
                                      AVMetadataObject.ObjectType.pdf417,
                                      AVMetadataObject.ObjectType.itf14,
                                      AVMetadataObject.ObjectType.dataMatrix,
                                      AVMetadataObject.ObjectType.interleaved2of5,
                                      AVMetadataObject.ObjectType.qr    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.hideKeyboardWhenTappedAround()
        
        checkBarButton = UIBarButtonItem(image: UIImage(named: "CheckIcon"), style: .plain, target: self, action: #selector(checkSelected))
        searchButton = UIBarButtonItem(image: UIImage(named: "SearchIcon"), style: .plain, target: self, action: #selector(searchSelected))
        self.navigationItem.rightBarButtonItems = [checkBarButton, searchButton]
        
        self.navigationItem.title = "Scanning".localized
        
        // 카메라 사용 권한을 요청
        AVCaptureDevice.requestAccess(for: AVMediaType.video) { response in
            if response {
                self.isCameraPermission = true
            } else {
                DispatchQueue.main.async {
                    ControlUtil.ToastMessage(.error, title: "Camera Error".localized, content: "No camera access. Change your setting for the camera.".localized)
                }
            }
        }
        
        // 카메라 사용 권한 획득 후 초기화 코드
        Timer.scheduledTimer(withTimeInterval: 0.5, repeats: true) { (timer) in
            if self.isCameraPermission {
                timer.invalidate()
                
                DispatchQueue.main.async {
                    _ = self.startCamera()
                }
            }
        }
        
        messageLabel.text = "Slowly move the equipment until the camera is focused. Don't take it too close.".localized
        
        // Get the back-facing camera for capturing videos
        let deviceDiscoverySession = AVCaptureDevice.DiscoverySession(deviceTypes: [.builtInDualCamera], mediaType: AVMediaType.video, position: .back)
        
        guard let captureDevice = deviceDiscoverySession.devices.first else {
            print("Failed to get the camera device")
            return
        }
        
        do {
            // Get an instance of the AVCaptureDeviceInput class using the previous device object.
            let input = try AVCaptureDeviceInput(device: captureDevice)
            
            // Set the input device on the capture session.
            captureSession?.addInput(input)
            
            // Initialize a AVCaptureMetadataOutput object and set it as the output device to the capture session.
            let captureMetadataOutput = AVCaptureMetadataOutput()
            captureSession?.addOutput(captureMetadataOutput)
            
            // Set delegate and use the default dispatch queue to execute the call back
            captureMetadataOutput.setMetadataObjectsDelegate(self as? AVCaptureMetadataOutputObjectsDelegate, queue: DispatchQueue.main)
            captureMetadataOutput.metadataObjectTypes = [AVMetadataObject.ObjectType.qr]
            
            // Initialize QR Code Frame to highlight the QR code
            qrCodeFrameView = UIView()
            
            if let qrCodeFrameView = qrCodeFrameView {
                qrCodeFrameView.layer.borderColor = UIColor.green.cgColor
                qrCodeFrameView.layer.borderWidth = 2
                view.addSubview(qrCodeFrameView)
                view.bringSubviewToFront(qrCodeFrameView)
            }
            
        } catch {
            // If any error occurs, simply print it out and don't continue any more.
            print(error)
            return
        }
        
        
        // Initialize the video preview layer and add it as a sublayer to the viewPreview view's layer.
        videoPreviewLayer = AVCaptureVideoPreviewLayer(session: captureSession!)
        videoPreviewLayer?.videoGravity = AVLayerVideoGravity.resizeAspectFill
        videoPreviewLayer?.frame = view.layer.bounds
        view.layer.addSublayer(videoPreviewLayer!)
        
        // Start video capture.
        captureSession!.startRunning()
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        EZLoadingActivity.show("Loading...".localized, disableUI: true)
        DispatchQueue.global().async {
            sleep(1)
            DispatchQueue.main.sync {
                EZLoadingActivity.hide()
            }
        }
    }
    
    // 초기화 - AVCaptureSession 객체를 생성하고 초기화
    func startCamera() -> Bool {
        
        if let captureDevice = getCameraDevice() {
            //            flashButton.isHidden = !captureDevice.hasTorch
            //            setFlashIcon()
            do {
                let input = try AVCaptureDeviceInput(device: captureDevice)
                
                captureSession = AVCaptureSession()
                if captureSession!.canAddInput(input) {
                    captureSession?.addInput(input)
                } else {
                    ControlUtil.ToastMessage(.error, title: "Camera Error".localized, content: "No camera access. Change your setting for the camera.".localized)
                    captureSession = nil
                    return false
                }
            } catch let error {
                ControlUtil.ToastMessage(.error, title: "Camera Error".localized, content: error.localizedDescription)
                return false
            }
        } else {
            ControlUtil.ToastMessage(.error, title: "Camera Error".localized, content: "No camera access. Change your setting for the camera.".localized)
            return false
        }
        
        if let captureSession = captureSession {
            let output = AVCaptureMetadataOutput()
            captureSession.addOutput(output)
            output.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
            output.metadataObjectTypes = supportedCodeTypes
            
            video = AVCaptureVideoPreviewLayer(session: captureSession)
            if let video = video {
                video.frame = view.layer.bounds
                view.layer.addSublayer(video)
            }
            view.bringSubviewToFront(messageLabel)
            //            view.bringSubviewToFront(imageLibraryButton)
            //            view.bringSubviewToFront(switchCameraButton)
            //            view.bringSubviewToFront(flashButton)
            if qrCodeFrameView == nil {         // Initialize QR Code Frame to highlight the QR code
                qrCodeFrameView = UIView()
                if let qrCodeFrameView = qrCodeFrameView {
                    qrCodeFrameView.layer.borderColor = UIColor.green.cgColor
                    qrCodeFrameView.layer.borderWidth = 2
                    view.addSubview(qrCodeFrameView)
                    view.bringSubviewToFront(qrCodeFrameView)
                }
            }
            
            captureSession.startRunning()
        }
        return true
    }
    
    
    func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {
        // Check if the metadataObjects array is not nil and it contains at least one object.
        if metadataObjects.count == 0 {
            qrCodeFrameView?.frame = CGRect.zero
            messageLabel.text = "No QR code is detected"
            return
        }
        
        // Get the metadata object.
        let metadataObj = metadataObjects[0] as! AVMetadataMachineReadableCodeObject
        
        if metadataObj.type == AVMetadataObject.ObjectType.qr {
            // If the found metadata is equal to the QR code metadata then update the status label's text and set the bounds
            let barCodeObject = videoPreviewLayer?.transformedMetadataObject(for: metadataObj)
            //            qrCodeFrameView?.frame = barCodeObject!.bounds
            
            if metadataObj.stringValue != nil {
                messageLabel.text = metadataObj.stringValue
            }
        }
    }
    
    func getCameraDevice() -> AVCaptureDevice? {
        return AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: cameraPosition)
    }
    
    @objc func checkSelected(_ sender: Any) {
        let viewcontroller = storyboard?.instantiateViewController(withIdentifier: "FoodDetailsViewController") as! FoodDetailsViewController
        self.navigationController?.pushViewController(viewcontroller, animated: true)
    }
    
    @objc func searchSelected(_ sender: Any) {
        let view: ConfirmDialogView = try! SwiftMessages.viewFromNib()
        view.configureDropShadow()
        
        view.yesAction = {
//            let id: Int64 = self.labelList[self.labelIndex].taskList[indexPath.row].ID
//
//            var listIndex = self.listList.lastIndex(where: {$0.TaskID == id})
//            while listIndex != nil {
//                self.listList.remove(at: listIndex!)
//                listIndex = self.listList.lastIndex(where: {$0.TaskID == id})
//            }
//
//            _ = MainViewController.Database.DeleteTask(id: id)
//            self.taskList.remove(at: self.taskList.lastIndex(where: {$0.ID == id})!)
//            self.labelList[self.labelIndex].taskList.remove(at: indexPath.row)
//            tableView.reloadData()
            //                self.tableView.deleteRows(at: [indexPath], with: .automatic)
            SwiftMessages.hide()
        }
        
        view.cancelAction = {
            SwiftMessages.hide()
        }
        
        view.barcodeTextField.delegate = self
        
        var config = SwiftMessages.defaultConfig
        config.presentationContext = .window(windowLevel: UIWindow.Level.normal)
        config.duration = .forever
        config.presentationStyle = .center
        config.dimMode = .gray(interactive: true)
        view.initControl()
        SwiftMessages.show(config: config, view: view)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {   //delegate method
        textField.resignFirstResponder()
        return true
    }
}

