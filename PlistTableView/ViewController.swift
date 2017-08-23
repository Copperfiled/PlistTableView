//
//  ViewController.swift
//  PlistTableView
//
//  Created by guanxiaobai on 22/08/2017.
//  Copyright © 2017 guanxiaobai. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    let plistView = PlistTableView(frame: UIScreen.main.bounds, style: .plain)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
//        self.tableView.delegate = self
        self.plistView.dataSource = self
        self.plistView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
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
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        let model = self.plistView.model(at: indexPath)
        cell.textLabel?.text = model["key"] as! String
        cell.detailTextLabel?.text = model["value"] as! String
        return cell
    }
}

