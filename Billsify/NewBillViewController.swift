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

        //Get image thumbnail for captured one
        self.getImage()
    }
    
    /*
     Action triggered on submit button clicked
     */
    @IBAction func submitBill(_ sender: Any) {
        
        //Set up CoreDAta context to persist in DB the new bill
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        
        //Retrieve information from view
        let bill = Bills(context: context)
        bill.id = Double.random(in: 1...99999999999999)
        bill.amount = Double(amountInput.text!)!
        bill.category = categoryInput.text
        bill.billdescription = descriptionInput.text
        bill.date = Date()
        bill.imgpath = BillCaptureController.img_path
        
        //Commit transaction persist the instance on DB
        (UIApplication.shared.delegate as! AppDelegate).saveContext()
        
        //Perform navigation to home
        performSegue(withIdentifier: "SegueToHome", sender: self)
    }
    
    @IBAction func cancelCreation(_ sender: Any) {
        //Perform navigation to Home
        performSegue(withIdentifier: "SegueToHome", sender: self)
    }
    
    /*
     Retrieves image from file path and pass it on to the ImagaView
     */
    func getImage(){
        let fileManager = FileManager.default
        
        if fileManager.fileExists(atPath: BillCaptureController.img_path){
            capturedImagePreview.image = UIImage(contentsOfFile: BillCaptureController.img_path)
        }else{
            print("Panic! No Image!")
        }
    }

}
