//
//  NearbyFriendsListViewController.swift
//  BikeTogether
//
//  Created by Supassara Sujjapong on 22/6/16.
//  Copyright © 2016 Supassara Sujjapong. All rights reserved.
//

import UIKit
import MapKit
class NearbyFriendsListViewController: UIViewController,MKMapViewDelegate, UITableViewDelegate, UITableViewDataSource, UIPickerViewDataSource, UIPickerViewDelegate {

    var pickerDataSource = ["Salaya(A)", "Silom(B)", "Ladprao(C)"];
    var alert = UIAlertController()
    var friendIDList: Array<String> = []
    var friendNameList: Array<String> = []
    var distanceAwayList: Array<String> = []
    var points: Array<MKPointAnnotation> = []
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var zoneLabel: UILabel!
    
    @IBAction func changeMethod() {
        pickerInAction()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(animated: Bool) {
        mapView.delegate = self
        
        switch userZone
        {
        case "A":
            zoneLabel.text = "Salaya(A)"
        case "B":
            zoneLabel.text = "Silom(B)"
        case "C":
            zoneLabel.text = "Ladprao(C)"
        default:
            zoneLabel.text = "Unknown error"
        }
        
        loadNearbyUsers()
        
        tableView.reloadData()
    }
    
    func loadNearbyUsers(){
        
        
        friendIDList = []
        friendNameList = []
        points = []
        
        let location = CLLocationCoordinate2DMake(currentLoc.coordinate.latitude, currentLoc.coordinate.longitude)
        
        let region = MKCoordinateRegion(center: location, span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.1))
        self.mapView.setRegion(region, animated: true)
        addRadiusCircle(location)
        
        
        // Search nearby users database call
        // searchusers.php
        
        let session = NSURLSession.sharedSession()
        let request = NSMutableURLRequest(URL: NSURL(string: "http://ridebike.atilal.com/searchusers.php/")!)
        request.HTTPMethod = "POST"
        let postString = "uid=\(userID)&currentlatitude=\(currentLoc.coordinate.latitude)&currentlongitude=\(currentLoc.coordinate.longitude)&zone=\(userZone)"
        
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
                let count = json["user"].count
                print(json)
                print("Number of nearby = \(count)")
                dispatch_async(dispatch_get_main_queue(), {
                    if count > 0 {
                        for i in 0...count-1{
                            
                            let uid = Int64(json["user"][i]["uid"].string!)!
                            let name = json["user"][i]["name"].string!
                            let latitude = Double(json["user"][i]["currentlatitude"].string!)
                            let longitude = Double(json["user"][i]["currentlongitude"].string!)
                            
                            let distanceAway = Double(json["user"][i]["distance"].string!)
                            var distanceAwayStr = ""
                            
                            print(distanceAway)
                            
                            if distanceAway < 0 {
                                let dString = String(format: "%g", round(distanceAway!*100))
                                distanceAwayStr = "\(dString) m away"
                            }
                            else{
                                let dString = String(round(distanceAway!*100)/100)
                                distanceAwayStr = "\(dString) km away"
                            }
                            
                            let location = CLLocationCoordinate2D(latitude: latitude!, longitude: longitude!)
                            
                            let point = MKPointAnnotation()
                            point.coordinate = location
                            point.title = String(name)
                            self.points.append(point)
                            self.mapView.addAnnotation(point)
                            
                            self.friendIDList.append(String(uid))
                            self.friendNameList.append(name)
                            self.distanceAwayList.append(distanceAwayStr)
                            
                            /*getName(uid, handler: {
                                (name) -> Void in
                                point.title = String(name)
                                self.friendNameList.append(name)
                            })*/
                            
                            print("fid = \(uid), lat = \(latitude),long = \(longitude)")
                        }
                        self.tableView.reloadData()
                    }})
                self.tableView.reloadData()
                
            }
        }
        dataTask.resume()
    }

    // ********************* TABLE VIEW METHODS ********************* //
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        mapView.selectAnnotation(points[indexPath.row], animated: true)
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return friendIDList.count
    }
    
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let Cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath) as! NearbyFriendsTableViewCell

        let facebookProfileUrl = "http://graph.facebook.com/\(friendIDList[indexPath.row])/picture?type=large"
        let friendImage = UIImage(data: NSData(contentsOfURL: NSURL(string: facebookProfileUrl)!)!)!
        let name = friendNameList[indexPath.row]
        let distanceAway = distanceAwayList[indexPath.row]
        
        Cell.profilePicture.image = friendImage
        Cell.profilePicture.contentMode = .ScaleToFill
        Cell.name.text = name
        Cell.distanceAway.text = distanceAway
        
        return Cell
        
    }
    
    // *********************  MAP METHODS ********************* //
    
    func addRadiusCircle(location: CLLocationCoordinate2D){
        self.mapView.delegate = self
        let circle = MKCircle(centerCoordinate: location, radius: 5000 as CLLocationDistance)
        self.mapView.addOverlay(circle)
    }
    
    func mapView(mapView: MKMapView, rendererForOverlay overlay: MKOverlay) -> MKOverlayRenderer {
        
        let circle = MKCircleRenderer(overlay: overlay)
        circle.strokeColor = blueTone
        circle.fillColor = UIColor(r: 96, g: 180, b: 241, a: 26)
        circle.lineWidth = 1
        return circle
    }

    // *********************  ALERT & PICKERVIEW METHODS ********************* //
    
    func pickerInAction(){
        
        let title = ""
        let message = "\n\n\n\n\n\n\n\n\n\n";
        alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.ActionSheet);
        alert.modalInPopover = true;
        
        
        let pickerFrame: CGRect = CGRectMake(17, 52, 270, 100);
        let picker: UIPickerView = UIPickerView(frame: pickerFrame);
        picker.delegate = self;
        picker.dataSource = self;
        alert.view.addSubview(picker);
        
        let toolFrame = CGRectMake(17, 5, 270, 45);
        let toolView: UIView = UIView(frame: toolFrame);
        
        //Create the cancel button
        let buttonCancelFrame: CGRect = CGRectMake(0, 7, 100, 30);
        let buttonCancel: UIButton = UIButton(frame: buttonCancelFrame);
        buttonCancel.setTitle("Cancel", forState: UIControlState.Normal);
        buttonCancel.setTitleColor(blueTone, forState: UIControlState.Normal);
        buttonCancel.addTarget(self, action: #selector(NearbyFriendsListViewController.cancelSelection(_:)), forControlEvents: UIControlEvents.TouchDown);
        toolView.addSubview(buttonCancel);
        
        //add buttons to the view
        let buttonOkFrame: CGRect = CGRectMake(170, 7, 100, 30);
        let buttonOk: UIButton = UIButton(frame: buttonOkFrame);
        buttonOk.setTitle("Select", forState: UIControlState.Normal);
        buttonOk.setTitleColor(blueTone, forState: UIControlState.Normal);
        buttonOk.addTarget(self, action: #selector(NearbyFriendsListViewController.selectChange(_:)), forControlEvents: UIControlEvents.TouchDown);
        toolView.addSubview(buttonOk); //add to the subview
        
        //add the toolbar to the alert controller
        alert.view.addSubview(toolView);
        self.presentViewController(alert, animated: true, completion: nil);
        
    }
    
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return 3
    }
    
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return pickerDataSource[row]
    }
    
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        zoneLabel.text = pickerDataSource[row]
    }
    
    func cancelSelection(sender: UIButton){
        self.alert.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func selectChange(sender: UIButton){
        
        //Update zone
        //Database call updatezone.php
        
        print("** Update Zone (DBMETHOD) **")
        
        switch zoneLabel.text!
        {
        case "Salaya(A)":
            userZone = "A"
        case "Silom(B)":
            userZone = "B"
        case "Ladprao(C)":
            userZone = "C"
        default:
            userZone = "A"
        }
        
        let session = NSURLSession.sharedSession()
        let request = NSMutableURLRequest(URL: NSURL(string: "http://ridebike.atilal.com/updatezone.php/")!)
        request.HTTPMethod = "POST"
        let postString = "uid=\(userID)&zone=\(userZone)"
        
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
                case " 0": print("** Update Zone (Response 0: Unknown error) **")
                case " 1": print("** Update Zone (Response 1: Success) **")
                default: print("** Update Zone (Response 0: Unknown error) **")
                }
                self.loadNearbyUsers()
                self.alert.dismissViewControllerAnimated(true, completion: nil)
            }
        }
        dataTask.resume()
    }
    
    // *********************  Others ********************* //

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
