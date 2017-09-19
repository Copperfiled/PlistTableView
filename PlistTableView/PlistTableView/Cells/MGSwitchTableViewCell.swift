//
//  MGSwitchTableViewCell.swift
//  MogoPartner
//
//  Created by guanxiaobai on 02/09/2017.
//  Copyright © 2017 mogoroom. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift

let MGSwitchTabelViewCell = "MGSwitchTabelViewCell"

@objc
protocol MGSwitchTabelViewCellDelegate: NSObjectProtocol {
    @objc optional func switchCell(_ switchCell: MGSwitchTableViewCell, isOn: Bool) -> Void
}
//右侧带有switch的Cell
class MGSwitchTableViewCell: UITableViewCell {

    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var aSwitch: UISwitch!
    @IBOutlet fileprivate  var subtitleLabel: UILabel!
    @IBOutlet fileprivate var detailLabel: UILabel!
    let disposeBag = DisposeBag()
    
    weak var delegate: MGSwitchTabelViewCellDelegate?
    
    var subTitle: String? {
        didSet {
            self.subtitleLabel.attributedText = self.attributeStr(with: subTitle)
        }
    }
    var detailTitle: String? {
        didSet {
            self.detailLabel.attributedText = self.attributeStr(with: detailTitle)
        }
    }
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    @IBAction func actionHandler(_ sender: UISwitch) {
        
        if let del = self.delegate, del.responds(to: #selector(MGSwitchTabelViewCellDelegate.switchCell(_:isOn:))) {
            del.switchCell!(self, isOn: sender.isOn)
        }
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}
extension MGSwitchTableViewCell {
    fileprivate func attributeStr(with string: String?) -> NSMutableAttributedString? {
        var attributeStr: NSMutableAttributedString?
        if let str = string {
            let range = NSRange(location: 0, length: str.characters.count)
            attributeStr = NSMutableAttributedString(string: str)
            attributeStr?.addAttribute(NSFontAttributeName, value: UIFont.systemFont(ofSize: 12), range: range)
            attributeStr?.addAttribute(NSForegroundColorAttributeName, value: UIColor.mgWarmGrey, range: range)
            
            let paragraph = NSMutableParagraphStyle()
            paragraph.lineSpacing = 10
            paragraph.lineHeightMultiple = 2
            attributeStr?.addAttribute(NSParagraphStyleAttributeName, value: paragraph, range: range)
        }
        return attributeStr
    }
}
