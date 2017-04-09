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
    
    let red = UIView.m_create {
        $0.backgroundColor = .red
    }
    
    let blue = UIView.m_create {
        $0.backgroundColor = .blue
    }
    
    let green = UIView.m_create {
        $0.backgroundColor = .green
    }
    
    let orange = UIView.m_create {
        $0.backgroundColor = .orange
    }
    
    let yellow = UIView.m_create {
        $0.backgroundColor = .yellow
    }
    
    let darkGray = UIView.m_create {
        $0.backgroundColor = .darkGray
    }
    
    let lightGray = UIView.m_create {
        $0.backgroundColor = .lightGray
    }
    
    let magenta = UIView.m_create {
        $0.backgroundColor = .magenta
    }
    
    override func viewDidLoad() {
        
        self.view.backgroundColor = .white
        self.view |+| [
            red,
            blue,
            green,
            orange,
            yellow,
            darkGray,
            lightGray,
            magenta
        ]
        
        self.view ||>> red || blue[~~40] || green[%%2]
        self.view ||>> [orange, yellow]
        
        self.m_visibleRegion ||^^ [red, blue, green] || orange[~~44] || yellow[~~44]
        
        // Insert gray in green
        
        green |>> %%1 | [darkGray, lightGray][~~44] | %%1
        green |^^ %%1 | darkGray[~~44] | %%1 | lightGray[~~44] | %%1
        
        // Insert magenta between grays
        
        darkGray.m_bottom |^ %%1 | magenta[~~22] | %%1 ^| lightGray.m_top
        darkGray |>> %%1 | magenta[~~22] | %%1
    }
    
}
