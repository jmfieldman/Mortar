//
//  ViewController.swift
//  MortarVFL
//
//  Created by Jason Fieldman on 4/8/17.
//  Copyright © 2017 Jason Fieldman. All rights reserved.
//

import UIKit

class ListController: UITableViewController {

    var examples: [UIViewController.Type] = [
        Example1ViewController.self,
        VFL_Example1ViewController.self,
        VFL_Example2ViewController.self,
        VFL_Example3ViewController.self,
        VFL_Example4ViewController.self,
        VFL_Example5ViewController.self,
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Mortar Examples"
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "Back", style: .plain, target: nil, action: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return examples.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell") ?? UITableViewCell(style: .default, reuseIdentifier: "cell")
        cell.textLabel?.text = "\(examples[indexPath.row])"
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let vc = examples[indexPath.row].init(nibName: nil, bundle: nil)
        self.navigationController?.pushViewController(vc, animated: true)
    }
}


