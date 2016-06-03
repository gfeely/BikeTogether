//
//  ViewController.swift
//  BikeTogether
//
//  Created by Supassara Sujjapong on 31/10/15.
//  Copyright © 2015 Supassara Sujjapong. All rights reserved.
//

import UIKit
import CoreLocation

class MainMenuViewController: UIViewController, CLLocationManagerDelegate {
    
    let locationManager = CLLocationManager()
    
    @IBOutlet weak var weatherImage: UIImageView!
    @IBOutlet weak var tempLabel: UILabel!
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var weatherDescription: UILabel!
    @IBOutlet weak var errorWeather: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Ask for Location Authorisation from the User.
        self.locationManager.requestAlwaysAuthorization()

        // For use in foreground
        self.locationManager.requestWhenInUseAuthorization()
        
        ///////////////////////////////////////////////////////////////////////////////////
        //User Interface Decorations
        //Profile Picture
        self.profileImageView.image = profilePicture
        self.profileImageView.contentMode = .ScaleAspectFill
        self.profileImageView.layer.cornerRadius = profileImageView.frame.size.width / 2;
        self.profileImageView.clipsToBounds = true
        
        //Weather
        self.weatherImage.hidden = true
        self.tempLabel.hidden = true
        self.cityLabel.hidden = true
        self.weatherDescription.hidden = true
        self.errorWeather.hidden = true
        ///////////////////////////////////////////////////////////////////////////////////
    }
    
    override func viewDidAppear(animated: Bool) {
        
        print("===========================")
        print("MainMenuViewController")
        
        //Update current location
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            locationManager.startUpdatingLocation()
        }
        
    }
    
    
    func locationManager(manager: CLLocationManager, didFailWithError error: NSError) {
        
        //Fail to get error, do:
        let alertBox = UIAlertController(title: "Alert", message: "Fail to get location", preferredStyle: UIAlertControllerStyle.Alert)
        alertBox.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default, handler: nil ))
        self.presentViewController(alertBox, animated: true, completion: nil)
    }
    
    func locationManager(manager: CLLocationManager, didUpdateToLocation newLocation: CLLocation, fromLocation oldLocation: CLLocation) {
        
        //Able to get location, do:
        let currentLocation: CLLocation = newLocation
        
        //Use current location for updateWeather
        let latitudeVal = String(round(currentLocation.coordinate.latitude*100)/100)
        let longitudeVal = String(round(currentLocation.coordinate.longitude*100)/100)
        locationManager.stopUpdatingLocation()
        updateWeather(latitudeVal, long: longitudeVal)
    }
    
    func updateWeather(lat: String, long:String){
        
        //Update weather function. Receives the latitude and longitude of the device current location and put it into the openweathermap web service to get the current weather information.
        
        var currentTemp:Double = 0
        
        //HTTP Request
        let path1 = "http://api.openweathermap.org/data/2.5/weather?lat="
        let path2 = "&lon="
        let apiKey = "&APPID=d2339a59857b86d84ddf37c13c0e4bb2"
        let url = NSURL(string: path1+lat+path2+long+apiKey)
        
        let task = NSURLSession.sharedSession().dataTaskWithURL(url!) { (data: NSData?, response: NSURLResponse?, error: NSError?) -> Void in
            
            if data == nil{
                
                //Error retrieving
                self.errorWeather.hidden = false
                
            }
            else{
                
                //Sucessful
                
                let json = JSON(data: data!)
                let cityName = json["name"].string
                let temp = json["main"]["temp"].double
                let desc = json["weather"][0]["main"].stringValue
                currentTemp = temp!-273.15
                currentTemp = round(currentTemp*100)/100
                print(cityName!)
                print(currentTemp)
                print(desc)
                
                //Stop updating the location
                self.locationManager.stopUpdatingLocation()
                
                //Because it is running on the other thread. Call this function to get to main queue to update label and image values
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    self.tempLabel.text = String("\(currentTemp)℃")
                    self.cityLabel.text = String(cityName!)
                    self.weatherDescription.text = desc
                    switch desc{
                    case "Rain":
                        self.weatherImage.image = UIImage(named: "rain")
                    case "Thunderstorm":
                        self.weatherImage.image = UIImage(named: "thunder")
                    case "Drizzle":
                        self.weatherImage.image = UIImage(named: "rain")
                    case "Snow":
                        self.weatherImage.image = UIImage(named: "snow")
                    case "Clear":
                        self.weatherImage.image = UIImage(named: "clearSky")
                    case "Mist":
                        self.weatherImage.image = UIImage(named: "mist")
                    case "Haze":
                        self.weatherImage.image = UIImage(named: "mist")
                    case "Fog":
                        self.weatherImage.image = UIImage(named: "mist")
                    case "Clouds":
                        self.weatherImage.image = UIImage(named: "cloudy")
                    default:
                        self.weatherImage.image = UIImage(named: "default")
                        
                }
            })
                //Show weather information
                self.weatherImage.hidden = false
                self.tempLabel.hidden = false
                self.cityLabel.hidden = false
                self.weatherDescription.hidden = false
            }}
        task.resume()
    }
    
    
    @IBAction func logOutButton() {
        
        //Log-out alert
        let alert = UIAlertController(title: "Sign-Out", message: "Are you sure you want to sign out?", preferredStyle: UIAlertControllerStyle.Alert)
        
        //Press Yes - user will be logged out
        alert.addAction(UIAlertAction(title: "Yes", style: .Default, handler: {
            (action: UIAlertAction!) in
            let loginManager = FBSDKLoginManager()
            loginManager.logOut()
            self.performSegueWithIdentifier("toLogged", sender: self)
        }))
        
        //Press No - nothing happens
        alert.addAction(UIAlertAction(title: "No", style: UIAlertActionStyle.Default, handler: nil))
        self.presentViewController(alert, animated: true, completion: nil)

    }
    
    @IBAction func backToMain (sender: UIStoryboardSegue){
        //For unwind segue to this view controller
    }
    
    ///////////////////////////////////////////////////////////////////////////////////////////////

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

