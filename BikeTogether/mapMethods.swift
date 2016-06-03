//
//  mapMethods.swift
//  BikeTogether
//
//  Created by Supassara Sujjapong on 11/5/16.
//  Copyright © 2016 Supassara Sujjapong. All rights reserved.
//

import Foundation
import MapKit

func drawRoute(sender: AnyObject, c1: CLLocation, c2:CLLocation){
    
    //Draw the route method
    
    let p1 = CLLocationCoordinate2D(latitude: c1.coordinate.latitude, longitude: c1.coordinate.longitude)
    let p2 = CLLocationCoordinate2D(latitude: c2.coordinate.latitude, longitude: c2.coordinate.longitude)
    
    var points: [CLLocationCoordinate2D]
    points = [p1,p2]
    let line = MKPolyline(coordinates: &points[0], count: 2)
    sender.mapView!!.addOverlay(line)
}

func getStartName(startPoint: CLLocation) -> (String){
    
    var startP = ""
    
    let geoCoder1 = CLGeocoder()
    geoCoder1.reverseGeocodeLocation(startPoint, completionHandler: { (placemarks, error) -> Void in
        
        // Place details
        var placeMark: CLPlacemark!
        placeMark = placemarks?[0]
        
        // Location name
        if let locationName = placeMark.addressDictionary!["Name"] as? NSString {
            startP = locationName as String
        }
        
    })
    
    return startP
}

func getDestName(endPoint: CLLocation) -> (String){
    
    var locName = ""
    
    let geoCoder1 = CLGeocoder()
    geoCoder1.reverseGeocodeLocation(endPoint, completionHandler: { (placemarks, error) -> Void in
        
        // Place details
        var placeMark: CLPlacemark!
        placeMark = placemarks?[0]
        
        // Location name
        if let locationName = placeMark.addressDictionary!["Name"] as? NSString {
            locName = locationName as String
        }})
    
    return locName
}


func takeSnapshot(mapView: MKMapView, withCallback: (UIImage?, NSError?) -> ()) {
    let options = MKMapSnapshotOptions()
    options.region = mapView.region
    options.size = mapView.frame.size
    options.scale = UIScreen.mainScreen().scale
    
    let snapshotter = MKMapSnapshotter(options: options)
    snapshotter.startWithCompletionHandler() { snapshot, error in
        guard snapshot != nil else {
            withCallback(nil, error)
            return
        }
        
        withCallback(snapshot!.image, nil)
    }
}