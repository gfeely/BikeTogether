//
//  SearchNearbyViewController.swift
//  BikeTogether
//
//  Created by Supassara Sujjapong on 20/6/16.
//  Copyright © 2016 Supassara Sujjapong. All rights reserved.
//

import UIKit
import MapKit

class SearchNearbyViewController: UIViewController {
    
    
    //@IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var segmentControl: UISegmentedControl!
    @IBOutlet weak var friendView: UIView!
    @IBOutlet weak var routeView: UIView!
    
    @IBAction func indexChange(sender: UISegmentedControl) {
        
        switch segmentControl.selectedSegmentIndex {
        case 0:
            self.title = "Search for Nearby Cyclists"
            friendView.hidden = false
            routeView.hidden = true

        case 1:
            self.title = "Plan Route"
            routeView.hidden = false
            friendView.hidden = true
            
            let PRVC : PlanRouteViewController = self.childViewControllers[0] as! PlanRouteViewController
            PRVC.viewDidAppear(true)

        default:
            break;
        }
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(animated: Bool) {
        
        print("===========================")
        print("SearchNearbyViewController")
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}