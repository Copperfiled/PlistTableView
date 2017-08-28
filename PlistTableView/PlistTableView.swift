//
//  PlistTableView.swift
//  PlistTableView
//
//  Created by guanxiaobai on 22/08/2017.
//  Copyright © 2017 guanxiaobai. All rights reserved.
//

import UIKit

public protocol PlistTableViewDataSource: NSObjectProtocol {
    /// 提供plist文件名
    var plistName: String { get }
    
    func tableView(_ tableView: UITableView, cell: UITableViewCell, forRowAt indexPath: IndexPath) -> Void
}
public protocol PlistTableViewDelegate: UITableViewDelegate {
    
}
extension UITableViewCellStyle {
    var cellIdf: String {
        switch self {
        case .default:
            return "defaultIdf"
        case .value1:
            return "value1Idf"
        case .value2:
            return "value2Idf"
        case .subtitle:
            return "subtitleIdf"
        }
    }
}
/// 由plist驱动的tableView
open class PlistTableView: UIView, UITableViewDataSource, UITableViewDelegate {
    enum CellIdentifier: String {
        case `default` = "defaultIDF"
    }
    
    fileprivate let tableView: UITableView!
    fileprivate var cellStyle: UITableViewCellStyle
    weak open var dataSource: PlistTableViewDataSource? = nil
    weak open var delegate: PlistTableViewDelegate? = nil
    
    // MARK: - 初始化方法
    public override convenience init(frame: CGRect) {
        self.init(frame: frame, style: .plain, cellStyle: .default)
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    public init(frame: CGRect, style: UITableViewStyle, cellStyle: UITableViewCellStyle) {
        self.tableView = UITableView(frame: frame, style: style)
        self.cellStyle = cellStyle
        super.init(frame: frame)
        
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.addSubview(self.tableView)
    }
    
    // MARK: - 数据相关
    open func model(at indexPath: IndexPath) -> [String : Any] {
        if let p = self.plist as? [[String : Any]] {
            return p[indexPath.row]
        }
        if let p = self.plist as? [[[String : Any]]] {
            return p[indexPath.section][indexPath.row]
        }
        return ["" : ""]
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
    // MARK: - UITableViewDataSource
    public func numberOfSections(in tableView: UITableView) -> Int {
        return self.numberOfSections
    }
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.numberOfRows(in: section)
    }
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: self.cellStyle.cellIdf)
        if cell == nil {
            cell = UITableViewCell(style: self.cellStyle, reuseIdentifier: self.cellStyle.cellIdf)
        }
        self.dataSource?.tableView(tableView, cell: cell!, forRowAt: indexPath)
        return cell!
    }
    
    // MARK: - UITableViewDelegate
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let del = self.delegate {
            del.tableView!(tableView, didSelectRowAt: indexPath)
        }
    }
}


// MARK: - private methods
extension PlistTableView {
    fileprivate var plist: Any? {
        PlistManager.share.register(tableView: self)
        return PlistManager.share.plist(for: self)
    }
    /// 这里暂时只考虑最多两层的结构
    fileprivate var numberOfSections: Int {
        if let p = self.plist as? [[[String: Any]]] {
            return p.count
        }
        return 1
    }
    fileprivate func numberOfRows(in section: Int) -> Int {
        if let p = self.plist as? [[String : Any]] {
            return p.count
        }
        if let p = self.plist as? [[[String: Any]]] {
            return p[section].count
        }
        return 1
    }
    var plistName: String? {
        if let del = self.dataSource {
            return del.plistName
        }
        return nil
    }
}
