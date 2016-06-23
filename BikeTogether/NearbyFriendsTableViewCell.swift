//
//  NearbyFriendsTableViewCell.swift
//  BikeTogether
//
//  Created by Supassara Sujjapong on 22/6/16.
//  Copyright © 2016 Supassara Sujjapong. All rights reserved.
//

import UIKit

class NearbyFriendsTableViewCell: UITableViewCell {

    @IBOutlet weak var profilePicture: UIImageView!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var distanceAway: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
