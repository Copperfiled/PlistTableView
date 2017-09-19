//
//  PlistManager.swift
//  PlistTableView
//
//  Created by guanxiaobai on 23/08/2017.
//  Copyright © 2017 guanxiaobai. All rights reserved.
//

import Foundation
import UIKit

/// section of tableView with plist
public protocol SectionModelProtocol {
    
    /// the height of header
    var headerheight: CGFloat { get set }
    
    /// the height of footer
    var footerheight: CGFloat { get set }
    
    /// headerTitle
    var headerTitle: String? { get set }
    
    /// footerTitle
    var footerTitle: String? { get set }
    
    /// the index of section
    var sectionIndex: Int { get set }
    
    var color: String { get set }
    
    var cellModels: [CellModelProtocol] { get set }
    
    init(with json: [String : Any])
}
public protocol CellModelProtocol {
    /// the height of the row, and 0 represent automatic
    var rowHeight: CGFloat { get set }
    
    /// the idf of cell
    var identifier:String? { get set }
    
    /// the title of left
    var title: String { get set }
    
    /// accessory type
    var accessoryType: UITableViewCellAccessoryType { get set }
    
    var key: String { get set }
    var value: String { get set }
    
    init(with json: [String : Any])
}
enum Location {
    case doucment
    case bundle
}
class PlistNode {
    var plistName: String?
    var path: String?
    var location: Location
    var tableView: PlistTableView
    var rawValue: Any?
    var next: PlistNode? = nil
    
    init(_ tableView: PlistTableView) {
        self.plistName = tableView.plistName
        self.location = .bundle //for now, bundle is only
        self.tableView = tableView
        self.rawValue = PlistManager.share.plist(for: tableView)
    }
}
/// Plist manager
class PlistManager {
    static let share: PlistManager = PlistManager()
    private var plistDict: [String : PlistNode] = [String : PlistNode]()
    
    /// register
    ///
    /// - Parameters:
    ///   - tableView: PlistTableView
    ///   - sectionClass: the section Model
    ///   - cellClass: the cell model
    @discardableResult
    func register(tableView: PlistTableView) -> Bool {
        if let filename = tableView.plistName {
            if self.isPlistExist(filename) {
                return false
            }
            let node = PlistNode(tableView)
            plistDict[filename] = node
        }
        return false
    }
    
    /// find the specified tableView
    ///
    /// - Parameter plist: the name of plist
    /// - Returns: instance of PlistTableView, or nil, if not exist
    func tableView(for plist: String) -> PlistTableView? {
        return plistDict[plist]?.tableView
    }
    func plist(for tableView: PlistTableView) -> Any? {
        guard let plistPath = Bundle.main.path(forResource: tableView.plistName!, ofType: "plist") else { return nil }
        do {
            let data = try Data(contentsOf: URL(fileURLWithPath: plistPath))
            let plist = try PropertyListSerialization.propertyList(from: data, options: .mutableContainers, format: nil)
            return plist
        } catch {
            //
        }
        return nil
    }
    
    func filePath(with fileName: String) -> URL {
        return GHFileURL.url(forDirectoryInDocument: "fileName", isDirecory: false)
    }
    /// check the plist
    ///
    /// - Parameter fileName: plist
    /// - Returns: true if exist
    func isPlistExist(_ fileName: String) -> Bool {
        let fileUrl = self.filePath(with: fileName)
        let isExistInDoc = FileManager.default.fileExists(atPath: fileUrl.absoluteString)
        let isExistInBundle = Bundle.main.path(forResource: fileName, ofType: ".plist") != nil
        return isExistInDoc || isExistInBundle
    }
    /// request plist file from the server
    func requestPlist() {
        //to do sth
    }
}










