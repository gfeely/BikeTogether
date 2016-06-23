//
//  FriendViewController.swift
//  BikeTogether
//
//  Created by Supassara Sujjapong on 27/5/16.
//  Copyright © 2016 Supassara Sujjapong. All rights reserved.
//

import UIKit

class FriendViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var friendIDList: Array<String> = []
    var friendNameList: Array<String> = []
    
    @IBOutlet weak var tableView: UITableView!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.separatorStyle = UITableViewCellSeparatorStyle.SingleLine
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(animated: Bool) {
        
        print("===========================")
        print("FriendViewController")
        
        friendNameList = []
        friendIDList = []
        
        var name: String = ""
    
        for i in 0...friendData.count-1 {
            let valueDict : NSDictionary = friendData[i] as! NSDictionary
            let id = valueDict.objectForKey("id") as! String
            print(id)
            print(valueDict.objectForKey("name"))
            
            if (valueDict.objectForKey("name") != nil){
                name = valueDict.objectForKey("name")! as! String
                friendNameList.append(name)
            }
            
           friendIDList.append(id)
        }
                
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
        
        let facebookProfileUrl = "http://graph.facebook.com/\(friendIDList[indexPath.row])/picture?type=large"
        let friendImage = UIImage(data: NSData(contentsOfURL: NSURL(string: facebookProfileUrl)!)!)!
        let name = friendNameList[indexPath.row]
        
        let Cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath) as! FriendTableViewCell

        let cellImageLayer: CALayer?  = Cell.frdPic.layer
        cellImageLayer!.cornerRadius = Cell.frdPic.frame.size.width / 2
        cellImageLayer!.masksToBounds = true
        
        Cell.frdPic.image = friendImage
        Cell.frdPic.contentMode = .ScaleAspectFill
        Cell.frdName.text = name
        
        totalDistance(Int64(friendIDList[indexPath.row])!, handler: {
            (distance) -> Void in
            dispatch_async(dispatch_get_main_queue(), {
                
                if(distance < 1000){
                    let dtn = round(distance)
                    Cell.distanceCovered.text = String("\(dtn) m")
                }else{
                    var dtn = distance/1000
                    dtn = round(dtn*100)/100
                    Cell.distanceCovered.text = String("\(dtn) km")
                }
                
            })
        })
        
        return Cell
        
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
