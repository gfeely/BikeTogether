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
    
    
    @IBOutlet weak var saveButton: UIButton!
    @IBOutlet weak var dismissButton: UIButton!
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var fromDestLabel: UILabel!
    @IBOutlet weak var totalDistLabel: UILabel!
    @IBOutlet weak var timeTakenLabel: UILabel!
    @IBOutlet weak var timeStamp: UILabel!
    @IBOutlet weak var nameTextField: UITextField!
    
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
        saveButton.layer.cornerRadius = saveButton.frame.size.width / 2
        saveButton.layer.borderWidth = 1
        saveButton.layer.borderColor = UIColor.whiteColor().CGColor
        
        //Finish Button
        dismissButton.layer.cornerRadius = dismissButton.frame.size.width / 2
        dismissButton.layer.borderWidth = 1
        dismissButton.layer.borderColor = UIColor.whiteColor().CGColor
        //////////////////////////////////////////////////////////////////////////////////

        
        ////////////////////////////////////////////////////////////////////////////////
        /*//Facebook share
        
        let content : FBSDKShareLinkContent = FBSDKShareLinkContent()
        //content.contentURL = NSURL(string: "https://www.facebook.com/FacebookDevelopers")!
        content.contentTitle = "My Facebook"
        content.contentDescription = "This is testing"
        //content.imageURL = NSURL(string: "https://scontent.fbkk5-5.fna.fbcdn.net/t31.0-8/13072756_1176190255734238_9079577487712337304_o.jpg")
        
        let shareButton: FBSDKShareButton = FBSDKShareButton()
        shareButton.shareContent = content
        shareButton.center = self.view.center
        self.view!.addSubview(shareButton)*/
        ////////////////////////////////////////////////////////////////////////////////
    }
    
    
    override func viewDidAppear(animated: Bool) {
        
        /////////////////////////////////////////////////////////////////////////////////////
        //Set text of the records
        
        getLocationName(locations[0], endPoint: locations[locations.count-1])
       
        timeStamp.text = startTimeStamp
    
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
        polylineRenderer.strokeColor = UIColor.blueColor()
        polylineRenderer.lineWidth = 4
        return polylineRenderer
    }
    
}
