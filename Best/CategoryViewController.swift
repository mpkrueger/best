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
//    var candidates: Array<PFObject>?
    
    override init(style: UITableViewStyle, className: String!) {
        super.init(style: style, className: className)
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        self.parseClassName = "CategoryCandidates"
        self.textKey = "candidateTitle"
        self.pullToRefreshEnabled = true
        self.paginationEnabled = false
    }
    
    override func queryForTable() -> PFQuery {
        var query = PFQuery(className: "CategoryCandidates")
        query.whereKey("categoryID", equalTo: currentObject!)
        query.orderByDescending("votes")
        return query
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath, object: PFObject?) -> CandidateTableViewCell {
        
        var cell = tableView.dequeueReusableCellWithIdentifier("Cell") as! CandidateTableViewCell!
        if cell == nil {
            cell = CandidateTableViewCell(style: UITableViewCellStyle.Default, reuseIdentifier: "Cell")
        }
        
        var query = PFQuery(className: "CategoryCandidates")
        query.whereKey("categoryID", equalTo: currentObject!)
        query.findObjectsInBackgroundWithBlock { (objects: [AnyObject]?, error: NSError?) -> Void in
            if error == nil {
                let candidates = objects as? [PFObject]
                
                var categoryVotes = PFQuery(className: "CandidateVotes")
                categoryVotes.whereKey("candidateID", containedIn: candidates!)
                categoryVotes.whereKey("userID", equalTo: PFUser.currentUser()!)
                
                categoryVotes.findObjectsInBackgroundWithBlock { (objects: [AnyObject]?, error: NSError?) -> Void in
                    if error == nil {
                        if objects?.count > 0 {
                            cell?.voteButton.removeFromSuperview()
                        }
                    }
                }
            }
        }
        
        cell?.voteButton.addTarget(self, action: "buttonAction:", forControlEvents: UIControlEvents.TouchUpInside)

        
        // Extract values from the PFObject to display in the table cell
        if let candidateTitle = object?["candidateTitle"] as? String {
            cell?.textLabel?.text = candidateTitle
        }
        
        if let votesTotal = object?["votes"] as? Int {
            if votesTotal > 1 {
                cell?.votesLabel.text = "\(votesTotal.description) votes"
            } else if votesTotal == 1 {
                cell?.votesLabel.text = "\(votesTotal.description) vote"
            }
        }
        
        cell.voteButton.tag = indexPath.row
        
        return cell
    }
    
    func buttonAction(sender:UIButton!) {
        
        let buttonPoint = sender.convertPoint(CGPointZero, toView: self.tableView)
        let buttonIndex = self.tableView.indexPathForRowAtPoint(buttonPoint)
        let candidate = objectAtIndexPath(buttonIndex)
        
        var candidateVote = PFObject(className: "CandidateVotes")
        candidateVote["candidateID"] = candidate
        candidateVote["userID"] = PFUser.currentUser()
        candidateVote.save()
        
        self.loadObjects()
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.registerClass(CandidateTableViewCell.self, forCellReuseIdentifier: "Cell")
        

    }
    
    override func viewDidAppear(animated: Bool) {
        self.loadObjects()
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
