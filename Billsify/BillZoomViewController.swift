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
    
    static var billDate: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()

        print(BillZoomViewController.billDate)
        
        //Create ImageView
        let imageView = UIImageView()
        view.addSubview(imageView)
        
        //Context from CoreData to retrieve stored information
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
                           
        do {
            let bills = try context.fetch(NSFetchRequest<NSFetchRequestResult>(entityName: "Bills"))
            var billCurrent: Bills
            //Get bill with the exact timestamp refered
            for bill in bills {
                if (BillZoomViewController.billDate == (bill as! Bills).date!.description) {
                    billCurrent = bill as! Bills
                    let fileManager = FileManager.default
                    ///Update image view with imagePath from Bill
                    var image = UIImage()
                    if fileManager.fileExists(atPath: billCurrent.imgpath!){
                        image = UIImage(contentsOfFile: billCurrent.imgpath!)!
                     } else {
                         image = UIImage(named: "empty_bill.png")!
                         print("Panic! No Image!")
                     }
                    imageView.image = image
                    imageView.contentMode = UIView.ContentMode.scaleAspectFit
                    imageView.translatesAutoresizingMaskIntoConstraints = false
                    
                    //Set constraints for IamgeView
                    imageView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true

                    imageView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
                    
                    imageView.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
                    
                    //Set up textView with all information regarding the bill in question
                    let category = UITextView()
                    category.text = "Category:  \(billCurrent.category!) \nAmount: \(billCurrent.amount) \nDate: \(billCurrent.date!.description) \nDescription: \(billCurrent.billdescription!)"
                    
                    imageView.addSubview(category)
                    category.translatesAutoresizingMaskIntoConstraints = false
                    
                    category.topAnchor.constraint(equalTo: imageView.topAnchor).isActive = true
                    
                    category.widthAnchor.constraint(equalTo: imageView.widthAnchor).isActive = true
                    
                    category.heightAnchor.constraint(equalToConstant: 200).isActive = true
                    
                    //Styling textView
                    category.backgroundColor = UIColor.black
                    category.textColor = UIColor.white
                    category.alpha = CGFloat(0.6)
                    category.isEditable = false
                    category.isUserInteractionEnabled = false
                    
                    break
                }
            }
                      
        } catch{
            //TODO: Enrich error handling
            print ("Failed request")
        }
    }
}
