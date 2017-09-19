//
//  MGInputTableViewCell.swift
//  MogoPartner
//
//  Created by guanxiaobai on 07/09/2017.
//  Copyright © 2017 mogoroom. All rights reserved.
//

import UIKit

let MGInputTableViewCellIdf = "MGInputTableViewCell"
/// 右边有输入框的cell
class MGInputTableViewCell: UITableViewCell {
    
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var inputTextField: UITextField!
    let aTextField = UITextField(frame: CGRect())
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    override func prepareForReuse() {
        super.prepareForReuse()
    }
}
