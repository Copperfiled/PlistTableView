//
//  MGAddTableViewCell.swift
//  MogoPartner
//
//  Created by guanxiaobai on 18/09/2017.
//  Copyright © 2017 mogoroom. All rights reserved.
//

import UIKit

@objc protocol MGAddTableViewCellDelegate: NSObjectProtocol {
    @objc optional func tableViewCell(cell: MGAddTableViewCell, add sender: UIButton)
}

class MGAddTableViewCell: UITableViewCell {

    weak var delegate: MGAddTableViewCellDelegate?
    @IBOutlet var titleLabel: UILabel!
    
    override func awakeFromNib()
    {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBAction func addAction(_ sender: UIButton) {
        if let dele = self.delegate, dele.responds(to: #selector(MGAddTableViewCellDelegate.tableViewCell(cell:add:))) {
            dele.tableViewCell!(cell: self, add: sender)
        }
    }
}
