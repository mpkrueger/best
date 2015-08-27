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
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath, object: PFObject?) -> CandidateTableViewCell {
        
        var cell = tableView.dequeueReusableCellWithIdentifier("Cell") as! CandidateTableViewCell!
        if cell == nil {
            cell = CandidateTableViewCell(style: UITableViewCellStyle.Default, reuseIdentifier: "Cell")
        }

        cell?.voteButton.addTarget(self, action: "buttonAction:", forControlEvents: UIControlEvents.TouchUpInside)

        
        // Extract values from the PFObject to display in the table cell
        if let candidateTitle = object?["candidateTitle"] as? String {
            cell?.textLabel?.text = candidateTitle
        }
        
        if let votesTotal = object?["votes"] as? Int {
            cell?.votesLabel.text = votesTotal.description
        }
        
        return cell
    }
    
    func buttonAction(sender:UIButton!) {
        println(self.tableView.indexPathForSelectedRow())
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.registerClass(CandidateTableViewCell.self, forCellReuseIdentifier: "Cell")

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