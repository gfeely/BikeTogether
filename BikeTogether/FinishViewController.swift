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
        
        /////////////////////////////////////////////////////////////////////////////////////
        // Save to to database
        let appDel:AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let context:NSManagedObjectContext? = appDel.managedObjectContext
        let en = NSEntityDescription.entityForName("Record", inManagedObjectContext:context!)
        
        let freq = NSFetchRequest(entityName: "Record")
        //Fetch all with the same name and sort it using key
        let predicate: NSPredicate = NSPredicate(format: "name = %@", nameTextField.text!)
        freq.predicate = predicate
        let sortDescriptor = NSSortDescriptor(key: "key", ascending: true)
        freq.sortDescriptors = [sortDescriptor]
        let list = try! context?.executeFetchRequest(freq)
        
        //If route name already exist, do not save the record. Else, save the new record
        if(list?.count > 0){
            normalAlert(self, title: "Route Name Already Exist", message: "Please input a new route name")
        }else{
        for (var i = 0; i < locations.count; i += 1){

            /*print(locations[i].coordinate.latitude)
                //Check if item exists
                if(existingItem != nil){
                    existingItem?.setValue(nameTextField.text, forKey: "name")
                    existingItem?.setValue(timeStamp.text, forKey: "timeStamp")
                    existingItem?.setValue(totalDistLabel.text, forKey: "distance")
                    existingItem?.setValue(timeTaken, forKey: "timeTaken")
                    existingItem?.setValue(i+1, forKey: "key")
                    existingItem?.setValue(locations[i].coordinate.latitude, forKey: "latitude")
                    existingItem?.setValue(locations[i].coordinate.longitude, forKey: "longitude")
                }
                else {
                    let newItem = Record(entity:en!, insertIntoManagedObjectContext:context!)
                    newItem.name = nameTextField.text
                    newItem.timeStamp = timeStamp.text! as String
                    newItem.distance = totalDistLabel.text! as String
                    newItem.timeTaken = timeTaken
                    newItem.key = i+1
                    newItem.latitude = locations[i].coordinate.latitude as NSNumber
                    newItem.longitude = locations[i].coordinate.longitude as NSNumber
                }
                do {
                    try context?.save()
                    dismissViewMethod(self, title: "Record Saved", message: "none", OnYes: false)
                } catch _ {
            }*/
            }}
        /////////////////////////////////////////////////////////////////////////////////////
    
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
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
        //Facebook share
        
        let content : FBSDKShareLinkContent = FBSDKShareLinkContent()
        //content.contentURL = NSURL(string: "https://www.facebook.com/FacebookDevelopers")!
        content.contentTitle = "My Facebook"
        content.contentDescription = "This is testing"
        //content.imageURL = NSURL(string: "https://scontent.fbkk5-5.fna.fbcdn.net/t31.0-8/13072756_1176190255734238_9079577487712337304_o.jpg")
        
        let shareButton: FBSDKShareButton = FBSDKShareButton()
        shareButton.shareContent = content
        shareButton.center = self.view.center
        self.view!.addSubview(shareButton)
        ////////////////////////////////////////////////////////////////////////////////
    }
    
    
    override func viewDidAppear(animated: Bool) {
        
        /////////////////////////////////////////////////////////////////////////////////////
        //Set text of the records
        
        getLocationName()
       
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
        
            for(var i = 1; i < locations.count; i += 1){
            
                //Draw route method needs two points to draw
                //Continuously send two location points to be drawn by the method
            
                drawRoute(locations[i-1], c2: locations[i])
            }
        }else{
            normalAlert(self, title: "No Distance has been Recorded", message: "none")
        }
        /////////////////////////////////////////////////////////////////////////////////////
    
    }
    
    func drawRoute(c1: CLLocation, c2:CLLocation){
        
        //Draw the route method
        
        let p1 = CLLocationCoordinate2D(latitude: c1.coordinate.latitude, longitude: c1.coordinate.longitude)
        let p2 = CLLocationCoordinate2D(latitude: c2.coordinate.latitude, longitude: c2.coordinate.longitude)
        
        var points: [CLLocationCoordinate2D]
        points = [p1,p2]
        let line = MKPolyline(coordinates: &points[0], count: 2)
        mapView.addOverlay(line)
    }
    
    func mapView(mapView: MKMapView!, rendererForOverlay overlay: MKOverlay!) -> MKOverlayRenderer! {
        
        //Polyline properties
        
        if overlay is MKPolyline {
            let polylineRenderer = MKPolylineRenderer(overlay: overlay)
            polylineRenderer.strokeColor = UIColor.blueColor()
            polylineRenderer.lineWidth = 4
            return polylineRenderer
        }
        return nil
    }
    
    
    func getLocationName(){
        let startPoint = locations[0]
        let endPoint = locations[locations.count-1]
        
        let geoCoder1 = CLGeocoder()
        geoCoder1.reverseGeocodeLocation(startPoint, completionHandler: { (placemarks, error) -> Void in
            
            // Place details
            var placeMark: CLPlacemark!
            placeMark = placemarks?[0]
            
            // Location name
            if let locationName = placeMark.addressDictionary!["Name"] as? NSString {
                print(locationName)
            }

        })
        
        let geoCoder2 = CLGeocoder()
        geoCoder2.reverseGeocodeLocation(endPoint, completionHandler: { (placemarks, error) -> Void in
            
            // Place details
            var placeMark: CLPlacemark!
            placeMark = placemarks?[0]
            
            // Location name
            if let locationName = placeMark.addressDictionary!["Name"] as? NSString {
                print(locationName)
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

}
