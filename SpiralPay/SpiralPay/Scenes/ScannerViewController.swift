//
//  ScannerViewController.swift
//  SpiralPay
//
//  Created by Zoeb on 27/02/18.
//  Copyright © 2018 EnvisionWorld. All rights reserved.
//

import AVFoundation
import UIKit

class ScannerViewController: SpiralPayViewController, AVCaptureMetadataOutputObjectsDelegate {

    @IBOutlet weak var mainView: UIView!
    @IBOutlet weak var centerView: UIView!
    
    var captureSession: AVCaptureSession!
    var previewLayer: AVCaptureVideoPreviewLayer!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        view.backgroundColor = UIColor.black
        captureSession = AVCaptureSession()
        
        guard let videoCaptureDevice = AVCaptureDevice.default(for: .video) else { return }
        let videoInput: AVCaptureDeviceInput
        
        do {
            videoInput = try AVCaptureDeviceInput(device: videoCaptureDevice)
        } catch {
            return
        }
        
        if (captureSession.canAddInput(videoInput)) {
            captureSession.addInput(videoInput)
        } else {
            failed()
            return
        }
        
        let metadataOutput = AVCaptureMetadataOutput()
        
        if (captureSession.canAddOutput(metadataOutput)) {
            captureSession.addOutput(metadataOutput)
            
            metadataOutput.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
            metadataOutput.metadataObjectTypes = [.qr]
        } else {
            failed()
            return
        }
        
        previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        previewLayer.frame = view.layer.bounds
        previewLayer.videoGravity = .resizeAspectFill
        mainView.layer.addSublayer(previewLayer)
        
        captureSession.startRunning()
    }
    
    func failed() {
        let ac = UIAlertController(title: "Scanning not supported", message: "Your device does not support scanning a code from an item. Please use a device with a camera.", preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "OK", style: .default))
        present(ac, animated: true)
        captureSession = nil
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if (captureSession?.isRunning == false) {
            captureSession.startRunning()
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        if (captureSession?.isRunning == true) {
            captureSession.stopRunning()
        }
    }
    
    func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {
        if metadataObjects.count == 0 {
            print("No Input Detected")
            return
        }
        
        if let metadataObject = metadataObjects.first {
            let barCodeObject = previewLayer?.transformedMetadataObject(for: metadataObject)

            let qrBounds = barCodeObject!.bounds
            if centerView.frame.origin.x < qrBounds.origin.x &&
                (centerView.frame.origin.x + centerView.frame.size.width) > (qrBounds.origin.x + qrBounds.size.width) &&
                centerView.frame.origin.y < qrBounds.origin.y &&
                (centerView.frame.origin.y + centerView.frame.size.height) > (qrBounds.origin.y + qrBounds.size.height){
                //QR in box
                centerView.layer.borderColor = UIColor.green.cgColor
                
                //Do further process
                guard let readableObject = metadataObject as? AVMetadataMachineReadableCodeObject else { return }
                guard let stringValue = readableObject.stringValue else { return }
                AudioServicesPlaySystemSound(SystemSoundID(kSystemSoundID_Vibrate))
                
                found(code: stringValue)
                
                captureSession.stopRunning()
                dismiss(animated: true)
                
            }
        }
    }
    
    func found(code: String) {
        print(code)
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .portrait
    }
    
    //MARK:- IBAction methods
    
    @IBAction func outsideAreaTapped() {
        self.dismiss(animated: true, completion: nil)
    }
    
    
}
