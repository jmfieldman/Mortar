//
//  VFL_Example1ViewController.swift
//  MortarVFL
//
//  Created by Jason Fieldman on 4/8/17.
//  Copyright © 2017 Jason Fieldman. All rights reserved.
//

import Foundation
import UIKit

class VFL_Example1ViewController: UIViewController {
    
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
        
        self.view |>> v1
        self.view |>> v2
        self.view |>> v3
        
        self.m_visibleRegion |^^ v1[~~1] | v2[~~1] | v3[~~1]

        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            print("\(self.v1.frame)")
            print("\(self.v2.frame)")
            print("\(self.v3.frame)")
        }
    }
    
}
