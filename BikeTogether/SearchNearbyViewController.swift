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
            friendView.hidden = false
            routeView.hidden = true

        case 1:
            routeView.hidden = false
            friendView.hidden = true
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