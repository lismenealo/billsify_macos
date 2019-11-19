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

        //Load context for fetching db
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        
        do {
            //Fetch bills in category
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
            //Get preview of all image bill in category
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
                
                //Define constraints
                imageView.topAnchor.constraint(equalTo: topAnchor).isActive = true
                
                imageView.heightAnchor.constraint(equalToConstant: 200).isActive = true
                   
                imageView.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
                   
                imageView.contentMode = UIView.ContentMode.scaleAspectFit
                
                //Upadate topAnchor as the current image bottomAnchor to be use on next iteration
                topAnchor = imageView.bottomAnchor
                
                //Define textView with information of the bill, to be attached to the bill image thumb
                let category = UITextView()
                category.text = "Amount: \(billsInCategory[imgpath.firstIndex(of: imageName)!].amount) \nDate: \(billsInCategory[imgpath.firstIndex(of: imageName)!].date!.description)"
                imageView.addSubview(category)
                category.translatesAutoresizingMaskIntoConstraints = false
                  
                category.topAnchor.constraint(equalTo: imageView.topAnchor).isActive = true
                  
                category.widthAnchor.constraint(equalTo: imageView.widthAnchor).isActive = true
                  
                category.bottomAnchor.constraint(equalTo: imageView.bottomAnchor).isActive = true
                
                //Set up textView styles
                category.backgroundColor = UIColor.black
                category.textColor = UIColor.white
                category.alpha = CGFloat(0.6)
                category.isEditable = false
                category.isUserInteractionEnabled = false
                   
                //Subscribe to tapEvent on image
                let singleTab = UITapGestureRecognizer(target: self, action:  #selector (BillsGalleryViewController.openCategoryDetails (_:)))
                imageView.isUserInteractionEnabled = true
                imageView.addGestureRecognizer(singleTab)
            }
            
            //Update content size to be able to move among bill thumbs
            scroll.contentSize.height = CGFloat(imgpath.count * 200)

        } catch {
              print ("Failed request")
        }
    }
       
    @objc func openCategoryDetails(_ sender:UITapGestureRecognizer) {
        //Get image tapped
        let tappedImage = sender.view as! UIImageView
        //Get textView from ImageView
        let subview = tappedImage.subviews[0] as! UITextView
        //Retrieve substring from TextView with the timestamp of bill created
        let index =  subview.text!.index( subview.text!.endIndex, offsetBy: -25)
        let mySubstring =  subview.text!.suffix(from: index)
        //Pass on information for bill details view
        BillZoomViewController.billDate = String(mySubstring)
        //Navigate to bill details view
        performSegue(withIdentifier: "billsImageZoom", sender: self)
    }
}
