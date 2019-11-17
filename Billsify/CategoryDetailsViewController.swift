//
//  AlbumViewController.swift
//  Billsify
//
//  Created by Lisbet Meneses on 15/11/2019.
//  Copyright © 2019 Lisbet Meneses. All rights reserved.
//

import UIKit
import CoreData

class CategoryDetailsViewController: UIViewController {

    static var category: String = ""
    @IBOutlet weak var scroll: UIScrollView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
                      
           do {
               let bills = try context.fetch(NSFetchRequest<NSFetchRequestResult>(entityName: "Bills"))
               var imgpath: [String] = []
            var billsInCategory: [Bills] = []
               for bill in bills {
                   let bill_category = (bill as! Bills).category!
                if (CategoryDetailsViewController.category == bill_category) {
                       let img = (bill as! Bills).imgpath!
                       imgpath.append(img)
                    billsInCategory.append(bill as! Bills)
                  }
              }
               let fileManager = FileManager.default
               var topAnchor = scroll.contentLayoutGuide.topAnchor
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
                   scroll.addSubview(imageView)
                   
                   // Pin the bottomedge of yourView to the margin's leading edge
                   imageView.topAnchor.constraint(equalTo: topAnchor).isActive = true

                   // The height of your view
                   imageView.heightAnchor.constraint(equalToConstant: 200).isActive = true
                   
                   imageView.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
                   
                   imageView.contentMode = UIView.ContentMode.scaleAspectFit
                
                  topAnchor = imageView.bottomAnchor
                  let category = UITextView()
                category.text = "Amount: \(billsInCategory[imgpath.firstIndex(of: imageName)!].amount) \nDate: \(billsInCategory[imgpath.firstIndex(of: imageName)!].date!.description)"
                  imageView.addSubview(category)
                  category.translatesAutoresizingMaskIntoConstraints = false
                  
                  category.topAnchor.constraint(equalTo: imageView.topAnchor).isActive = true
                  
                  category.widthAnchor.constraint(equalTo: imageView.widthAnchor).isActive = true
                  
                  category.bottomAnchor.constraint(equalTo: imageView.bottomAnchor).isActive = true
                  
                  category.backgroundColor = UIColor.black
                  category.textColor = UIColor.white
                  category.alpha = CGFloat(0.6)
                  category.isEditable = false
                  category.isUserInteractionEnabled = false
                   
                   let singleTab = UITapGestureRecognizer(target: self, action:  #selector (BillsGalleryViewController.openCategoryDetails (_:)))
                   imageView.isUserInteractionEnabled = true
                   imageView.addGestureRecognizer(singleTab)
               }
               
               scroll.contentSize.height = CGFloat(imgpath.count * 200)

           } catch{
              print ("Failed request")
               
           }
       }
       
       @objc func openCategoryDetails(_ sender:UITapGestureRecognizer){
           let tappedImage = sender.view as! UIImageView
           let subview = tappedImage.subviews[0] as! UITextView
           let index =  subview.text!.index( subview.text!.endIndex, offsetBy: -25)
           let mySubstring =  subview.text!.suffix(from: index) // playground
           BillZoomViewController.billDate = String(mySubstring)
           performSegue(withIdentifier: "billsImageZoom", sender: self)
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
