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

    @IBOutlet weak var detailTextView: UITextView!
    @IBOutlet weak var headerImageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func viewDidAppear(animated: Bool) {
        
        switch injuryName {
        case "sprain.png":
            self.title = "Sprain and Strain"
            headerImageView.image = UIImage(named: "sprain-info.png")
        case "cut.png":
            self.title = "Cut and Grazing"
            headerImageView.image = UIImage(named: "cut-info.png")
        case "headinjury.png":
            self.title = "Head Injury"
            headerImageView.image = UIImage(named: "head-info.png")
        case "fracture.png":
            self.title = "Fracture"
            headerImageView.image = UIImage(named: "fracture-info.png")
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
