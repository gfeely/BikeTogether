//
//  ViewController.swift
//  Testing1
//
//  Created by Supassara Sujjapong on 15/3/16.
//  Copyright © 2016 Supassara Sujjapong. All rights reserved.
//

import UIKit

var strFirstName: String = ""
var strLastName: String = ""
var strPictureURL: String = ""
var profilePicture: UIImage = UIImage(named: "test.jpg")!
var userID = 0

class LogInViewController: UIViewController, FBSDKLoginButtonDelegate {
    
    @IBOutlet weak var backgroundImage: UIImageView!
    @IBOutlet var btnFacebook: FBSDKLoginButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let _ = FBSDKAccessToken.currentAccessToken() {
            // If user already logged in
            btnFacebook.hidden = true
        }else{
            
            // If user have not logged in
            btnFacebook.hidden = false
        }
        
    }
    
    override func viewDidAppear(animated: Bool) {
        if let _ = FBSDKAccessToken.currentAccessToken() {
            
            // If user already logged in
            btnFacebook.hidden = true
            backgroundImage.image = UIImage(named: "launchscreen")
            returnUserData()
        }else{
            
            // If user have not logged in
            btnFacebook.hidden = false
            backgroundImage.image = UIImage(named: "loginScreen")
        }
    }
    
    func loginButton(loginButton: FBSDKLoginButton!, didCompleteWithResult result: FBSDKLoginManagerLoginResult!, error: NSError!)
    {
        returnUserData()
    }
    
    func returnUserData()
    {
        
        // Ask for permission and get user details
        
        let graphRequest : FBSDKGraphRequest = FBSDKGraphRequest(graphPath: "me", parameters: ["fields":"id, first_name, last_name, picture.type(large)"])
        graphRequest.startWithCompletionHandler({ (connection, result, error) -> Void in
            
            if ((error) != nil)
            {
                // Process error
                print("Error: \(error)")
            }
            else
            {
                let id = (result.objectForKey("id") as? String)!
                userID = Int(id)!
                print("This is my ID  \(userID)")
                strFirstName = (result.objectForKey("first_name") as? String)!
                strLastName = (result.objectForKey("last_name") as? String)!
                strPictureURL = (result.objectForKey("picture")?.objectForKey("data")?.objectForKey("url") as? String)!
                profilePicture = UIImage(data: NSData(contentsOfURL: NSURL(string: strPictureURL)!)!)!
                self.performSegueWithIdentifier("goToMain", sender: self)
            }
        })
    }
    
    func loginButtonDidLogOut(loginButton: FBSDKLoginButton!)
    {
    }
    
    @IBAction func loggedOut (sender: UIStoryboardSegue){
        //For unwind segue to this view controller
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}

