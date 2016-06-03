//
//  UserRecordTableViewController.swift
//  BikeTogether
//
//  Created by Supassara Sujjapong on 12/5/16.
//  Copyright © 2016 Supassara Sujjapong. All rights reserved.
//

import UIKit
import CoreData

class UserRecordTableViewController: UITableViewController {

    var list: Array<AnyObject>? = []
    var recordList: Array<String>? = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }
    
    override func viewDidAppear(animated: Bool) {
        
        print("===========================")
        print("UserRecordViewController")
        
        recordList = []
        
        let session = NSURLSession.sharedSession()
        let request = NSMutableURLRequest(URL: NSURL(string: "http://ridebike.atilal.com/showrname.php/")!)
        request.HTTPMethod = "POST"
        let postString = "uid=\(userID)"
        
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
                print(responseString)
                if data != nil{
                    
                    print("** Get rname (DBMethod)**")
                    let json = JSON(data: data!)
                    let count = json["rname"].count
                    if count > 0 {
                        dispatch_async(dispatch_get_main_queue(), {
                            for i in 0...count-1{
                                self.recordList?.append(json["rname"][i].string!)
                                self.tableView.reloadData()
                            }
                        })
                    }else{
                        print("No record")
                    }
                }
            }
        }
        dataTask.resume()
        tableView.reloadData()
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
        return recordList!.count
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath) as! UserRecordTableViewCell

        
        let cellImageLayer: CALayer?  = cell.mapImage.layer
        cellImageLayer!.cornerRadius = cell.mapImage.frame.size.width / 2
        cellImageLayer!.masksToBounds = true
        
        //Text on cell is the name from the array
        cell.mapImage.contentMode = .ScaleAspectFill
        cell.routeName.text = recordList![indexPath.row]
        return cell
    }
    

    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */


    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if(segue.identifier == "toIndividualRecord"){
            let x:NSIndexPath? = self.tableView.indexPathForSelectedRow
            let selectedRow = recordList![x!.row]
            let IRVC: IndiRecordViewController = segue.destinationViewController as! IndiRecordViewController
            IRVC.rname = selectedRow
            IRVC.title = selectedRow
        }
    }
    

}
