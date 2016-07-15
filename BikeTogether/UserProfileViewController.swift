//
//  UserProfileViewController.swift
//  BikeTogether
//
//  Created by Supassara Sujjapong on 20/5/16.
//  Copyright © 2016 Supassara Sujjapong. All rights reserved.
//

import UIKit
import Charts

class UserProfileViewController: UIViewController, ChartViewDelegate {

    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var totDistanceLabel: UILabel!
    @IBOutlet weak var recordsTot: UILabel!
    @IBOutlet weak var zoneLabel: UILabel!
    @IBOutlet weak var chartView: LineChartView!
    
    var disArr: Array<Double> = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.chartView.delegate = self
        self.chartView.descriptionTextColor = UIColor.whiteColor()
        self.chartView.gridBackgroundColor = UIColor.darkGrayColor()
        self.chartView.noDataText = "No routes recorded"

        userNameLabel.text = "\(strFirstName) \(strLastName)"
        
        self.profileImageView.image = profilePicture
        self.profileImageView.contentMode = .ScaleAspectFill
        self.profileImageView.layer.cornerRadius = profileImageView.frame.size.width / 2;
        self.profileImageView.clipsToBounds = true

    }

    override func viewDidAppear(animated: Bool) {
        //func totalDistance(uid: Int64, handler: (totalDistance: Double) -> () ){
        disArr = []
        
        self.zoneLabel.text = "\(userZone)"
        
        let session = NSURLSession.sharedSession()
        let request = NSMutableURLRequest(URL: NSURL(string: "http://ridebike.atilal.com/statistic.php/")!)
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
                
                let json = JSON(data: data!)
                if json.count > 0{
                    dispatch_async(dispatch_get_main_queue(), {
                    
                        let recordCount = json["count"].string!
                        print(recordCount)
                        self.recordsTot.text = recordCount
                        
                        let disCount = json["distance"].count
                        for i in 0...disCount-1{
                            let distance = Double(json["distance"][i].string!)!
                            self.disArr.append(distance)
                        }
                        print(self.disArr)
                        self.setChartData(disCount, datas: self.disArr)
                    })
                }
            }
        }
        dataTask.resume()

        
        totalDistance(userID, handler: {
            (distance) -> Void in
            dispatch_async(dispatch_get_main_queue(), {

            if(distance < 1000){
                let dtn = round(distance)
                self.totDistanceLabel.text = String(format: "%g m", dtn)
            }else{
                var dtn = distance/1000
                dtn = round(dtn*100)/100
                self.totDistanceLabel.text = String("\(dtn) km")
            }

        })
        })
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    func setChartData(count : Int, datas: [Double] ){
        // 1 - creating an array of data entries
        var xaxis: Array<String> = []
        
        var yVals1 : [ChartDataEntry] = [ChartDataEntry]()
        for i in 0...count-1 {
            yVals1.append(ChartDataEntry(value: datas[i], xIndex: i))
            xaxis.append("")
        }
        
        // 2 - create a data set with our array
        let set1: LineChartDataSet = LineChartDataSet(yVals: yVals1, label: "User record")
        set1.axisDependency = .Left // Line will correlate with left axis values
        set1.setColor(UIColor.redColor().colorWithAlphaComponent(0.5)) // our line's opacity is 50%
        set1.setCircleColor(UIColor.redColor()) // our circle will be dark red
        set1.lineWidth = 2.0
        set1.circleRadius = 6.0 // the radius of the node circle
        set1.fillAlpha = 65 / 255.0
        set1.fillColor = UIColor.redColor()
        set1.highlightColor = UIColor.whiteColor()
        set1.drawCircleHoleEnabled = true
        
        //barChartView.animate(xAxisDuration: 2.0, yAxisDuration: 2.0)
        
        //3 - create an array to store our LineChartDataSets
        var dataSets : [LineChartDataSet] = [LineChartDataSet]()
        dataSets.append(set1)
        
        //4 - pass our months in for our x-axis label value along with our dataSets
        let data: LineChartData = LineChartData(xVals: xaxis, dataSets: dataSets)
        data.setValueTextColor(UIColor.whiteColor())
        
        
        //5 - finally set our data
        self.chartView.data = data
        chartView.animate(xAxisDuration: 2.0)

    }

    

}
