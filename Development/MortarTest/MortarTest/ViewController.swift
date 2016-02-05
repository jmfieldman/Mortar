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
        
        let s = UIView(frame: CGRectMake(100, 100, 50, 50))
        s.backgroundColor = UIColor(red: 0, green: 1, blue: 0, alpha: 0.5)
        
        let r = UIView(frame: CGRectMake(100, 100, 50, 50))
        r.backgroundColor = UIColor(red: 0, green: 0, blue: 1, alpha: 0.5)
        
        self.view |+| [
            t,
            s |+| [
                r
            ]
        ]
        
        //s.m_size |=| t.m_size
        //s.m_left |=| 200
        //s.m_top     |=| 200 ! .Low
        //s.m_left    |=| 200 ! .Low
        //[s.m_size ! .Low, s.m_size]   |=| (60, 60) ! .Low

        //s.m_left |=| [s].m_right ! .Low
        
        //s.m_size |=| (100, 100)
        //s.m_frame |>| (160, 100, t, 50)
        //s.m_frame |<| (180, 120, 100, 100)
        
        //[s, t].m_width
        
        //s.m_frame |=| (200, 200, 50, 50)
        
        [s.m_bottom, s.m_sides] |=| self.view
        s.m_height              |=| 50
        
        //r.m_cornerBL |=| s.m_cornerTL
        //r.m_size     |=| (self.view, s)
        
        [r.m_frame]     |=| (100, 200, 30, 30)
        
        
        [r, s].m_frame |=| [ (1,1,1,1), (2,2,2,2) ]
        r.m_frame |=| s.m_frame - (1,1,1,1)
            attr - (fourple) -> fourple
        
        //r.m_size |=| s.m_size + (4, 5)
        //r.m_size |=| s.m_size * 2
        
        //r.m_frame |=| (4, 4)
        
        //[r.m_cornerBL, r.m_size] |=| [s.m_cornerTL,
        
        
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
