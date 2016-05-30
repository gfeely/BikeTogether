//
//  UserProfileViewController.swift
//  BikeTogether
//
//  Created by Supassara Sujjapong on 20/5/16.
//  Copyright © 2016 Supassara Sujjapong. All rights reserved.
//

import UIKit

class UserProfileViewController: UIViewController {

    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var userNameLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        userNameLabel.text = "\(strFirstName) \(strLastName)"
        
        self.profileImageView.image = profilePicture
        self.profileImageView.contentMode = .ScaleAspectFill
        self.profileImageView.layer.cornerRadius = profileImageView.frame.size.width / 2;
        self.profileImageView.clipsToBounds = true
        
        
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
