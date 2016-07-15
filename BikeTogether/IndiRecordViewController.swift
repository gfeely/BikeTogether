//
//  IndiRecordViewController.swift
//  BikeTogether
//
//  Created by Supassara Sujjapong on 12/5/16.
//  Copyright © 2016 Supassara Sujjapong. All rights reserved.
//

import UIKit
import MapKit

class IndiRecordViewController: UIViewController, MKMapViewDelegate {
    
    var rname = ""
    var rid = 0
    var timeDuration = ""
    var distance: Double = 0
    var startTime = ""
    var stopTime = ""
    
    @IBOutlet weak var infoView: UIView!
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var timeTakenLabel: UILabel!
    @IBOutlet weak var distanceCoveredLabel: UILabel!
    @IBOutlet weak var stopTimestamp: UILabel!
    @IBOutlet weak var startTimeStamp: UILabel!
    
    @IBOutlet weak var slocLabel: UILabel!
    @IBOutlet weak var dlocLabel: UILabel!
    
    @IBOutlet weak var deleteButton: UIButton!
    
    @IBAction func deleteRecMethod(sender: AnyObject) {
        
        let alert = UIAlertController(title: "Delete Permanently", message: "Are you sure you want to delete this record?", preferredStyle: UIAlertControllerStyle.Alert)
        
        //Press Yes - user will be redirected to Main Menu
        alert.addAction(UIAlertAction(title: "Delete", style: .Default, handler: {
            (action: UIAlertAction!) in
            
            self.activityIndicator.startAnimating()
            
            let session = NSURLSession.sharedSession()
            let request = NSMutableURLRequest(URL: NSURL(string: "http://ridebike.atilal.com/deleteuserrecord.php/")!)
            request.HTTPMethod = "POST"
            let postString = "rid=\(self.rid)&rname\(self.rname)"
            
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
                    
                    if data != nil{
                        
                        let responseString = NSString(data: data!, encoding: NSUTF8StringEncoding)
                        print(responseString)
                        
                        switch responseString!
                        {
                            case " 00": print("** Delete user-route (Response 01) **")
                            case " 01": print("** Delete user-route (Response 01) **")
                            case " 10": print("** Delete user-route (Response 10) **")
                            case " 11": print("** Delete user-route from riderecord + activity (Response 1: Success)")
                            default: print("** Delete user-route (Response unknown)")
                        }
                        
                        NSOperationQueue.mainQueue().addOperationWithBlock{
                            self.activityIndicator.stopAnimating()
                            self.navigationController?.popViewControllerAnimated(true)
                        }
                    }
                }
            }
            dataTask.resume()

            
        }))
        
        //Press No - nothing happens
        alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Default, handler: nil))
        
        self.presentViewController(alert, animated: true, completion: nil)
        
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        deleteButton.layer.cornerRadius = 20

        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(animated: Bool) {
        print("===========================")
        print("IndiRecordViewController")
        
        self.activityIndicator.stopAnimating()

        
        print(rname)
        mapView.delegate = self
        

        
        
        let session = NSURLSession.sharedSession()
        let request = NSMutableURLRequest(URL: NSURL(string: "http://ridebike.atilal.com/viewrecord.php/")!)
        request.HTTPMethod = "POST"
        let postString = "uid=\(userID)&rname=\(rname)"
        
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
                
                if data != nil{
                    
                    print("** View record (DBMethod)**")
                    let json = JSON(data: data!)
                    
                    dispatch_async(dispatch_get_main_queue(), {
                        
                        let id = json["rid"].string!
                        let dis = json["distance"].string!

                        self.rid = Int(id)!
                        self.timeDuration = json["timeduration"].string!
                        self.distance = Double(dis)!
                        self.stopTime = json["stoptimestamp"].string!
                        self.startTime = json["starttimestamp"].string!
                        
                        print("rid = \(self.rid)")
                        print("time duration = \(self.timeDuration)")
                        print("distance = \(self.distance)")
                        print("stop time = \(self.stopTime)")
                        print("start time = \(self.startTime)")
                        
                        
                        if(self.distance < 1000){
                            let dtn = round(self.distance)
                            self.distanceCoveredLabel.text = String(format: "%g m", dtn)
                        }else{
                            var dtn = self.distance/1000
                            dtn = round(dtn*100)/100
                            self.distanceCoveredLabel.text = String("\(dtn) km")
                        }

                        //self.distanceCoveredLabel.text = String(format: "%.2f" , self.distance)

                        self.timeTakenLabel.text = self.timeDuration
                        self.stopTimestamp.text = self.stopTime
                        self.startTimeStamp.text = self.startTime
                        
                        viewLocation(self.rid, handler: {
                            location, count in
                            
                            let region = MKCoordinateRegion(center: location[count-1].coordinate, span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01))
                            self.mapView.setRegion(region, animated: true)
                            
                            let source = CLLocationCoordinate2D(latitude: location[0].coordinate.latitude, longitude: location[0].coordinate.longitude)
                            let destination = CLLocationCoordinate2D(latitude: location[count-1].coordinate.latitude, longitude: location[count-1].coordinate.longitude)
                            
                            let startPoint = MKPointAnnotation()
                            startPoint.coordinate = source
                            startPoint.title = "Starting Point"
                            self.mapView.addAnnotation(startPoint)
                            
                            let destPoint = MKPointAnnotation()
                            destPoint.coordinate = destination
                            destPoint.title = "Finishing Point"
                            self.mapView.addAnnotation(destPoint)
                            
                            let startlocName = CLGeocoder()
                            startlocName.reverseGeocodeLocation(location[0], completionHandler: { (placemarks, error) -> Void in
                                
                                // Place details
                                var placeMark: CLPlacemark!
                                placeMark = placemarks?[0]
                                
                                // Location name
                                if let locationName = placeMark.addressDictionary!["Name"] as? NSString {
                                    if let city = placeMark.addressDictionary!["City"] as? NSString {
                                        let locN = locationName as String
                                        let citN = city as String
                                        self.slocLabel.text = "From : \(locN), \(citN)"
                                    }
                                }
                                
                            })
                            
                            let destlocName = CLGeocoder()
                            destlocName.reverseGeocodeLocation(location[location.count - 1], completionHandler: { (placemarks, error) -> Void in
                                
                                // Place details
                                var placeMark: CLPlacemark!
                                placeMark = placemarks?[0]
                                
                                // Location name
                                if let locationName = placeMark.addressDictionary!["Name"] as? NSString {
                                    if let city = placeMark.addressDictionary!["City"] as? NSString {
                                        let locN = locationName as String
                                        let citN = city as String
                                        self.dlocLabel.text = "Destination : \(locN), \(citN)"
                                    }
                                }
                                
                            })
                            
                            for i in 1...count-1{
                                //Draw route method needs two points to draw
                                //Continuously send two location points to be drawn by the method
                                drawRoute(self, c1: location[i-1], c2: location[i])
                            }
                        })
                    
                        let content : FBSDKShareLinkContent = FBSDKShareLinkContent()
                        content.contentURL = NSURL(string: "https://www.facebook.com")
                        content.contentTitle = "Come Bike Together!"
                        
                        if(self.distance < 1000){
                            content.contentDescription = "My record on \(self.stopTime). Cycled \(round(self.distance)) m with Bike Together. My time is \(self.timeDuration). Come beat me!"
                        }else{
                            content.contentDescription = "My record on \(self.stopTime). Cycled \(round(self.distance/1000)) km with Bike Together. My time is \(self.timeDuration). Come beat me!"
                        }
                        
                        content.imageURL = NSURL(string: "https://scontent.fbkk5-1.fna.fbcdn.net/v/t1.0-9/13512240_1216978311655432_38099313990545828_n.jpg?oh=434d641f4d72a3f9c753960ac95c9964&oe=5805442B")
                        
                        let button : FBSDKShareButton = FBSDKShareButton()
                        button.shareContent = content
                        button.frame =  CGRectMake(self.infoView.bounds.origin.x, self.infoView.bounds.origin.y, self.infoView.frame.size.width, self.infoView.frame.size.height)
                        self.infoView.layer.cornerRadius = 10
                        self.infoView.addSubview(button)
                    
                    })
                }
            }
        }
        dataTask.resume()
        
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func mapView(mapView: MKMapView, rendererForOverlay overlay: MKOverlay) -> MKOverlayRenderer {
        
        //Polyline properties
        
        let polylineRenderer = MKPolylineRenderer(overlay: overlay)
        polylineRenderer.strokeColor = redTone
        polylineRenderer.lineWidth = 4
        return polylineRenderer
    }

}
