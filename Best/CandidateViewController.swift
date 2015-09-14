//
//  CandidateViewController.swift
//  Best
//
//  Created by Matt Krueger on 8/13/15.
//  Copyright (c) 2015 Matt Krueger. All rights reserved.
//

import UIKit

class CandidateViewController: UIViewController {
    
    var currentObject: PFObject?
    var categoryTitle: String?
    
    @IBOutlet weak var candidateTitle: UITextField!
    
    @IBAction func cancelButton(sender: AnyObject) {
        self.navigationController?.dismissViewControllerAnimated(true, completion: nil)
    }
    
    
    
    required init(coder aDecoder: (NSCoder!)) {

        super.init(coder: aDecoder)

    }
    
    init(currentObject: PFObject, categoryTitle: String) {
        self.currentObject = currentObject
        self.categoryTitle = categoryTitle
        
        super.init(nibName: nil, bundle: nil)
        
    }
    
    
    
    @IBAction func saveButton(sender: AnyObject) {
        if let candidateTitle = candidateTitle.text {
            var candidate = PFObject(className: "CategoryCandidates")
            candidate["candidateTitle"] = candidateTitle
            candidate["votes"] = 0
            candidate["categoryID"] = currentObject
            
            candidate.save()
            
            var candidateVote = PFObject(className: "CandidateVotes")
            candidateVote["candidateID"] = candidate
            candidateVote["userID"] = PFUser.currentUser()
            candidateVote.saveInBackgroundWithBlock {
                (success: Bool, error: NSError?) -> Void in
                if (success) {
                    // The object has been saved.
                    println("object saved")
                } else {
                    // There was a problem, check error.description
                }
            }
        }
        
        
        self.navigationController?.dismissViewControllerAnimated(true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        var prompt = UILabel(frame: CGRectMake(0, CGRectGetHeight(self.view.frame) / 4, 300, 20))
        prompt.center = CGPointMake(CGRectGetWidth(self.view.frame) / 2, CGRectGetHeight(self.view.frame) / 4)
        prompt.text = "What is the best place to get \(categoryTitle)?"
        
        println(currentObject)
        println(categoryTitle)
        
        self.view.addSubview(prompt)
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
