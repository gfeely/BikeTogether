//
//  detailsViewController.swift
//  BikeTogether
//
//  Created by Supassara Sujjapong on 7/6/16.
//  Copyright © 2016 Supassara Sujjapong. All rights reserved.
//

import UIKit

class detailsViewController: UIViewController {
    
    var injuryName = ""
    //var injuryImage = ["sprain.png", "wound.png", "headinjury.png", "fracture.png", "dehydration.png"]

    @IBOutlet weak var detailTextView: UITextView!
    @IBOutlet weak var headerImageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func viewDidAppear(animated: Bool) {
        headerImageView.image = UIImage(named: injuryName)
        
        switch injuryName {
        case "sprain.png":
            detailTextView.text = "• Help the injured person to sit or lie down comfortably, with some padding underneath their injury to support it. \n\n• Cool the area with a cold compress/ice pack to help reduce the swelling and pain. \n\n• Apply comfortable support to the injury, by placing a layer of padding over the cold compress and securing it in place with a bandage. \n \n• Support the injured part in a raised position if possible. \n\n• If the pain is severe or they are unable to move he injured part, arrange to get them to hospital"

        case "wound.png":
            detailTextView.text = "Fail to retrieve"

        case "headinjury.png":
            detailTextView.text = "Fail to retrieve"

        case "fracture.png":
            detailTextView.text = "Fail to retrieve"

        case "dehydration.png":
            detailTextView.text = "Fail to retrieve"

        default:
            detailTextView.text = "Fail to retrieve"
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
