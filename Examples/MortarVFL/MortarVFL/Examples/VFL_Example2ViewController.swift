//
//  VFL_Example2ViewController.swift
//  MortarVFL
//
//  Created by Jason Fieldman on 4/8/17.
//  Copyright © 2017 Jason Fieldman. All rights reserved.
//

import Foundation
import UIKit

class VFL_Example2ViewController: UIViewController {
    
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
        
        self.view |>> 40 | v1 | 40
        self.view |>> %%1 | v2[~~40] | %%2
        self.view ||>> v3
        
        self.m_visibleRegion |^^ v1 | v2 | v3
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            print("\(self.v1.frame)")
            print("\(self.v2.frame)")
            print("\(self.v3.frame)")
        }
    }
    
}
