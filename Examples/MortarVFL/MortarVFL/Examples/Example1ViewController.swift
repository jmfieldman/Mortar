//
//  Example1ViewController.swift
//  MortarVFL
//
//  Created by Jason Fieldman on 4/8/17.
//  Copyright © 2017 Jason Fieldman. All rights reserved.
//

import Foundation
import UIKit

class Example1ViewController: UIViewController {
    
    let v1 = UIView.m_create {
        $0.backgroundColor = .red
    }
    
    let v2 = UIView.m_create {
        $0.backgroundColor = .blue
    }
    
    let v3 = UIView.m_create {
        $0.backgroundColor = .green
    }
    
    override func viewDidLoad() {
        
        self.view.backgroundColor = .white
        self.view |^| [v1, v2, v3]
        
        [v1, v2, v3].m_size     |=| (80, 80)
        [v1, v2, v3].m_centerX  |=| self.view
        
        v1.m_bottom             |=| v2.m_top - 20
        v2.m_centerY            |=| self.view
        v3.m_top                |=| v2.m_bottom + 20
    }
    
}
