//
//  FriendTableViewCell.swift
//  BikeTogether
//
//  Created by Supassara Sujjapong on 3/6/16.
//  Copyright © 2016 Supassara Sujjapong. All rights reserved.
//

import UIKit

class FriendTableViewCell: UITableViewCell {

    @IBOutlet weak var frdPic: UIImageView!
    @IBOutlet weak var frdName: UILabel!
    @IBOutlet weak var distanceCovered: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code        
        
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }

}
