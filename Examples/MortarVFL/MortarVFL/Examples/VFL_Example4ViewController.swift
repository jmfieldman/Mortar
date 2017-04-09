//
//  VFL_Example4ViewController.swift
//  MortarVFL
//
//  Created by Jason Fieldman on 4/9/17.
//  Copyright © 2017 Jason Fieldman. All rights reserved.
//

import Foundation
import UIKit

class VFL_Example4ViewController: UIViewController {
    
    let v1 = UIView.m_create {
        $0.backgroundColor = .red
    }
    
    let v2 = UIView.m_create {
        $0.backgroundColor = .red
    }
    
    let v3 = UIView.m_create {
        $0.backgroundColor = .red
    }
    
    let g1 = UIView.m_create {
        $0.backgroundColor = .green
    }
    
    let g2 = UIView.m_create {
        $0.backgroundColor = .green
    }
    
    let g3 = UIView.m_create {
        $0.backgroundColor = .green
    }
    
    override func viewDidLoad() {
        
        self.view.backgroundColor = .white
        self.view |+| [
            v1, v2, v3,
            g1, g2, g3,
        ]
        
        self.m_topLayoutGuideBottom ||^ v1[~~44] || v2[~~44] || v3[~~44]
        self.view ||> [v1, v2, v3][~~44]
        
        g1[~~44] || g2[~~44] || g3[~~44] ^!! self.m_bottomLayoutGuideTop
        [g1, g2, g3][~~44] <!! self.view
    }
    
}
