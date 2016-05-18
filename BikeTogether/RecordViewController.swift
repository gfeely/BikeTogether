//
//  RecordViewController.swift
//  BikeTogether
//
//  Created by Supassara Sujjapong on 1/11/15.
//  Copyright © 2015 Supassara Sujjapong. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class RecordViewController: UIViewController, CLLocationManagerDelegate, MKMapViewDelegate {
    
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var startButton: UIButton!
    @IBOutlet weak var stopButton: UIButton!
    @IBOutlet weak var distanceText: UILabel!
    @IBOutlet weak var speedText: UILabel!
    
    var distance: Double = 0
    var startTimeStamp = ""
    var stopTimeStamp = ""

    //Location Manager Initiliasation
    lazy var locations = [CLLocation]()
    lazy var locationManager: CLLocationManager = {
        var _locationManager = CLLocationManager()
        _locationManager.delegate = self
        _locationManager.desiredAccuracy = kCLLocationAccuracyBest
        _locationManager.activityType = .Fitness
        
        // Movement threshold for new events
        _locationManager.distanceFilter = 10.0
        return _locationManager
    }()
    
    //State of the Start Button
    //STATE 1 = Press while in this state = start recording. State change 2.
    //STATE 2 = Press while in this state = stop. State change to 3
    //STATE 3 = Press while in this state = reset. State change to 1
    var state: Int = 1
    
    ///////////////////////////////////////////////////////////////////////////////////////////////
    
    @IBAction func unwindToMain(sender: UIBarButtonItem) {
        backToMainMenuOnYes(self)
    }
    
    @IBAction func toFinish(sender: AnyObject) {
        
        if(state == 1){
            
            //Can not FINISH if the ride has not been recorded.
            //If STATE 1 is pressed, value of state will change to 2
            
            normalAlert(self, title: "No Ride Recorded", message: "Press start to start recording")
        }
        if(state == 2){
            
            //Can not FINISH if the ride is still recording
            //If STATE 2 is pressed, value of state will change to 3
            
            normalAlert(self, title: "Stop Before Finishing", message: "Press stop to stop recording")
        }
        if(state == 3 && locations.count > 1){
            
            //Can only FINISH when STOP is pressed
            //If current STATE = 3 means that STATE 2(STOP) is pressed
            //Alert prompted - press YES (Direct to finish), press NO (Nothing happen)
            
            let alert = UIAlertController(title: "Finish", message: "Are you sure you are finished?", preferredStyle: UIAlertControllerStyle.Alert)
            
            alert.addAction(UIAlertAction(title: "Yes", style: .Default, handler: {
                (action: UIAlertAction!) in
                self.performSegueWithIdentifier("toFinish", sender: self)
            }))
            alert.addAction(UIAlertAction(title: "No", style: UIAlertActionStyle.Default, handler: nil))
            self.presentViewController(alert, animated: true, completion: nil)
        }
        else{
            normalAlert(self, title: "Cannot Finish", message: "No distance has been recorded")
        }
    }
    
    ///////////////////////////////////////////////////////////////////////////////////////////////
    //Timer Methods
    
    //Timer Initialisations
    var startTime = NSTimeInterval()
    var timer = NSTimer()
    var isPause = false
    var minutes : UInt8 = 0
    var seconds : UInt8 = 0
    var fraction : UInt8 = 0
    var start: Bool = false
    var speed: CLLocationSpeed = CLLocationSpeed()

    @IBOutlet weak var timeText: UILabel!
    @IBAction func timerMethod() {
        
        if(state == 1){
            
            //Recording State - record distance, time and draw route
            //If state 1 is pressed, state = 2
            //Button change text to - Stop
            
            state = 2
            start = true
            startButton.setTitle("Stop", forState: .Normal)
            let aSelector : Selector = "updateTime"
            if (!timer.valid && isPause == false){
                timer = NSTimer.scheduledTimerWithTimeInterval(0.01, target: self, selector: aSelector, userInfo: nil, repeats: true)
                startTime = NSDate.timeIntervalSinceReferenceDate()
                isPause = true
                
                startTimeStamp = NSDateFormatter.localizedStringFromDate(NSDate(), dateStyle: .MediumStyle, timeStyle: .ShortStyle)
            }
            else{
                timer = NSTimer.scheduledTimerWithTimeInterval(0.01, target: self, selector: aSelector, userInfo: nil, repeats: true)
                timer.fire()
            }
        }
        else if(state == 2){
            
            //Recording is paused
            //If state 2 is pressed, state = 3
            //Button change text to - Reset
            
            state = 3
            start = false
            startButton.setTitle("Reset", forState: .Normal)
            isPause = false
            timer.invalidate()
            
            stopTimeStamp = NSDateFormatter.localizedStringFromDate(NSDate(), dateStyle: .MediumStyle, timeStyle: .ShortStyle)
        }
        else if(state == 3){
            
            //Recording is reset
            //If state 3 is press, state = 1
            //Button change text to - Start
            self.resetAll()
        }
    }
    
    func updateTime(){
        
        //StopWatch Timer Method
        
        let currentTime = NSDate.timeIntervalSinceReferenceDate()
        var elapsedTime: NSTimeInterval = currentTime - startTime
        
        minutes = UInt8(elapsedTime / 60.0)
        elapsedTime -= (NSTimeInterval(minutes) * 60)
        
        seconds = UInt8(elapsedTime)
        elapsedTime -= NSTimeInterval(seconds)
        
        fraction = UInt8(elapsedTime * 100)
        
        let strMinutes = String(format: "%02d", minutes)
        let strSeconds = String(format: "%02d", seconds)
        let strFraction = String(format: "%02d", fraction)
        
        timeText.text = "\(strMinutes):\(strSeconds):\(strFraction)"
    }
    //End of Timer Methods
    ///////////////////////////////////////////////////////////////////////////////////////////////
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        //////////////////////////////////////////////////////////////////////////////////
        //User Interface Decorations
        //Start Button
        startButton.layer.cornerRadius = startButton.frame.size.width / 2
        startButton.layer.borderWidth = 4
        startButton.layer.borderColor = UIColor.whiteColor().CGColor
        
        //Finish Button
        stopButton.layer.cornerRadius = startButton.frame.size.width / 2
        stopButton.layer.borderWidth = 4
        stopButton.layer.borderColor = UIColor.whiteColor().CGColor
        //////////////////////////////////////////////////////////////////////////////////
    }
    
    override func viewDidAppear(animated: Bool) {
        
        if CLLocationManager.locationServicesEnabled() {
            //Start updating the location at ViewDidAppear
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            locationManager.startUpdatingLocation()
        }
    }
    
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        //Things to do while the current location is being updated
    
        //Set the region of the map to the last location in the locations array. (Will keep updating, tracking and map will region will follow last location)
        let location = locations.last
        let center = CLLocationCoordinate2D(latitude: location!.coordinate.latitude, longitude: location!.coordinate.longitude)
        let region = MKCoordinateRegion(center: center, span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01))
        self.mapView.setRegion(region, animated: true)
        
        //Track distance and route
        //Only do this if the start button is pressed
        if(start == true){
            
            speedText.text = String(Int(round(speed*3.6)))
            
            for location in locations {
                
                if location.horizontalAccuracy < 20 {
                    //update distance
                    if self.locations.count > 0 {
                        distance = distance + location.distanceFromLocation(self.locations.last!)
                    }
                    
                    //For changing format, metres and kilometres. (format: 000.00 m or *.00 km)
                    if(distance < 1000){
                        distanceText.text = String("\(round(distance*100)/100) m")
                    }else{
                        var dtn = distance/1000
                        dtn = round(dtn*100)/100
                        distanceText.text = String("\(dtn) km")
                    }
                    
                    //Save location to the array
                    self.locations.append(location)
                    
                    //Draw MKPolyline while updating user location
                    //Must have atleast 2 points to draw a polyline route.
                    if(self.locations.count>1){
                        let sourceIndex = self.locations.count - 1
                        let destinationIndex = self.locations.count - 2
                        let c1 = self.locations[sourceIndex].coordinate
                        let c2 = self.locations[destinationIndex].coordinate
                        var a = [c1, c2]
                        let polyline = MKPolyline(coordinates: &a, count: a.count)
                        //polylines.append(mapView.addOverlay(polyline))
                        mapView.addOverlay(polyline)
                    }
                }
            }
        }
        
        //Get speed
        speed = locationManager.location!.speed
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
    
    func resetAll(){
        //This function resets all values recorded
        state = 1
        startButton.setTitle("Start", forState: .Normal)
        distanceText.text = "0 m"
        timeText.text = "00:00:00"
        speedText.text = "0"
        distance = 0
        speed = 0
        mapView.removeOverlays(mapView.overlays)
        
        timer.invalidate()
        minutes = 0
        seconds = 0
        fraction = 0
        
        
        locations = [CLLocation]()
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if(segue.identifier == "toFinish"){
            
            //Send timeTaken, distance covered and arrray of locations to the FinishViewController
            //Reset all recordings
            
            let FVC: FinishViewController = segue.destinationViewController as! FinishViewController
            FVC.timeTaken = timeText.text!
            FVC.distance = distance
            FVC.locations = locations
            FVC.startTimeStamp = startTimeStamp
            FVC.stopTimeStamp = stopTimeStamp
            self.resetAll()
        }
    }
    
    
    
    
}
