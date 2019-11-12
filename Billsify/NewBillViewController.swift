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
        
        let bill = Bill(context: context)
        bill.id = Double.random(in: 1...99999999999999999999) as NSNumber
        bill.amount = Double(amountInput.text!) as! Double
        bill.category = categoryInput.text
        bill.bill_description = descriptionInput.text
        bill.date = Date()
        bill.img_path = BillCaptureController.img_path
        
        (UIApplication.shared.delegate as! AppDelegate).saveContext()
        
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let newViewController = storyBoard.instantiateViewController(withIdentifier: "BillsBrief") as! BillsBriefViewController
        self.present(newViewController, animated: true, completion: nil)
    }
    
    @IBAction func cancelCreation(_ sender: Any) {
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
