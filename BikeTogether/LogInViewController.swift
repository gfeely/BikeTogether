//
//  ViewController.swift
//  Testing1
//
//  Created by Supassara Sujjapong on 15/3/16.
//  Copyright © 2016 Supassara Sujjapong. All rights reserved.
//

import UIKit

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
        
        print("===========================")
        print("LoginViewController")
        
        if let _ = FBSDKAccessToken.currentAccessToken() {
            
            // If user already logged in
            btnFacebook.hidden = true
            backgroundImage.image = UIImage(named: "launchscreen")
            returnUserData()
            
            
        }else{
            
            // If user have not logged in
            btnFacebook.hidden = false
            backgroundImage.image = UIImage(named: "loginScreen")
            configureFacebook()
            
        }
    }
    
    func loginButton(loginButton: FBSDKLoginButton!, didCompleteWithResult result: FBSDKLoginManagerLoginResult!, error: NSError!)
    {
        // When facebook login button is clicked
        returnUserData()
    }
    
    func configureFacebook()
    {
        btnFacebook.readPermissions = ["public_profile", "email", "user_friends"];
        btnFacebook.delegate = self
    }
    
    func returnUserData()
    {
        
        // Ask for permission and get user details
        // Sign-in online database (UID, name check new or existing)
        
        let graphRequest : FBSDKGraphRequest = FBSDKGraphRequest(graphPath: "me", parameters: ["fields":"id, first_name, last_name, picture.type(large), friends"])
        graphRequest.startWithCompletionHandler({ (connection, result, error) -> Void in
            
            if ((error) != nil)
            {
                // Process error
                print("Error: \(error)")
            }
            else
            {
                //print(result)
                
                let resultdict = result.objectForKey("friends") as! NSDictionary
                friendData = resultdict.objectForKey("data") as! NSArray
                
                let id = (result.objectForKey("id") as? String)!
                userID = Int(id)!
                strFirstName = (result.objectForKey("first_name") as? String)!
                strLastName = (result.objectForKey("last_name") as? String)!
                strPictureURL = (result.objectForKey("picture")?.objectForKey("data")?.objectForKey("url") as? String)!
                profilePicture = UIImage(data: NSData(contentsOfURL: NSURL(string: strPictureURL)!)!)!
                
                
                print("This is my ID \(userID)")
                print("This is my name \(strFirstName)")
                
                signIn(userID, name: strFirstName)
                
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

    ///////////////////////////////////////////////////////////////////////////////////////////////

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}

