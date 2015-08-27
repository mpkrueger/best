//
//  CandidateViewController.swift
//  Best
//
//  Created by Matt Krueger on 8/13/15.
//  Copyright (c) 2015 Matt Krueger. All rights reserved.
//

import UIKit

class CandidateViewController: UIViewController {
    
    var currentObject : PFObject?
    
    @IBOutlet weak var candidateTitle: UITextField!
    
    @IBAction func cancelButton(sender: AnyObject) {
    }
    
    @IBAction func saveButton(sender: AnyObject) {
        if let candidateTitle = candidateTitle.text {
            var candidate = PFObject(className: "CategoryCandidates")
            candidate["candidateTitle"] = candidateTitle
            candidate["votes"] = 1
            candidate["categoryID"] = currentObject
//            candidate.pinInBackground()
            
            candidate.saveEventually(nil)
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
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
