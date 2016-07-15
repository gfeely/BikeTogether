//
//  PlanNewRouteViewController.swift
//  BikeTogether
//
//  Created by Supassara Sujjapong on 25/6/16.
//  Copyright © 2016 Supassara Sujjapong. All rights reserved.
//

import UIKit
import MapKit

class PlanNewRouteViewController: UIViewController, MKMapViewDelegate {

    @IBOutlet weak var infoView: UIView!
    @IBOutlet weak var infoLabel: UILabel!
    
    @IBOutlet weak var detailsView: UIView!
    @IBOutlet weak var inputNameField: UITextField!
    @IBOutlet weak var distanceLabel: UILabel!
    
    @IBOutlet weak var clearButton: UIButton!
    
    @IBOutlet weak var mapView: MKMapView!
    
    var count = 0
    var routeCreated = false
    var startP = CLLocationCoordinate2D()
    var destP = CLLocationCoordinate2D()
    
    @IBAction func saveMethod(sender: AnyObject) {
        
        if (((inputNameField.text?.isEmpty) != nil) && routeCreated == false){
            normalAlert(self, title: "No route created.", message: "Tap and hold to create a new route.")
            
        }else if (inputNameField.text == ""){
            normalAlert(self, title: "Route name is empty.", message: "Please enter a name for your new route.")
        }else{
        
            let rname = String(inputNameField.text!)
            
            let session = NSURLSession.sharedSession()
            let request = NSMutableURLRequest(URL: NSURL(string: "http://ridebike.atilal.com/addzoneroute.php/")!)
            request.HTTPMethod = "POST"
            let postString = "rname=\(rname)&sourcelatitude=\(startP.latitude)&sourcelongitude=\(startP.longitude)&deslatitude=\(destP.latitude)&deslongitude=\(destP.longitude)&zone=\(userZone)"
            
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
                        print("** Save new plan route (Response 0: Unknown error)")
                        normalAlert(self, title: "Error", message: "There was an error updating the information to the database")
                    case " 1":
                        print("** Save new plan route (Response 1: Success)")
                        
                        let alert = UIAlertController(title: "Success", message: "New route has been added", preferredStyle: UIAlertControllerStyle.Alert)
                        
                        alert.addAction(UIAlertAction(title: "Ok", style: .Default, handler: {
                            (action: UIAlertAction!) in
                                self.dismissViewControllerAnimated(true, completion: nil)
                        }))
                        
                        NSOperationQueue.mainQueue().addOperationWithBlock {
                            self.presentViewController(alert, animated: true, completion: nil)
                        }
                        
                    default: print("Response is either 0-3")
                    }

                    
                }
            }
            dataTask.resume()
        }
    
    }
    
    
    @IBAction func clearMethod(sender: AnyObject) {
        if clearButton.titleLabel?.text == "Cancel"{
            self.dismissViewControllerAnimated(true, completion: nil)
        }
        else if clearButton.titleLabel?.text == "Reset" {
            mapView.removeOverlays(mapView.overlays)

            let allAnnotations = self.mapView.annotations
            self.mapView.removeAnnotations(allAnnotations)
            
            count = 0
            routeCreated = false
            
            infoLabel.text = "Tap and hold to choose your starting location."
            detailsView.hidden = true
            infoView.hidden = false
            
            clearButton.setTitle("Cancel", forState: UIControlState.Normal)
            clearButton.backgroundColor = redTone
        }
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        detailsView.hidden = true
        
        let location = CLLocationCoordinate2DMake(currentLoc.coordinate.latitude, currentLoc.coordinate.longitude)
        let region = MKCoordinateRegion(center: location, span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.1))
        self.mapView.setRegion(region, animated: true)
        
        let longPress = UILongPressGestureRecognizer(target: self, action: #selector(PlanNewRouteViewController.action(_:)))
        longPress.minimumPressDuration = 1
        mapView.addGestureRecognizer(longPress)
    
    }
    
    func action(gestureRecognizer:UIGestureRecognizer) {
       
        let touchPoint = gestureRecognizer.locationInView(self.mapView)
        
        if count == 0 {
            
            startP = mapView.convertPoint(touchPoint, toCoordinateFromView: self.mapView)
            
            let newAnotation = MKPointAnnotation()
            newAnotation.coordinate = startP
            newAnotation.title = "Starting Location"
            mapView.addAnnotation(newAnotation)
            
            self.clearButton.setTitle("Reset", forState: UIControlState.Normal)
            self.clearButton.backgroundColor = yellowTone
            self.infoLabel.text = "Tap and hold to choose your destination."
            
            count += 1
            
        }
        else if count == 2 {
            
            destP = mapView.convertPoint(touchPoint, toCoordinateFromView: self.mapView)

            let newAnotation = MKPointAnnotation()
            newAnotation.coordinate = destP
            newAnotation.title = "Destination"
            mapView.addAnnotation(newAnotation)
            
            routing(startP.latitude, slong: startP.longitude, dlat: destP.latitude, dlong: destP.longitude)

            count += 1
        }
        else {
            count += 1
        }
        
    }

    override func viewDidAppear(animated: Bool) {
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func mapView(mapView: MKMapView, rendererForOverlay overlay: MKOverlay) -> MKOverlayRenderer {
        let renderer = MKPolylineRenderer(polyline: overlay as! MKPolyline)
        renderer.strokeColor = redTone
        renderer.lineWidth = 4
        return renderer
    }
    
    func routing(slat: Double, slong: Double, dlat: Double, dlong: Double){
        
        let request = MKDirectionsRequest()
        let source = CLLocationCoordinate2D(latitude: slat, longitude: slong)
        let destination = CLLocationCoordinate2D(latitude: dlat, longitude: dlong)
        
        request.source = MKMapItem(placemark: MKPlacemark(coordinate: source, addressDictionary: nil))
        request.destination = MKMapItem(placemark: MKPlacemark(coordinate: destination, addressDictionary: nil))
        request.requestsAlternateRoutes = true
        request.transportType = .Any
        
        let srcPoint = MKPointAnnotation()
        srcPoint.coordinate = source
        srcPoint.title = "Starting point"
        self.mapView.addAnnotation(srcPoint)
        
        let destPoint = MKPointAnnotation()
        destPoint.coordinate = destination
        destPoint.title = "Destination point"
        self.mapView.addAnnotation(destPoint)
        
        
        let directions = MKDirections(request: request)
        
        directions.calculateDirectionsWithCompletionHandler { [unowned self] response, error in
            guard let unwrappedResponse = response else { return }
            
            for route in unwrappedResponse.routes {
                let distance = Double((response!.routes.first?.distance)!)
                
                if distance > 999{
                    self.distanceLabel.text = "\(String(format: "%.2f",distance/1000)) km"
                }else{
                    self.distanceLabel.text = "\(String(format:"%g",distance)) m"
                }
                
                self.routeCreated = true
                self.infoView.hidden = true
                self.detailsView.hidden = false
                self.mapView.addOverlay(route.polyline)
                //self.mapView.setVisibleMapRect(route.polyline.boundingMapRect, animated: true)
            }
        }
        
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
