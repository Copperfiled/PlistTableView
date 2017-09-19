//
//  ViewController.swift
//  PlistTableView
//
//  Created by guanxiaobai on 22/08/2017.
//  Copyright © 2017 guanxiaobai. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    let plistView = PlistTableView(frame: UIScreen.main.bounds, style: .grouped, cellStyle: [.value1, .switch, .input, .add])
    
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
        return "roomDetail_info_distribute"
    }
    func tableView(_ tableView: PlistTableView, config cell: UITableViewCell, parentKeyString: String?, keyString: String?, at indexPath: IndexPath) -> Void {
        
    }
}

