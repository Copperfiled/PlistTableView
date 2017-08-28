//
//  CellModel.swift
//  PlistTableView
//
//  Created by guanxiaobai on 23/08/2017.
//  Copyright © 2017 guanxiaobai. All rights reserved.
//

import Foundation
import UIKit

class CellModel: CellModelProtocol {
    private var rawValue: [String : Any]!
    
    /// the height of the row, and 0 represent automatic
    var rowHeight: CGFloat = 0
    
    /// the idf of cell
    var identifier:String? = ""
    
    /// the title of left
    var title: String = ""
    
    /// accessory type
    var accessoryType: UITableViewCellAccessoryType = .none
    
    var key: String = ""
    var value: String = ""
    
    required init(with json: [String : Any]) {
        self.rawValue = json
    }
}
