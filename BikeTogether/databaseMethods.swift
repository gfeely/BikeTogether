//
//  databaseMethods.swift
//  BikeTogether
//
//  Created by Supassara Sujjapong on 19/5/16.
//  Copyright © 2016 Supassara Sujjapong. All rights reserved.
//

import Foundation





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
            //print("Response:\n\(response!)\n")
            //print("Data:\n\(data!)")
            //self.myWeather = String(data: data!, encoding: NSUTF8StringEncoding)!
            //print(self.myWeather)
            
            let responseString = NSString(data: data!, encoding: NSUTF8StringEncoding)
            print("responseString = \(responseString)")
            
        }
    }
    dataTask.resume()
    
}