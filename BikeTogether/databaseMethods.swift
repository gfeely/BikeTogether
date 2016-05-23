//
//  databaseMethods.swift
//  BikeTogether
//
//  Created by Supassara Sujjapong on 19/5/16.
//  Copyright © 2016 Supassara Sujjapong. All rights reserved.
//

import Foundation

//////////////////////////////////////////////////////////////////////////////////

func signIn(uid: Int, name: String){
    
    // Send UID and user name to database
    // Use in: LoginViewController
    // file: signin.php
    
    print("** Sign-in (DBMETHOD) **")
    
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
                case " 0": print("Response 0: Unknown error")
                case " 1": print("Response 1: New user")
                case " 2": print("Response 2: Existing user")
                default: print("Response is either 0-3")
            }
        }
    }
    dataTask.resume()
}

func repeatRname (rname: String, completionHandler: (result: Int) -> ()) {
    
    // Update new recorded ride into ride_record table
    // Use in: FinishViewController
    // file: riderecord.php
    
    print("** Check Repeated RNAME (DBMETHOD) **")
    
    let session = NSURLSession.sharedSession()
    let request = NSMutableURLRequest(URL: NSURL(string: "http://ridebike.atilal.com/repeatrname.php/")!)
    request.HTTPMethod = "POST"
    let postString = "rname=\(rname)"
    
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
                case " 0":
                    print("Response 0: Repeated rname")
                    completionHandler(result: 0)
                case " 1":
                    print("Response 1: New rname")
                    completionHandler(result: 1)
                default:
                    print("Response 0: Unidentified Error")
                    completionHandler(result: 0)
            }
        }
    }
    dataTask.resume()
    
}

//////////////////////////////////////////////////////////////////////////////////

func recordNewRide (uid: Int, rname: String, timeduration: String, distance: Double, starttimestamp: String, stoptimestamp: String, completionHandler: (result: Int) -> ()){

    // Update new recorded ride into ride_record table
    // Use in: FinishViewController
    // file: riderecord.php
    
    print("** Record new ride (DBMETHOD) **")
    
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
            let trimmedString = responseString!.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceCharacterSet())
            let rid = Int(trimmedString)
            print("rid = \(rid!)")
            completionHandler(result: rid!)
            
        }
    }
    dataTask.resume()
    
}

//////////////////////////////////////////////////////////////////////////////////

func recordRideLocation (rid: Int, uid: Int, latitude: Double, longitude: Double, mapKey: Int){
    
    // Update new recorded ride into ride_record table
    // Use in: FinishViewController
    // file: riderecord.php
    
    print("** Update the ride location (DBMETHOD) **")
    
    let session = NSURLSession.sharedSession()
    let request = NSMutableURLRequest(URL: NSURL(string: "http://ridebike.atilal.com/rideactivity.php/")!)
    request.HTTPMethod = "POST"
    let postString = "rid=\(rid)&uid=\(uid)&latitude=\(latitude)&longitude=\(longitude)&mapkey=\(mapKey)"
    
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
            case " 0": print("Response 0: Error")
            case " 1": print("Response 1: Updated")
            default: print("Response is either 0-1")
            }
            
            print(responseString)
            
        }
    }
    dataTask.resume()
    
}


///

func delay(delay:Double, closure:()->()) {
    dispatch_after(
        dispatch_time(
            DISPATCH_TIME_NOW,
            Int64(delay * Double(NSEC_PER_SEC))
        ),
        dispatch_get_main_queue(), closure)
}