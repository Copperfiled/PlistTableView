//
//  ViewController.swift
//  PlistTableView
//
//  Created by guanxiaobai on 22/08/2017.
//  Copyright © 2017 guanxiaobai. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    let plistView = PlistTableView(frame: UIScreen.main.bounds, style: .plain, cellStyle: .default)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
//        self.tableView.delegate = self
        self.plistView.dataSource = self
        self.view.addSubview(plistView)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
extension ViewController: PlistTableViewDelegate {
    
}
extension ViewController: PlistTableViewDataSource {
    var plistName: String {
        return "test"
    }
    func tableView(_ tableView: UITableView, cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let model = self.plistView.model(at: indexPath)
        cell.textLabel?.text = model["key"] as? String
        cell.detailTextLabel?.text = model["value"] as? String
    }
}

