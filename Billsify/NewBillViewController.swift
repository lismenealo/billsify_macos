//
//  NewBillViewController.swift
//  Billsify
//
//  Created by Lisbet Meneses on 12/11/2019.
//  Copyright © 2019 Lisbet Meneses. All rights reserved.
//

import UIKit

class NewBillViewController: UIViewController {

    @IBOutlet weak var categoryInput: UITextField!
    @IBOutlet weak var amountInput: UITextField!
    @IBOutlet weak var descriptionInput: UITextField!
    @IBOutlet weak var capturedImagePreview: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        self.getImage()
    }
    
    @IBAction func submitBill(_ sender: Any) {
        
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        
        let bill = Bills(context: context)
        bill.id = Double.random(in: 1...99999999999999999999)
        bill.amount = 200
        bill.category = categoryInput.text
        bill.billdescription = descriptionInput.text
        bill.date = Date()
        bill.imgpath = BillCaptureController.img_path
        
        (UIApplication.shared.delegate as! AppDelegate).saveContext()
        
        performSegue(withIdentifier: "SegueToHome", sender: self)
    }
    
    @IBAction func cancelCreation(_ sender: Any) {
        performSegue(withIdentifier: "SegueToHome", sender: self)
    }
    
    func getImage(){
        let fileManager = FileManager.default
        
        if fileManager.fileExists(atPath: BillCaptureController.img_path){
            capturedImagePreview.image = UIImage(contentsOfFile: BillCaptureController.img_path)
        }else{
            print("Panic! No Image!")
        }
    }

}
