//
//  MGAddRowTableViewCell.swift
//  MogoPartner
//
//  Created by guanxiaobai on 15/09/2017.
//  Copyright © 2017 mogoroom. All rights reserved.
//

import UIKit

let AddRowCell = "add"

@objc protocol MGAddRowTableViewCellDelegate: NSObjectProtocol {
    @objc optional func tableViewCell(cell: MGAddRowTableViewCell, didSelect sender: UIButton)
}
/// 添加行
class MGAddRowTableViewCell: UITableViewCell {

    weak var delegate: MGAddRowTableViewCellDelegate?
    
    @IBOutlet var titleLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    @IBAction func addAction(_ sender: UIButton) {
        if let dele = self.delegate, dele.responds(to: #selector(MGAddRowTableViewCellDelegate.tableViewCell(cell:didSelect:))) {
            dele.tableViewCell!(cell: self, didSelect: sender)
        }
    }
    
}
