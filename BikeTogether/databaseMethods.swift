//
//  databaseMethods.swift
//  BikeTogether
//
//  Created by Supassara Sujjapong on 19/5/16.
//  Copyright © 2016 Supassara Sujjapong. All rights reserved.
//

import Foundation

func signIn(uid: Int, name: String){
    
    let session = NSURLSession.sharedSession()
    let request = NSMutableURLRequest(URL: NSURL(string: "http://ridebike.atilal.com/signin.php/")!)
    request.HTTPMethod = "POST"
    let postString = "uid=\(uid)&name=\(name)"
    
    request.HTTPBody = postString.dataUsingEncoding(NSUTF8StringEncoding)
    
    let dataTask = session.dataTaskWithRequest(request) {
        (data: NSData?, response: NSURLResponse?, error: NSError?) in
        if let error = error {
            // Case 1: Error
            // We got some kind of error while trying to get data from the server.
            print("Error:\n\(error)")
        }
        else {
            // Case 2: Success
            // We got a response from the server!
            
            let responseString = NSString(data: data!, encoding: NSUTF8StringEncoding)
            switch responseString!
            {
                case " 0": print("Unknown error")
                case " 1": print("New user")
                case " 2": print("Existing user")
                default: print("Response is either 0-3")
            }
        }
    }
    dataTask.resume()

    
}






func recordNewRide (uid: Int, rname: String, timeduration: String, distance: Double, starttimestamp: String, stoptimestamp: String){

    // Update new recorded ride into ride_record table
    // file: riderecord.php
    
    let session = NSURLSession.sharedSession()
    let request = NSMutableURLRequest(URL: NSURL(string: "http://ridebike.atilal.com/riderecord.php/")!)
    request.HTTPMethod = "POST"
    let postString = "uid=\(uid)&rname=\(rname)&timeduration=\(timeduration)&distance=\(distance)&starttimestamp=\(starttimestamp)&stoptimestamp=\(stoptimestamp)"
    
    request.HTTPBody = postString.dataUsingEncoding(NSUTF8StringEncoding)
    
    let dataTask = session.dataTaskWithRequest(request) {
        (data: NSData?, response: NSURLResponse?, error: NSError?) in
        if let error = error {
            // Case 1: Error
            // We got some kind of error while trying to get data from the server.
            print("Error:\n\(error)")
        }
        else {
            // Case 2: Success
            // We got a response from the server!
            
            let responseString = NSString(data: data!, encoding: NSUTF8StringEncoding)
            print("responseString = \(responseString)")
            
        }
    }
    dataTask.resume()
    
}