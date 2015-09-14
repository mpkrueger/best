//
//  NewCategoryViewController.swift
//  Best
//
//  Created by Matt Krueger on 9/6/15.
//  Copyright (c) 2015 Matt Krueger. All rights reserved.
//

import UIKit

class NewCategoryViewController: UIViewController {

    @IBOutlet weak var categoryTitle: UITextField!
    @IBOutlet weak var categoryCategory: UITextField!
    
    @IBAction func cancelButton(sender: AnyObject) {
        self.navigationController?.dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func saveButton(sender: AnyObject) {
        if let categoryTitle = categoryTitle.text {
            var category = PFObject(className: "BestCategory")
            category["categoryTitle"] = categoryTitle
            category["city"] = "San Francisco"
                
            category.save()
        }
        
        self.navigationController?.dismissViewControllerAnimated(true, completion: nil)

    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    


}
