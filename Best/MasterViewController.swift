//
//  MasterViewController.swift
//  Best
//
//  Created by Matt Krueger on 8/7/15.
//  Copyright (c) 2015 Matt Krueger. All rights reserved.
//

import UIKit
import Parse
import ParseUI

class MasterViewController: PFQueryTableViewController, PFLogInViewControllerDelegate, PFSignUpViewControllerDelegate {
    
    // Initialize the PFQueryTable tableview
    override init(style: UITableViewStyle, className: String!) {
        super.init(style: style, className: className)
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        // Configure the PFQueryTableView
        self.parseClassName = "BestCategory"
        self.textKey = "categoryTitle"
        self.pullToRefreshEnabled = true
        self.paginationEnabled = false
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath, object: PFObject?) -> PFTableViewCell? {
        var cell = tableView.dequeueReusableCellWithIdentifier("Cell") as! PFTableViewCell!
        if cell == nil {
            cell = PFTableViewCell(style: UITableViewCellStyle.Default, reuseIdentifier: "Cell")
        }
        
        // Extract values from the PFObject to display in the table cell
        if let categoryTitle = object?["categoryTitle"] as? String {
            cell?.textLabel?.text = categoryTitle
        }
        
        if let categoryCategory = object?["categoryCategory"] as? String {
            cell?.detailTextLabel?.text = categoryCategory
        }
        return cell
    }
    
    var logInViewController: PFLogInViewController! = PFLogInViewController()
    var signUpViewController: PFSignUpViewController! = PFSignUpViewController()


    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        self.presentLogInView()
        
        self.loadObjects()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func presentLogInView() {
        if (PFUser.currentUser() == nil) {
            self.logInViewController.fields = PFLogInFields.Facebook
            
            var logInLogoTitle = UILabel()
            logInLogoTitle.text = "Best"
            
            self.logInViewController.logInView?.logo = logInLogoTitle
            
            self.logInViewController.delegate = self
            
            var signupLogoTitle = UILabel()
            signupLogoTitle.text = "Best"
            
            self.signUpViewController.signUpView?.logo = signupLogoTitle
            
            self.signUpViewController.delegate = self
            
            self.logInViewController.signUpController = self.signUpViewController
            
            self.presentViewController(logInViewController, animated: true, completion: nil)
        } else {
            println("Current user already signed in")
            self.dismissViewControllerAnimated(true, completion: nil)
        }
    }
    
    // MARK: Parse Login
    
    func logInViewController(logInController: PFLogInViewController, didLogInUser user: PFUser) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func logInViewController(logInController: PFLogInViewController, didFailToLogInWithError error: NSError?) {
        println("Failed to login")
    }
    
    // MARK: Parse Signup
    
    func signUpViewController(signUpController: PFSignUpViewController, didSignUpUser user: PFUser) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func signUpViewController(signUpController: PFSignUpViewController, didFailToSignUpWithError error: NSError?) {
        println("Failed to sign up")
    }
    
    func signUpViewControllerDidCancelSignUp(signUpController: PFSignUpViewController) {
        println("User dismissed signup")
    }
    
    // MARK: Actions
    
    @IBAction func createNewCategory(sender: UIBarButtonItem) {
        self.performSegueWithIdentifier("CreateNewCategory", sender: UIBarButtonItem())
    }
    
    
    @IBAction func logout(sender: AnyObject) {
        PFUser.logOut()
        self.presentLogInView()
    }
    
    func tableview(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        self.performSegueWithIdentifier("ShowCategoryView", sender: indexPath)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "CreateNewCategory" {
            
        } else if segue.identifier == "ShowCategoryView" {
            var navigationView = segue.destinationViewController as! UINavigationController
            var categoryView = navigationView.visibleViewController as! CategoryViewController
            
            if let indexPath = self.tableView.indexPathForSelectedRow() {
                let row = Int(indexPath.row)
                categoryView.currentObject = (objects?[row] as! PFObject)
            }
        }
        
    }
    
    // MARK: Queries
    
    // Define the query that will provide the data for the table view
    override func queryForTable() -> PFQuery {
        var query = PFQuery(className: "BestCategory")
        query.orderByAscending("categoryTitle")
        return query
    }


}

