//
//  ThirdViewController.swift
//  Billsify
//
//  Created by Lisbet Meneses on 10/11/2019.
//  Copyright © 2019 Lisbet Meneses. All rights reserved.
//

import UIKit
import CoreData

class BillsGalleryViewController: UIViewController {

    @IBOutlet var scroll: UIScrollView!
    @IBOutlet var scrollView: UIScrollView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Create context to retrieve bills from DB using CoreData
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
               
        do {
            //Retrieve bills group by category, get sample bill image as thumnail
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
            //Instantiate fileManager object to retrieve preview of imgPath
            let fileManager = FileManager.default
            var topAnchor = scroll.contentLayoutGuide.topAnchor
            var image = UIImage()
            for imageName in imgpath {
                if fileManager.fileExists(atPath: imageName){
                    image = UIImage(contentsOfFile: imageName)!
                } else {
                    //In case the file does not exist use empty_bill image as default, print an info in console
                    image = UIImage(named: "empty_bill.png")!
                    print("Panic! No Image!")
                }
                //Load preview on category thumbnail, attach the created imageView to the scrollView
                let imageView = UIImageView(image: image)
                imageView.translatesAutoresizingMaskIntoConstraints = false
                scroll.addSubview(imageView)
                
                //Set up constraint for the ImageView
                imageView.topAnchor.constraint(equalTo: topAnchor, constant: CGFloat(5)).isActive = true

                imageView.heightAnchor.constraint(equalToConstant: 200).isActive = true
                
                imageView.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
                
                //Set ContentMode
                imageView.contentMode = UIView.ContentMode.scaleAspectFit
                
                //Set topAnchor as bottom of the currnt image to be used on the next iteraation
                topAnchor = imageView.bottomAnchor
                
                //Create textView to print information of the category on top of the image
                let category = UITextView()
                category.text = categories[imgpath.firstIndex(of: imageName)!]
                imageView.addSubview(category)
                
                //Set up contraints of the textView within the image
                category.translatesAutoresizingMaskIntoConstraints = false
                
                category.topAnchor.constraint(equalTo: imageView.topAnchor).isActive = true
                
                category.widthAnchor.constraint(equalTo: imageView.widthAnchor).isActive = true
                
                category.bottomAnchor.constraint(equalTo: imageView.bottomAnchor).isActive = true
                
                //Set up styles of the textView and disable userInteraction
                category.backgroundColor = UIColor.black
                category.textColor = UIColor.white
                category.alpha = CGFloat(0.6)
                category.isEditable = false
                category.isUserInteractionEnabled = false
                
                //Create GestureRecognizer and subscribe to the event. Enable userInteraction on ImageView
                let singleTab = UITapGestureRecognizer(target: self, action:  #selector (BillsGalleryViewController.openCategoryDetails (_:)))
                imageView.isUserInteractionEnabled = true
                imageView.addGestureRecognizer(singleTab)
            }
            
            //Set up contentSize on scrollView to allow srolling among all categories listed
            scroll.contentSize.height = CGFloat(imgpath.count * 200)

        } catch{
            //TODO: Better error handling. More than just failed request can happen above
           print ("Failed request")
            
        }
    }
    
    //Method that will be called on the event of tap in any of the imageViews
    @objc func openCategoryDetails(_ sender:UITapGestureRecognizer){
        //Retrieve Image tapped
        let tappedImage = sender.view as! UIImageView
        //From image get textView
        let subview = tappedImage.subviews[0] as! UITextView
        //Pass on the category name on to the next view. Unable to achieve this func with prepareSegue
        CategoryDetailsViewController.category = subview.text!
        //Perform navigation to category bills
        performSegue(withIdentifier: "categoryDetails", sender: self)
    }
}
