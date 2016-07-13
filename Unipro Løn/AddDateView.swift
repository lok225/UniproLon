//
//  AddDateView.swift
//  Løn
//
//  Created by Martin Lok on 14/07/2016.
//  Copyright © 2016 Martin Lok. All rights reserved.
//

import UIKit

import UIKit

class AddDateView: UIView {
    
    var navBar: UINavigationBar?
    var height: CGFloat = 88
    var width: CGFloat!
    
    override func drawRect(rect: CGRect) {
        
        // Nedenstående gør ingen forskel
        width = rect.width
        
        let boxRect = CGRect(x: 0, y: 0, width: width, height: height + 20)
        let box = UIBezierPath(rect: boxRect)
        UIColor(white: 0.3, alpha: 0.85).setFill()
        box.fill()
        
        let addButtonRect = CGRect(x: width - 8 - 50, y: boxRect.minY + 8 + 20, width: 50, height: height - 16)
        let addButton: UIButton = UIButton(frame: addButtonRect)
        addButton.setTitle("Tilføj", forState: UIControlState.Normal)
        addButton.setTitleColor(UIColor.whiteColor(), forState: .Normal)
        addButton.addTarget(addButton.parentViewController, action: #selector(GrasMainVC.addButtonPressed(_:)), forControlEvents: .TouchUpInside)
        self.addSubview(addButton)
        
        let datePickerRect = CGRect(x: 24, y: boxRect.minY + 8 + 20, width: width - 16 - 100, height: height - 16)
        let datePicker = UIDatePicker(frame: datePickerRect)
        
        // Ændre datePickerMode for at tvinge redraw
        datePicker.setValue(UIColor.whiteColor(), forKeyPath: "textColor")
        datePicker.datePickerMode = .CountDownTimer
        datePicker.datePickerMode = .Date
        
        self.addSubview(datePicker)
    }
    
    
    
    class func createAddView(inView view: UIView) -> AddDateView {
        let addView = AddDateView(frame: view.bounds)
        addView.opaque = false
        
        view.addSubview(addView)
        
        addView.backgroundColor = UIColor.clearColor()
        
        return addView
    }
    
}
