//
//  SectionModel.swift
//  PlistTableView
//
//  Created by guanxiaobai on 23/08/2017.
//  Copyright © 2017 guanxiaobai. All rights reserved.
//

import Foundation
import UIKit

class SectionModel: SectionModelProtocol {
    private var rawValue: [String : Any]!
    
    /// the height of header
    var headerheight: CGFloat = 10
    
    /// the height of footer
    var footerheight: CGFloat = 0
    
    /// headerTitle
    var headerTitle: String? = ""
    
    /// footerTitle
    var footerTitle: String? = ""
    
    /// the index of section
    var sectionIndex: Int = 0
    
    var color: String = "#FFFFFF"
    
    var cellModels: [CellModelProtocol] = [CellModel]()
    
    required init(with json: [String : Any]) {
        self.rawValue = json
    }
}
