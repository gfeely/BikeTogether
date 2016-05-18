//
//  Navigations.swift
//  BikeTogether
//
//  Created by Supassara Sujjapong on 10/12/15.
//  Copyright © 2015 Supassara Sujjapong. All rights reserved.
//
// This file is a collection of frequent use functions for alerts

import Foundation
import UIKit

func backToMainMenuOnYes(sender: AnyObject){
    
    ////////////////////////////////////////////////////////////////////////////////
    //This function is used for prompting an alert message to ask if the user wants to go back to main menu
    // Yes or No to go back to Main Menu
    ////////////////////////////////////////////////////////////////////////////////

    let alert = UIAlertController(title: "Exit to Main Menu", message: "Are you sure you want to leave?", preferredStyle: UIAlertControllerStyle.Alert)
    
    //Press Yes - user will be redirected to Main Menu
    alert.addAction(UIAlertAction(title: "Yes", style: .Default, handler: {
        (action: UIAlertAction!) in
        sender.performSegueWithIdentifier("unwindToMain", sender: sender)
    }))
    
    //Press No - nothing happens
    alert.addAction(UIAlertAction(title: "No", style: UIAlertActionStyle.Default, handler: nil))
    
    sender.presentViewController(alert, animated: true, completion: nil)
}

func dismissViewMethod (sender: AnyObject, title: String, message: String, OnYes: Bool){
    
    ////////////////////////////////////////////////////////////////////////////////
    // This alert dismisses the current view controller
    // Can choose to have YES/NO or just OK to pop to root view controller
    ////////////////////////////////////////////////////////////////////////////////

    if(message == "none"){
        //If message == none, means no input message -> nil
        let alert = UIAlertController(title: title, message: nil, preferredStyle: UIAlertControllerStyle.Alert)
        if(OnYes == true){
            //Dismiss on pressing yes (two options yes or no)
            alert.addAction(UIAlertAction(title: "Yes", style: .Default, handler: {
                (action: UIAlertAction!) in
                sender.navigationController!!.popToRootViewControllerAnimated(true)
            }))
            alert.addAction(UIAlertAction(title: "No", style: UIAlertActionStyle.Default, handler: nil))
        }else{
            //Dismiss (one option)
            alert.addAction(UIAlertAction(title: "Ok", style: .Default, handler: {
                (action: UIAlertAction!) in
                sender.navigationController!!.popToRootViewControllerAnimated(true)
            }))
        }
        sender.presentViewController(alert, animated: true, completion: nil)
    }else{
        //There is input message
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.Alert)
        if(OnYes == true){
            //Dismiss on pressing yes (two options yes or no)
            alert.addAction(UIAlertAction(title: "Yes", style: .Default, handler: {
                (action: UIAlertAction!) in
                sender.navigationController!!.popToRootViewControllerAnimated(true)
            }))
            alert.addAction(UIAlertAction(title: "No", style: UIAlertActionStyle.Default, handler: nil))
        }else{
            //Dismiss (one option)
            alert.addAction(UIAlertAction(title: "Ok", style: .Default, handler: {
                (action: UIAlertAction!) in
                sender.navigationController!!.popToRootViewControllerAnimated(true)
            }))
        }
        sender.presentViewController(alert, animated: true, completion: nil)
    }
}

func normalAlert(sender: AnyObject, title: String, message: String){
    
    ////////////////////////////////////////////////////////////////////////////////
    // This function is used for prompting an alert with or without a message
    // With or without a message , "OK" to dismiss
    ////////////////////////////////////////////////////////////////////////////////

    if(message == "none"){
        // No input message -> nil
        let alert = UIAlertController(title: title, message: nil, preferredStyle: UIAlertControllerStyle.Alert)
        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default, handler: nil))
        sender.presentViewController(alert, animated: true, completion: nil)
    }else{
        //With input message
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.Alert)
        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default, handler: nil))
        sender.presentViewController(alert, animated: true, completion: nil)
    }
}