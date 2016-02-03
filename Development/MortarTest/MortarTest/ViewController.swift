//
//  ViewController.swift
//  MortarTest
//
//  Created by Jason Fieldman on 1/30/16.
//  Copyright © 2016 Jason Fieldman. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

	override func viewDidLoad() {
		super.viewDidLoad()
		// Do any additional setup after loading the view, typically from a nib.
        
        let t = UIView(frame: CGRectMake(100, 100, 50, 50))
        t.backgroundColor = UIColor.redColor()
        self.view.addSubview(t)
        
        let s = UIView(frame: CGRectMake(100, 100, 50, 50))
        s.backgroundColor = UIColor(red: 0, green: 1, blue: 0, alpha: 0.5)
        self.view.addSubview(s)
        
        //s.m_size |=| t.m_size
        //s.m_left |=| 200
        s.m_top     |=| 200 !! .Low
        s.m_left    |=| 200 !! .Low
        s.m_size    |=| (60, 60) !! .Low

        //s.m_size |=| (100, 100)
        //s.m_frame |>| (160, 100, t, 50)
        //s.m_frame |<| (180, 120, 100, 100)
        
        //[s, t].m_width
        
        //s.m_frame |=| (200, 200, 50, 50)
        
        
        /*
        let z = s.m_top |=| 40
        NSLayoutConstraint.deactivateConstraints(z.nsConstraints)
        self.view.updateConstraintsIfNeeded()
        z.nsConstraints.forEach {
            ($0.firstItem as! UIView).removeConstraint($0)
            ($0.secondItem as! UIView).removeConstraint($0)
            $0.active = false
            ($0.firstItem as! UIView).superview!.updateConstraints()
            $0.priority = UILayoutPriorityRequired;
            ($0.firstItem as! UIView).addConstraint($0)
            ($0.secondItem as! UIView).addConstraint($0)
        }
        */
	}

	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
		// Dispose of any resources that can be recreated.
	}


}
