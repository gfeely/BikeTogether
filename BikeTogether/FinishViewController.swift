//
//  FinishViewController.swift
//  BikeTogether
//
//  Created by Supassara Sujjapong on 10/12/15.
//  Copyright © 2015 Supassara Sujjapong. All rights reserved.
//

import UIKit
import MapKit
import CoreData

class FinishViewController: UIViewController, MKMapViewDelegate {
    
    var existingItem:NSManagedObject?
    var locations = [CLLocation]()
    var distance: Double = 0
    var timeTaken: String = ""
    var startTimeStamp = ""
    var stopTimeStamp = ""
    var showDate = ""
    var startLoc = ""
    var destLoc = ""
    
    @IBOutlet weak var infoView: UIView!
    
    @IBOutlet weak var saveButton: UIButton!
    @IBOutlet weak var dismissButton: UIButton!
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var fromDestLabel: UILabel!
    @IBOutlet weak var totalDistLabel: UILabel!
    @IBOutlet weak var timeTakenLabel: UILabel!
    @IBOutlet weak var timeStamp: UILabel!
    @IBOutlet weak var nameTextField: UITextField!
    
    @IBOutlet weak var locName: UILabel!
    @IBOutlet weak var cityName: UILabel!
    
    @IBAction func unwindToMain(sender: AnyObject) {
        backToMainMenuOnYes(self)
    }
    
    @IBAction func dismissMethod() {
        dismissViewMethod(self, title: "Dismiss Record", message: "Are you sure you want to dismiss this record?", OnYes: true)
    }
    
    
    @IBAction func saveMethod() {
        
        // Save to to online database
        // Add to riderecord, rideactivity
        
        repeatRname(nameTextField.text!, completionHandler:
            { result in
                print("Respond result: \(result)")
                if result == 0{
                    normalAlert(self, title: "Name Already Exist", message: "Please re-enter a new route name.")
                }
                else{
                    recordNewRide(userID, rname: self.nameTextField.text!, timeduration: self.timeTaken, distance: self.distance, starttimestamp: self.startTimeStamp, stoptimestamp: self.stopTimeStamp,completionHandler:{ rid in
                        
                        if rid != 0{
                            var count = 1
                            for i in self.locations{
                                recordRideLocation(rid, uid: userID, latitude: i.coordinate.latitude, longitude: i.coordinate.longitude, mapKey: count)
                                count += 1
                            }
                            normalAlert(self, title: "Success", message: "Your record has been saved.")
                        }
                        else{
                            normalAlert(self, title: "An Error Has Occured", message: "There is an error saving to the online database.")
                        }
                    })
                }
        })
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print("===========================")
        print("FinishViewController")
        
        //////////////////////////////////////////////////////////////////////////////////
        //User Interface Decorations
        //Save Button
        saveButton.layer.cornerRadius = 20
        saveButton.layer.borderWidth = 1
        saveButton.layer.borderColor = UIColor.whiteColor().CGColor
        
        //Finish Button
        dismissButton.layer.cornerRadius = 20
        dismissButton.layer.borderWidth = 1
        dismissButton.layer.borderColor = UIColor.whiteColor().CGColor
        //////////////////////////////////////////////////////////////////////////////////

        
        ////////////////////////////////////////////////////////////////////////////////
    //Facebook share
        
        let content : FBSDKShareLinkContent = FBSDKShareLinkContent()
        content.contentURL = NSURL(string: "http://www.facebook.com/")
        content.contentTitle = "Come Bike Together!"
        
        if(distance < 1000){
            content.contentDescription = "I just cycled \(round(distance)) m with Bike Together. My time is \(timeTaken). Come join me!"
        }else{
            content.contentDescription = "I just cycled \(round(distance/1000)) km with Bike Together. My time is \(timeTaken). Come join me!"
        }
        
        content.imageURL = NSURL(string: "https://scontent.fbkk5-4.fna.fbcdn.net/v/t1.0-9/13315649_1199178556768741_202862369797131353_n.jpg?oh=8da6927d9e4e9d852c3232bc96d4e7e3&oe=57DB022F")
        
        let button : FBSDKShareButton = FBSDKShareButton()
        button.shareContent = content
        button.frame =  CGRectMake(self.infoView.bounds.origin.x, self.infoView.bounds.origin.y, self.infoView.frame.size.width, self.infoView.frame.size.height)
        self.infoView.layer.cornerRadius = 10
        self.infoView.addSubview(button)
        ////////////////////////////////////////////////////////////////////////////////
    }
    
    
    override func viewDidAppear(animated: Bool) {
        
        /////////////////////////////////////////////////////////////////////////////////////
        //Set text of the records
        
        timeStamp.text = showDate
    
        if(distance < 1000){
            totalDistLabel.text = String("\(round(distance*100)/100) m")
        }else{
            var dtn = distance/1000
            dtn = round(dtn*100)/100
            totalDistLabel.text = String("\(dtn) km")
        }
        
        timeTakenLabel.text = timeTaken
        /////////////////////////////////////////////////////////////////////////////////////
        
        /////////////////////////////////////////////////////////////////////////////////////
        //Map configurations
        //Draw route and pin
        
        //If there is recorded location
        if(locations.count > 0){
            let location = locations.last
            let destination = CLLocationCoordinate2D(latitude: location!.coordinate.latitude, longitude: location!.coordinate.longitude)
            let source = CLLocationCoordinate2D(latitude: locations[0].coordinate.latitude, longitude: locations[0].coordinate.longitude)

            let region = MKCoordinateRegion(center: destination, span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01))
            self.mapView.setRegion(region, animated: true)
        
            let startPoint = MKPointAnnotation()
            startPoint.coordinate = source
            startPoint.title = "Starting Point"
            mapView.addAnnotation(startPoint)
        
            let destPoint = MKPointAnnotation()
            destPoint.coordinate = destination
            destPoint.title = "Finishing Point"
            mapView.addAnnotation(destPoint)
        
            let locationCount = locations.count
            for i in 1...locationCount-1{
                
                //Draw route method needs two points to draw
                //Continuously send two location points to be drawn by the method
                drawRoute(self, c1: locations[i-1], c2: locations[i])
                
            }
        }else{
            normalAlert(self, title: "No Distance has been Recorded", message: "none")
        }
        /////////////////////////////////////////////////////////////////////////////////////
        
        let startlocName = CLGeocoder()
        startlocName.reverseGeocodeLocation(locations[0], completionHandler: { (placemarks, error) -> Void in
            
            // Place details
            var placeMark: CLPlacemark!
            placeMark = placemarks?[0]
            
            // Location name
            if let locationName = placeMark.addressDictionary!["Name"] as? NSString {
                self.locName.text = locationName as String
            }
            
            // City
            if let city = placeMark.addressDictionary!["City"] as? NSString {
                self.cityName.text = city as String
            }
            
        })
    }
    
    ///////////////////////////////////////////////////////////////////////////////////////////////////
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?){
        view.endEditing(true)
        super.touchesBegan(touches, withEvent: event)
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }

    func mapView(mapView: MKMapView, rendererForOverlay overlay: MKOverlay) -> MKOverlayRenderer {
        
        //Polyline properties
        
        let polylineRenderer = MKPolylineRenderer(overlay: overlay)
        polylineRenderer.strokeColor = redTone
        polylineRenderer.lineWidth = 4
        return polylineRenderer
    }
    
}
