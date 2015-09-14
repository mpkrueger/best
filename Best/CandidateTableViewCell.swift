//
//  CandidateTableViewCell.swift
//  Best
//
//  Created by Matt Krueger on 8/20/15.
//  Copyright (c) 2015 Matt Krueger. All rights reserved.
//

import UIKit
import Parse
import ParseUI

class CandidateTableViewCell: PFTableViewCell {
    
    let plusImage = UIImage(named: "plus.png") as UIImage!
    let checkmarkImage = UIImage(named: "checkmark.png") as UIImage!

    var voteButton: DOFavoriteButton = DOFavoriteButton()
    var votesLabel: UILabel = UILabel()
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String!) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        voteButton = DOFavoriteButton(frame: CGRectMake((CGRectGetWidth(self.contentView.frame) * 15/16), 0, 44, 44), image: UIImage(named: "crown.png"))
        voteButton.imageColorOff = UIColor.blueColor()
        voteButton.lineColor = UIColor.yellowColor()
        voteButton.circleColor = UIColor.greenColor()
        voteButton.duration = 2
        
        votesLabel.frame = CGRectMake((CGRectGetWidth(self.contentView.frame) * 5 / 8), (CGRectGetHeight(self.contentView.frame) / 4), (CGRectGetWidth(self.contentView.frame) / 4), (CGRectGetHeight(self.contentView.frame) / 2))
        
        self.contentView.addSubview(voteButton)
        self.contentView.addSubview(votesLabel)
        
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

}