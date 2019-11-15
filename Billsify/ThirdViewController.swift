//
//  ThirdViewController.swift
//  Billsify
//
//  Created by Lisbet Meneses on 10/11/2019.
//  Copyright © 2019 Lisbet Meneses. All rights reserved.
//

import UIKit
import CoreData

class ThirdViewController: UIViewController {

    @IBOutlet var scrollView: UIScrollView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
               
        do {
            let bills = try context.fetch(NSFetchRequest<NSFetchRequestResult>(entityName: "Bills"))
            var categories: [String] = []
            var imgpath: [String] = []
            for bill in bills {
                let bill_category = (bill as! Bills).category!
                if (!categories.contains(bill_category)) {
                    categories.append(bill_category)
                    let img = (bill as! Bills).imgpath!
                    imgpath.append(img)
               }
           }
            let fileManager = FileManager.default
            var topAnchor = view.topAnchor
            var image = UIImage()
            for imageName in imgpath {
                if fileManager.fileExists(atPath: imageName){
                    image = UIImage(contentsOfFile: imageName)!
                } else {
                    image = UIImage(named: "empty_bill.png")!
                    print("Panic! No Image!")
                }
                
                let imageView = UIImageView(image: image)
                imageView.translatesAutoresizingMaskIntoConstraints = false
                scrollView.addSubview(imageView)
                
                // Pin the bottomedge of yourView to the margin's leading edge
                imageView.topAnchor.constraint(equalTo: topAnchor).isActive = true

                // The height of your view
                imageView.heightAnchor.constraint(equalToConstant: 200).isActive = true
                
                imageView.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
                
                imageView.contentMode = UIView.ContentMode.scaleAspectFill
                
                topAnchor = imageView.bottomAnchor
            }           

        } catch{
           print ("Failed request")
            
        }
        
        // Do any additional setup after loading the view.
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
