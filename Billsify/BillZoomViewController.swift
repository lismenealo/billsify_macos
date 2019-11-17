//
//  BillZoomViewController.swift
//  Billsify
//
//  Created by Lisbet Meneses on 15/11/2019.
//  Copyright © 2019 Lisbet Meneses. All rights reserved.
//

import UIKit
import CoreData

class BillZoomViewController: UIViewController {

    @IBOutlet weak var imageView: UIImageView!
    
    static var billDate: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()

        print(BillZoomViewController.billDate)
        
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
                           
        do {
            let bills = try context.fetch(NSFetchRequest<NSFetchRequestResult>(entityName: "Bills"))
            var billCurrent: Bills
            for bill in bills {
                if (BillZoomViewController.billDate == (bill as! Bills).date!.description) {
                    billCurrent = bill as! Bills
                    let fileManager = FileManager.default
                    var image = UIImage()
                    if fileManager.fileExists(atPath: billCurrent.imgpath!){
                        image = UIImage(contentsOfFile: billCurrent.imgpath!)!
                     } else {
                         image = UIImage(named: "empty_bill.png")!
                         print("Panic! No Image!")
                     }
                    imageView.image = image
                    break
                }
            }
                      
        } catch{
            print ("Failed request")
        }
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
