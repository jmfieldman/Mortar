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
        //s.m_top  |=| 200

        //s.m_size |=| (100, 100)
        s.m_frame |=| (160, 100, 50, 50)
	}

	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
		// Dispose of any resources that can be recreated.
	}


}

