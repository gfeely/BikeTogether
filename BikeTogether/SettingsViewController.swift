//
//  SettingsViewController.swift
//  BikeTogether
//
//  Created by Supassara Sujjapong on 28/6/16.
//  Copyright © 2016 Supassara Sujjapong. All rights reserved.
//

import UIKit

class SettingsViewController: UIViewController {


    @IBAction func logOutMethod(sender: AnyObject) {
        
        //Log-out alert
        let alert = UIAlertController(title: "Sign-Out", message: "Are you sure you want to sign out?", preferredStyle: UIAlertControllerStyle.Alert)
        
        //Press Yes - user will be logged out
        alert.addAction(UIAlertAction(title: "Yes", style: .Default, handler: {
            (action: UIAlertAction!) in
            let loginManager = FBSDKLoginManager()
            loginManager.logOut()
            self.performSegueWithIdentifier("toLogged", sender: self)
        }))
        
        //Press No - nothing happens
        alert.addAction(UIAlertAction(title: "No", style: UIAlertActionStyle.Default, handler: nil))
        self.presentViewController(alert, animated: true, completion: nil)
        
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
