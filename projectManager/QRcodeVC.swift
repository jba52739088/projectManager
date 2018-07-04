//
//  QRcodeVC.swift
//  myCustomCamera
//
//  Created by 黃恩祐 on 2017/11/26.
//  Copyright © 2017年 ENYUHUANG. All rights reserved.
//

import UIKit
import AVFoundation

class QRcodeVC: UIViewController, AVCaptureMetadataOutputObjectsDelegate {

    
    @IBOutlet weak var messageLabel: UILabel!
    @IBOutlet weak var label: UILabel!
    
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    var captureSession:AVCaptureSession?
    var videoPreviewLayer:AVCaptureVideoPreviewLayer?
    var qrCodeFrameView:UIView?
    var error:NSError?
    var isGetData = false
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let captureDevice = AVCaptureDevice.default(for: AVMediaType.video)
        var input: AVCaptureDeviceInput!
        do{
            input = try AVCaptureDeviceInput(device: captureDevice!)
        }catch let error as NSError{
            input = nil
            self.error = error
            print(self.error!.localizedDescription)
        }
        captureSession = AVCaptureSession()
        captureSession?.addInput(input as AVCaptureInput)
        let captureMetadataOutput = AVCaptureMetadataOutput()
        captureSession?.addOutput(captureMetadataOutput)
        captureMetadataOutput.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
        captureMetadataOutput.metadataObjectTypes = [AVMetadataObject.ObjectType.qr]
        videoPreviewLayer = AVCaptureVideoPreviewLayer(session: captureSession!)
        videoPreviewLayer?.videoGravity = AVLayerVideoGravity.resizeAspectFill
        videoPreviewLayer?.frame = view.layer.bounds
        view.layer.addSublayer(videoPreviewLayer!)
        captureSession?.startRunning()
        view.bringSubview(toFront: messageLabel)

        qrCodeFrameView = UIView()
        qrCodeFrameView?.layer.borderColor = UIColor.black.cgColor
        qrCodeFrameView?.layer.borderWidth = 2
        view.addSubview(qrCodeFrameView!)
        view.bringSubview(toFront: qrCodeFrameView!)
        view.bringSubview(toFront: self.label)

    }

    func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection){
        if metadataObjects == nil || metadataObjects.count == 0 {
            qrCodeFrameView?.frame = CGRect.zero
            return
        }
        self.captureSession?.stopRunning()
        let metadataObj = metadataObjects[0] as! AVMetadataMachineReadableCodeObject
        if metadataObj.type == AVMetadataObject.ObjectType.qr {
            
            let barCodeObject = videoPreviewLayer?.transformedMetadataObject(for: metadataObj as
                AVMetadataMachineReadableCodeObject) as! AVMetadataMachineReadableCodeObject
            qrCodeFrameView?.frame = barCodeObject.bounds;
            if metadataObj.stringValue != nil {
                messageLabel.text = metadataObj.stringValue
                self.insertMatchedMemberRequest(invite_id: metadataObj.stringValue!, { (isSucceed, message) in
                    if isSucceed {
                        print("scan succeed")
                        if let didScanVC = self.storyboard?.instantiateViewController(withIdentifier: "didScanVC") as? didScanVC {
                            didScanVC.memberName = message
                            self.navigationController?.pushViewController(didScanVC, animated: true)
                        }
                    }
                })
                return
            }
        }
        
    }
    
    func getData(){
//        if isGetData == false{
//            isGetData = true
//        if (self.messageLabel.text == "https://goo.gl/4y5g1L") {
//            appDelegate.tag01 = 3
//        }else if (self.messageLabel.text == "https://goo.gl/jN8cDv") {
//            appDelegate.tag01 = 6
//        }else if (self.messageLabel.text == "https://goo.gl/b6cLNv") {
//            appDelegate.tag01 = 2
//        }else if (self.messageLabel.text == "https://goo.gl/wIfPlm") {
//            appDelegate.tag01 = 5
//        }else if (self.messageLabel.text == "https://goo.gl/O4Rl0I") {
//            appDelegate.tag01 = 4
//        }
//
//        let nextVC = self.storyboard?.instantiateViewController(withIdentifier: "stepThreeLv1VC") as! stepThreeLv1VC
//        nextVC.view.frame = appDelegate.mainVC.view.frame
//        appDelegate.mainVC.addChildViewController(nextVC)
//        appDelegate.mainVC.view.addSubview(nextVC.view)
//        nextVC.didMove(toParentViewController: appDelegate.mainVC)
//        self.view.removeFromSuperview()
//        }
    
    }

}
