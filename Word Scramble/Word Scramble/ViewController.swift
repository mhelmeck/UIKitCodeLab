//
//  ViewController.swift
//  Word Scramble
//
//  Created by Maciej Helmecki on 30/06/2023.
//

import UIKit

class ViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        
        view.backgroundColor = .white
    }
}
