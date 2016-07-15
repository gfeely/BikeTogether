//
//  globalVariables.swift
//  BikeTogether
//
//  Created by Supassara Sujjapong on 27/5/16.
//  Copyright © 2016 Supassara Sujjapong. All rights reserved.
//

import Foundation
import CoreLocation

var strFirstName: String = ""
var strLastName: String = ""
var strPictureURL: String = ""
var profilePicture: UIImage = UIImage(named: "test.jpg")!
var userID: Int64 = 0
var groups: String = ""
var friendData = NSArray()
var currentLoc:CLLocation = CLLocation(latitude: 0, longitude: 0)
var userZone = "A"

extension UIColor {
    convenience init(r: Int, g:Int , b:Int , a: Int) {
        self.init(red: CGFloat(r)/255, green: CGFloat(g)/255, blue: CGFloat(b)/255, alpha: CGFloat(a)/255)
    }
}

let redTone = UIColor(r: 231, g: 76, b: 60, a: 255)
let blueTone = UIColor(r: 96, g: 180, b: 241, a: 255)
let yellowTone = UIColor(r: 245, g: 207, b: 67, a: 255)

extension UIView {
    
    func pb_takeSnapshot() -> UIImage {
        UIGraphicsBeginImageContextWithOptions(bounds.size, false, UIScreen.mainScreen().scale)
        
        drawViewHierarchyInRect(self.bounds, afterScreenUpdates: true)
        
        // old style: layer.renderInContext(UIGraphicsGetCurrentContext())
        
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image
    }
}