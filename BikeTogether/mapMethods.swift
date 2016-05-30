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

func getLocationName(startPoint: CLLocation, endPoint: CLLocation){
    
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
