//
//  databaseMethods.swift
//  BikeTogether
//
//  Created by Supassara Sujjapong on 19/5/16.
//  Copyright © 2016 Supassara Sujjapong. All rights reserved.
//

import Foundation
import MapKit

//////////////////////////////////////////////////////////////////////////////////

func signIn(uid: Int64, name: String){
    
    // Send UID and user name to database
    // Use in: LoginViewController
    // file: signin.php
    
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
                case " 0": print("** Sign-in (Response 0: Unknown error)")
                case " 1":
                    print("** Sign-in (Response 1: New user)")
                    createCurLoc(uid, lat: 0, long: 0)
                case " 2":
                    print("** Sign-in (Response 2: Existing user)")
                default: print("Response is either 0-3")
            }
        }
    }
    dataTask.resume()
}

func getZone () {
    
    // Get user zone
    // Use in: SignInViewController
    // file: getzone.php
    
    print("** Get Zone (DBMETHOD) **")
    
    let session = NSURLSession.sharedSession()
    let request = NSMutableURLRequest(URL: NSURL(string: "http://ridebike.atilal.com/getzone.php/")!)
    request.HTTPMethod = "POST"
    let postString = "uid=\(userID)"
    
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
            userZone = trimmedString

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

func recordNewRide (uid: Int64, rname: String, timeduration: String, distance: Double, starttimestamp: String, stoptimestamp: String, completionHandler: (result: Int) -> ()){

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
            completionHandler(result: 0)
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

func recordRideLocation (rid: Int, uid: Int64, latitude: Double, longitude: Double, mapKey: Int){
    
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


func viewLocation(rid: Int, handler: (locations: Array<CLLocation>, c: Int) -> ()) {
    
    var loc: Array<CLLocation> = []
    
    let session = NSURLSession.sharedSession()
    let request = NSMutableURLRequest(URL: NSURL(string: "http://ridebike.atilal.com/viewlocation.php/")!)
    request.HTTPMethod = "POST"
    let postString = "uid=\(userID)&rid=\(rid)"
    
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
            print("** View location (DBMETHOD)**")
            
            let json = JSON(data: data!)
            let count = json["latitude"].count
            print(count)
            
            dispatch_async(dispatch_get_main_queue(), {
                if count > 0 {
                    for i in 0...count-1{
                        let latitude = Double(json["latitude"][i].string!)
                        let longitude = Double(json["longitude"][i].string!)
                        //print(latitude)
                    
                        let location = CLLocation(latitude: latitude!, longitude: longitude!)
                        loc.append(location)
                    }
                    handler(locations: loc, c: count)
                }})
        }
    }
    dataTask.resume()

}

func totalDistance(uid: Int64, handler: (totalDistance: Double) -> () ){
    
    let session = NSURLSession.sharedSession()
    let request = NSMutableURLRequest(URL: NSURL(string: "http://ridebike.atilal.com/totaldistance.php/")!)
    request.HTTPMethod = "POST"
    let postString = "uid=\(uid)"
    
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
            print("** Total Distance (DBMETHOD)**")
            let responseString = NSString(data: data!, encoding: NSUTF8StringEncoding)
            let trimmedString = responseString!.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceCharacterSet())
            let distance = Double(trimmedString)!
            handler(totalDistance: distance)
        }
    }
    dataTask.resume()
}

func updateCurLoc(uid: Int64, lat: Double, long: Double){
    
    let session = NSURLSession.sharedSession()
    let request = NSMutableURLRequest(URL: NSURL(string: "http://ridebike.atilal.com/updatelocation.php/")!)
    request.HTTPMethod = "POST"
    let postString = "uid=\(uid)&currentlatitude=\(lat)&currentlongitude=\(long)"
    
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
                print("** Update Current location (Response 0: Unknown error) **")
            case " 1":
                print("** Update Current location (Response 1: Success) **")
            default:
                print("** Create db current location (Response is either 0-3) **")
            }
        }
    }
    dataTask.resume()
}

func createCurLoc(uid: Int64, lat: Double, long: Double){
    
    let session = NSURLSession.sharedSession()
    let request = NSMutableURLRequest(URL: NSURL(string: "http://ridebike.atilal.com/currentlocation.php/")!)
    request.HTTPMethod = "POST"
    let postString = "uid=\(uid)&latitude=\(lat)&longitude=\(long)&zone=A"
    
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
                print("** Create db current location (Response 0: Unknown error) **")
            case " 1":
                print("** Create db current location (Response 1: Success) **")
            default:
                print("** Create db current location (Response is either 0-3) **")
            }
            
        }
    }
    dataTask.resume()
}


func getName(uid: Int64, handler: (name: String) -> () ){
    
    let session = NSURLSession.sharedSession()
    let request = NSMutableURLRequest(URL: NSURL(string: "http://ridebike.atilal.com/getname.php/")!)
    request.HTTPMethod = "POST"
    let postString = "uid=\(uid)"
    
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
            handler(name: trimmedString)
            
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