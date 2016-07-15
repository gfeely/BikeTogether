//
//  GroupViewController.swift
//  BikeTogether
//
//  Created by Supassara Sujjapong on 27/6/16.
//  Copyright © 2016 Supassara Sujjapong. All rights reserved.
//

import UIKit

class GroupViewController: UIViewController, UITableViewDelegate, UITableViewDataSource  {


    var ranking : [(Double, Int64, String)] = []

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var selfPositionLabel: UILabel!
    @IBOutlet weak var infoView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.allowsSelection = false
        self.tableView.separatorStyle = UITableViewCellSeparatorStyle.SingleLine
        self.selfPositionLabel.layer.cornerRadius = selfPositionLabel.frame.size.width / 2
        self.selfPositionLabel.layer.masksToBounds = true
    }
    
    override func viewDidAppear(animated: Bool) {
        
        ranking = []
        
        let session = NSURLSession.sharedSession()
        let request = NSMutableURLRequest(URL: NSURL(string: "http://ridebike.atilal.com/ranking.php/")!)
        request.HTTPMethod = "POST"
        let postString = "zone=\(userZone)"
        
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

                if data != nil{
                    
                    print("** Zone ranking (DBMETHOD)**")

                    let json = JSON(data: data!)
                    let count = json["friend"].count
                    if count > 0 {
                        dispatch_async(dispatch_get_main_queue(), {
                            for i in 0...count-1{
                                
                                let id = Int64(json["friend"][i]["uid"].string!)!
                                let name = json["friend"][i]["name"].string!
                                let distance = Double(json["friend"][i]["distance"].string!)!
                                self.ranking.append((distance, id, name))
                            }
                            self.tableView.reloadData()

                        })
                    }

                
                }
            }}
        dataTask.resume()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return ranking.count
    }
    
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let Cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath) as! FriendTableViewCell
        
        //Sort ranking
        let sortedRank = ranking.sort({ ($0.0 > $1.0) })
        var strArr = String(sortedRank[indexPath.row])
        strArr = strArr.stringByReplacingOccurrencesOfString("(", withString: "", options: NSStringCompareOptions.LiteralSearch, range: nil)
        strArr = strArr.stringByReplacingOccurrencesOfString("\"", withString: "", options: NSStringCompareOptions.LiteralSearch, range: nil)
        strArr = strArr.stringByReplacingOccurrencesOfString(")", withString: "", options: NSStringCompareOptions.LiteralSearch, range: nil)
        //print(strArr)
        let split = strArr.componentsSeparatedByString(", ")
        
        //Set up values
        let facebookProfileUrl = "http://graph.facebook.com/\(split[1])/picture?type=large"
        let friendImage = UIImage(data: NSData(contentsOfURL: NSURL(string: facebookProfileUrl)!)!)!
        let name = split[2]
        
        let cellImageLayer: CALayer?  = Cell.frdPic.layer
        cellImageLayer!.cornerRadius = Cell.frdPic.frame.size.width / 2
        cellImageLayer!.masksToBounds = true
        
        Cell.frdPic.image = friendImage
        Cell.frdPic.contentMode = .ScaleAspectFill
        Cell.frdName.text = name
        
        let distance = Double(split[0])!
        if(distance < 1000){
            let dtn = round(distance)
            Cell.distanceCovered.text = String(format: "%g m", dtn)
        }else{
            var dtn = distance/1000
            dtn = round(dtn*100)/100
            Cell.distanceCovered.text = String("\(dtn) km")
        }
        
        let position = indexPath.row + 1
        Cell.rankPosition.text = "\(position)"
        
        switch position {
        case 1:
            Cell.rankPosition.backgroundColor = redTone
        case 2:
            Cell.rankPosition.backgroundColor = yellowTone
        case 3:
            Cell.rankPosition.backgroundColor = blueTone
        default:
            Cell.rankPosition.backgroundColor = UIColor.lightGrayColor()
            
        }
        
        let isEqual = (split[1] == String(userID))
        if isEqual == true{
            selfPositionLabel.text = "\(position)"
            
            let content : FBSDKShareLinkContent = FBSDKShareLinkContent()
            content.contentURL = NSURL(string: "https://www.facebook.com")
            content.contentTitle = "Come Bike Together!"
            
            content.contentDescription = "I am ranked \(position) among my group! Come bike together!"
            
            content.imageURL = NSURL(string: "https://scontent.fbkk5-1.fna.fbcdn.net/v/t1.0-9/13512240_1216978311655432_38099313990545828_n.jpg?oh=434d641f4d72a3f9c753960ac95c9964&oe=5805442B")
            
            let button : FBSDKShareButton = FBSDKShareButton()
            button.shareContent = content
            button.frame =  CGRectMake(self.infoView.bounds.origin.x, self.infoView.bounds.origin.y, self.infoView.frame.size.width, self.infoView.frame.size.height)
            self.infoView.layer.cornerRadius = 10
            self.infoView.addSubview(button)

        }
        
        return Cell
        
    }

}
