//
//  PlanRouteViewController.swift
//  BikeTogether
//
//  Created by Supassara Sujjapong on 23/6/16.
//  Copyright © 2016 Supassara Sujjapong. All rights reserved.
//

import UIKit
import MapKit

class PlanRouteViewController: UIViewController, MKMapViewDelegate, UITableViewDelegate, UITableViewDataSource {

    
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var tableView: UITableView!
    
    var nameList: Array<String> = []
    var ridList: Array<Int> = []
    var slat: Array<Double> = []
    var slong: Array<Double> = []
    var dlat: Array<Double> = []
    var dlong: Array<Double> = []
    
    
    @IBOutlet weak var distanceLabel: UILabel!
    @IBOutlet weak var descriptionView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mapView.delegate = self
    }
    
    
    override func viewDidAppear(animated: Bool) {
    
        print("===========================")
        print("PlanRouteViewController")
        
        descriptionView.hidden = true
        
        mapView.removeOverlays(mapView.overlays)
        let allAnnotations = self.mapView.annotations
        self.mapView.removeAnnotations(allAnnotations)
        
        let location = CLLocationCoordinate2DMake(currentLoc.coordinate.latitude, currentLoc.coordinate.longitude)
        
        let region = MKCoordinateRegion(center: location, span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01))
        self.mapView.setRegion(region, animated: true)
        
        getRoutes()
    }
    
    func mapView(mapView: MKMapView, rendererForOverlay overlay: MKOverlay) -> MKOverlayRenderer {
        let renderer = MKPolylineRenderer(polyline: overlay as! MKPolyline)
        renderer.strokeColor = redTone
        renderer.lineWidth = 4
        return renderer
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // ********************* TABLE VIEW METHODS ********************* //
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        routing(slat[indexPath.row], slong: slong[indexPath.row], dlat: dlat[indexPath.row], dlong: dlong[indexPath.row])
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return nameList.count
    }
    
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let Cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath) as! NearbyFriendsTableViewCell
        
        Cell.name.text = nameList[indexPath.row]
        
        return Cell
        
    }
    
    
    func tableView(tableView: UITableView, editActionsForRowAtIndexPath indexPath: NSIndexPath) -> [UITableViewRowAction]? {
        let deleteRoute = UITableViewRowAction(style: .Normal, title: "Delete") { action, index in
            
            let alert = UIAlertController(title: "Delete Permanently", message: "Are you sure you want to delete this route? \n Other users in this group will not be able to access this route again.", preferredStyle: UIAlertControllerStyle.Alert)
            
            //Press Yes - user will be redirected to Main Menu
            alert.addAction(UIAlertAction(title: "Delete", style: .Default, handler: {
                (action: UIAlertAction!) in
                
                let rid = self.ridList[indexPath.row]
                
                let session = NSURLSession.sharedSession()
                let request = NSMutableURLRequest(URL: NSURL(string: "http://ridebike.atilal.com/deletezoneroute.php/")!)
                request.HTTPMethod = "POST"
                let postString = "rid=\(rid)"
                
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
                        case " 0": print("** Delete zone-route (Response 0: Unknown error) **")
                        case " 1":
                            print("** Delete zone-route (Response 1: Success)")
                            NSOperationQueue.mainQueue().addOperationWithBlock {
                                self.viewDidAppear(true)
                            }
                            default: print("** Delete zone-route (Response not 0: Unknown error) **")
                        }
                    }
                }
                dataTask.resume()

                
                print("deleted")
                
            }))
            
            //Press No - nothing happens
            alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Default, handler: nil))
            
            self.presentViewController(alert, animated: true, completion: nil)

        }
        deleteRoute.backgroundColor = redTone
        
        return [deleteRoute]
    }
    
    func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // the cells you would like the actions to appear needs to be editable
        return true
    }
    
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        // you need to implement this method too or you can't swipe to display the actions
    }
    
    // ********************* ROUTING METHODS ********************* //
    
    func getRoutes(){
        
        nameList = []
        ridList = []
        slat = []
        slong = []
        dlat = []
        dlong = []
        
        let session = NSURLSession.sharedSession()
        let request = NSMutableURLRequest(URL: NSURL(string: "http://ridebike.atilal.com/showzoneroute.php/")!)
        request.HTTPMethod = "POST"
        let postString = "zone=\(userZone)"
        
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
                    
                    let json = JSON(data: data!)
                    let count = json["route"].count
                    print("Number of routes = \(count)")
                    dispatch_async(dispatch_get_main_queue(), {
                        if count > 0 {
                            for i in 0...count-1{
                                
                                let rid = Int(json["route"][i]["rid"].string!)!
                                let name = json["route"][i]["rname"].string!
                                let slatitude = Double(json["route"][i]["sourcelatitude"].string!)
                                let slongitude = Double(json["route"][i]["sourcelongitude"].string!)
                                let dlatitude = Double(json["route"][i]["deslatitude"].string!)
                                let dlongitude = Double(json["route"][i]["deslongitude"].string!)
                                
                                self.ridList.append(rid)
                                self.nameList.append(name)
                                self.slat.append(slatitude!)
                                self.slong.append(slongitude!)
                                self.dlat.append(dlatitude!)
                                self.dlong.append(dlongitude!)
                                
                            }
                        }
                        self.tableView.reloadData()
                    })
            }
        }
        dataTask.resume()

    }
    
    
    func routing(slat: Double, slong: Double, dlat: Double, dlong: Double){
        
        mapView.removeOverlays(mapView.overlays)
        let allAnnotations = self.mapView.annotations
        self.mapView.removeAnnotations(allAnnotations)
        
        let request = MKDirectionsRequest()
        let source = CLLocationCoordinate2D(latitude: slat, longitude: slong)
        let destination = CLLocationCoordinate2D(latitude: dlat, longitude: dlong)
        
        request.source = MKMapItem(placemark: MKPlacemark(coordinate: source, addressDictionary: nil))
        request.destination = MKMapItem(placemark: MKPlacemark(coordinate: destination, addressDictionary: nil))
        request.requestsAlternateRoutes = true
        request.transportType = .Walking
        
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
                
                self.descriptionView.hidden = false
                self.mapView.addOverlay(route.polyline)
                self.mapView.setVisibleMapRect(route.polyline.boundingMapRect, animated: true)
            }
        }

    }
    
}
