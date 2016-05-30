//
//  FriendViewController.swift
//  BikeTogether
//
//  Created by Supassara Sujjapong on 27/5/16.
//  Copyright © 2016 Supassara Sujjapong. All rights reserved.
//

import UIKit

class FriendViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var friendIDList: Array<Int> = []
    var friendNameList: Array<String> = []
    
    @IBOutlet weak var tableView: UITableView!
    

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(animated: Bool) {
        
        print("===========================")
        print("FriendViewController")
        
        friendNameList = []
        friendIDList = []
        
        for i in 0...friendData.count-1 {
            let valueDict : NSDictionary = friendData[i] as! NSDictionary
            let id = valueDict.objectForKey("id") as! String
            let name = valueDict.objectForKey("name") as! String
            friendIDList.append(Int(id)!)
            friendNameList.append(name)
        }
        
        print(friendIDList)
        
        tableView.reloadData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return friendIDList.count
    }
    
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath)
        
        let facebookProfileUrl = "http://graph.facebook.com/\(friendIDList[indexPath.row])/picture?type=large"
        let friendImage = UIImage(data: NSData(contentsOfURL: NSURL(string: facebookProfileUrl)!)!)!
        
        //Text on cell is the name from the array
        cell.textLabel?.text = friendNameList[indexPath.row]
        cell.imageView?.image = friendImage
        
        return cell
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
