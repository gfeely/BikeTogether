//
//  globalVariables.swift
//  BikeTogether
//
//  Created by Supassara Sujjapong on 27/5/16.
//  Copyright © 2016 Supassara Sujjapong. All rights reserved.
//

import Foundation

var strFirstName: String = ""
var strLastName: String = ""
var strPictureURL: String = ""
var profilePicture: UIImage = UIImage(named: "test.jpg")!
var userID: Int64 = 0
var groups: String = ""

var friendData = NSArray()


//Color
extension UIColor {
    convenience init(red: Int, green: Int, blue: Int) {
        let newRed = CGFloat(red)/255
        let newGreen = CGFloat(green)/255
        let newBlue = CGFloat(blue)/255
        
        self.init(red: newRed, green: newGreen, blue: newBlue, alpha: 1.0)
    }
}

let redTone = UIColor(red: 231, green: 76, blue: 60)