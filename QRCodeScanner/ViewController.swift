//
//  ViewController.swift
//  QRCodeScanner
//
//  Created by Bibek on 5/19/19.
//  Copyright © 2019 ARtech. All rights reserved.
//

import AVFoundation
import UIKit

class ViewController: UIViewController, AVCaptureMetadataOutputObjectsDelegate {
    
    @IBOutlet var videoPreview : UIView!
    
    var stringUrL = String()
    
    enum error : Error{
        case noCameraAvailable
        case videoInputInitFail
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        do{
            try scanQrCode()
        }catch{
            print("Failed to scan the QR/BarCode")
        }
        
    }
    
    func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {
        if metadataObjects.count > 0 {
            let mechineReadableCode = metadataObjects[0] as! AVMetadataMachineReadableCodeObject
            if mechineReadableCode.type == AVMetadataObject.ObjectType.qr {
                stringUrL = mechineReadableCode.stringValue!
//                performSegue(withIdentifier: "openUrl", sender: self)
                let vc  = self.storyboard?.instantiateViewController(withIdentifier: "WebViewController") as! WebViewController
                self.present(vc, animated: true, completion: nil)
                AudioServicesPlaySystemSound(SystemSoundID(kSystemSoundID_Vibrate))
                print(mechineReadableCode.stringValue!)
            }
        }
    }
    
    func scanQrCode() throws{
        let avCaptureSession = AVCaptureSession()
        
        guard let avCaptureDevice = AVCaptureDevice.default(for:
            AVMediaType.video) else{
                print("No Camera")
                
                throw error.noCameraAvailable
        }
        
        guard let avCaptureInput = try? AVCaptureDeviceInput(
            device: avCaptureDevice) else{
            print("Failed to init camera.")
                throw error.videoInputInitFail
        }
        
        let avCaputerMetadataOutput = AVCaptureMetadataOutput()
        avCaputerMetadataOutput.setMetadataObjectsDelegate(self,queue: DispatchQueue.main)
        
        avCaptureSession.addInput(avCaptureInput)
        avCaptureSession.addOutput(avCaputerMetadataOutput)
        
        avCaputerMetadataOutput.metadataObjectTypes =
        [AVMetadataObject.ObjectType.qr]
        
        let avCaptureVideoPreviewLayer =
            AVCaptureVideoPreviewLayer(session: avCaptureSession)
        avCaptureVideoPreviewLayer.videoGravity = AVLayerVideoGravity.resizeAspectFill
        
        avCaptureVideoPreviewLayer.frame = videoPreview.bounds
        self.videoPreview.layer.addSublayer(avCaptureVideoPreviewLayer)
        
        avCaptureSession.startRunning()
    }
    
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        if segue.identifier == "openUrl" {
//            let destination = segue.destination as! WebViewController
//            destination.url = URL(string: stringUrL)
//        }
//    }
    
}

