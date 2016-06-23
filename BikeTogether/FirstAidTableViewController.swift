//
//  FirstAidTableViewController.swift
//  BikeTogether
//
//  Created by Supassara Sujjapong on 6/6/16.
//  Copyright © 2016 Supassara Sujjapong. All rights reserved.
//

import UIKit

class FirstAidTableViewController: UITableViewController {
    
    var injuryImage = ["sprain.png", "wound.png", "headinjury.png", "fracture.png"]
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        
        self.tableView.separatorStyle = UITableViewCellSeparatorStyle.None

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 4
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath) as! infoTableViewCell
        
        
        //Text on cell is the name from the array
        cell.infoImageView.image = UIImage(named: injuryImage[indexPath.row])
        cell.infoImageView.contentMode = .ScaleAspectFill
        
        //cell.infoLabel.text = images[indexPath.row]
        
        return cell
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if(segue.identifier == "toDetail"){
            let x:NSIndexPath? = self.tableView.indexPathForSelectedRow
            let DVC: detailsViewController = segue.destinationViewController as! detailsViewController
            //DVC.headerImage = images[(x?.row)!]
            DVC.injuryName = injuryImage[x!.row]
        }
    }

}
