//
//  PastRecordViewController.swift
//  BikeTogether
//
//  Created by Supassara Sujjapong on 10/12/15.
//  Copyright © 2015 Supassara Sujjapong. All rights reserved.
//

import UIKit
import MapKit
import CoreData

class PastRecordViewController: UIViewController, MKMapViewDelegate{
    
    var name = ""
    var list: Array<AnyObject>? = []
    var latitude: Double = 0
    var longitude: Double = 0

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var timeStampLabel: UILabel!
    @IBOutlet weak var distanceLabel: UILabel!
    @IBOutlet weak var timeTakenLabel: UILabel!
    @IBOutlet weak var mapView: MKMapView!

    override func viewDidLoad() {
        super.viewDidLoad()
    }
  
    override func viewDidAppear(animated: Bool) {

        ////////////////////////////////////////////////////////////////////////////////////
        //Database Fetch
        let appDel:AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let context:NSManagedObjectContext? = appDel.managedObjectContext
        let freq = NSFetchRequest(entityName: "Record")
        
        //Fetch all with the same name and sort it using key
        let predicate: NSPredicate = NSPredicate(format: "name = %@", name)
        freq.predicate = predicate
        let sortDescriptor = NSSortDescriptor(key: "key", ascending: true)
        freq.sortDescriptors = [sortDescriptor]
        
        list = try! context?.executeFetchRequest(freq)
        
        if(list!.count > 0){
            

            //Starting Point
            let data1 = list![0] as! NSManagedObject
            self.title = data1.valueForKeyPath("name") as? String
            latitude = data1.valueForKeyPath("latitude") as! Double
            longitude = data1.valueForKeyPath("longitude") as! Double
            let source = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
            
            //Destination Point
            let data2 = list!.last as! NSManagedObject
            let destLat = data2.valueForKeyPath("latitude") as! Double
            let destLong = data2.valueForKeyPath("latitude") as! Double
            let destination = CLLocationCoordinate2D(latitude: destLat, longitude: destLong)
            
            let region = MKCoordinateRegion(center: destination, span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01))
            self.mapView.setRegion(region, animated: true)
            
            ///////////////////////////////////////////////
            //Set text labels
            nameLabel.text = data1.valueForKey("name") as? String
            timeStampLabel.text = data1.valueForKey("timeStamp") as? String
            distanceLabel.text = data1.valueForKey("distance") as? String
            timeTakenLabel.text = data1.valueForKey("timeTaken") as? String
            ///////////////////////////////////////////////

            //Drawing the route
            for(var i = 0; i < list!.count; i += 1){
                let data3 = list![i] as! NSManagedObject
                let la1 = data3.valueForKeyPath("latitude") as! Double
                let lo1 = data3.valueForKeyPath("longitude") as! Double
                drawRoute(la1, long1: lo1)
            }
        }
        ////////////////////////////////////////////////////////////////////////////////////
    }

    func drawRoute (lat1: Double, long1: Double){
        //This function is used for drawing the route. Needs two points to draw.
        //First Point (P1), second point (P2)
        let p1 = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        latitude = lat1
        longitude = long1
        let p2 = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        
        var points: [CLLocationCoordinate2D]
        points = [p1, p2]
        let geodesic = MKPolyline(coordinates: &points[0], count: 2)
        mapView.addOverlay(geodesic)
        
        //Set region of map to center at the destination point
        let destination = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        let region = MKCoordinateRegion(center: destination, span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01))
        self.mapView.setRegion(region, animated: true)
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
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

}
