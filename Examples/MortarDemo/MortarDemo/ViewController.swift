//
//  ViewController.swift
//  Copyright © 2025 Jason Fieldman.
//

import Mortar

class ViewController: UIViewController {
    override func loadView() {
        view = UIView { parent in
            UIView { child1 in
                child1.backgroundColor = .blue
                child1.position.center == parent.position.center
                child1.size == CGSize(width: 100, height: 100)
            }
        }
        view.backgroundColor = .red
    }
}
