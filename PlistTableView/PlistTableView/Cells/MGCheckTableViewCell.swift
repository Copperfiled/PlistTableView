//
//  MGCheckTableViewCell.swift
//  MogoPartner
//
//  Created by guanxiaobai on 04/09/2017.
//  Copyright © 2017 mogoroom. All rights reserved.
//

import UIKit

let MGCheckTableViewCellIdf = "check"

@objc protocol MGCheckTableViewCellDelegate: NSObjectProtocol {
    @objc optional func checkTableViewCell(_ cell: MGCheckTableViewCell, isSelected: Bool) -> Void
}
class MGCheckTableViewCell: UITableViewCell {

    @IBOutlet var checkButton: UIButton!
    weak var delegate: MGCheckTableViewCellDelegate? = nil
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    @IBAction func actionHandler(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
        if let del = self.delegate, del.responds(to: #selector(MGCheckTableViewCellDelegate.checkTableViewCell(_:isSelected:))) {
            del.checkTableViewCell!(self, isSelected: sender.isSelected)
        }
    }
    
}
