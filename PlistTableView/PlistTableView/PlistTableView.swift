//
//  PlistTableView.swift
//  PlistTableView
//
//  Created by guanxiaobai on 22/08/2017.
//  Copyright © 2017 guanxiaobai. All rights reserved.
//

import UIKit
import SnapKit
import DeeplinkNavigator

@objc public protocol PlistTableViewDataSource: NSObjectProtocol {
    /// 提供plist文件名
    var plistName: String { get }
    
    func tableView(_ tableView: PlistTableView, config cell: UITableViewCell, parentKeyString: String?, keyString: String?, at indexPath: IndexPath) -> Void
    // 为了适应可以动态修改cell的个数，这里规定
    // 当返回小于0的数值是，使用plist中的个数
    @objc optional func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
}
@objc
public protocol PlistTableViewDelegate: UITableViewDelegate {
    @objc optional func contextForNavigation() -> NavigationContext
    @objc optional func tableView(_ tableView: UITableView, didSelected indexPath: IndexPath, with keyString: String?) -> Void
}

public struct PlistTableViewCellStyle: OptionSet {
    public let rawValue: Int
    public init(rawValue: PlistTableViewCellStyle.RawValue) {
        self.rawValue = rawValue
    }
    public static var `default` = PlistTableViewCellStyle(rawValue: 1 << 0)
    public static var value1: PlistTableViewCellStyle = PlistTableViewCellStyle(rawValue: 1 << 1)
    public static var value2 = PlistTableViewCellStyle(rawValue: 1 << 2)
    public static var subtitle = PlistTableViewCellStyle(rawValue: 1 << 3)
    public static var `switch` = PlistTableViewCellStyle(rawValue: 1 << 4)
    public static var input = PlistTableViewCellStyle(rawValue: 1 << 5)
    public static var add = PlistTableViewCellStyle(rawValue: 1 << 6)
    public static var remark = PlistTableViewCellStyle(rawValue: 1 << 7)
    
    var cellIdf: String {
        switch self {
        case PlistTableViewCellStyle.default:
            return "defaultIdf"
        case PlistTableViewCellStyle.value1:
            return "value1Idf"
        case PlistTableViewCellStyle.value2:
            return "value2Idf"
        case PlistTableViewCellStyle.subtitle:
            return "subtitleIdf"
        case PlistTableViewCellStyle.switch:
            return "switch"
        case PlistTableViewCellStyle.input:
            return "input"
        case PlistTableViewCellStyle.add:
            return "add"
        case PlistTableViewCellStyle.remark:
            return "remark"
        default:
            return ""
        }
    }
    
}
/// 由plist驱动的tableView
open class PlistTableView: UIView {
    
    fileprivate let tableView: UITableView!
    fileprivate var cellStyle: PlistTableViewCellStyle
    weak open var dataSource: PlistTableViewDataSource? = nil
    weak open var delegate: PlistTableViewDelegate? = nil
    
    // MARK: - 初始化方法
    public override convenience init(frame: CGRect) {
        self.init(frame: frame, style: .plain, cellStyle: .default)
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    public init(frame: CGRect, style: UITableViewStyle, cellStyle: PlistTableViewCellStyle) {
        self.tableView = UITableView(frame: frame, style: style)
        self.cellStyle = cellStyle
        super.init(frame: frame)
        
        self.tableView.delegate = self
        self.tableView.dataSource = self
        
        self.registerCells()
        
        self.addSubview(self.tableView)
        self.backgroundColor = UIColor.white
        self.tableView.snp.makeConstraints { (make) in
            make.edges.equalTo(self)
        }
    }
    
    // MARK: - 数据相关
    open func cellModel(at indexPath: IndexPath) -> [String : Any]? {
        guard let p = self.plist as? [[String : Any]] else { return nil }
        guard let cellModels = p[indexPath.section]["cellModels"] as? [[String : Any]] else { return nil }
        return cellModels[indexPath.row]
    }
    open func reloadData() {
        self.tableView.reloadData()
    }
    // MARK: - Header Footer
    open var tableHeaderView: UIView? {
        didSet {
            self.tableView.tableHeaderView = self.tableHeaderView
        }
    }
    open var tableFooterView: UIView? {
        didSet {
            self.tableView.tableFooterView = self.tableFooterView
        }
    }
}
// MARK: - UITableViewDelegate
extension PlistTableView: UITableViewDelegate {
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let cell = tableView.cellForRow(at: indexPath) {
            if cell.accessoryType != .disclosureIndicator {
                return
            }
        }
        if let model = self.cellModel(at: indexPath) {
            if let naviStr = model["navigationStr"] as? String {
                if naviStr.characters.count > 0 {
                    var context: NavigationContext?
                    if let del = self.delegate, del.responds(to: #selector(PlistTableViewDelegate.contextForNavigation)) {
                        context = del.contextForNavigation!()
                    }
                    Navigator.push(naviStr, context: context)
                }
            }
        }
        if let del = self.delegate, del.responds(to: #selector(PlistTableViewDelegate.tableView(_:didSelected:with:))) {
            var key: String? = nil
            if let model = self.cellModel(at: indexPath) {
                key = model["keyString"] as? String
            }
            del.tableView!(tableView, didSelected: indexPath, with: key)
        } else if let del = self.delegate, del.responds(to: #selector(PlistTableViewDelegate.tableView(_:didSelectRowAt:))) {
            del.tableView!(tableView, didSelectRowAt: indexPath)
        }
    }
    public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50.5
    }
}
// MARK: - UITableViewDataSource
extension PlistTableView: UITableViewDataSource {
    public func numberOfSections(in tableView: UITableView) -> Int {
        return self.numberOfSections
    }
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if let dataSource = self.dataSource, dataSource.responds(to: #selector(PlistTableView.tableView(_:numberOfRowsInSection:))) {
            let num = dataSource.tableView!(self.tableView, numberOfRowsInSection: section)
            if num > 0 {
                return num
            }
        }
        return self.numberOfRows(in: section)
    }
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var parentKeyString: String? = nil
        var keyString: String? = nil
        
        var cell: UITableViewCell? = nil
        if let model = self.cellModel(at: indexPath) {
            
            if let idf = model["identifier"] as? String {
                cell = tableView.dequeueReusableCell(withIdentifier: idf, for: indexPath)
            } else {
                cell = tableView.dequeueReusableCell(withIdentifier: "value1")
            }
            
            if cell == nil {
                cell = UITableViewCell(style: .value1, reuseIdentifier: "value1")
            }
            
            cell?.selectionStyle = .none
            cell?.textLabel?.text = model["title"] as? String
            cell?.textLabel?.textColor = UIColor(hexString: "#323232")
            cell?.textLabel?.font = UIFont.systemFont(ofSize: 15)
            cell?.detailTextLabel?.text = model["placeholder"] as? String
            cell?.detailTextLabel?.font = UIFont.systemFont(ofSize: 15)
            
            if let accessoryType = model["accessoryType"] as? Int {
                cell?.accessoryType = UITableViewCellAccessoryType(rawValue: accessoryType)!
            }
            
            if let aCell = cell as? MGInputTableViewCell  {
                aCell.textLabel?.text = nil
                aCell.titleLabel.text = model["title"] as? String
                aCell.inputTextField.placeholder = model["placeholder"] as? String
            }
            if let aCell = cell as? MGSwitchTableViewCell {
                aCell.textLabel?.text = nil
                aCell.titleLabel.text = model["title"] as? String
            }
            if let aCell = cell as? MGAddTableViewCell {
                aCell.textLabel?.text = nil
                aCell.titleLabel.text = model["title"] as? String
            }
            parentKeyString = model["parentKeyString"] as? String
            keyString = model["keyString"] as? String
            
            if let string = parentKeyString, string.characters.count <= 0 {
                parentKeyString = nil
            }
            if let string = keyString, string.characters.count <= 0 {
                keyString = nil
            }
        }
        self.dataSource?.tableView(self, config: cell!, parentKeyString: parentKeyString, keyString: keyString, at: indexPath)
        return cell!
    }
    public func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 5
    }
    public func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0
    }
}
// MARK: - private methods
extension PlistTableView {
    fileprivate var plist: Any? {
        PlistManager.share.register(tableView: self)
        return PlistManager.share.plistNode(for: self)?.rawValue
    }
    /// 这里暂时只考虑最多两层的结构
    fileprivate var numberOfSections: Int {
        guard let p = self.plist as? [[String: Any]] else {
            return 0
        }
        return p.count
    }
    fileprivate func numberOfRows(in section: Int) -> Int {
        guard let p = self.plist as? [[String : Any]] else { return 0 }
        guard let cells = p[section]["cellModels"] as? [[String : Any]] else { return 0 }
        return cells.count
    }
    var plistName: String? {
        if let del = self.dataSource {
            return del.plistName
        }
        return nil
    }
    fileprivate func registerCells() {
        if self.cellStyle.contains(.switch) {
            let nib = UINib(nibName: "MGSwitchTableViewCell", bundle: Bundle.main)
            self.tableView.register(nib, forCellReuseIdentifier: PlistTableViewCellStyle.switch.cellIdf)
        }
        if self.cellStyle.contains(.input) {
            let nib = UINib(nibName: "MGInputTableViewCell", bundle: Bundle.main)
            self.tableView.register(nib, forCellReuseIdentifier: PlistTableViewCellStyle.input.cellIdf)
        }
        if self.cellStyle.contains(.add) {
            let nib = UINib(nibName: "MGAddTableViewCell", bundle: Bundle.main)
            self.tableView.register(nib, forCellReuseIdentifier: PlistTableViewCellStyle.add.cellIdf)
        }
        if self.cellStyle.contains(.remark) {
            let nib = UINib(nibName: "MGRemarkTableViewCell", bundle: Bundle.main)
            self.tableView.register(nib, forCellReuseIdentifier: PlistTableViewCellStyle.remark.cellIdf)
        }
    }
}
