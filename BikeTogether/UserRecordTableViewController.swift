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
        ////////////////////////////////////////////////////////////////////////////////////
        //Database fetch request
        let appDel:AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let context:NSManagedObjectContext? = appDel.managedObjectContext
        let freq = NSFetchRequest(entityName: "Record")
        list = try! context?.executeFetchRequest(freq)
        
        //If the database contains nothing, do nothing
        if (list?.count == 0){}
        else{
            //Put name into array for show on table
            for ( var i = 0; i < list!.count; i += 1) {
                let data:NSManagedObject = list![i] as! NSManagedObject
                let name = data.valueForKey("name") as? String
                //If the array already contains the name, do nothing. Else add to list
                if (recordList!.contains((data.valueForKey("name")as? String)!)){}
                else{recordList?.append(name!)}
            }
        }
        /////////////////////////////////////////////////////////////////////////////////////
        
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
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath)
        
        //Text on cell is the name from the array
        cell.textLabel?.text = recordList![indexPath.row]
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
            //let selectedRow = recordList![x!.row]
            let IRVC: IndiRecordViewController = segue.destinationViewController as! IndiRecordViewController
            //IRVC.name = selectedRow
        }
    }
    

}