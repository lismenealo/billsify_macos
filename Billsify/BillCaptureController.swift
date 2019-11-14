//
//  SecondViewController.swift
//  Billsify
//
//  Created by Lisbet Meneses on 10/11/2019.
//  Copyright © 2019 Lisbet Meneses. All rights reserved.
//

import UIKit
import Photos

class BillCaptureController: UIViewController {

    @IBOutlet weak var capturePreviewView2: UIImageView!
    @IBOutlet weak var previewCapture: UIImageView!
    @IBOutlet weak var captureButton2: UIButton!
    
    let cameraController = CameraController()
    
    static var img_path = "empty.png"
    
    override var prefersStatusBarHidden: Bool { return true }
    
    var session: AVCaptureSession?
    var stillImageOutput: AVCapturePhotoOutput?
    var videoPreviewLayer: AVCaptureVideoPreviewLayer?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        func configureCameraController() {
            cameraController.prepare {(error) in
                if let error = error {
                    print(error)
                }
                
                try? self.cameraController.displayPreview(on: self.capturePreviewView2)
            }
        }
        
        func styleCaptureButton() {
            captureButton2.layer.borderColor = UIColor.black.cgColor
            captureButton2.layer.borderWidth = 2
            
            captureButton2.layer.cornerRadius = min(captureButton2.frame.width, captureButton2.frame.height) / 2
        }
        
        styleCaptureButton()
        configureCameraController()
    }
    
    @IBAction func CapureImage(_ sender: Any) {
        
        self.saveImage(imageName: "bill" + Int64.random(in: 1...999999999999999999).description + ".png")
        print(BillCaptureController.img_path)
        
        cameraController.captureImage {(image, error) in
            guard let image = image else {
                print(error ?? "Image capture error")
                return
            }
            
            try? PHPhotoLibrary.shared().performChangesAndWait {
                PHAssetChangeRequest.creationRequestForAsset(from: image)
            }
        }
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let newViewController = storyBoard.instantiateViewController(withIdentifier: "NewBill") as! NewBillViewController
        self.present(newViewController, animated: true, completion: nil)
    }
    
    func saveImage(imageName: String){
        //create an instance of the FileManager
        let fileManager = FileManager.default
        //get the image path
        let imagePath = (NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as NSString).appendingPathComponent(imageName)
        //get the image we took with camera
        let image = capturePreviewView2.image!
        //get the PNG data for this image
        let data = image.pngData()
        //store it in the document directory
        fileManager.createFile(atPath: imagePath as String, contents: data, attributes: nil)
        
        BillCaptureController.img_path = imagePath
    }

}

