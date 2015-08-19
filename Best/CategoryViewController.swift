//
//  CategoryViewController.swift
//  Best
//
//  Created by Matt Krueger on 8/12/15.
//  Copyright (c) 2015 Matt Krueger. All rights reserved.
//

import UIKit
import Parse
import ParseUI

class CategoryViewController: PFQueryTableViewController {
    var currentObject : PFObject?
    
    override init(style: UITableViewStyle, className: String!) {
        super.init(style: style, className: className)
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        var query = PFQuery(className: "CategoryCandidates")
        var candidates: Array = query.findObjects()!
        PFObject.pinAll(candidates)
        
        self.parseClassName = "CategoryCandidates"
        self.textKey = "candidateTitle"
        self.pullToRefreshEnabled = true
        self.paginationEnabled = false
    }
    
    override func queryForTable() -> PFQuery {
        var query = PFQuery(className: "CategoryCandidates")
        query.fromLocalDatastore()
        query.orderByDescending("votes")
        query.whereKey("categoryID", equalTo: currentObject!)
        return query
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath, object: PFObject?) -> PFTableViewCell {
        
        var cell = tableView.dequeueReusableCellWithIdentifier("Cell") as! PFTableViewCell!
        if cell == nil {
            cell = PFTableViewCell(style: UITableViewCellStyle.Default, reuseIdentifier: "Cell")
        }
        
        // Extract values from the PFObject to display in the table cell
        if let candidateTitle = object?["candidateTitle"] as? String {
            cell?.textLabel?.text = candidateTitle
        }
        
        return cell
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    override func viewDidAppear(animated: Bool) {
        
        // This isn't working
        println("page is going to reload data")
        dispatch_async(dispatch_get_main_queue(), { () -> Void in
            self.tableView.reloadData()
        })
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        var navigationView = segue.destinationViewController as! UINavigationController
        var candidateView = navigationView.visibleViewController as! CandidateViewController
        
        candidateView.currentObject = currentObject
    }
}
