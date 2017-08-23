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
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
}
public protocol PlistTableViewDelegate: UITableViewDelegate {
    
}
/// 由plist驱动的tableView
/// 需完善的功能： 1. 提供默认cell
///             2. 最好能根据plist文件生成model对象，或者根据model生成Plist文件（后者好像有点违背初衷）
///             3. 提供更新plist文件的接口（这个功能不需要用户提供plist，因为需要保存在Document中）
///             4. 需要提供adjust功能
open class PlistTableView: UIView {
    
    fileprivate let tableView: UITableView!
    weak open var dataSource: PlistTableViewDataSource? = nil
    weak open var delegate: PlistTableViewDelegate? = nil
    
    // MARK: - 初始化方法
    public override convenience init(frame: CGRect) {
        self.init(frame: frame, style: .plain)
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    public init(frame: CGRect, style: UITableViewStyle) {
        self.tableView = UITableView(frame: frame, style: style)
        super.init(frame: frame)
        
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.addSubview(self.tableView)
    }
    
    @available(iOS 5.0, *)
    open func register(nib aNib: UINib?, forCellReuseIdentifier identifier: String) {
        self.tableView.register(aNib, forCellReuseIdentifier: identifier)
    }
    
    @available(iOS 6.0, *)
    open func register(_ cellClass: Swift.AnyClass?, forCellReuseIdentifier identifier: String) {
        self.tableView.register(cellClass, forCellReuseIdentifier: identifier)
    }
    
    @available(iOS 6.0, *)
    open func register(nib aNib: UINib?, forHeaderFooterViewReuseIdentifier identifier: String) {
        self.tableView.register(aNib, forHeaderFooterViewReuseIdentifier: identifier)
    }
    
    @available(iOS 6.0, *)
    open func register(_ aClass: Swift.AnyClass?, forHeaderFooterViewReuseIdentifier identifier: String) {
        self.tableView.register(aClass, forHeaderFooterViewReuseIdentifier: identifier)
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
}

// MARK: - UITableViewDelegate
extension PlistTableView: UITableViewDelegate {
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let del = self.delegate {
            del.tableView!(tableView, didSelectRowAt: indexPath)
        }
    }
}

// MARK: - UITableViewDataSource
extension PlistTableView: UITableViewDataSource {
    public func numberOfSections(in tableView: UITableView) -> Int {
        return self.numberOfSections
    }
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.numberOfRows(in: section)
    }
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return self.dataSource!.tableView(tableView, cellForRowAt: indexPath)
    }
}
// MARK: - private methods
extension PlistTableView {
    fileprivate var plist: Any? {
        if let source = self.dataSource {
            let filename = source.plistName
            guard let plistPath = Bundle.main.path(forResource: filename, ofType: "plist") else { return 0 }
            do {
                let data = try Data(contentsOf: URL(fileURLWithPath: plistPath))
                let plist = try PropertyListSerialization.propertyList(from: data, options: .mutableContainers, format: nil)
                return plist
            } catch {
                //
            }
        }
        return nil
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
}
