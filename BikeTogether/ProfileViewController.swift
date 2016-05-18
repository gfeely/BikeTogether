//
//  ProfileViewController.swift
//  BikeTogether
//
//  Created by Supassara Sujjapong on 10/12/15.
//  Copyright © 2015 Supassara Sujjapong. All rights reserved.
//

import UIKit
import CoreData

class ProfileViewController: UIViewController, UITableViewDelegate, UITableViewDataSource  {

    var list: Array<AnyObject>? = []
    var recordList: Array<String>? = []
    
    
    @IBOutlet weak var avatarImageView: UIImageView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var firstname: UILabel!
    @IBOutlet weak var lastname: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        ///////////////////////////////////////////////////////////////////////////////////
        //User Interface Decorations
        
        firstname.text = strFirstName
        lastname.text = strLastName
        
        //Profile Picture
        self.avatarImageView.image = profilePicture
        avatarImageView.contentMode = .ScaleAspectFill
        avatarImageView.layer.cornerRadius = avatarImageView.frame.size.width / 2;
        avatarImageView.clipsToBounds = true
        avatarImageView.layer.borderColor = UIColor.whiteColor().CGColor
        avatarImageView.layer.borderWidth = 5
        ////////////////////////////////////////////////////////////////////////////////////
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

    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return recordList!.count
    }
    
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath)
        
        //Text on cell is the name from the array
        cell.textLabel?.text = recordList![indexPath.row]
        return cell
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        //Name variable in the PastRecordViewController is equal to the name selected on the table row
        if(segue.identifier == "toPastRecord"){
            let x:NSIndexPath? = self.tableView.indexPathForSelectedRow
            let selectedRow = recordList![x!.row]
            let PRVC: PastRecordViewController = segue.destinationViewController as! PastRecordViewController
            PRVC.name = selectedRow
        }
        
    }

}
