//
//  VFL_Example3ViewController.swift
//  MortarVFL
//
//  Created by Jason Fieldman on 4/8/17.
//  Copyright © 2017 Jason Fieldman. All rights reserved.
//

import Foundation
import UIKit

class VFL_Example3ViewController: UIViewController {
    
    let v1 = UIView.m_create {
        $0.backgroundColor = .red
    }
    
    let v2 = UIView.m_create {
        $0.backgroundColor = .blue
    }
    
    let v3 = UIView.m_create {
        $0.backgroundColor = .green
    }
    
    let v4 = UIView.m_create {
        $0.backgroundColor = .orange
    }
    
    let v5 = UIView.m_create {
        $0.backgroundColor = .yellow
    }
    
    let g1 = UIView.m_create {
        $0.backgroundColor = .darkGray
    }
    
    let g2 = UIView.m_create {
        $0.backgroundColor = .lightGray
    }
    
    let gg = UIView.m_create {
        $0.backgroundColor = .magenta
    }
    
    override func viewDidLoad() {
        
        self.view.backgroundColor = .white
        self.view |+| [v1, v2, v3, v4, v5, g1, g2, gg]
        
        self.view ||>> v1 || v2[==40] || v3[~~2]
        self.view ||>> v4
        self.view ||>> v5
        
        self.m_visibleRegion ||^^ [v1, v2, v3] || v4[==44] || v5[==44]
        
        // Insert gray in green
        
        v3 |>> ~~1 | [g1, g2][==44] | ~~1
        v3 |^^ ~~1 | g1[==44] | ~~1 | g2[==44] | ~~1
        
        // Insert magenta between grays
        
        g1.m_bottom |^ ~~1 | gg[==22] | ~~1 ^| g2.m_top
        g1 |>> ~~1 | gg[==22] | ~~1
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            print("\(self.v1.frame)")
            print("\(self.v2.frame)")
            print("\(self.v3.frame)")
            print("\(self.v4.frame)")
            print("\(self.v5.frame)")
            print("\(self.g1.frame)")
            print("\(self.g2.frame)")
        }
    }
    
}
