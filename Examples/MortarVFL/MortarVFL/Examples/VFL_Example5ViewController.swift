//
//  VFL_Example5ViewController.swift
//  MortarVFL
//
//  Created by Brian Kenny on 4/24/17.
//  Copyright © 2017 Jason Fieldman. All rights reserved.
//

import Foundation
import UIKit


//This simply a view that we can set to an arbitrary intrinsic content size.
//It could be replaced by a label with similar results
class MyView: UIView {

    var arbitrarySize: CGSize? { didSet { invalidateIntrinsicContentSize() } }

    override var intrinsicContentSize: CGSize { get { return arbitrarySize ?? super.intrinsicContentSize } }

}

//This VC shows a vertical layout and how intrinsic content size interacts with fixed and weighted elements when things don't fit
class VFL_Example5ViewController: UIViewController {

    var variant  = 0

    let label1 = UILabel.m_create {
        $0.textAlignment = .center
        $0.font = UIFont.boldSystemFont(ofSize: 20)
    }

    let label2 = UILabel.m_create {
        $0.numberOfLines = 0
    }

    let button1 = UIButton.m_create {
        $0.setTitle("Cick Me ", for: .normal)
        $0.setTitleColor(.black, for: .normal)
        $0.layer.cornerRadius = 5
        $0.layer.masksToBounds = true
    }

    let view1 = MyView.m_create {
        $0.backgroundColor = .red
        $0.m_compResistV = MortarAliasLayoutPriorityDefaultLow
    }

    let view2 = MyView.m_create {
        $0.backgroundColor = .green
    }

    override func viewDidLoad() {
        self.view.backgroundColor = .white

        let allViews = [label1, label2, button1, view1, view2]

        // Give everything a border so the label frames are clearly visible
        allViews.forEach {
            $0.layer.borderColor = UIColor.lightGray.cgColor
            $0.layer.borderWidth = 1
        }

        self.view |+| allViews

        // horizontal: pin all views between edges of m_visibleRegion with || padding(8pt) on both sides
        m_visibleRegion ||>> allViews


        // vertical: pin all the views in the given order with a variety of heights and spacers
        m_visibleRegion ||^^ view1 | ~~2 | label1 || label2 | ~~1 | button1[==44] | 20 |  view2[~~1]

        button1.addTarget(self, action: #selector(tap), for: .touchUpInside)
        tap()

    }

    func tap() {
        let height = variant*125 as Int

        label1.text = "Variant \(variant)"

        switch variant {
        case 0: label2.text = "The red view has an intrinsic content size of 0 by 0. Because its intrinsic height is 0 it will not be visible.  The top ~~2 , middle ~~1 and bottom view2[~~1] split proportionally whatever height is not used by the constant and intrinsic sized views. Click the button to change the intrinsic content size of the red view."

        case 1: label2.text = "Now we have set the red view's intrinsic content size to 0 by \(height). It will now be \(height) pt high, and the weighted views have shrunk to accomodate it. Note that it has a width because it's 0 intrinsic content width is lower prioirity than the 'm_visibleRegion ||>> allViews' constraint pinning its edges realative to its superview. No constraints have changed."

        default: label2.text = "The red view has an intrinsic content size of 0 by \(height). It will now be \(height) pt high or as close to that height as possible.  If you are running on an iPhone 5 then it won't fit. In that case all the weighted spacers will have zero height and the red view, because we set its compression resistance lower than the other intrinsic views, will be less than its desired height.  All the fixed height spaces/views will be intact as they are .required"
        }

        view1.arbitrarySize = CGSize(width: 0, height: height)

        variant =  variant>1 ? 0 :variant+1
    }

}
