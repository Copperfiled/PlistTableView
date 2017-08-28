//
//  GHPath.swift
//  baiding-ios
//
//  Created by guanxiaobai on 12/09/2016.
//  Copyright © 2016 guanxiaobai. All rights reserved.
//

/**
 *  关于文件路径的工具类
 */

import Foundation

public class GHFileURL {
    
    //  MARK: bundle相关
    /**
     返回bundle中指定文件的路径
     
     - parameter name:   文件名
     - parameter ofType: 文件后缀
     
     - returns: name.ofType文件所在bundle包中的路径
     */
    private static func url(forResource name: String?, withExtension ext: String?) -> URL? {
        return Bundle.main.url(forResource: name, withExtension: ext)
    }
    /**
     mainBundle的路径
     
     - returns: mainBundle的路径
     */
    public static func urlForMainBundle() -> URL {
        return self.url(forResource: nil, withExtension: nil)!
    }
    
    // MARK: doucument相关
    public static func urlForDocument() -> URL {
        return try! FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
    }
    /**
     返回document中指定文件的路径
     
     - parameter name: 文件名
     
     - returns: document中指定文件的路径
     */
    public static func url(forDirectoryInDocument name: String, isDirecory: Bool) -> URL {
        return self.urlForDocument().appendingPathComponent(name, isDirectory: isDirecory)
    }
    // MARK: cache 相关
    public func URLForCache() -> URL {
        return try! FileManager.default.url(for: .cachesDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
    }
}
